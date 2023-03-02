from rest_framework.viewsets import ModelViewSet
from rest_framework.response import Response
from rest_framework.views import APIView
from posts.models import *
from .serializers import *


#
class PostViewSet(ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer

    def get_serializer_context(self):

        return {
            'request': None, 
            'format': self.format_kwarg,
            'view': self
        }

    def get_queryset(self):
        return Post.objects.all().select_related('category')


class CategoryViewSet(ModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer