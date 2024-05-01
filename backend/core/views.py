import os

from rest_framework import status 
from rest_framework.response import Response
from rest_framework.views import APIView

from django.shortcuts import render
from django.http import HttpResponse
from django.http import JsonResponse

from .models import Landmark
from .serializers import LandmarkSerializer

def get_landmark():
    landmarks = Landmark.objects.all()
    data = []
    for landmark in landmarks:
        data.append(
            {
                "id": landmark.id,  # Include ID if needed for other functionalities
                "name": landmark.name,
                "latitude": landmark.latitude,
                "longitude": landmark.longitude,
                "category": landmark.category.name,  # Assuming a category field
                "description": landmark.description,
                # Add other relevant data if needed
            }
        )
    return JsonResponse(data, safe=False)  # Set safe=False for nested data

class LandmarkListAPIView(APIView):
    def get (self, request):
        landmarks = Landmark.objects.all()
        serializer = LandmarkSerializer(landmarks, many=True)
        return Response(serializer.data)


def map_view(request):
    # You might want to fetch additional context data here (e.g., user information)
    project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")
    api_key = os.environ.get("GOOGLE_CLOUD_API_KEY")
    landmarks = get_landmark()
    context = {"landmarks": landmarks}
    return render(request, "map_view.html", context)

