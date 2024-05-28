from django.conf import settings
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.generics import RetrieveUpdateAPIView
from rest_framework.parsers import FormParser, MultiPartParser, JSONParser
from rest_framework import viewsets, permissions
from rest_framework.permissions import IsAuthenticated
from rest_framework import status, viewsets
from django.shortcuts import render, get_object_or_404
from core import models
from api import serializers

# Create your views here.


class IsAdminOrReadOnly(permissions.BasePermission):
    """
    Custom permission to only allow admins to edit or delete.
    """

    def has_permission(self, request, view):
        return bool(
            request.method in permissions.SAFE_METHODS
            or request.user
            and request.user.is_staff
        )


# 1. User Profile API ("me/") & AcountUser
class MeApiHandler(RetrieveUpdateAPIView):
    """
    API Endpoint that returns currently logged-in account's user information.
    This includes information that is not publicly-available.
    """

    permission_classes = [IsAuthenticated]
    parser_classes = [FormParser, MultiPartParser, JSONParser]
    serializer_class = serializers.AccountUserSerializer

    def get(self, request):
        if request.user.is_authenticated:
            user = request.user
            return Response({"username": user.username, "email": user.email})
        else:
            return Response({"error": "User is not authenticated"}, status=401)

    def get_object(self):
        return get_object_or_404(models.AccountUser, user_id=self.request.user.id)

    def retrieve(self, request):
        user_settings = models.AccountUser.objects.get(user_id=request.user.id)
        serializer = serializers.AccountUserSerializer(user_settings)

        return Response(serializer.data)


# 2. AccountUser ("users/")
class AccountUserViewSet(viewsets.ModelViewSet):
    queryset = models.AccountUser.objects.all()
    serializer_class = serializers.AccountUserSerializer
    permission_classes = [IsAdminOrReadOnly]

    def get_serializer_class(self):
        if self.action in ["list", "retrieve"]:
            return serializers.PublicScopeAccountUserSerializer
        return serializers.AccountUserSerializer


# 3. Country
class CountryViewSet(viewsets.ModelViewSet):
    queryset = models.Country.objects.all()
    serializer_class = serializers.CountrySerializer
    permission_classes = [IsAdminOrReadOnly]


# 4. City
class CityViewSet(viewsets.ModelViewSet):
    queryset = models.City.objects.all()
    serializer_class = serializers.CitySerializer
    permission_classes = [IsAdminOrReadOnly]


# 5. Category
class CategoryViewSet(viewsets.ModelViewSet):
    queryset = models.Category.objects.all()
    serializer_class = serializers.CategorySerializer
    permission_classes = [IsAdminOrReadOnly]


# 6. Landmark
class LandmarkViewSet(viewsets.ModelViewSet):
    queryset = models.Landmark.objects.all()
    serializer_class = serializers.LandmarkSerializer
    permission_classes = [IsAdminOrReadOnly]


# 7. AudioBooks ("guideAudioBooks/")
class AudioBookViewSet(viewsets.ModelViewSet):
    queryset = models.AudioBook.objects.all()
    serializer_class = serializers.AudioBookSerializer
    permission_classes = [IsAdminOrReadOnly]


# 8. The Main AlaguideObject View ("guideObjectList/")
class ListAlaguideObject(viewsets.ModelViewSet):
    queryset = models.AlaguideObject.objects.all()
    serializer_class = serializers.AlaguideObjectSerializer
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


# 8.1 Details of the AlaguideObjects
class DetailAlaguideObject(viewsets.ModelViewSet):
    queryset = models.AlaguideObject.objects.all()
    serializer_class = serializers.AlaguideObjectSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]


# 9. Language Selection ("guideLanguageSelection/")
class LanguageSelectionView(APIView):
    permission_classes = [permissions.AllowAny]

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
        serializer = serializers.AccountUserSerializer(user, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request):
        user = request.user
        serializer = serializers.AccountUserSerializer(user, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# 10. ViewSets for CRUD operations


# 10.1
class UserReviewViewSet(viewsets.ModelViewSet):
    queryset = models.UserReview.objects.all()
    serializer_class = serializers.UserReviewSerializer
    permission_classes = [IsAdminOrReadOnly]


# 10.2
class LikeRatingViewSet(viewsets.ModelViewSet):
    queryset = models.LikeRating.objects.all()
    serializer_class = serializers.LikeRatingSerializer
    permission_classes = [IsAdminOrReadOnly]


# 10.3
class TagViewSet(viewsets.ModelViewSet):
    queryset = models.Tag.objects.all()
    serializer_class = serializers.TagSerializer
    permission_classes = [IsAdminOrReadOnly]


# 10.4
class LandmarkTagViewSet(viewsets.ModelViewSet):
    queryset = models.LandmarkTag.objects.all()
    serializer_class = serializers.LandmarkTagSerializer
    permission_classes = [IsAdminOrReadOnly]


# 11. Feedback - Role-Based Access Control (RBAC)
class FeedbackView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        feedback_data = request.data
        # Here you can process the feedback sent from the user
        # Create an appropriate model and serialiser to store the feedback
        # Processing example:
        return Response({"message": "Feedback received successfully"})
