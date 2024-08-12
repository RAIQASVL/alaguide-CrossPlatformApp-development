from django.db import models
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin
from django.contrib.auth.base_user import BaseUserManager
from django.core.files import File
from django.utils.translation import gettext_lazy as _
from rest_framework.authtoken.models import Token


# User Model
class CustomUserManager(BaseUserManager):
    def _create_user(
        self, username, first_name, last_name, email, password, **extra_fields
    ):
        if not email:
            raise ValueError("Email must be provided")
        if not password:
            raise ValueError("Password is not provided")

        user = self.model(
            username=username,
            first_name=first_name,
            last_name=last_name,
            email=self.normalize_email(email),
            **extra_fields,
        )

        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_user(
        self, username, first_name, last_name, email, password=None, **extra_fields
    ):
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_active", True)
        extra_fields.setdefault("is_superuser", False)
        return self._create_user(
            username, first_name, last_name, email, password, **extra_fields
        )

    def create_superuser(
        self, username, first_name, last_name, email, password=None, **extra_fields
    ):
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_superuser", True)
        extra_fields.setdefault("is_active", True)
        return self.create_user(
            username, first_name, last_name, email, password, **extra_fields
        )


class User(AbstractBaseUser, PermissionsMixin):
    user_id = models.AutoField(primary_key=True)
    username = models.CharField(max_length=150, unique=True)
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    email = models.EmailField(_("Email Address"), max_length=100, unique=True)
    email_is_verified = models.BooleanField(default=False)
    password = models.CharField(max_length=128, blank=False, null=False)
    phone_number = models.CharField(max_length=15, blank=True, null=True)
    birth_date = models.DateField(blank=True, null=True)
    default_country_id = models.IntegerField(default=1, null=True)
    default_city_id = models.IntegerField(default=1, null=True)
    preferred_language = models.CharField(max_length=10, default="en", null=True)

    is_staff = models.BooleanField(default=True)
    is_active = models.BooleanField(default=True)
    is_superuser = models.BooleanField(default=False)

    USERNAME_FIELD = "username"
    EMAIL_FIELD = "email"
    REQUIRED_FIELDS = ["email", "first_name", "last_name"]

    objects = CustomUserManager()

    def __str__(self):
        return self.username

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)

    class Meta:
        managed = True
        db_table = "Users"


# Email Backend

from django.contrib.auth import get_user_model
from django.contrib.auth.backends import ModelBackend


class EmailOrUsernameModelBackend(ModelBackend):
    def authenticate(self, request, username=None, password=None, **kwargs):
        UserModel = get_user_model()
        try:
            user = UserModel.objects.get(username=username)
        except UserModel.DoesNotExist:
            try:
                user = UserModel.objects.get(email=username)
            except UserModel.DoesNotExist:
                UserModel().set_password(password)
                return None

        if user.check_password(password) and self.user_can_authenticate(user):
            user.backend = f"{self.__module__}.{self.__class__.__name__}"
            return user
        return None


class Country(models.Model):
    country_id = models.AutoField(primary_key=True, null=False, default=None)
    country = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.country

    class Meta:
        managed = False
        db_table = "Countries"


class City(models.Model):
    city_id = models.AutoField(primary_key=True, null=False, default=None)
    city = models.CharField(max_length=100, unique=True)
    description = models.TextField()
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    country = models.ForeignKey(
        Country,
        db_column="country",
        to_field="country",
        on_delete=models.CASCADE,
        null=False,
        default=None,
    )

    def __str__(self):
        return str(self.city)

    class Meta:
        managed = False
        db_table = "Cities"


class Category(models.Model):
    """Model for categorizing landmarks."""

    category_id = models.AutoField(primary_key=True, null=False, default=None)
    category = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return str(self.category)

    class Meta:
        managed = False
        db_table = "LandmarksCategory"


class Landmark(models.Model):
    landmark_id = models.AutoField(primary_key=True, null=False, default=None)
    country = models.ForeignKey(
        Country,
        db_column="country",
        to_field="country",
        on_delete=models.CASCADE,
        null=False,
        default=None,
    )
    city = models.ForeignKey(
        City,
        db_column="city",
        to_field="city",
        on_delete=models.CASCADE,
        null=False,
        default=None,
    )
    landmark = models.CharField(max_length=255, unique=True)
    latitude = models.DecimalField(
        max_digits=9, decimal_places=6, unique=True, null=True
    )
    longitude = models.DecimalField(
        max_digits=9, decimal_places=6, unique=True, null=True
    )

    def __str__(self):
        return format(self.landmark)

    class Meta:
        managed = False
        db_table = "Landmarks"


class AudioBook(models.Model):
    audiobook_id = models.AutoField(primary_key=True, null=False, default=None)
    landmark_id = models.ForeignKey(
        Landmark,
        db_column="landmark_id",
        on_delete=models.CASCADE,
        null=False,
        default=None,
    )
    title = models.CharField(max_length=255, unique=True, null=False)
    author = models.CharField(max_length=100, unique=False, null=False)
    guide = models.CharField(max_length=100, unique=False, null=False)
    audio_url = models.FileField(upload_to="audio", unique=True)

    def __str__(self):
        return self.title

    class Meta:
        managed = False
        db_table = "AudioBooks"


# Model for main objects
class AlaguideObject(models.Model):
    ala_object_id = models.AutoField(primary_key=True)
    country = models.ForeignKey(
        Country,
        db_column="country",
        to_field="country",
        on_delete=models.CASCADE,
        null=False,
        default=None,
    )
    city = models.ForeignKey(
        City,
        db_column="city",
        to_field="city",
        related_name="alaguide_object_city",
        on_delete=models.CASCADE,
        null=False,
    )
    category = models.ForeignKey(
        Category,
        db_column="category",
        to_field="category",
        on_delete=models.CASCADE,
        null=False,
        default=None,
    )  # Category relationship
    landmark = models.ForeignKey(
        Landmark,
        db_column="landmark",
        to_field="landmark",
        related_name="alaguide_object_landmark",
        on_delete=models.CASCADE,
        null=False,
    )
    title = models.ForeignKey(
        AudioBook,
        db_column="title",
        to_field="title",
        related_name="alaguide_object_title",
        on_delete=models.CASCADE,
        null=False,
        default=None,
    )
    author = models.CharField(max_length=100, unique=False, null=False)
    guide = models.CharField(max_length=100, unique=False, null=False)
    description = models.TextField(max_length=1000, null=True, blank=True)
    latitude = models.ForeignKey(
        Landmark,
        db_column="latitude",
        to_field="latitude",
        related_name="alaguide_object_latitude",
        on_delete=models.CASCADE,
        null=False,
    )
    longitude = models.ForeignKey(
        Landmark,
        db_column="longitude",
        to_field="longitude",
        related_name="alaguide_object_longitude",
        on_delete=models.CASCADE,
        null=False,
    )
    image_url = models.FileField(
        upload_to="landmarks", unique=False, null=True, blank=True
    )
    audio_url = models.ForeignKey(
        AudioBook,
        db_column="audio_url",
        to_field="audio_url",
        related_name="alaguide_object_audio",
        on_delete=models.CASCADE,
        null=False,
    )

    def __str__(self):
        return str(self.landmark)

    class Meta:
        managed = False
        db_table = "AlaguideObjects"
