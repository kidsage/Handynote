from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .users.views import *
from .posts.views import *
from rest_framework_simplejwt.views import TokenRefreshView, TokenVerifyView

#
router = DefaultRouter()
# router.register(r'user', UserViewSet)
router.register(r'profile', ProfileViewSet)
router.register(r'post', PostViewSet)
router.register(r'category', CategoryViewSet)

#
urlpatterns = [
    path('', include(router.urls)),  
]