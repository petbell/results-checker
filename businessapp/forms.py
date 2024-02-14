from django import forms

class BatchForm (forms.Form):
    batchDate = forms.DateField(label='Batch Date')
    batch_id = forms.IntegerField(label='Batch Number')
    farm_name = forms.CharField( max_length=30)
    bird_number = forms.IntegerField( label='Number of Birds')
    week = forms.IntegerField()
