from django.urls import path
from core.views import aPage
from django.urls import path, include

app_name = 'core'

urlpatterns = [
    path('a', aPage),
]
