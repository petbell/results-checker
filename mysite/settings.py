"""
Django settings for mysite project.

Generated by 'django-admin startproject' using Django 5.0.

For more information on this file, see
https://docs.djangoproject.com/en/5.0/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/5.0/ref/settings/
"""

from pathlib import Path

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/5.0/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'django-insecure-89=r%nowzid3&$8qc1*l37tu_gx1e&1vx*#qmn0l_-y4r%rhdn'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = ['*']


# Application definition

INSTALLED_APPS = [
    'stripee.apps.StripeeConfig',
    'businessapp.apps.BusinessappConfig',
    'results.apps.ResultsConfig',
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'mysite.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'mysite.wsgi.application'


# Database
# https://docs.djangoproject.com/en/5.0/ref/settings/#databases

DATABASES = {
    'default': {
       'ENGINE': 'django.db.backends.sqlite3',
        #'NAME': 'C:\\Users\TOSHIBA\Desktop\\DS Tutorial\\ssce.db',
        'NAME': 'ssce.db',
    }
}


# Password validation
# https://docs.djangoproject.com/en/5.0/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/5.0/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/5.0/howto/static-files/

STATIC_URL = 'static/'

# Default primary key field type
# https://docs.djangoproject.com/en/5.0/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# this is the login view name for the @login_required decorator
LOGIN_URL = 'login'

#everything below is for stripe integration
STRIPE_PUBLIC_KEY = "pk_test_51Obm3nCEL3dCjPQVC3BVtmpc8RcERMzwoiDhEnCkTR2qONeQL96OsFneBMwDryoSJNd5CvupLSiKT6Xb6PDJsTTu00ss30OSjr"
STRIPE_SECRET_KEY = "sk_test_51Obm3nCEL3dCjPQV5Wtm4JgZjyNUt60IlUfU6O8A1iBZZBSm0ZewWgZUiR8kAOVpD6hNr2vSXjB9kCADjv0atY7t00YmJXfQJc"
STRIPE_WEBHOOK_SECRET = 'whsec_48bc5c9417906b600e5c6a9dec3d6d549643a1f9695ff073d24a9880f04d5df0'
# this is email backend to send mail to stripe customer
EMAIL_BACKEND = "django.core.mail.backends.console.EmailBackend"

#everything following is for flutterwave integration
RAVE_PUBLIC_KEY = "FLWPUBK_TEST-f6d0ba789495635a06c1c0aaa1b3ace6-X"
RAVE_SECRET_KEY = "FLWSECK_TEST-026bad446136a159ad404a127b8ff81c-X"
RAVE_ENCRYPTION_KEY = "FLWSECK_TEST62d0965f4385"