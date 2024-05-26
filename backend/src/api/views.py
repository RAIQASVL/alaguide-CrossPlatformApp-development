from django.conf import settings
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.generics import RetrieveUpdateAPIView, ListCreateAPIView, RetrieveUpdateDestroyAPIView
from rest_framework.parsers import FormParser, MultiPartParser, JSONParser
from rest_framework.permissions import IsAuthenticated
from rest_framework import status, viewsets
from django.shortcuts import render, get_object_or_404
from rest_framework import generics
from core import models
from api import serializers

# Create your views here.


# User Profile API ("me/")
class MeApiHandler(RetrieveUpdateAPIView):
    """
    API Endpoint that returns currently logged-in account's user information.
    This includes information that is not publicly-available.
    """

    permission_classes = [IsAuthenticated]
    parser_classes = [FormParser, MultiPartParser, JSONParser]
    serializer_class = serializers.AccountUserSerializer

    def get_object(self):
        return self.request.user

    def retrieve(self, request):
        user_settings = models.AccountUser.objects.get(user_id=request.user.user_id)
        serializer = serializers.AccountUserSerializer(user_settings)

        return Response(serializer.data)


# The Main AlaguideObject View ("guideObjectList/")
class ListAlaguideObject(viewsets.ModelViewSet):
    queryset = models.AlaguideObject.objects.all()
    serializer_class = serializers.AlaguideObjectSerializer

    def get_queryset(self):
        queryset = super().get_queryset()
        country_id = self.request.query_params.get(
            "country_id", settings.DEFAULT_COUNTRY_ID
        )
        city_id = self.request.query_params.get("city_id", settings.DEFAULT_CITY_ID)

        if country_id and city_id:
            queryset = queryset.filter(city__country_id=country_id, city_id=city_id)
        elif country_id:
            queryset = queryset.filter(city__country_id=country_id)
        elif city_id:
            queryset = queryset.filter(city_id=city_id)

        return queryset


class DetailAlaguideObject(viewsets.ModelViewSet):
    queryset = models.AlaguideObject.objects.all()
    serializer_class = serializers.AlaguideObjectSerializer


# Resource-based
# | Language Selection ("guideLanguageSelection/")
class LanguageSelectionView(APIView):
    def get(self, request):
        # Assume that the language is passed as a query parameter
        selected_language = request.query_params.get("language")

        # Here you can get a list of available languages from your application settings or a database
        # Suppose you have a list of languages in the form of a dictionary
        languages = [
            {"language_code": "kz", "language_name": "Kazakh"},
            {"language_code": "ru", "language_name": "Russian"},
            {"language_code": "en", "language_name": "English"},
            # Others ...
        ]

        return Response(languages)

    def put(self, request):
        user = request.user
        serializer = serializers.AccountUserSerializer(user, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# Role-Based Access Control (RBAC)
class FeedbackView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        # Here you can process the feedback sent from the user
        # Create an appropriate model and serialiser to store the feedback
        # Processing example:

        feedback_data = request.data  # Assume that feedback data is sent in JSON format
        # Here you can perform additional actions such as saving to the database and sending notifications to the administrator
        return Response({"message": "Feedback received successfully"})


# ViewSets for CRUD operations
class CountryViewSet(viewsets.ModelViewSet):
    queryset = models.Country.objects.all()
    serializer_class = serializers.CountrySerializer

class CityViewSet(viewsets.ModelViewSet):
    queryset = models.City.objects.all()
    serializer_class = serializers.CitySerializer
    
class UserReviewViewSet(viewsets.ModelViewSet):
    queryset = models.UserReview.objects.all()
    serializer_class = serializers.UserReviewSerializer
    
class CategoryViewSet(viewsets.ModelViewSet):
    queryset = models.Category.objects.all()
    serializer_class = serializers.CategorySerializer
    
class LandmarkViewSet(viewsets.ModelViewSet):
    queryset = models.Landmark.objects.all()
    serializer_class = serializers.LandmarkSerializer

class LandmarkTagViewSet(viewsets.ModelViewSet):
    queryset = models.LandmarkTag.objects.all()
    serializer_class = serializers.LandmarkTagSerializer
    
class AudioBookViewSet(viewsets.ModelViewSet):
    queryset = models.AudioBook.objects.all()
    serializer_class = serializers.AudioBookSerializer

class AccountUserViewSet(viewsets.ModelViewSet):
    queryset = models.AccountUser.objects.all()
    serializer_class = serializers.AccountUserSerializer

class LikeRatingViewSet(viewsets.ModelViewSet):
    queryset = models.LikeRating.objects.all()
    serializer_class = serializers.LikeRatingSerializer

class TagViewSet(viewsets.ModelViewSet):
    queryset = models.Tag.objects.all()
    serializer_class = serializers.TagSerializer
