from rest_framework import serializers
from posts.models import *


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['id', 'name']

    def __str__(self) -> str:
        return self.name


class PostSerializer(serializers.ModelSerializer):
    category = CategorySerializer(required=False)
    updated_at = serializers.SerializerMethodField()

    class Meta:
        model = Post
        fields = ['id', 'title', 'category', 'content', 'priority', 'color', 'updated_at']
        read_only_fields = ('updated_at',)

    def get_updated_at(self, obj):
        return obj.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    
    def create(self, validated_data):
        category_data = validated_data.pop('category')
        category, _ = Category.objects.get_or_create(**category_data)
        post = Post.objects.create(category=category, **validated_data)
        return post
    
    def update(self, instance, validated_data):
        instance.title = validated_data.get('title', instance.title)
        category_data = validated_data.pop('category')
        instance.category, _ = Category.objects.get_or_create(**category_data)
        instance.content = validated_data.get('content', instance.content)
        instance.priority = validated_data.get('priority', instance.priority)
        instance.color = validated_data.get('color', instance.color)
        instance.save()
        return instance
