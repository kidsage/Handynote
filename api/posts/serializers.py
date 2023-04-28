from rest_framework import serializers
from posts.models import *


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['id', 'name']
        # 고유성 검사 제거
        # https://github.com/encode/django-rest-framework/issues/1682
        extra_kwargs = {
            'name': {'validators': []},
        }

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
        category_data = validated_data.pop('category')
        if category_data:
            category_instance = Category.objects.filter(name=category_data['name']).first()
            if category_instance:
                instance.category = category_instance
            else:
                category = Category.objects.create(**category_data)
                instance.category = category

        return super().update(instance, validated_data)