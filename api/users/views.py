from django.contrib.auth import authenticate
from rest_framework import status
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet
from rest_framework.generics import GenericAPIView
from rest_framework.permissions import AllowAny, IsAdminUser, IsAuthenticatedOrReadOnly, IsAuthenticated
from rest_framework.decorators import action
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.authentication import JWTAuthentication

from users.models import *
from .serializers import *
from .permissions import IsSelf

#
class UserViewSet(ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    authentication_classes = [JWTAuthentication]
    
    def get_permissions(self):
        permission_classes = []
        if self.action == 'list':
            permission_classes = [IsAuthenticatedOrReadOnly]
        elif self.action == 'create' or self.action == 'retrieve':
            permission_classes = [AllowAny]
        else:
            permission_classes = [IsSelf | IsAdminUser]
        return [permission() for permission in permission_classes]
        

# user data를 넣어서 지원할 수 있도록 세팅할 예정
class ProfileViewSet(ModelViewSet): 
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]