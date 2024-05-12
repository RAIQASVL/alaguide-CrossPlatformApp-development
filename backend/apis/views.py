from django.shortcuts import render
from rest_framework import generics

# Create your views here.
from core import models
from .serializers import AlaguideObjectSerializer

class ListAlaguideObject(generics.ListCreateAPIView):
    queryset = models.AlaguideObject.objects.all()
    serializer_class = AlaguideObjectSerializer
    
class DetailAlaguideObject(generics.RetrieveUpdateDestroyAPIView):
    queryset = models.AlaguideObject.objects.all()
    serializer_class = AlaguideObjectSerializer 