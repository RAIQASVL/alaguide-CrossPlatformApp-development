from django.conf import settings
from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter, SimpleRouter
from django.conf.urls.static import static
from django.views.generic import TemplateView
from allauth.account.views import (
    LoginView,
    SignupView,
    LogoutView,
    PasswordSetView,
    PasswordChangeView,
    PasswordResetView,
    PasswordResetFromKeyView,
    EmailView,
    ConfirmEmailView,
)
from api.views import (
    MeApiHandler,
    AccountUserViewSet,
    LanguageSelectionView,
    CountryViewSet,
    CityViewSet,
    CategoryViewSet,
    LandmarkViewSet,
    AudioBookViewSet,
    ListAlaguideObject,
    DetailAlaguideObject,
    FeedbackView,
    UserReviewViewSet,
    LikeRatingViewSet,
    TagViewSet,
    LandmarkTagViewSet
)

router = DefaultRouter()
simple_router = SimpleRouter()

router.register(r'users', AccountUserViewSet)
router.register(r'countries', CountryViewSet)
router.register(r'cities', CityViewSet)
router.register(r'categories', CategoryViewSet)
router.register(r'landmarks', LandmarkViewSet)
router.register(r'audiobooks', AudioBookViewSet)
router.register(r'alaguideobjects-list', ListAlaguideObject, basename="alaguideobjects-list")
router.register(r'alaguideobjects-detail', DetailAlaguideObject, basename="alaguideobjects-detail")
router.register(r'userreviews', UserReviewViewSet)
router.register(r'likeratings', LikeRatingViewSet)
router.register(r'tags', TagViewSet)
router.register(r'landmarktags', LandmarkTagViewSet)

urlpatterns = [
    # Django Admin
    path("admin/", admin.site.urls),
    # API v1 URLS
    path("api/v1/", include(router.urls)),
    # Other app URLS 
    path("api/v1/", include("api.urls")),

]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
