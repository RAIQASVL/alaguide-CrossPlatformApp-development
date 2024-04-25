from django.contrib import admin
from .models import GoogleSocialApp

# Register your models here.


@admin.register(GoogleSocialApp)
class GoogleSocialAppAdmin(admin.ModelAdmin):
    list_display = ("client_id", "secret", "key")
