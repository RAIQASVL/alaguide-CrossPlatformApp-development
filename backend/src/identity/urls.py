from django.urls import path, include
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
app_name = 'identity'

urlpatterns = [
    path('', include('dj_rest_auth.urls')),
]