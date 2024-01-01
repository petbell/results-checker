from django.shortcuts import render
from django.http import HttpResponse
from django.db import connection
from .forms import ContactForm
from .forms import ResultForm

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
            return HttpResponse("Your data is submitted")
    else:
        form = ContactForm()
        
    context = {
        'form_key' : form
    }        
    return render (request, 'results/contact.html', context)

def checkResult (request):
    if request.method == 'POST':
        form = ResultForm (request.POST)
        if form.is_valid():
            data = form.cleaned_data
            student_id = data['studentid']
            pin = data['cardpin']
            serial = data['serial']
            with connection.cursor() as cursor:
                sql = '"SELECT * FROM TbCard WHERE pin = %s", [pin]' #the param does not work this way unless i hardcode it like below
                cursor.execute("SELECT * FROM TbCard WHERE pin = %s AND serial = %s ", [pin, serial])
                cardresult = cursor.fetchone()
                # if a card exists, check if it has been used by the student
                if cardresult:
                    cursor.execute("SELECT * FROM TbTransact WHERE student_id = %s AND pin = %s",[student_id, pin] )
                    transactresult = cursor.fetchone()
                    if transactresult:
                        #get result, update tbtransact
                        cursor.execute("UPDATE TbTransact SET card_use = card_use+1 WHERE student_id = %s AND pin = %s", [student_id, pin])
                        cursor.execute("SELECT * FROM TbResults WHERE student_id = %s",[student_id ])
                        result = cursor.fetchone()
                        context = {
                            'form_key' : result
                            }
                        return render (request, 'results/checkresult.html', context)
                    else:
                        #add form details to tbtransact and retrieve result
                        cursor.execute("INSERT INTO TbTransact (student_id, pin, card_use) VALUES (%s,%s,1)", [student_id, pin])
                        cursor.execute("SELECT * FROM TbResults WHERE student_id = %s",[student_id ])
                        result = cursor.fetchone()
                        context = {
                            'form_key' : result
                            }
                        return render (request, 'results/checkresult.html', context)
                else:
                    #show form and error message, wrong card
                    form = ResultForm()
                    context = {
                        'form_key' : form
                    }
                    return render (request, 'results/checkresult.html', context)
               
                context = {
        'form_key' : transactresult
                }
                return render (request, 'results/checkresult.html', context)
            
            #return HttpResponse(pin)
            
    else:
        form = ResultForm()
    context = {
        'form_key' : form
                }
      
    return render (request, 'results/checkresult.html', context)