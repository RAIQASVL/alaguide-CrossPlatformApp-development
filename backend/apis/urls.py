from django.urls import path
from .views import (
    ListAlaguideObject,
    DetailAlaguideObject,
    MenuView,
    LocationMenuView,
    ContentMenuView,
    LanguageMenuView,
    AboutView,
    SupportView,
    FeedbackView,
)


urlpatterns = [
    # 1. The Main AlaguideObject View ("guide/objects/")
    path("", ListAlaguideObject.as_view()),
    path("<int:pk>/", DetailAlaguideObject.as_view()),
    # 2. Menu View ("guide/menu/")
    path("guide/menu/", MenuView.as_view()),
    # 3. Menu View: Sub Category "Location" ("guide/menu/location/")
    path("guide/menu/location/", LocationMenuView.as_view()),
    # 4. Menu View: Sub Category "Content" ("guide/menu/content/")
    path("guide/menu/content/", ContentMenuView.as_view()),
    # 5. Menu View: Sub Category "Language" ("guide/menu/language/")
    path("guide/menu/language/", LanguageMenuView.as_view()),
    # 6. Menu View: Sub Category "About" ("guide/menu/about/")
    path("guide/menu/about/", AboutView.as_view()),
    # 7. Menu View: Sub Category "Support" ("guide/menu/support/")
    path("guide/menu/support/", SupportView.as_view()),
    # 8. Menu View: Sub Category "Feedback" ("guide/menu/feedback/")
    path("guide/menu/feedback/", FeedbackView.as_view()),
]
