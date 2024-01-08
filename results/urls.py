from django.urls import path
from . import views

urlpatterns = [
    path ("", views.index, name='index'),
    path ("getallresult/", views.get_allresult, name= 'get_allresult'),
    path ("getresult/", views.get_result, name= 'get_result'),
    path ("contact/", views.contactView, name= 'contact'),
    path ("check/", views.checkResult, name= 'check'),
    path ("signup/", views.signupView, name= 'signup'),
    path ("login/", views.loginView, name= 'login'),
    path ("logout/", views.logoutView, name= 'logout')
]