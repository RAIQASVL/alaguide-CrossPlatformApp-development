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
        return request.build_absolute_uri(obj.audio_file.url) if obj.audio_file else None    

# The Main AlaguideObject ("guideObjectList/") & ("guideObjectList/<int:pk>/")
class AlaguideObjectSerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField()
    audio_url = serializers.SerializerMethodField()
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
            "image",
            "image_url",
            "audio",
            "audio_url"
        )
    def get_image_url(self, obj):
        request = self.context.get('request')
        return request.build_absolute_uri(obj.image.image_file.url) if obj.image else None
    
    def get_audio_url(self, obj):
        request = self.context.get('request')
        return request.build_absolute_uri(odj.audio.audio_file.url) if obj.audio else None

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