from rest_framework import serializers
from django.contrib.auth.tokens import default_token_generator
from django.contrib.auth.forms import SetPasswordForm
from django.contrib.auth import get_user_model
from django.utils.http import urlsafe_base64_decode
from django.utils.translation import gettext_lazy as _

UserModel = get_user_model()


class NewPasswordResetConfirmSerializer(serializers.Serializer):
    new_password1 = serializers.CharField(max_length=128)
    new_password2 = serializers.CharField(max_length=128)
    uid = serializers.CharField(required=False)
    token = serializers.CharField(required=False)

    set_password_form_class = SetPasswordForm

    def validate(self, attrs):
        uid = attrs.get("uid") or self.context.get("uid")
        token = attrs.get("token") or self.context.get("token")

        if not uid or not token:
            raise serializers.ValidationError({"error": _("Missing uid or token")})

        try:
            uid = urlsafe_base64_decode(uid).decode()
            self.user = UserModel._default_manager.get(pk=uid)
        except (TypeError, ValueError, OverflowError, UserModel.DoesNotExist):
            raise serializers.ValidationError({"uid": [_("Invalid value")]})

        if not default_token_generator.check_token(self.user, token):
            raise serializers.ValidationError({"token": [_("Invalid value")]})

        if attrs["new_password1"] != attrs["new_password2"]:
            raise serializers.ValidationError(
                {"new_password2": [_("The two password fields didn't match.")]}
            )

        return attrs

    def save(self):
        self.user.set_password(self.validated_data["new_password1"])
        self.user.save()
        return self.user
