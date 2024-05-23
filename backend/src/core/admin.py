import os
from django.conf import settings
from django.contrib import admin
from .models import (
    Country,
    City,
    Category,
    Landmark,
    AudioBook,
    AlaguideObject,
    AccountUser,
    UserReview,
    LikeRating,
    Tag,
    LandmarkTag,
    SocialProvider,
    MapData,
)

admin.site.register(Country)
admin.site.register(City)
admin.site.register(Category)
admin.site.register(Landmark)
admin.site.register(AudioBook)
admin.site.register(AlaguideObject)
admin.site.register(AccountUser)
admin.site.register(UserReview)
admin.site.register(LikeRating)
admin.site.register(Tag)
admin.site.register(LandmarkTag)
admin.site.register(SocialProvider)
admin.site.register(MapData)

# @admin.register(MapData)
# class VenueAdmin(admin.ModelAdmin):
#     list_display = ('name', 'latitude', 'longitude',)
#     search_fields = ('name',)

#     fieldsets = (
#         (None, {
#             'fields': ('name', 'latitude', 'longitude',)
#         }),
#     )

#     class Media:
#         if hasattr(settings, 'api_key') and settings.api_key:
#             css = {
#                 'STATICFILES_DIRS': ("admin/css/location_picker.css",),
#             }
#             js = ('https://maps.googleapis.com/maps/api/js?key={}'.format(settings.api_key),
#                 'STATICFILES_DIRS/admin/js/location_picker.js',
#                 )
