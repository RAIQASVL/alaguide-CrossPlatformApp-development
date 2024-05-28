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

# AudioBooks for AlaguideObject  
class AudioBookSerializer(serializers.ModelSerializer):
    audio_url = serializers.SerializerMethodField()
    class Meta:
        model = models.AudioBook
        fields = '__all__'
    
    def get_audio_url(self, obj):
        request = self.context.get('request')
        return request.build_absolute_uri(obj.audio_url.url) if obj.audio_url else None    

# The Main AlaguideObject ("guideObjectList/") & ("guideObjectList/<int:pk>/")
class AlaguideObjectSerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField()
    audio_url = serializers.SerializerMethodField()
    class Meta:
        model = models.AlaguideObject
        fields = (
            "ala_object_id",
            "landmark_id",
            "title",
            "description",
            "city_id",
            "category_id",
            "latitude",
            "longitude",
            "image_url",
            "audio_url"
        )

    def get_image(self, obj):
        request = self.context.get('request')
        return request.build_absolute_uri(obj.image_url.image_url.url) if obj.image_url else None
    
    def get_audio(self, obj):
        request = self.context.get('request')
        return request.build_absolute_uri(obj.audio_url.audio_url.url) if obj.audio_url else None

# 
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
    

# SerializersSets for CRUD operations
class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Category
        fields = '__all__'
        
class LandmarkSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Landmark
        fields = '__all__'
        

class UserReviewSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.UserReview
        fields = '__all__'
class LikeRatingSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.LikeRating
        fields = '__all__'

class TagSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Tag
        fields = '__all__'        
        
class LandmarkTagSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.LandmarkTag
        fields = '__all__'    