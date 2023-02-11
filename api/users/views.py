from rest_framework.viewsets import ModelViewSet
from rest_framework.permissions import AllowAny
from users.models import *
from .serializers import *

#
class UserViewSet(ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [AllowAny]


# user data를 넣어서 지원할 수 있도록 세팅할 예정
class ProfileViewSet(ModelViewSet): 
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer
    permission_classes = [AllowAny]