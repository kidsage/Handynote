from users.models import *
from rest_framework import serializers

#
class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ['nickname', 'image', 'phonenumber', 'introduce']