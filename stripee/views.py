import json
from django.shortcuts import render, redirect
import stripe
from django.conf import settings
from django.http import JsonResponse, HttpResponse
from django.views import View
from .models import Price, Product
from django.views.generic import TemplateView
from django.views.decorators.csrf import csrf_exempt
from django.core.mail import send_mail

stripe.api_key = settings.STRIPE_SECRET_KEY


# Create your views here.

class CreateCheckoutSessionView(View):
    def post (self, requests, *args, **kwargs):
        price = Price.objects.get(id= self.kwargs["pk"])
        domain = "http://petbell.com"
        if settings.DEBUG:
            domain = "http://127.0.0.1:8000"
        checkout_session = stripe.checkout.Session.create(
            payment_method_types = ["card"], 
            line_items = [
                {
                    'price': price.stripe_price_id,
                    'quantity': 1,
                },
            ],
        
        mode = 'payment',
        success_url = domain + '/stripee/success/?sessionid={CHECKOUT_SESSION_ID}',
        cancel_url = domain + '/stripee/cancel/',
        )
        return redirect (checkout_session.url)
        

class SuccessView(TemplateView):
    template_name = "stripee/success.html"
    def get_context_data(self, **kwargs):
        session_id = self.request.GET.get('sessionid')
        session = stripe.checkout.Session.retrieve(session_id)
        print (type(session))
        line_items = stripe.checkout.Session.list_line_items(session_id)
        product = line_items["data"][0]['description']
        #print (customer)
        context = super(SuccessView, self).get_context_data(**kwargs)
        context.update({
            'session' : session,
            #'customer' : customer
            "line_items" : line_items,
            'product': product
        })
        return context
        

class CancelView (TemplateView):
    template_name = "stripee/cancel.html"
    
class ProductLandingPageView(TemplateView):
    template_name = 'stripee/landing.html'
    
    def get_context_data(self, **kwargs):
        product = Product.objects.get(name="Test Product")
        prices = Price.objects.filter(product=product)
        context =  super(ProductLandingPageView,self).get_context_data(**kwargs)
        
        context.update({
            "product": product,
            "prices": prices
        })
        return context
        
  

@csrf_exempt
def stripe_webhook(request):
    payload = request.body
    sig_header = request.META['HTTP_STRIPE_SIGNATURE']
    event = None
 
    try:
        event = stripe.Webhook.construct_event(
            payload, sig_header, settings.STRIPE_WEBHOOK_SECRET
        )
    except ValueError as e:
        # Invalid payload
        return HttpResponse(status=400)
    except stripe.error.SignatureVerificationError as e:
        # Invalid signature
        return HttpResponse(status=400)
 
    # Handle the checkout.session.completed event
    if event['type'] == 'checkout.session.completed':
        print( "Payment passed through webhook successfully")
        session = event['data']['object']
        customer_email = session["customer_details"]["email"]
        payment_intent = session["payment_intent"]
        line_items = stripe.checkout.Session.list_line_items(session["id"])
        
        stripe_price_id = line_items["data"][0]["price"]["id"]
        price = Price.objects.get(stripe_price_id= stripe_price_id)
        product = price.product

 
        # TODO - send an email to the customer
        send_mail(
        subject="Here is your product",
        message=f"Thanks for your purchase. The URL is: {product.url}",
            recipient_list=[customer_email],
            from_email="petbell@live.com"
        )
        
        print(customer_email)
        print (f" Line Items: {line_items}")
        print (f"Product: {product}")
        print (f"Price: {price}")
        print (f"This goes the event: {event}")
        print (f"Here is session: : : {session}")
        
    elif event["type"] == "payment_intent.succeeded":
        intent = event['data']['object']

        stripe_customer_id = intent["customer"]
        stripe_customer = stripe.Customer.retrieve(stripe_customer_id)

        customer_email = stripe_customer['email']
        product_id = intent["metadata"]["product_id"]

        product = Product.objects.get(id=product_id)

        send_mail(
            subject="Here is your product",
            message=f"Thanks for your purchase. Here is the product you ordered. The URL is {product.url}",
            recipient_list=[customer_email],
            from_email="petbell2001@yahoo.co.uk"
        )

        
    return HttpResponse(status=200)


class StripeIntentView(View):
    def post(self, request, *args, **kwargs):
        try:
            req_json = json.loads(request.body)
            customer = stripe.Customer.create(email=req_json['email'])
            product_id = self.kwargs["pk"]
            product = Product.objects.get(id=product_id)
            intent = stripe.PaymentIntent.create(
                amount=product.price,
                currency='usd',
                customer=customer['id'],
                metadata={
                    "product_id": product.id
                }
            )
            return JsonResponse({
                'clientSecret': intent['client_secret']
            })
        except Exception as e:
            return JsonResponse({ 'error': str(e) })
        
class CustomPaymentView(TemplateView):
    template_name = "stripee/custom_payment.html"

    def get_context_data(self, **kwargs):
        product = Product.objects.get(name="Test Product")
        prices = Price.objects.filter(product=product)
        context = super(CustomPaymentView, self).get_context_data(**kwargs)
        context.update({
            "product": product,
            "prices": prices,
            "STRIPE_PUBLIC_KEY": settings.STRIPE_PUBLIC_KEY
        })
        return context