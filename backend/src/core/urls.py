from django.urls import path, include
from . import views
from allauth.account.views import LoginView, SignupView

urlpatterns = [
    # Django Allauth
    path("accounts/login/", LoginView.as_view(), name="account_login"),
    path("accounts/signup/", SignupView.as_view(), name="account_signup"),
    
    # Google Maps API
    # path("map/", views.map_view, name="map-view"),
    # path("api/landmarks/", views.get_landmark, name="landmarks-api"),
    # Other URL patterns for your core app
]
