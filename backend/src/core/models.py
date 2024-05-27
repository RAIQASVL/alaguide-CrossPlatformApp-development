from django.db import models
from django.core.files import File
from django.contrib.auth.models import (
    AbstractBaseUser,
    BaseUserManager,
    PermissionsMixin,
)
from server.settings import BASE_DIR
#from django.utils import timezone

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

    objects = CustomUserManager()

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["username", "first_name", "last_name"]

    def __str__(self):
        return self.name

    class Meta:
        managed = True
        db_table = "Users"

class Country(models.Model):
    country_id = models.AutoField(primary_key=True, null=False, default=None)
    countryname = models.CharField(max_length=100)

    def __str__(self):
        return self.countryname

    class Meta:
        managed = False
        db_table = "Countries"


class City(models.Model):
    city_id = models.AutoField(primary_key=True, null=False, default=None)
    cityname = models.CharField(max_length=100)
    description = models.TextField()
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    country_id = models.ForeignKey(Country, db_column="country_id", on_delete=models.CASCADE, null=False, default=None)

    def __str__(self):
        return self.cityname

    class Meta:
        managed = False
        db_table = "Cities"


class Category(models.Model):
    """Model for categorizing landmarks."""

    category_id = models.AutoField(primary_key=True, null=False, default=None)
    categoryname = models.CharField(max_length=50, unique=True)

    def __str__(self):
        return self.categoryname

    class Meta:
        managed = False
        db_table = "LandmarksCategory"


class Landmark(models.Model):
    landmark_id = models.AutoField(primary_key=True, null=False, default=None)
    landmarkname = models.CharField(max_length=100)
    description = models.TextField()
    image_url = models.FileField()
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    city_id = models.ForeignKey(City, db_column="city_id", on_delete=models.CASCADE, null=False, default=None)
    category_id = models.ForeignKey(Category, db_column="category_id", on_delete=models.CASCADE, null=False, default=None)  # Category relationship

    def __str__(self):
        return self.landmarkname
    class Meta:
        managed = False
        db_table = "Landmarks"


class AudioBook(models.Model):
    audiobook_id = models.AutoField(primary_key=True, null=False, default=None)
    title = models.CharField(max_length=255)
    description = models.TextField()
    audio_url = models.FileField(upload_to=(BASE_DIR / "media" / "audio"))
    landmark_id = models.ForeignKey(Landmark, db_column="landmark_id", on_delete=models.CASCADE, null=False, default=None)

    def __str__(self):
        return self.title
    
    class Meta:
        managed = False
        db_table = "AudioBooks"


# Model for main objects
class AlaguideObject(models.Model):
    ala_object_id = models.AutoField(primary_key=True, null=False, default=None)
    title = models.CharField(max_length=255)
    description = models.TextField()
    city_id = models.ForeignKey(City, db_column="city_id", on_delete=models.CASCADE, null=False, default=None)
    category_id = models.ForeignKey(Category, db_column="category_id", on_delete=models.CASCADE, null=False, default=None)
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    image_url = models.ForeignKey(
        Landmark, on_delete=models.CASCADE, 
        db_column="image_url", related_name='alaguide_objects', null=False, default=None
        )
    audio = models.ForeignKey(
        AudioBook, on_delete=models.CASCADE, 
        db_column="audio_url", related_name='alaguide_objects', null=False, default=None
        )

    def __str__(self):
        return self.title
    class Meta:
        managed = False
        db_table = "AlaguideObjects"

# Other Models
class UserReview(models.Model):
    review_id = models.AutoField(primary_key=True, null=False, default=None)
    text = models.TextField()
    rating = models.DecimalField(max_digits=3, decimal_places=1)
    date_posted = models.DateField(default=None)
    user_id = models.ForeignKey(AccountUser, db_column="user_id", on_delete=models.CASCADE, null=False, default=None)
    landmark_id = models.ForeignKey(Landmark, db_column="landmark_id", on_delete=models.CASCADE, null=False, default=None)

    def __str__(self):
        return self.text

    class Meta:
        managed = True
        db_table = "UserReviews"


class LikeRating(models.Model):
    like_rating_id = models.AutoField(primary_key=True, null=False)
    user_id = models.ForeignKey(AccountUser, db_column="user_id", on_delete=models.CASCADE, null=False, default=None)
    landmark_id = models.ForeignKey(Landmark, db_column="landmark_id", on_delete=models.CASCADE, null=False, default=None)
    type = models.CharField(max_length=5, default="like")
    date_liked_or_rated = models.DateField(default=None)

    def __str__(self):
        return self.type

    class Meta:
        managed = True
        db_table = "LikesRatings"


class Tag(models.Model):
    tag_id = models.AutoField(primary_key=True, null=False)
    tagname = models.CharField(max_length=255)

    def __str__(self):
        return self.tagname

    class Meta:
        managed = False
        db_table = "Tags"


class LandmarkTag(models.Model):
    landmark = models.ForeignKey(Landmark, db_column="landmark_id", on_delete=models.CASCADE, null=False, default=None)
    tag_id = models.ForeignKey(Tag, db_column="tag_id", on_delete=models.CASCADE, null=False, default=None)

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
    user_id = models.ForeignKey(AccountUser, db_column="user_id", on_delete=models.CASCADE, null=False, default=None)

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
