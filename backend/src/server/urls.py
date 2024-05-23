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
]
