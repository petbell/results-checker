from django.shortcuts import render
from django.http import HttpResponse
from .models import TbProducts, TbCustomers
from .forms import BatchForm

from datetime import datetime
from datetime import timedelta

# Create your views here.

def indexView (request):
    return HttpResponse ("This is the index page of business app")

def productsView (request):
    all_products = TbProducts.objects.all()
    
    context = {
        'all_products_key': all_products
    }
    return render(request, 'businessapp/products.html', context)

def customersView (request):
    all_customers = TbCustomers.objects.all()
    
    context = {
        'all_customers_key': all_customers
    }
    return render(request, 'businessapp/customers.html', context)


def batchView(request):
    if request.method == 'POST':
        form = BatchForm (request.POST)
        if form.is_valid():
            data = form.cleaned_data
            batchDate = data['batchDate']
            batch_id = data['batch_id']
            farm_name = data['farm_name']
            bird_number = data['bird_number']
            week = data['week']
            
            # computeBatch reurns a tuple  which i use as a tuple of values
            compVal = computeBatch(batchDate, bird_number)
            # this is the tuple of keys so that i can add to data dictionary             
            compKey = ('feedCost', 'firstVacc', 'secondVacc', 'thirdVacc', 'fourthVacc')
            
            # making a new dict out of the two tuples above
            # we can also use dict comprehension {k.v for (k,v) in zip(keys,values)}
            if len(compKey) == len (compVal):
                dictComp = dict(zip(compKey,compVal))
                
            # now merge both dicts
            datas = data|dictComp
            context = {"batch_keys" : datas}
        return render(request, 'businessapp/bizbase.html', context)
    else:
        form = BatchForm()
        context = {
            'batch_keys': form
        }
        return render(request, 'businessapp/batch.html', context)    
        
        

def computeBatch(batchDate, bird_number):
    feedPrice = 12000
    bagEstimate = 4
    feedCost = feedPrice * bagEstimate * bird_number
    firstVacc = batchDate + timedelta(days = 7)
    secondVacc = batchDate + timedelta(days = 14)
    thirdVacc = batchDate + timedelta(days = 21)
    fourthVacc = batchDate + timedelta(days = 28)
    return feedCost, firstVacc, secondVacc, thirdVacc, fourthVacc
    
        