from django.urls import path, include, re_path
from rest_framework.routers import DefaultRouter
from dj_rest_auth.views import (
    PasswordResetConfirmView,
    PasswordResetView,
    PasswordChangeView,
)
from dj_rest_auth.registration.views import VerifyEmailView, ResendEmailVerificationView


router = DefaultRouter()
app_name = "identity"

urlpatterns = [
    path(
        "password/reset/confirm/<uidb64>/<token>/",
        PasswordResetConfirmView.as_view(),
        name="password_reset_confirm",
    ),
]
