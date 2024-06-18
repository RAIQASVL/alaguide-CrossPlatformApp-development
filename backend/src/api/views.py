from django.conf import settings
from rest_framework.decorators import action, api_view
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import viewsets, permissions
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework import status, viewsets
from django.shortcuts import render, get_object_or_404
from core.views import IsAdminOrReadOnly, IsAuthenticated
from core.models import (
    User,
    Country,
    City,
    Category,
    Landmark,
    AudioBook,
    AlaguideObject
)
from api.serializers import (
    UserSerializer,
    CountrySerializer,
    CitySerializer,
    CategorySerializer,
    LandmarkSerializer,
    AudioBookSerializer,
    AlaguideObjectSerializer,
    PreferredLanguageUpdateSerializer
)


class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAdminOrReadOnly]


# Country
class CountryViewSet(viewsets.ModelViewSet):
    queryset = Country.objects.all()
    serializer_class = CountrySerializer
    permission_classes = [IsAdminOrReadOnly]


# City
class CityViewSet(viewsets.ModelViewSet):
    queryset = City.objects.all()
    serializer_class = CitySerializer
    permission_classes = [IsAdminOrReadOnly]


# Category
class CategoryViewSet(viewsets.ModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer
    permission_classes = [IsAdminOrReadOnly]


# Landmark
class LandmarkViewSet(viewsets.ModelViewSet):
    queryset = Landmark.objects.all()
    serializer_class = LandmarkSerializer
    permission_classes = [IsAdminOrReadOnly]


# AudioBooks ("guideAudioBooks/")
class AudioBookViewSet(viewsets.ModelViewSet):
    queryset = AudioBook.objects.all()
    serializer_class = AudioBookSerializer
    permission_classes = [IsAdminOrReadOnly]


# The Main AlaguideObject View ("guideObjectList/")
class ListAlaguideObject(viewsets.ModelViewSet):
    queryset = AlaguideObject.objects.all()
    serializer_class = AlaguideObjectSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]

    def get_queryset(self):
        queryset = super().get_queryset()
        country = self.request.query_params.get("country", settings.DEFAULT_COUNTRY)
        city = self.request.query_params.get("city", settings.DEFAULT_CITY)
        if country and city:
            queryset = queryset.filter(city__country=country, city_id=city)
        elif country:
            queryset = queryset.filter(city__country=country)
        elif city:
            queryset = queryset.filter(city_id=city)
        return queryset


# Language Selection ("guideLanguageSelection/")
class LanguageSelectionView(APIView):
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]

    def get(self, request):
        selected_language = request.query_params.get("language")
        languages = [
            {"language_code": "kz", "language_name": "Kazakh"},
            {"language_code": "ru", "language_name": "Russian"},
            {"language_code": "en", "language_name": "English"},
        ]
        return Response(languages)

    def put(self, request):
        user = request.user
        serializer = PreferredLanguageUpdateSerializer(user, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_404_BAD_REQUEST)

# Feedback - Role-Based Access Control (RBAC)
class FeedbackView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        feedback_data = request.data
        # Here you can process the feedback sent from the user
        # Create an appropriate model and serializer to store the feedback
        # Processing example:
        return Response({"message": "Feedback received successfully"})
