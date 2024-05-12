from django.urls import path
from .views import ListAlaguideObject, DetailAlaguideObject

urlpatterns = [
    path("", ListAlaguideObject.as_view()),
    path("<int:pk>/", DetailAlaguideObject.as_view())
]
