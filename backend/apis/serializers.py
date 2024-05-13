from rest_framework import serializers
from core import models


# 1. The Main AlaguideObject View ("guide/objects/")
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


# 2. Menu View ("guide/menu/") - without serialaizers


# 3. Menu View: Sub Category "Location" ("guide/menu/location/")
class CountrySerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Country
        fields = ["country_id", "countryname"]


class CitySerializer(serializers.ModelSerializer):
    class Meta:
        model = models.City
        fields = ["city_id", "cityname"]


# 4. Menu View: Sub Category "Content" ("guide/menu/content/")

# |  Logic include class AlaguideObjectSerializer(serializers.ModelSerializer)


# 5. Menu View: Sub Category "Language" ("guide/menu/language/")
class LanguageSerializer(serializers.Serializer):
    language_code = serializers.CharField()
    language_name = serializers.CharField()


# 6. Menu View: Sub Category "About" ("guide/menu/about/")
class AboutSerializer(serializers.Serializer):
    about_text = serializers.CharField()


# 7. Menu View: Sub Category "Support" ("guide/menu/support/")
class SupportView(serializers.Serializer):
    email = serializers.EmailField()
    phone = serializers.CharField()
    address = serializers.CharField()
