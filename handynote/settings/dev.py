from datetime import datetime
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

# SWAGGER SETTINGS
SWAGGER_SETTINGS = {
    'USE_SESSION_AUTH': False,
    'SECURITY_DEFINITIONS': {
        'basic': {
            'type': 'basic'
        }
    }
}

LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
        },
    },
    "root": {
        "handlers": ["console"],
        "level": "WARNING",
    },
    "loggers": {
        "django": {
            "handlers": ["console"],
            "level": os.getenv("DJANGO_LOG_LEVEL", "INFO"),
            "propagate": False,
        },
    },
}


# MARKDOWN SETTINGS
# MARKDOWNX_MARKDOWN_EXTENSIONS = [
#     'markdown.extensions.extra',
#     'markdown.extensions.codehilite',
#     'markdown.extensions.toc',
# ]

# MARKDOWNX_MARKDOWN_EXTENSION_CONFIGS = {
#     'markdown.extensions.codehilite': {
#         'use_pygments': True,
#         'noclasses': True
#     }
# }

# MARKDOWNX_UPLOAD_URLS_PATH = '/markdownx/upload/'
# MARKDOWNX_MEDIA_PATH = datetime.now().strftime('markdownx/%Y/%m/%d')
# MARKDOWNX_UPLOAD_CONTENT_TYPES = ['image/jpeg', 'image/png', 'image/svg+xml']