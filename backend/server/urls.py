from django.contrib import admin
from django.urls import path, include
from . import views
from django.views.generic import TemplateView
from allauth.account.views import LoginView, SignupView

urlpatterns = [
    path("admin/", admin.site.urls),
    path(
        "home/", TemplateView.as_view(template_name="dashboard/home.html"), name="home"
    ),
    path("accounts/", include("allauth.urls")),
    # Django Allauth
    path("accounts/login/", LoginView.as_view(), name="account_login"),
    path("accounts/signup/", SignupView.as_view(), name="account_signup"),
    # Google Maps API (Place these in core app's urls.py)
    # path("map/", views.map_view, name="map-view"),
    # path("api/landmarks/", views.get_landmarks, name="landmarks-api"),
    # Include core app URLs after defining app-specific patterns
    path("", include("core.urls")),  # Assuming core is your app name
    # Other URL patterns for other apps
]
