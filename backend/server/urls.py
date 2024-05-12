from django.contrib import admin
from django.urls import path, include
from . import views
from django.views.generic import TemplateView
from allauth.account.views import LoginView, SignupView

urlpatterns = [
    path("admin/", admin.site.urls),
    # Other URL patterns for other apps
    path("", include("apis.urls")),
    path("", include("core.urls")),
    # REST API
    path("guide/objects/", include("apis.urls")),
    # path("guide/objects/ala_object_id/", include("apis.urls")),
    # path("guide/menu/", include("apis.urls")),
    # path("guide/menu/content/", include("apis.urls")),
    # path("guide/menu/language/", include("apis.urls")),
    # path("guide/menu/about", include("apis.urls")),
    # path("guide/menu/support", include("apis.urls")),
    # path("guide/menu/feedback/", include("apis.urls")),
    # path("guide/cities", include("apis.urls")),
    # path("guide/cities/city_id/content/", include("apis.urls")),
    # path("guide/cities/city_id/content/search", include("apis.urls")),
    # Django Allauth
    path("home/", TemplateView.as_view(template_name="dashboard/home.html"), name="home"),
    path("accounts/", include("allauth.urls")),
    path("accounts/login/", LoginView.as_view(), name="account_login"),
    path("accounts/signup/", SignupView.as_view(), name="account_signup"),
    # Google Maps API (Place these in core app's urls.py)
    # path("map/", views.map_view, name="map-view"),
    # path("api/landmarks/", views.get_landmarks, name="landmarks-api"),
]
