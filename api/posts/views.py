from rest_framework.viewsets import ModelViewSet
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.decorators import action
from markdownx.utils import markdownify
from posts.models import *
from .serializers import *


#
class PostViewSet(ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer
    # serializer_classes = {
    #     ''
    # }
    permission_classes = [IsAuthenticatedOrReadOnly]


    def get_queryset(self):
        return Post.objects.all().select_related('category')
    
    def get_serializer_class(self):
        if hasattr(self, 'serializer_classes'):
            return self.serializer_classes.get(self.action, self.serializer_class)
        
        return super().get_serializer_class()
    
    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)
        content = markdownify(instance.content)

        return Response({**serializer.data, 'content': content})
    
    # 나만 쓸 수 있는 포스트를 따로 구현할건데, viewset을 하나 더 파는게 나으려나?
    # @action(detail=True)
    # def my_post(self, request):


class CategoryViewSet(ModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer