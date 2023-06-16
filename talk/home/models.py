from django.contrib.auth.models import AbstractUser, Group
from django.contrib.auth.models import BaseUserManager
from django.db import models


class UserManager(BaseUserManager):
    def _create_user(self, email, password, **extra_fields):
        if not email:
            raise ValueError('The Email field must be set')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_user(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', False)
        extra_fields.setdefault('is_superuser', False)
        return self._create_user(email, password, **extra_fields)

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')
        return self._create_user(email, password, **extra_fields)


class User(AbstractUser):
    email = models.EmailField(unique=True)
    username = models.CharField(max_length=50, unique=True)
    avatar = models.ForeignKey('Avatar', on_delete=models.SET_NULL, null=True, blank=True)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']

    objects = UserManager()

    # Add related_name arguments to resolve clash
    groups = models.ManyToManyField(Group, related_name='home_users')
    user_permissions = models.ManyToManyField(
        'auth.Permission', related_name='home_users'
    )


class Avatar(models.Model):
    image = models.ImageField(upload_to='avatars/')

    def __str__(self):
        return f"Avatar {self.pk}"


class Object(models.Model):
    name = models.CharField(max_length=100)
    image = models.ImageField(upload_to='object_images/')

    def __str__(self):
        return self.name
