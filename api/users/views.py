from django.contrib.auth import (
    authenticate, 
    login as auth_login, 
    logout as auth_logout
)
from rest_framework import status
from rest_framework.response import Response
# from rest_framework.views import APIView
from rest_framework.viewsets import ModelViewSet
from rest_framework.permissions import AllowAny, IsAdminUser, IsAuthenticatedOrReadOnly, IsAuthenticated
from rest_framework.decorators import action
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.exceptions import InvalidToken, TokenError
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
        elif self.action == 'login':
            permission_classes = [AllowAny]
        elif self.action == 'logout':
            permission_classes = [IsSelf]
        else:
            permission_classes = [IsSelf | IsAdminUser]
        return [permission() for permission in permission_classes]
    
    @action(detail=False, methods=['post'])
    def login(self, request):
        email = request.data.get('email')
        password = request.data.get('password')

        user = authenticate(email=email, password=password)

        if user is not None:
            refresh = RefreshToken.for_user(user)
            req = {
                # "user": User.objects.filter(email=email).values(),
                "token": {
                    "access": str(refresh.access_token),
                    "refresh": str(refresh),
                },
                "message": "User Login Successful.",
            }
            auth_login(request, user)
            return Response(req, status=status.HTTP_200_OK)
        else:
            return Response({'error': 'Invalid Credentials'}, status=status.HTTP_401_UNAUTHORIZED)
    
    @action(detail=False, methods=['post'])
    def logout(self, request):
        refresh_token = request.data.get('refresh')
        if refresh_token:
            try:
                token = RefreshToken(refresh_token)
                token.blacklist()
                # BlacklistToken.objects.create(token=refresh_token)
                auth_logout(request)
                return Response({'message': 'User Logged Out'}, status=status.HTTP_200_OK)
            except (InvalidToken, TokenError):
                return Response({'error': 'Invalid Token'}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response({'error': 'Refresh Token not found'}, status=status.HTTP_400_BAD_REQUEST)


# user data를 넣어서 지원할 수 있도록 세팅할 예정
class ProfileViewSet(ModelViewSet): 
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]