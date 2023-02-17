from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .users.views import *
from .posts.views import *
from .users.token import MyTokenObtainPairView

from rest_framework_simplejwt.views import TokenRefreshView

router = DefaultRouter()
router.register(r'user', UserViewSet)
router.register(r'profile', ProfileViewSet)
router.register(r'post', PostViewSet)
router.register(r'comment', CommentViewSet)
router.register(r'category', CategoryViewSet)
router.register(r'tag', TagViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('token/', MyTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]