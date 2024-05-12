from django.db import models

# Database Models


class Country(models.Model):
    country_id = models.AutoField(primary_key=True)
    countryname = models.CharField(max_length=100)

    def __str__(self):
        return self.name

    class Meta:
        managed = False
        db_table = "Countries"


class City(models.Model):
    city_id = models.AutoField(primary_key=True)
    cityname = models.CharField(max_length=100)
    description = models.TextField()
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    country = models.ForeignKey(Country, on_delete=models.CASCADE, null=True)

    def __str__(self):
        return self.name

    class Meta:
        managed = False
        db_table = "Cities"


class Category(models.Model):
    """Model for categorizing landmarks."""
    category_id = models.AutoField(primary_key=True)
    categoryname = models.CharField(max_length=50, unique=True)

    def __str__(self):
        return self.name

    class Meta:
        managed = False
        db_table = "LandmarksCategory"


class Landmark(models.Model):
    landmark_id = models.AutoField(primary_key=True)
    landmarkname = models.CharField(max_length=100)
    description = models.TextField()
    image_url = models.CharField(max_length=255)
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    city = models.ForeignKey(City, on_delete=models.CASCADE, null=True)
    category = models.ForeignKey(
        Category, on_delete=models.CASCADE, null=True
    )  # Category relationship

    def __str__(self):
        return self.name

    class Meta:
        managed = False
        db_table = "Landmarks"


class AudioBook(models.Model):
    audiobook_id = models.AutoField(primary_key=True,)
    title = models.CharField(max_length=255)
    description = models.TextField()
    audio_url = models.CharField(max_length=255)
    landmark_id = models.ForeignKey(Landmark, on_delete=models.CASCADE, db_column="landmark_id")

    def __str__(self):
        return self.name

    class Meta:
        managed = False
        db_table = "AudioBooks"


# Model for main objects
class AlaguideObject(models.Model):
    ala_object_id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=255)
    description = models.TextField()
    city = models.ForeignKey(City, on_delete=models.CASCADE, null=True)
    category = models.ForeignKey(Category, on_delete=models.CASCADE)
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    image_url = models.CharField(max_length=255)
    audio_url = models.ForeignKey(AudioBook, on_delete=models.CASCADE, db_column="audio_url")
    
    def __str__(self):
        return self.name
    
    class Meta:
        managed = False
        db_table = "AlaguideObjects"


class User(models.Model):
    user_id = models.AutoField(primary_key=True)
    username = models.CharField(max_length=100)
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    email = models.EmailField(max_length=100)
    password = models.CharField(max_length=100)

    def __str__(self):
        return self.name

    class Meta:
        managed = False
        db_table = "Users"


class UserReview(models.Model):
    review_id = models.AutoField(primary_key=True)
    text = models.TextField()
    rating = models.DecimalField(max_digits=3, decimal_places=1)
    date_posted = models.DateField()
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True)
    landmark = models.ForeignKey(Landmark, on_delete=models.CASCADE, null=True)

    def __str__(self):
        return self.name

    class Meta:
        managed = False
        db_table = "UserReviews"


class LikeRating(models.Model):
    like_rating_id = models.AutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True)
    landmark = models.ForeignKey(Landmark, on_delete=models.CASCADE, null=True)
    type = models.CharField(max_length=5)
    date_liked_or_rated = models.DateField()

    def __str__(self):
        return self.name

    class Meta:
        managed = False
        db_table = "LikesRatings"


class Tag(models.Model):
    tag_id = models.AutoField(primary_key=True)
    tagname = models.CharField(max_length=255)

    def __str__(self):
        return self.name

    class Meta:
        managed = False
        db_table = "Tags"


class LandmarkTag(models.Model):
    landmark = models.ForeignKey(Landmark, on_delete=models.CASCADE, null=True)
    tag = models.ForeignKey(Tag, on_delete=models.CASCADE, null=True)

    def __str__(self):
        return self.name

    class Meta:
        managed = False
        db_table = "LandmarkTags"
        unique_together = (("landmark", "tag"),)


# AllAuth
class SocialProvider(models.Model):
    provider = models.CharField(max_length=50)
    client_id = models.CharField(max_length=255)
    secret = models.CharField(max_length=255)
    key = models.CharField(max_length=255, blank=True, null=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True)
    landmark = models.ForeignKey(Landmark, on_delete=models.CASCADE, null=True)

    def __str__(self):
        return self.provider

    class Meta:
        managed = False
        db_table = "SocialProvider"


# Google Map
class MapData(models.Model):
    name = models.CharField(
        max_length=255, blank=True
    )  # Optional name for the map configuration
    data = models.JSONField()  # Stores map data in JSON format

    def __str__(self):
        return self.name

    class Meta:
        managed = False
        db_table = "MapData"


class Venue(models.Model):
    name = models.CharField(max_length=255)
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    
    def __str__(self):
        return self.name
    
    class Meta:
        managed = True
        db_table = "Venues"    