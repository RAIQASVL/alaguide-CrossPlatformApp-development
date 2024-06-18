from django.urls import path, include, re_path
from rest_framework.routers import DefaultRouter
from api import views
from api.views import (
    UserViewSet,
    CountryViewSet,
    CityViewSet,
    CategoryViewSet,
    LandmarkViewSet,
    AudioBookViewSet,
    ListAlaguideObject,
    LanguageSelectionView,
    FeedbackView
)
from core.views import (
    MeApiHandler
)

app_name = 'api'

router = DefaultRouter()

router.register(r'users', UserViewSet, basename="UsersViewSet")
router.register(r'countries', CountryViewSet, basename="CountryViewSet")
router.register(r'cities', CityViewSet, basename="CityViewSet")
router.register(r'categories', CategoryViewSet, basename="CategoryViewSet")
router.register(r'landmarks', LandmarkViewSet, basename="LandmarkViewSet")
router.register(r'guide-audiobooks', AudioBookViewSet, basename="AudioBookViewSet")
router.register(r'alaguideobjects', ListAlaguideObject, basename="ListAlaguideObject")


urlpatterns = [
    # Other app URLS
    path('', include(router.urls)),
    # Language selection
    path('guideLanguageSelection/', LanguageSelectionView.as_view(), name="guide_language_selection"),
    # Feedback
    path('guidePostFeedback/', FeedbackView.as_view(), name="feedback"),
    # Me API
    path('me/', MeApiHandler.as_view(), name='me'),
]
