from handynote.settings.base import *
import os
import environ


# SECURITY WARNING: keep the secret key used in production secret!

env = environ.Env(
    # set casting, default value
    DEBUG=(bool, False)
)

# Take environment variables from .env file
environ.Env.read_env(os.path.join(BASE_DIR, '.env'))

SECRET_KEY = env('SECRET_KEY')
db_id = env('DB_ID')
db_pw = env('DB_PW')


# SECURITY WARNING: don't run with debug turned on in production!

DEBUG = True

ALLOWED_HOSTS = ['*']


# Databases
## connect to postgresql
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        # 'ENGINE': 'django_postgres_extensions.backends.postgresql',
        'NAME': 'handynote',
        'USER': db_id,
        'PASSWORD': db_pw,
        'HOST': 'localhost',
        'PORT': '5432',
    }
}