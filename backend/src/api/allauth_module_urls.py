from django.urls import path, include
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

# 1. Authentication and Authorization - Django Allauth 

urlpatterns = [
    path("home/", TemplateView.as_view(template_name="dashboard/home.html"), name="home"),
    path("accounts/", include("allauth.urls")),
    path("accounts/login/", LoginView.as_view(), name="account_login"),
    path("accounts/signup/", SignupView.as_view(), name="account_signup"),
    path("accounts/logout/", LogoutView.as_view(), name="account_logout"),
    path("accounts/password/set/", PasswordSetView.as_view(), name="account_set_password"),
    path("accounts/password/change/", PasswordChangeView.as_view(), name="account_change_password"),
    path("accounts/password/reset/", PasswordResetView.as_view(), name="account_reset_password"),
    path("accounts/password/reset/<uidb64>/<token>/", PasswordResetFromKeyView.as_view(), name="account_reset_password_from_key"),
    path("accounts/email/", EmailView.as_view(), name="account_email"),
    path("accounts/confirm-email/<key>/", ConfirmEmailView.as_view(), name="account_confirm_email"),
]
