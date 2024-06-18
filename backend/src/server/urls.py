from django.conf import settings
from django.contrib import admin
from django.urls import path, include
from django.conf.urls.static import static 


urlpatterns = [
    # Django Admin
    path('admin/', admin.site.urls),
    # Authentication and Authorization - Django REST Framework & All Auth
    path('account/', include('identity.urls')),
    path('registration/', include('dj_rest_auth.registration.urls')),
    path('accounts/', include('allauth.urls')), 
    # APP's
    path('core/', include(('core.urls', 'core'), namespace='core-space')),
    # API v1 URLS
    path('api/v1/', include(('api.urls', 'api'), namespace='api')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    
