from django.db import models


GENDER_CHOICES = [
    ('M', 'Male'),
    ('F', 'Female')
]
# Create your models here.

class TbProducts (models.Model):
    product_id = models.AutoField (primary_key=True)
    product_name = models.CharField(max_length= 30 )
    product_description  = models.CharField("Description", max_length = 300)
    price = models.IntegerField()
    image = models.ImageField (upload_to='images/businessapp')
    date_added = models.DateTimeField (auto_now_add=True)
    updated = models.DateTimeField (auto_now = True)

    def __str__(self):
        return self.product_name      
    
class TbCustomers (models.Model):
    customer_id = models.AutoField (primary_key=True)
    cust_first_name = models.CharField("Customer Name", max_length= 30)
    cust_last_name = models.CharField("Customer Surname", max_length= 30)
    phone = models.IntegerField()
    email = models.EmailField()
    gender = models.CharField(choices = GENDER_CHOICES, max_length = 10)
    #date_of_birth = models.DateField()
    age = models.PositiveIntegerField()
    
    def __str__(self):
        return self.cust_last_name + " " + self.cust_first_name