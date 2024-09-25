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
    AlaguideObject,
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
        fields = ["city_id", "city", "description", "latitude", "longitude", "country"]


# Language Selector Logic
class LanguageSerializer(serializers.Serializer):
    language_code = serializers.CharField()
    language_name = serializers.CharField()


class PreferredLanguageUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ["preferred_language"]


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

    def get_audio_rus_url(self, obj):
        request = self.context.get("request")
        return (
            request.build_absolute_uri(obj.audio_rus_url.url)
            if obj.audio_rus_url
            else None
        )

    def get_audio_eng_url(self, obj):
        request = self.context.get("request")
        return (
            request.build_absolute_uri(obj.audio_eng_url.url)
            if obj.audio_eng_url
            else None
        )

    def get_audio_kz_url(self, obj):
        request = self.context.get("request")
        return (
            request.build_absolute_uri(obj.audio_kz_url.url)
            if obj.audio_kz_url
            else None
        )


# The Main AlaguideObject ("guideObjectList/") & ("guideObjectList/<int:pk>/")
class AlaguideObjectSerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField()
    audio_rus_url = serializers.SerializerMethodField()
    audio_eng_url = serializers.SerializerMethodField()
    audio_kz_url = serializers.SerializerMethodField()

    def get_image_url(self, obj):
        if obj.image_url:
            return self.context["request"].build_absolute_uri(obj.image_url.url)
        return None

    def get_audio_rus_url(self, obj):
        request = self.context.get("request")
        if obj.audio_rus_url and obj.audio_rus_url.audio_rus_url:
            return request.build_absolute_uri(obj.audio_rus_url.audio_rus_url.url)
        return None

    def get_audio_eng_url(self, obj):
        request = self.context.get("request")
        if obj.audio_eng_url and obj.audio_eng_url.audio_eng_url:
            return request.build_absolute_uri(obj.audio_eng_url.audio_eng_url.url)
        return None

    def get_audio_kz_url(self, obj):
        request = self.context.get("request")
        if obj.audio_kz_url and obj.audio_kz_url.audio_kz_url:
            return request.build_absolute_uri(obj.audio_kz_url.audio_kz_url.url)
        return None

    class Meta:
        model = AlaguideObject
        fields = "__all__"
