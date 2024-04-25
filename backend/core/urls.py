from django.urls import path, include
from . import views
from allauth.account.views import LoginView, SignupView

urlpatterns = [
    path("", views.all_user),
    # Django Allauth
    path("accounts/login/", LoginView.as_view(), name="account_login"),
    path("accounts/signup/", SignupView.as_view(), name="account_signup"),
]
