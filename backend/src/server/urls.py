from django.contrib import admin
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
from api.views import (
    ListAlaguideObject,
    DetailAlaguideObject,
    MeApiHandler,
    LanguageSelectionView,
    FeedbackView,
)

urlpatterns = [
    # Django Admin
    path("admin/", admin.site.urls),
    # Other URL patterns for other apps
    path("api/v1/", include("api.urls")),
    # 1. Authentication and Authorization - Django Allauth
    path("api/v1/home/", TemplateView.as_view(template_name="dashboard/home.html"), name="home"),
    path("api/v1/accounts/", include("allauth.urls")),
    path("api/v1/accounts/login/", LoginView.as_view(), name="account_login"),
    path("api/v1/accounts/signup/", SignupView.as_view(), name="account_signup"),
    path("api/v1/accounts/logout/", LogoutView.as_view(), name="account_logout"),
    # | Password Management
    path("api/v1/accounts/password/set/", PasswordSetView.as_view(), name="account_set_password"),
    path("api/v1/accounts/password/change/", PasswordChangeView.as_view(), name="account_change_password"),
    # | Password Reset
    path("api/v1/accounts/password/reset/", PasswordResetView.as_view(), name="account_reset_password"),
    path("api/v1/accounts/password/reset/<uidb64>/<token>/", PasswordResetFromKeyView.as_view(), name="account_reset_password_from_key"),
    # | Emails Management
    path("api/v1/accounts/email/", EmailView.as_view(), name="account_email"),
    path("api/v1/accounts/confirm-email/<key>/", ConfirmEmailView.as_view(), name="account_confirm_email"),
    # 2. User Profile API
    path("api/v1/me/", MeApiHandler.as_view(), name="api_accounts_me"),
    # 3. Resource-based URLs
    # | The Main AlaguideObject View ("guideObjectList/")
    path("api/v1/guideObjectList/", ListAlaguideObject.as_view(), name="main_alaguide_object"), 
    path("api/v1/guideObjectList/<int:pk>/", DetailAlaguideObject.as_view(), name="detail_alaguide_object"),
    # 4. Language Selection
    path("api/v1/guideLanguageSelection/", LanguageSelectionView.as_view(), name="guide_languge_selection"),
    # 5. Feedback | Role-Based Access Control (RBAC)
    path("api/v1/guidePostFeedback/", FeedbackView.as_view(), name="feedback"),
]
