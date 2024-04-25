from django.db import models

# Create your models here.


# Google Social App
class GoogleSocialApp(models.Model):
    client_id = models.CharField(max_length=255)
    secret = models.CharField(max_length=255)
    key = models.CharField(max_length=255, blank=True, null=True)

    def __str__(self):
        return self.client_id


# Database models
class Users(models.Model):
    email = models.EmailField(max_length=30)
    password = models.CharField(max_length=50)


class Person(models.Model):
    first_name = models.CharField(max_length=70)
    last_name = models.CharField(max_length=70)
