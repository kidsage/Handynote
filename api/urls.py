from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .users.views import UserViewSet, ProfileViewSet

router = DefaultRouter()
router.register(r'user', UserViewSet)
router.register(r'profile', ProfileViewSet)

urlpatterns = [
    path('', include(router.urls)),
]