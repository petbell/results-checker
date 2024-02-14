from django.contrib import admin
from .models import TbCustomers, TbProducts

# Register your models here.
admin.site.register(TbProducts)
admin.site.register(TbCustomers)