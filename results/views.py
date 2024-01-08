from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.db import connection
from .forms import ContactForm
from .forms import ResultForm
from .forms import LoginForm, SignUpForm
from django.contrib.auth.models import User, auth
from django.contrib import messages
# this decorator is for specifying views that need the user to be logged in first
from django.contrib.auth.decorators import login_required 

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
                messages.info (request,user.username + "User successfully created")
                return redirect ('login')
        else:
            messages.info (request, "Both passwords do not match!!!")
            return redirect(signupView)
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

