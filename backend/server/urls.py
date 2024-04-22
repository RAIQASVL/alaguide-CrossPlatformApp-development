from django.contrib import admin
from django.urls import re_path, path, include
from . import views

urlpatterns = [
    # Add points for "users" app-module to connect a database"
    path("admin/", admin.site.urls),
    path("users/", include("users.urls")),
    # Add JWT points
    re_path("login", views.login),
    re_path("signup", views.signup),
    re_path("test_token", views.test_token),
    # AllAuth
    path("accounts/", include("allauth.urls")),
]
