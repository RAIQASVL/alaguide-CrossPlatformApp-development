from django.contrib import admin
from .models import (
    Country,
    City,
    Category,
    Landmark,
    AudioBook,
    User,
    UserReview,
    LikeRating,
    Tag,
    LandmarkTag,
    SocialProvider,
)

admin.site.register(Country)
admin.site.register(City)
admin.site.register(Category)
admin.site.register(Landmark)
admin.site.register(AudioBook)
admin.site.register(User)
admin.site.register(UserReview)
admin.site.register(LikeRating)
admin.site.register(Tag)
admin.site.register(LandmarkTag)
admin.site.register(SocialProvider)
