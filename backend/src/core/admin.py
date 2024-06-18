from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from core.models import (
    User,
    Country,
    City,
    Category,
    Landmark,
    AudioBook,
    AlaguideObject
)
from identity.models import (
    SocialProvider
)

@admin.register(User)
class UserAdmin(BaseUserAdmin):
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('username', 'first_name', 'last_name', 'email', 'password1', 'password2'),
        }),
    )
    fieldsets = (
        (None, {'fields': ('username', 'email', 'password')}),
        ('Personal info', {'fields': ('first_name', 'last_name')}),
        ('Permissions', {'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')}),
        ('Important dates', {'fields': ('last_login',)}),
    )

    list_display = ('username', 'email', 'first_name', 'last_name', 'is_active', 'is_staff', 'is_superuser')
    search_fields = ('username', 'email', 'first_name', 'last_name')
    ordering = ('email',)


admin.site.register(Country)
admin.site.register(City)
admin.site.register(Category)
admin.site.register(Landmark)
admin.site.register(AudioBook)
admin.site.register(AlaguideObject)
admin.site.register(SocialProvider)

