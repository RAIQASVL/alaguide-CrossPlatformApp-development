from rest_framework.views import APIView
from rest_framework.response import Response
from django.shortcuts import render
from rest_framework import generics
from core import models

from .serializers import AlaguideObjectSerializer, CountrySerializer, CitySerializer

# Create your views here.


# 1. The Main AlaguideObject View ("guide/objects/")
class ListAlaguideObject(generics.ListCreateAPIView):
    queryset = models.AlaguideObject.objects.all()
    serializer_class = AlaguideObjectSerializer


class DetailAlaguideObject(generics.RetrieveUpdateDestroyAPIView):
    queryset = models.AlaguideObject.objects.all()
    serializer_class = AlaguideObjectSerializer


# 2. Menu View ("guide/menu/")
class MenuView(APIView):
    def get(self, request):
        menu = [
            {"name": "Home", "url": "/"},
            {"name": "Location", "url": "/guide/menu/location/"},
            {"name": "Content", "url": "/guide/menu/content/"},
            {"name": "Language", "url": "/guide/menu/language/"},
            {"name": "About", "url": "/guide/menu/about/"},
            {"name": "Support", "url": "/guide/menu/support/"},
            {"name": "Feedback", "url": "/guide/menu/feedback/"},
        ]
        return Response(menu)


# 3. Menu View: Sub Category "Location" ("guide/menu/location/")
class LocationMenuView(APIView):
    def get(self, request):
        countries = models.Country.objects.all()
        cities = models.City.objects.all()

        country_serializer = CountrySerializer(countries, many=True)
        city_serializer = CitySerializer(cities, many=True)

        return Response(
            {"countries": country_serializer.data, "cities": city_serializer.data}
        )


# 4. Menu View: Sub Category "Content" ("guide/menu/content/")
class ContentMenuView(APIView):
    def get(self, request):
        # Getting the query parameters
        country_id = request.query_params.get("country_id")
        city_id = request.query_params.get("city_id")

        # Filter content by selected country and city, if parameters are specified
        if country_id and city_id:
            content = models.AlaguideObject.objects.filter(
                city__country_id=country_id, city_id=city_id
            )
        elif country_id:
            content = models.AlaguideObject.objects.filter(city__country_id=country_id)
        elif city_id:
            content = models.AlaguideObject.objects.filter(city_id=city_id)
        else:
            content = models.AlaguideObject.objects.all()

        # Serialise the content and return a response
        serializer = AlaguideObjectSerializer(content, many=True)
        return Response(serializer.data)


# 5. Menu View: Sub Category "Language" ("guide/menu/language/")
class LanguageMenuView(APIView):
    def get(self, request):
        # Here you can get a list of available languages from your application
        # For example, you can get them from the project settings or
        # Get the selected language from the request parameters or from the client-side storage

        selected_language = request.query_params.get(
            "language"
        )  #  Assume that the language is passed as a query parameter

        # Here you can get a list of available languages from your application settings or a database
        # Suppose you have a list of languages in the form of a dictionary

        languages = [
            {"language_code": "kz", "language_name": "Kazakh"},
            {"language_code": "ru", "language_name": "Russian"},
            {"language_code": "en", "language_name": "English"},
            # Others ...
        ]

        return Response(languages)


# 6. Menu View: Sub Category "About" ("guide/menu/about/")
class AboutView(APIView):
    def get(self, request):
        # Here you can return static text or database data containing the project description
        about_text = "Our project is aimed at providing..."
        return Response({"about_text": about_text})


# 7. Menu View: Sub Category "Support" ("guide/menu/support/")
class SupportView(APIView):
    def get(self, request):
        support_info = {
            "email": "support@example.com",
            "phone": "+123456789",
            "address": "123 Main St, City, Country",
        }
        return Response(support_info)


# 8. Menu View: Sub Category "Feedback" ("guide/menu/feedback/")
class FeedbackView(APIView):
    def post(self, request):
        # Here you can process the feedback sent from the user
        # Create an appropriate model and serialiser to store the feedback
        # Processing example:

        feedback_data = request.data  # Assume that feedback data is sent in JSON format
        # Here you can perform additional actions such as saving to the database and sending notifications to the administrator
        return Response({"message": "Feedback received successfully"})
