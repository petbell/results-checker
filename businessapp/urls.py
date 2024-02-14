from django.urls import path
from . import views


urlpatterns = [
    path( "", views.indexView, name= 'index'),
    path( "customers/", views.customersView, name= 'customers'),
    path( "products/", views.productsView, name= 'products'),
    path( "batch/", views.batchView, name= 'batch')
    
]


