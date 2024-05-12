from rest_framework import serializers

# from .models import Landmark, Category

# class CategorySerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Category
#         fields = ("id", "name")

# class LandmarkSerializer(serializers.ModelSerializer):
#     category = CategorySerializer(read_only=True)
    
#     class Meta:
#         model = Landmark
#         fields = ('id', 'name', 'latitude', 'longitude', 'category', 'description')
        