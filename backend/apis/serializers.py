from rest_framework import serializers
from core import models

class AlaguideObjectSerializer(serializers.ModelSerializer):
    class Meta:
        fields = (
            "ala_object_id",
            "title",
            "description",
            "city",
            "category",
            "latitude",
            "longitude",
            "image_url",
            "audio_url"
        )
        model=models.AlaguideObject