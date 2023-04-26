from rest_framework import status
from rest_framework.viewsets import ModelViewSet
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from posts.models import *
from .serializers import *


#
class PostViewSet(ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer
    # permission_classes = [IsAuthenticatedOrReadOnly]

    def get_queryset(self):
        return Post.objects.all().select_related('category')
    
    def get_serializer_class(self):
        if hasattr(self, 'serializer_classes'):
            return self.serializer_classes.get(self.action, self.serializer_class)
        
        return super().get_serializer_class()


class CategoryViewSet(ModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer