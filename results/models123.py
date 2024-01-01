from django.db import models

# Create your models here.

class TbResults(models.Model):
    student_id = models.IntegerField(primary_key=True)
    student_name = models.TextField()
    maths = models.IntegerField()
    english = models.IntegerField()
    economics = models.IntegerField()
    biology = models.IntegerField()
    
class TbCard(models.Model):
    serial = models.IntegerField (primary_key=True)
    pin = models.IntegerField()
    # auto_now is for updated times
    print_date = models.DateTimeField(null=False, blank=True, auto_now_add=True)
    expiry = models.DateTimeField(print_date,  '+3months')
    used = models.BooleanField(default= False)
    
    