from users.models import *
from rest_framework import serializers

#
class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ['user', 'nickname', 'image', 'phonenumber', 'introduce']


class UserSerializer(serializers.ModelSerializer):
    profile = ProfileSerializer(read_only=True)

    class Meta:
        model = User
        fields = ['email', 'password', 'profile']
        extra_kwargs = {
            'password': {'write_only': True},
        }


class LogoutSerializer(serializers.Serializer):
    refresh = serializers.CharField(max_length=255)