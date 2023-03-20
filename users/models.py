from datetime import datetime
from django.db import models
# from django.contrib.auth.models import BaseUserManager, AbstractBaseUser, PermissionsMixin
from django.core.validators import RegexValidator

# Create your models here.
class Profile(models.Model):

    def user_directory_path(instance, filename):
        # 공식 docs에서 가져옴.
        return f'user_{instance.user.id}/{filename}'

    phoneNumberRegex = RegexValidator(regex = r'^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$')
    nickname = models.CharField("유저 닉네임", max_length=20, unique=True)
    image = models.ImageField("프로필 이미지", upload_to=user_directory_path, null=True)
    phonenumber = models.CharField("전화번호", validators = [phoneNumberRegex], max_length = 11, unique = True)
    introduce = models.CharField("간략한 소개", max_length=100, null=True, blank=True)

    def __str__(self):
        return f"{self.user.username} Profile"

    class Meta:
        db_table = 'userprofile'