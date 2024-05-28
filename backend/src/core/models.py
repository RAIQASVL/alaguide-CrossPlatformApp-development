from django.db import models
from django.core.files import File
from django.contrib.auth.models import (
    AbstractBaseUser,
    BaseUserManager,
    PermissionsMixin,
)
from server.settings import BASE_DIR
from django.utils.translation import gettext_lazy as _

# from django.utils import timezone


# Database Models
class CustomUserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError("The Email field must be set")
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_superuser", True)
        extra_fields.setdefault("is_active", True)

        if extra_fields.get("is_staff") is not True:
            raise ValueError("Superuser must have is_staff=True.")
        if extra_fields.get("is_superuser") is not True:
            raise ValueError("Superuser must have is_superuser=True.")

        return self.create_user(email, password, **extra_fields)

    class Meta:
        managed = True
        db_table = "CustomUsers"


class AccountUser(models.Model):
    user_id = models.AutoField(primary_key=True, null=False, default=None)
    username = models.CharField(max_length=100)
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    email = models.EmailField(max_length=100)
    password = models.CharField(max_length=100)
    default_country_id = models.IntegerField(default=1)
    default_city_id = models.IntegerField(default=1)
    preferred_language = models.CharField(max_length=10, default="en")
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["username", "first_name", "last_name"]

    objects = CustomUserManager()

    def __str__(self):
        return self.username

    class Meta:
        managed = True
        db_table = "Users"


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
    landmark = models.CharField(max_length=255, unique=True)
    description = models.TextField()
    image_url = models.FileField(upload_to="landmarks", unique=True, null=True)
    latitude = models.DecimalField(
        max_digits=9, decimal_places=6, unique=True, null=True
    )
    longitude = models.DecimalField(
        max_digits=9, decimal_places=6, unique=True, null=True
    )
    city = models.ForeignKey(
        City,
        db_column="city",
        to_field="city",
        on_delete=models.CASCADE,
        null=False,
        default=None,
    )
    category = models.ForeignKey(
        Category,
        db_column="category",
        to_field="category",
        on_delete=models.CASCADE,
        null=False,
        default=None,
    )  # Category relationship

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
    title = models.CharField(max_length=255)
    description = models.TextField()
    audio_url = models.FileField(upload_to="audio", unique=True)

    def __str__(self):
        return self.title

    class Meta:
        managed = False
        db_table = "AudioBooks"


# Model for main objects
class AlaguideObject(models.Model):
    ala_object_id = models.AutoField(primary_key=True)
    landmark = models.ForeignKey(
        Landmark,
        db_column="landmark",
        to_field="landmark",
        related_name="alaguide_objects_landmark",
        on_delete=models.CASCADE,
        null=False,
    )
    description = models.TextField()
    city = models.ForeignKey(
        City,
        db_column="city",
        to_field="city",
        related_name="alaguide_objects_city",
        on_delete=models.CASCADE,
        null=False,
    )
    category = models.ForeignKey(
        Category,
        db_column="category",
        to_field="category",
        related_name="alaguide_objects_category",
        on_delete=models.CASCADE,
        null=False,
    )
    latitude = models.ForeignKey(
        Landmark,
        db_column="latitude",
        to_field="latitude",
        related_name="alaguide_objects_latitude",
        on_delete=models.CASCADE,
        null=False,
    )
    longitude = models.ForeignKey(
        Landmark,
        db_column="longitude",
        to_field="longitude",
        related_name="alaguide_objects_longitude",
        on_delete=models.CASCADE,
        null=False,
    )
    image_url = models.ForeignKey(
        Landmark,
        db_column="image_url",
        to_field="image_url",
        related_name="alaguide_objects_image",
        on_delete=models.CASCADE,
        null=False,
    )
    audio_url = models.ForeignKey(
        AudioBook,
        db_column="audio_url",
        to_field="audio_url",
        related_name="alaguide_objects_audio",
        on_delete=models.CASCADE,
        null=False,
    )

    def __str__(self):
        return str(self.landmark)

    class Meta:
        managed = False
        db_table = "AlaguideObjects"


# Other Models
class UserReview(models.Model):
    review_id = models.AutoField(primary_key=True, null=False, default=None)
    text = models.TextField()
    rating = models.DecimalField(max_digits=3, decimal_places=1)
    date_posted = models.DateField(default=None)
    user_id = models.ForeignKey(
        AccountUser,
        db_column="user_id",
        on_delete=models.CASCADE,
        null=False,
        default=None,
    )
    landmark_id = models.ForeignKey(
        Landmark,
        db_column="landmark_id",
        on_delete=models.CASCADE,
        null=False,
        default=None,
    )

    def __str__(self):
        return self.text

    class Meta:
        managed = True
        db_table = "UserReviews"


class LikeRating(models.Model):
    like_rating_id = models.AutoField(primary_key=True, null=False)
    user_id = models.ForeignKey(
        AccountUser,
        db_column="user_id",
        on_delete=models.CASCADE,
        null=False,
        default=None,
    )
    landmark_id = models.ForeignKey(
        Landmark,
        db_column="landmark_id",
        on_delete=models.CASCADE,
        null=False,
        default=None,
    )
    type = models.CharField(max_length=5, default="like")
    date_liked_or_rated = models.DateField(default=None)

    def __str__(self):
        return self.type

    class Meta:
        managed = True
        db_table = "LikesRatings"


class Tag(models.Model):
    tag_id = models.AutoField(primary_key=True, default=None, null=False)
    tag = models.CharField(max_length=255, unique=True)

    def __str__(self):
        return self.tag

    class Meta:
        managed = False
        db_table = "Tags"


class LandmarkTag(models.Model):
    landmark_tag_id = models.AutoField(primary_key=True, null=False)
    landmark = models.ForeignKey(
        Landmark,
        db_column="landmark",
        to_field="landmark",
        on_delete=models.CASCADE,
        null=False,
        default=None,
    )
    tag = models.ForeignKey(
        Tag,
        db_column="tag",
        to_field="tag",
        on_delete=models.CASCADE,
        null=False,
        default=None,
    )

    def __str__(self):
        return self.landmark

    class Meta:
        managed = False
        db_table = "LandmarkTags"
        unique_together = (("landmark", "tag_id"),)


# AllAuth
class SocialProvider(models.Model):
    provider = models.CharField(max_length=50)
    client_id = models.CharField(max_length=255, default=None)
    secret = models.CharField(max_length=255, default=None)
    key = models.CharField(max_length=255, blank=True, null=True, default=None)
    user_id = models.ForeignKey(
        AccountUser,
        db_column="user_id",
        on_delete=models.CASCADE,
        null=False,
        default=None,
    )

    def __str__(self):
        return self.provider

    class Meta:
        managed = True
        db_table = "SocialProvider"


# Google Map
class MapData(models.Model):
    name = models.CharField(
        max_length=255, blank=True, default=None
    )  # Optional name for the map configuration
    data = models.JSONField(default=dict)  # Stores map data in JSON format

    def __str__(self):
        return self.name

    class Meta:
        managed = False
        db_table = "MapData"
