from django.contrib import admin
from django.urls import re_path, path, include
from . import views
from .views import Home
from django.views.generic import TemplateView
from django.conf import settings
from django.conf.urls.static import static


urlpatterns = [
    # Add points for "core" app-module to connect a database"
    path("admin/", admin.site.urls),
    path("core/", include("core.urls")),
    # Add JWT points
    # path("login/", views.login),
    path("signup/", views.signup),
    # AllAuth
    path("", Home.as_view(), name="home"),
    path(
        "home/", TemplateView.as_view(template_name="dashboard/home.html"), name="home"
    ),
    path("accounts/", include("allauth.urls")),
]

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)