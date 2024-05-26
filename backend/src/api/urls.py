from django.urls import path, include
from rest_framework.routers import DefaultRouter
from api import views

router = DefaultRouter()
router.register(r'users', views.AccountUserViewSet, basename="AccountUserViewSet")
router.register(r'countries', views.CountryViewSet, basename="CountryViewSet")
router.register(r'cities', views.CityViewSet, basename="CityViewSet")
router.register(r'categories', views.CategoryViewSet, basename="CategoryViewSet")
router.register(r'landmarks', views.LandmarkViewSet, basename="LandmarkViewSet")
router.register(r'guide-audiobooks', views.AudioBookViewSet, basename="AudioBookViewSet")
router.register(r'alaguideobjects', views.ListAlaguideObject, basename="ListAlaguideObject")
router.register(r'alaguideobject-details', views.DetailAlaguideObject, basename="DetailAlaguideObject")
router.register(r'userreviews', views.UserReviewViewSet, basename="UserReviewViewSet")
router.register(r'likeratings', views.LikeRatingViewSet, basename="LikeRatingViewSet")
router.register(r'tags', views.TagViewSet, basename="TagViewSet")
router.register(r'landmarktags', views.LandmarkTagViewSet, basename="LandmarkTagViewSet")

urlpatterns = [
    # Other app URLS
    path('', include(router.urls)),
    # Language selection
    path('guideLanguageSelection/', views.LanguageSelectionView.as_view(), name="guide_language_selection"),
    # Feedback
    path('guidePostFeedback/', views.FeedbackView.as_view(), name="feedback"),
    # Me API
    path('me/', views.MeApiHandler.as_view(), name='api_accounts_me'),
]
