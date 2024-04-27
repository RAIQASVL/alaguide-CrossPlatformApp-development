from django.db import models

# Database Models


class Country(models.Model):
    country_id = models.AutoField(primary_key=True)
    countryname = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = "Countries"


class City(models.Model):
    city_id = models.AutoField(primary_key=True)
    cityname = models.CharField(max_length=100)
    description = models.TextField()
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    country = models.ForeignKey(Country, on_delete=models.CASCADE)

    class Meta:
        managed = False
        db_table = "Cities"


class Landmark(models.Model):
    landmark_id = models.AutoField(primary_key=True)
    landmarkname = models.CharField(max_length=100)
    description = models.TextField()
    image_url = models.CharField(max_length=255)
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    city = models.ForeignKey(City, on_delete=models.CASCADE)

    class Meta:
        managed = False
        db_table = "Landmarks"


class AudioBook(models.Model):
    audiobook_id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=255)
    description = models.TextField()
    audio_url = models.CharField(max_length=255)
    landmark = models.ForeignKey(Landmark, on_delete=models.CASCADE)

    class Meta:
        managed = False
        db_table = "AudioBooks"


class User(models.Model):
    user_id = models.AutoField(primary_key=True)
    username = models.CharField(max_length=100)
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    email = models.EmailField(max_length=100)
    password = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = "Users"


class UserReview(models.Model):
    review_id = models.AutoField(primary_key=True)
    text = models.TextField()
    rating = models.DecimalField(max_digits=3, decimal_places=1)
    date_posted = models.DateField()
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    landmark = models.ForeignKey(Landmark, on_delete=models.CASCADE)

    class Meta:
        managed = False
        db_table = "UserReviews"


class LikeRating(models.Model):
    like_rating_id = models.AutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    landmark = models.ForeignKey(Landmark, on_delete=models.CASCADE)
    type = models.CharField(max_length=5)
    date_liked_or_rated = models.DateField()

    class Meta:
        managed = False
        db_table = "LikesRatings"


class Tag(models.Model):
    tag_id = models.AutoField(primary_key=True)
    tagname = models.CharField(max_length=255)

    class Meta:
        managed = False
        db_table = "Tags"


class LandmarkTag(models.Model):
    landmark = models.ForeignKey(Landmark, on_delete=models.CASCADE)
    tag = models.ForeignKey(Tag, on_delete=models.CASCADE)

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
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    landmark = models.ForeignKey(Landmark, on_delete=models.CASCADE)

    def __str__(self):
        return self.provider

    class Meta:
        managed = False
        db_table = "SocialProvider"
