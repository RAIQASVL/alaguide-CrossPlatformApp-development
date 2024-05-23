from django.conf import settings
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.generics import RetrieveUpdateAPIView
from rest_framework.parsers import FormParser, MultiPartParser, JSONParser
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from django.shortcuts import render
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
class ListAlaguideObject(generics.ListCreateAPIView):
    serializer_class = serializers.AlaguideObjectSerializer

    def get_queryset(self):
        queryset = models.AlaguideObject.objects.all()
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


class DetailAlaguideObject(generics.RetrieveUpdateDestroyAPIView):
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
