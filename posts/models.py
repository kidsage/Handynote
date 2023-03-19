from django.db import models
from users.models import User
from markdownx.models import MarkdownxField

# Create your models here.
class Post(models.Model):
    category = models.ForeignKey('Category', on_delete=models.SET_NULL, blank=True, null=True)
    # user = models.ForeignKey(User, on_delete=models.PROTECT)
    title = models.CharField('TITLE', max_length=50)
    # image = models.ImageField('IMAGE', upload_to='post/%Y/%m/', blank=True, null=True)
    content = MarkdownxField()
    created_at = models.DateTimeField('CREATED AT', auto_now_add=True)
    updated_at = models.DateTimeField('UPDATED AT', auto_now=True)

    class Meta:
        ordering = ('updated_at', )

    def __str__(self):
        return self.title


class Category(models.Model):
    name = models.CharField(max_length=50, unique=True)
    description = models.CharField('DESCRIPTION', max_length=100, blank=True, help_text='simple one-line text')

    def __str__(self):
        return self.name