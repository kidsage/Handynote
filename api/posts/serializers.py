from rest_framework import serializers
from posts.models import *


class PostSerializer(serializers.ModelSerializer):
    category = serializers.StringRelatedField()
    updated_at = serializers.SerializerMethodField()

    class Meta:
        model = Post
        fields = ['id', 'title', 'category', 'content', 'priority', 'color', 'updated_at']
        read_only_fields = ('updated_at',)

    def get_updated_at(self, obj):
        return obj.updated_at.strftime('%Y-%m-%d %H:%M:%S')


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['name']

    def __str__(self) -> str:
        return self.name