from rest_framework import serializers
from core import models


class AccountUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.AccountUser
        fields = [
            "user_id",
            "username",
            "first_name",
            "last_name",
            "email",
            "default_country_id",
            "default_city_id",
            "preferred_language",
            "date_joined",
            "last_login",
        ]

        read_only_fields = [
            "user_id",
            "username",
            "date_joined",
            "last_login",
        ]


class PublicScopeAccountUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.AccountUser
        fields = ["user_id", "username", "first_name", "last_name", "email"]
        read_only_fields = fields


# The Main AlaguideObject View ("guide/objects/")
class AlaguideObjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.AlaguideObject
        fields = (
            "ala_object_id",
            "title",
            "description",
            "city",
            "category",
            "latitude",
            "longitude",
            "image_url",
            "audio_url",
        )


# Menu View: Sub Category "Location" ("guide/menu/location/")
class CountrySerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Country
        fields = ["country_id", "countryname"]


class CitySerializer(serializers.ModelSerializer):
    class Meta:
        model = models.City
        fields = ["city_id", "cityname"]


# Menu View: Sub Category "Language" ("guide/menu/language/")
class LanguageSerializer(serializers.Serializer):
    language_code = serializers.CharField()
    language_name = serializers.CharField()
