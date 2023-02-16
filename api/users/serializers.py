from users.models import *
from rest_framework import serializers
from django.contrib.auth.models import update_last_login

#
class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ['user', 'nickname', 'image', 'phonenumber', 'introduce']


class UserSerializer(serializers.ModelSerializer):
    profile = ProfileSerializer(read_only=True)

    class Meta:
        model = User
        fields = ['email', 'password', 'profile', 'is_active']

    # def login(self, validated_data):



class UserLoginSerializer(serializers.Serializer):
    email = serializers.CharField(required=True)
    password = serializers.CharField(required=True, write_only=True)