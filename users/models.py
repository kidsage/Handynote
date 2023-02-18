from datetime import datetime
from django.db import models
from django.contrib.auth.models import BaseUserManager, AbstractBaseUser, PermissionsMixin
from django.core.validators import RegexValidator

# Create your models here.
class UserManager(BaseUserManager):

    # All user
    def create_user(self, email, password=None, **extra_fields):

        if email is None:
            raise TypeError('Users must have an email address.')

        if password is None:
            raise TypeError('Users must have a password.')
    
        user = self.model(email = self.normalize_email(email), **extra_fields)

        user.set_password(password)
        user.save(using=self._db)
        
        return user

    # admin user
    def create_superuser(self, email, password, **extra_fields):
        
        if password is None:
            raise TypeError('Superuser must have a password.')
        
        # "create_user"함수를 이용해 우선 사용자를 DB에 저장
        user = self.create_user(email, password, **extra_fields)
        # 관리자로 지정
        user.is_superuser = True
        user.is_admin = True
        user.is_staff = True
        user.save(using=self._db)
        
        return user


class User(AbstractBaseUser, PermissionsMixin):

    email = models.EmailField(max_length=100, unique=True)
    date_joined = models.DateTimeField(default=datetime.now())
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    is_admin = models.BooleanField(default=False)
    
    USERNAME_FIELD = 'email'
    
    # REQUIRED_FIELDS = []
    
    objects = UserManager()
    
    def __str__(self):
        return self.email
    
    def get_full_name(self):
        return self.username

    class Meta:
        db_table = 'user'
    


class Profile(models.Model):

    def user_directory_path(instance, filename):
        # 공식 docs에서 가져옴.
        return f'user_{instance.user.id}/{filename}'

    phoneNumberRegex = RegexValidator(regex = r'^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$')

    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    nickname = models.CharField("유저 닉네임", max_length=20, unique=True)
    image = models.ImageField("프로필 이미지", upload_to=user_directory_path, null=True)
    phonenumber = models.CharField("전화번호", validators = [phoneNumberRegex], max_length = 11, unique = True)
    introduce = models.CharField("간략한 소개", max_length=100, null=True, blank=True)

    def __str__(self):
        return f"{self.user.username} Profile"

    class Meta:
        db_table = 'userprofile'


class Follow(models.Model):
    # followings = models.ManyToManyField('self', symmetrical=False, related_name='followers')
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='following')
    following = models.ForeignKey(User, on_delete=models.CASCADE, related_name='follower')
    created = models.DateTimeField(auto_now_add=True, db_index=True)

    def __str__(self):
        f"{self.user} follows {self.following}"

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['user','following'],  name='unique_followers')
        ]
        ordering = ["-created",]
        db_table = 'follow'