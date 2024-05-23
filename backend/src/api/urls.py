from django.urls import path, include
from . import views
from django.views.generic import TemplateView
from allauth.account.views import LoginView, SignupView, LogoutView
from allauth.account.views import PasswordSetView
from allauth.account.views import PasswordChangeView
from allauth.account.views import PasswordResetView
from allauth.account.views import PasswordResetFromKeyView
from allauth.account.views import EmailView
from allauth.account.views import ConfirmEmailView
from .views import (
    ListAlaguideObject,
    DetailAlaguideObject,
    MeApiHandler,
    LanguageSelectionView,
    FeedbackView,
)

urlpatterns = [
    # 1. Authentication and Authorization - Django Allauth
    path("home/", TemplateView.as_view(template_name="dashboard/home.html"), name="home"),
    path("accounts/", include("allauth.urls")),
    path("accounts/login/", LoginView.as_view(), name="account_login"),
    path("accounts/signup/", SignupView.as_view(), name="account_signup"),
    path("accounts/logout/", LogoutView.as_view(), name="account_logout"),
    # | Password Management
    path("accounts/password/set/", PasswordSetView.as_view(), name="account_set_password"),
    path("accounts/password/change/", PasswordChangeView.as_view(), name="account_change_password"),
    # | Password Reset
    path("accounts/password/reset/", PasswordResetView.as_view(), name="account_reset_password"),
    path("accounts/password/reset/<uidb64>/<token>/", PasswordResetFromKeyView.as_view(), name="account_reset_password_from_key"),
    # | Emails Management
    path("accounts/email/", EmailView.as_view(), name="account_email"),
    path("accounts/confirm-email/<key>/", ConfirmEmailView.as_view(), name="account_confirm_email"),
    # 2. User Profile API
    path("me/", MeApiHandler.as_view(), name="api_accounts_me"),
    # 3. Resource-based URLs
    # | The Main AlaguideObject View ("guideObjectList/")
    path("guideObjectList/", ListAlaguideObject.as_view()),
    path("guideObjectList/<int:pk>/", DetailAlaguideObject.as_view()),
    # 4. Language Selection
    path("guideLanguageSelection/", LanguageSelectionView.as_view()),
    # 5. Feedback | Role-Based Access Control (RBAC)
    path("guidePostFeedback/", FeedbackView.as_view(), name="feedback"),
]

    # Google Maps API
    # path("map/", views.map_view, name="map-view"),
    # path("api/landmarks/", views.get_landmark, name="landmarks-api"),
    # Other URL patterns for your core app