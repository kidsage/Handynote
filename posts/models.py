from django.db import models
from users.models import User

# Create your models here.
class Post(models.Model):
    category = models.ForeignKey('Category', on_delete=models.SET_NULL, blank=True, null=True)
    tags = models.ManyToManyField('Tag', blank=True)
    title = models.CharField('TITLE', max_length=50)
    description = models.CharField('DESCRIPTION', max_length=100, blank=True, help_text='simple one-line text')
    image = models.ImageField('IMAGE', upload_to='blog/%Y/%m/', blank=True, null=True)
    content = models.TextField('CONTENT')
    created_at = models.DateTimeField('CREATED AT', auto_now_add=True)
    updated_at = models.DateTimeField('UPDATED AT', auto_now=True)
    like = models.PositiveSmallIntegerField('LIKE', default=0)

    class Meta:
        ordering = ('updated_at', )

    def __str__(self):
        return self.title


class Category(models.Model):
    name = models.CharField(max_length=50, unique=True)
    description = models.CharField('DESCRIPTION', max_length=100, blank=True, help_text='simple one-line text')

    def __str__(self):
        return self.name


class Tag(models.Model):
    name = models.CharField(max_length=50)

    def __str__(self):
        return self.name


class Comment(models.Model):
    post = models.ForeignKey(Post, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    content = models.TextField('CONTENT')
    created_at = models.DateTimeField('CREATED AT', auto_now_add=True)
    updated_at = models.DateTimeField('UPDATED AT', auto_now=True)
    parent = models.ForeignKey('self' , null=True , blank=True , on_delete=models.CASCADE , related_name='replies')

    @property
    def short_content(self):
        return self.content[:10]

    def __str__(self):
        return self.short_content

    class Meta:
        ordering=['-date_posted']

    @property
    def children(self):
        return Comment.objects.filter(parent=self).reverse()

    @property
    def is_parent(self):
        if self.parent is None:
            return True
        return False