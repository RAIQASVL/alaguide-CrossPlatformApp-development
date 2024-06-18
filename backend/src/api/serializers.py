from django.conf import settings
from django.contrib.auth.tokens import default_token_generator
from django.core.mail import send_mail
from rest_framework import serializers
from core.models import (
    User,
    Country,
    City,
    Category,
    Landmark,
    AudioBook, 
    AlaguideObject
)
from core import models


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = "__all__"
        

class CountrySerializer(serializers.ModelSerializer):
    class Meta:
        model = Country
        fields = ["country_id", "country"]


class CitySerializer(serializers.ModelSerializer):
    class Meta:
        model = City
        fields = ["city_id", "city"]

# Language Selector Logic
class LanguageSerializer(serializers.Serializer):
    language_code = serializers.CharField()
    language_name = serializers.CharField()
    
class PreferredLanguageUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['preferred_language']


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = "__all__"


class LandmarkSerializer(serializers.ModelSerializer):
    class Meta:
        model = Landmark
        fields = "__all__"


# AudioBooks for AlaguideObject
class AudioBookSerializer(serializers.ModelSerializer):
    audio_url = serializers.SerializerMethodField()

    class Meta:
        model = AudioBook
        fields = "__all__"

    def get_audio_url(self, obj):
        request = self.context.get("request")
        return request.build_absolute_uri(obj.audio_url.url) if obj.audio_url else None


# The Main AlaguideObject ("guideObjectList/") & ("guideObjectList/<int:pk>/")
class AlaguideObjectSerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField()
    audio_url = serializers.SerializerMethodField()

    def get_image_url(self, obj):
        if obj.image_url:
            return (
                obj.image_url.image_url.url
            )  # access the actual image_url field in the Landmark model
        else:
            return None

    def get_audio_url(self, obj):
        if obj.audio_url:
            request = self.context.get("request")
            return request.build_absolute_uri(obj.audio_url.audio_url.url)
        else:
            return None

    class Meta:
        model = AlaguideObject
        fields = (
            "ala_object_id",
            "landmark",
            "description",
            "city",
            "category",
            "latitude",
            "longitude",
            "image_url",
            "audio_url",
        )

