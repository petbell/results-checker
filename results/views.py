from typing import Any
from django.db.models.query import QuerySet
from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.db import connection
from .forms import ContactForm
from .forms import ResultForm
from .forms import LoginForm, SignUpForm , CardForm
from django.contrib.auth.models import User, auth
from django.contrib import messages
# this decorator is for specifying views that need the user to be logged in first
from django.contrib.auth.decorators import login_required 
from random import randint
from django.conf import settings
from django.views.generic import ListView, TemplateView
from eth_account import Account
import secrets
from django.core.paginator import Paginator







def index (request):
    return HttpResponse ("This is going to be my first django app again")

# Create your views here.
def get_allresult(request):
    with connection.cursor() as cursor:
        sql = 'SELECT * FROM TbResults'
        cursor.execute(sql)
        result = cursor.fetchall()
        return render(request, "results/allresults.html", context= {'data': result})

# view for 1 record
def get_result(request):
    with connection.cursor() as cursor:
        sql = 'SELECT * FROM TbResults WHERE student_id = 124'
        cursor.execute(sql)
        result = cursor.fetchone()
        return render(request, "results/results.html", context= {'data': result})
    
def check(request,studentid,pin, serial ):
    pass    

def contactView(request):
    if request.method == 'POST':
        form = ContactForm(request.POST)
        if form.is_valid():
            pass
    else:
        form = ContactForm()
        
    context = {
        'form_key' : form
    }        
    return render (request, 'results/contact.html', context)

# the login url has been set in settings.py
@login_required
def checkResult (request):
    if request.method == 'POST':
        form = ResultForm (request.POST)
        if form.is_valid():
            data = form.cleaned_data
            student_id = data['studentid']
            pin = data['cardpin']
            serial = data['serial']
            with connection.cursor() as cursor:
                # first check if the student data is available
                cursor.execute("SELECT * FROM TbResults WHERE student_id = %s",[student_id ])
                checkStudent = cursor.fetchone()
                if checkStudent:
                    sql = '"SELECT * FROM TbCard WHERE pin = %s", [pin]' #the param does not work this way unless i hardcode it like below
                    # need to look for a way to query the query
                    cursor.execute("SELECT * FROM TbCard WHERE pin = %s AND serial = %s ", [pin, serial])
                    cardresult = cursor.fetchone()
                    # if a card exists, check if it has been used by the student
                    if cardresult :
                        # the column is referenced by index from the query result
                        if cardresult [4] == 1:
                            print (cardresult)
                            # error message that card has been used more than 5 times.
                            messages.info (request,'DEPLETED!! Card has already been used up to 5 times')
                            form = ResultForm(request.POST)
                            context = {
                                'form_key' : form
                            }
                            return render (request, 'results/checkresult.html', context)                            #(card already used by a different student)
                            
                        else:
                            # query results with the  card pin first
                            cursor.execute("SELECT * FROM TbTransact WHERE pin = %s",[pin] )
                            transactresult = cursor.fetchone()
                            # if the card has been used before, check if used by the same student, 
                            # get the result and update tbtransact
                            if transactresult:
                                # the column is referenced by index from the query result
                                if transactresult[1] != student_id :
                                    messages.error (request, "Card already used for another student")
                                    form = ResultForm(request.POST)
                                    context = {
                                        'form_key' : form
                                    }
                                    return render (request, 'results/checkresult.html', context)
                                else:
                                    #get result, update tbtransact
                                    cursor.execute("UPDATE TbTransact SET card_use = card_use+1 WHERE student_id = %s AND pin = %s", [student_id, pin])
                                    cursor.execute("SELECT * FROM TbResults WHERE student_id = %s",[student_id ])
                                    result = cursor.fetchone()
                                    
                                    # convert queryset into a dictionary of column name: value pairs 
                                    desc = cursor.description
                                    col_names = [col[0] for col in desc]
                                    resultDict = dict(zip(col_names, result))
                                    
                                    cursor.execute("SELECT card_use FROM TbTransact WHERE student_id = %s AND pin = %s", [student_id, pin])
                                    cardUse = cursor.fetchone()
                                    card_use = cardUse[0]
                                    
                                    context = {
                                    'form_key' : resultDict,
                                    'use_key' : card_use
                                    }
                                    print (card_use)
                                    print (context)
                                    return render (request, 'results/displayresult.html', context)
                            
                            else:
                                #add form details to tbtransact and retrieve result
                                cursor.execute("INSERT INTO TbTransact (student_id, pin, card_use) VALUES (%s,%s,1)", [student_id, pin])
                                cursor.execute("SELECT * FROM TbResults WHERE student_id = %s",[student_id ])
                                result = cursor.fetchone()
                                # convert queryset into a dictionary of column name: value pairs 
                                desc = cursor.description
                                col_names = [col[0] for col in desc]
                                resultDict = dict(zip(col_names, result))
                                context = {
                                    'form_key' : resultDict
                                    }
                                return render (request, 'results/displayresult.html', context)
                    else:
                        #show form and error message, wrong card 
                        messages.info (request, 'The card is invalid, check the nummbers and try again')
                        form = ResultForm(request.POST)
                        context = {
                            'form_key' : form
                        }
                        return render (request, 'results/checkresult.html', context)
                
                else:
                    messages.error(request, "Student result not available. Check the number and try again")
                    form = ResultForm(request.POST)
                    context = {
                        'form_key' : form
                    }
                    return render (request, 'results/checkresult.html', context)
                
                #return HttpResponse(pin)
                
    else:
        form = ResultForm()
    context = {
        'form_key' : form
                }
      
    return render (request, 'results/checkresult.html', context)


def signupView(request):
    if request.method == 'POST':
        form = SignUpForm(request.POST)
        first_name = request.POST ['first_name']
        last_name = request.POST ['last_name']
        username = request.POST ['username']
        email =     request.POST ['email']
        password = request.POST ['password']
        confirm_password = request.POST ['confirm_password']
        
        if password == confirm_password:
            if User.objects.filter(username = username).exists():
                messages.info (request,'Username already exists')
                return redirect ('signup')
            else:
                user = User.objects.create_user(username=username, password=password, email= email, first_name = first_name, last_name = last_name)
                user.set_password(password)
                user.save()
                print ("User created")
                messages.info (request,user.username + " User successfully created")
                return redirect ('login')
        else:
            messages.info (request, "Both passwords do not match!!!")
            return redirect('signup')
    else:
        print ("No post method")
        
        form = SignUpForm()
        context = {
            'form_key' : form
        }
        return render (request,'results/signup.html', context)

def loginView (request):
    if request.method == 'POST':
        form = LoginForm(request.POST)
        uname = request.POST.get("username")
        pword = request.POST.get ("password")
        
        user_data = auth.authenticate(username = uname, password = pword)
        if user_data is not None:
            auth.login(request, user_data)
            print ('Welcome user')
            messages.info (request, "welcome user " + user_data.username)
            return redirect ('check')
        else:
            form = LoginForm()
            context = {
                'form_key' : form
            }

            #dispplays the message in a for loop added in the base template
            messages.info (request, "Invalid username or password")
            # take note of it being render and not redirect cos it is a GET
            return render (request, 'results/login.html', context)
    else:
        form = LoginForm()
        context = {
            'form_key' : form
        }
        return render (request,'results/login.html', context)
        
def logoutView (request):
    auth.logout (request)
    return redirect ('login')


def createCardView (request):
    if request.method == 'POST':
        form = CardForm(request.POST)
        number_of_card = int(request.POST.get('number_of_card'))
        makeCard(number_of_card)
        return HttpResponse ( "cards succesfully produced")
    else:
        form = CardForm()
        context = {
            'form_key' : form
        }
        return render(request, 'results/makepin.html', context)        
        



def makeCard(number_of_card):
    for i in range(0,number_of_card):
        cardpin = randint(100000000000, 999999999999)
        with connection.cursor() as cursor:
            cursor.execute ("INSERT INTO TbCard (pin) VALUES (%s)", [cardpin])
            
           
    
#class keysLolView(TemplateView):
 #   template_name = "results/keyslol.html"
    
    
  #  def get_context_data(self, **kwargs) -> dict[str, Any]:
   #     context = super().get_context_data(**kwargs)
    #    context[""] = 
     #   return context
    #def get_context_data(self, **kwargs):
     #   context = super(CLASS_NAME, self).get_context_data(**kwargs)
      #  return context
    
        

class keysLolListView(ListView):
    #model = MODEL_NAME
    template_name = "results/keyslol.html"
    paginate_by = 5
    context_object_name = 'wallets'

    def get_queryset(self):
        addRange= range(0,14)
        privkey = list(map(lambda u : secrets.token_hex(32), addRange))
        publickey = list(map(lambda v : Account.from_key(v).address.lower(), privkey))
        print (publickey)
        
        wallets = list(zip(privkey,publickey))
        print (f"These are the {wallets}")
        return wallets
        
    def post(self,request, *args, **kwargs):
        pkPage = randint(0,904625697166532776746648320380374280103671755200316906558262375061821325312)
        #domain = "http://petbell.com"
        #if settings.DEBUG:
        #    domain = "http://127.0.0.1:8000/results/keyslol"+ str(pkPage)
        privKeyLower = (pkPage - 1) * 128 + 0
        privKeyUpper = (pkPage - 1) * 128 + 127
        pageRange = range (privKeyLower,privKeyUpper)
        
        pagePk= list(map(hex,pageRange))
        pagePubkey = list(map(lambda p: Account.from_key(p).address.lower(),pagePk))
        wallets = list(zip(pagePk,pagePubkey))
        pagetotal = range (0, int(1.157921e+77))
        q = Paginator(pagetotal,128)
        
        print (f"private key {pagePk}")
        print (f"public key {pagePubkey}")
        print (wallets)
        context = {
            'pkPage_key': pkPage,
            'wallets_key' : wallets
        }
        print (context)
        print(q.count)
        print(q.num_pages)
        print(q.page_range)
        return render (request, "results/keyspage.html", context)
     