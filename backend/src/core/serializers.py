from rest_framework import serializers
from dj_rest_auth.serializers import LoginSerializer
from dj_rest_auth.registration.serializers import RegisterSerializer
from dj_rest_auth.serializers import LoginSerializer as DefaultLoginSerializer
from django.contrib.auth import authenticate
from core.models import User


class NewRegisterSerializer(RegisterSerializer):
    first_name = serializers.CharField()
    last_name = serializers.CharField()

    def custom_signup(self, request, user):
        user.first_name = request.data["first_name"]
        user.last_name = request.data["last_name"]
        user.save()

    pass


class NewLoginSerializer(DefaultLoginSerializer):
    username = serializers.CharField(required=False, allow_blank=True)
    email = serializers.EmailField(required=False, allow_blank=True)

    def validate(self, attrs):
        username = attrs.get("username")
        email = attrs.get("email")
        password = attrs.get("password")

        user = None

        if username:
            user = authenticate(
                self.context["request"], username=username, password=password
            )
        elif email:
            user = authenticate(
                self.context["request"], username=email, password=password
            )

        if not user:
            msg = "Unable to log in with provided credentials."
            raise serializers.ValidationError(msg)

        attrs["user"] = user
        return attrs


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = "__all__"


class PublicScopeUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = "__all__"
