from django.conf import settings
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
        ]

        read_only_fields = [
            "user_id",
            "username",
        ]


class PublicScopeAccountUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.AccountUser
        fields = ["user_id", "username", "first_name", "last_name", "email"]
        read_only_fields = fields


# AudioBooks for AlaguideObject
class AudioBookSerializer(serializers.ModelSerializer):
    audio_url = serializers.SerializerMethodField()

    class Meta:
        model = models.AudioBook
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
        model = models.AlaguideObject
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


#
class CountrySerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Country
        fields = ["country_id", "country"]


class CitySerializer(serializers.ModelSerializer):
    class Meta:
        model = models.City
        fields = ["city_id", "city"]


# Menu View: Sub Category "Language" ("guide/menu/language/")
class LanguageSerializer(serializers.Serializer):
    language_code = serializers.CharField()
    language_name = serializers.CharField()


# SerializersSets for CRUD operations
class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Category
        fields = "__all__"


class LandmarkSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Landmark
        fields = "__all__"


class UserReviewSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.UserReview
        fields = "__all__"


class LikeRatingSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.LikeRating
        fields = "__all__"


class TagSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Tag
        fields = "__all__"


class LandmarkTagSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.LandmarkTag
        fields = "__all__"
