from rest_framework.viewsets import ModelViewSet
from rest_framework.permissions import AllowAny
from users.models import *
from .serializers import *

#
class UserViewSet(ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [AllowAny]
