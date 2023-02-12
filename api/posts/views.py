from rest_framework.viewsets import ModelViewSet
from rest_framework.response import Response
from rest_framework.views import APIView
from posts.models import *
from .serializers import *



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
        return Post.objects.all().select_related('category').prefetch_related('tags', 'comment_set')

    # viewset에서 get method는 사용하지 않는다.
    def like(self, request, *args, **kwargs):
        instance = self.get_object()
        instance.like += 1
        instance.save()

        return Response(instance.like)


class CommentViewSet(ModelViewSet):
    queryset = Comment.objects.all()
    serializer_class = CommentSerializer


# class CateTagAPIView(APIView):
#     def get(self, request, *args, **kwargs):
#         cateList = Category.objects.all()
#         tagList = Tag.objects.all()

#         data = {
#             'cateList': cateList,
#             'tagList': tagList,
#         }

#         serializer = CateTagSerializer(instance=data)
#         return Response(serializer.data)
