from users.models import *
from rest_framework import serializers
from django.contrib.auth.models import update_last_login

#
class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ['nickname', 'image', 'phonenumber', 'introduce']


class UserSerializer(serializers.ModelSerializer):
    # profile = ProfileSerializer(required=True)

    class Meta:
        model = User
        fields = ['email', 'password'] #, 'profile']