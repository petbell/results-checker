from django.contrib import admin
from .models import Product, Price



class PriceInlineAdmin (admin.TabularInline):
    model = Price
    extra = 0
    
class ProductAdmin (admin.ModelAdmin):
    inlines = [PriceInlineAdmin]
# Register your models here.
admin.site.register(Product, ProductAdmin)
admin.site.register(Price)
