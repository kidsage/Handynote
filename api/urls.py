from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .users.views import *
from .posts.views import *
from rest_framework_simplejwt.views import TokenRefreshView, TokenVerifyView

#
router = DefaultRouter()
router.register(r'user', UserViewSet)
router.register(r'profile', ProfileViewSet)
router.register(r'post', PostViewSet)
router.register(r'category', CategoryViewSet)

#
urlpatterns = [
    path('', include(router.urls)),
    # path('login/', UserViewSet.as_view({'post': 'login'}), name='auth_login'),
    # path('logout/', UserViewSet.as_view({'post': 'logout'}), name='auth_logout'),
    path('refresh-token/', TokenRefreshView.as_view(), name='auth_refresh_token'),
    path('verify-token/', TokenVerifyView.as_view(), name='auth_verify_token'),   
]