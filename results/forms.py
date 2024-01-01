from django import forms


class ContactForm (forms.Form):
    name = forms.CharField(label="Your name", max_length=30)
    email = forms.EmailField()
    mobile = forms.IntegerField()


class ResultForm (forms.Form):
    studentid = forms.IntegerField(label="Student Number")
    cardpin = forms.IntegerField(label="Card PIN")
    serial = forms.IntegerField(label="Card Serial Number")