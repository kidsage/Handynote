from rest_framework import serializers
from posts.models import *


class PostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = ['id', 'title', 'image', 'like', 'category']


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['name']


class TagSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tag
        fields = ['name']


# class CateTagSerializer(serializers.Serializer):
#     cateList = serializers.ListField(child=serializers.CharField())
#     tagList = serializers.ListField(child=serializers.CharField())