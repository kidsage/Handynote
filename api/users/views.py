from django.contrib.auth import authenticate
from rest_framework import status
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet
from rest_framework.generics import GenericAPIView
from rest_framework.permissions import AllowAny, IsAdminUser, IsAuthenticatedOrReadOnly, IsAuthenticated
from rest_framework.decorators import action
from rest_framework_simplejwt.tokens import RefreshToken

from users.models import *
from .serializers import *
from .permissions import IsSelf

#
class UserViewSet(ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    
    def get_permissions(self):
        permission_classes = []
        if self.action == 'list':
            permission_classes = [IsAuthenticatedOrReadOnly]
        elif self.action == 'create' or self.action == 'retrieve':
            permission_classes = [AllowAny]
        else:
            permission_classes = [IsSelf | IsAdminUser]
        return [permission() for permission in permission_classes]

    @action(detail=False, methods=['post'])
    def login(self, request):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        data = serializer.data
        user = authenticate(email=data['email'], password=data['password'])

        token = RefreshToken.for_user(user['email'])
        refresh = str(token)
        access = str(token.access_token)

        if user is not None:
            return Response (
                { 
                    'user': user,
                    'access': access,
                    'refresh': refresh,
                },
                status=status.HTTP_200_OK,
            )
        else:
            return Response(status=status.HTTP_405_METHOD_NOT_ALLOWED)


# class LogoutViewSet(ModelViewSet):
#     queryset = User
#     serializer_class = LogoutSerializer
#     permission_classes = [IsAuthenticated]


class LogoutAPIView(GenericAPIView):
    serializer_class = LogoutSerializer
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(status=status.HTTP_204_NO_CONTENT)


# user data를 넣어서 지원할 수 있도록 세팅할 예정
class ProfileViewSet(ModelViewSet): 
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]