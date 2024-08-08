from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework.permissions import IsAuthenticated
from rest_framework import generics, status, permissions, viewsets
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import FormParser, MultiPartParser, JSONParser
from django.conf import settings
from dj_rest_auth.views import LoginView as DefaultLoginView
from django.contrib.auth import login as django_login
from core.models import User, EmailOrUsernameModelBackend
from core.serializers import UserSerializer


class IsAdminOrReadOnly(permissions.BasePermission):
    """
    Custom permission to only allow admins to edit or delete.
    """

    def has_permission(self, request, view):
        return bool(
            request.method in permissions.SAFE_METHODS
            or request.user
            and request.user.is_staff
        )


@csrf_exempt
def aPage(request):
    user: User = User.objects.get(pk=1)
    # username = request.POST.get("username")
    # email = request.POST.get("email")
    # print(email)
    # print(username)
    return JsonResponse({"UserName": user.username, "email": user.email})


# User Profile API ("me/")
class MeApiHandler(generics.RetrieveUpdateAPIView):
    """
    API Endpoint that returns and updates currently logged-in user's information.
    This includes information that is not publicly-available.
    """

    permission_classes = [IsAuthenticated]
    parser_classes = [FormParser, MultiPartParser, JSONParser]
    serializer_class = UserSerializer

    def get(self, request):
        if request.user.is_authenticated:
            user = request.user
            serializer = UserSerializer(user)
            return Response(serializer.data)
        else:
            return Response(
                {"error": "User is not authenticated"},
                status=status.HTTP_401_UNAUTHORIZED,
            )

    def get_object(self):
        return self.request.user


# class CustomLoginView(DefaultLoginView):
#     def login(self):
#         self.user = self.serializer.validated_data["user"]
#         if self.user:
#             self.token = self.serializer.validated_data["token"]
#             django_login(self.request, self.user)
