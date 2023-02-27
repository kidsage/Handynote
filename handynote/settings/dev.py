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
        'NAME': 'handynote_dev',
        'USER': db_id,
        'PASSWORD': db_pw,
        'HOST': 'localhost',
        'PORT': '5432',
    }
}

SIMPLE_JWT = {
    "TOKEN_OBTAIN_SERIALIZER": "api.users.token.MyTokenObtainPairSerializer",

    'ACCESS_TOKEN_LIFETIME': timedelta(hours=1),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=1),
    'ROTATE_REFRESH_TOKENS': True,
    'BLACKLIST_AFTER_ROTATION': True,
    'UPDATE_LAST_LOGIN': False,
    'TOKEN_USER_CLASS': AUTH_USER_MODEL, # 자신의 User 모델 연결

    'AUTH_HEADER_TYPES': ('Bearer',),
    'USER_ID_FIELD': 'email',
    'USER_ID_CLAIM': 'user_email',
}