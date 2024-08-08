from rest_framework import generics, status
from rest_framework.generics import GenericAPIView
from django.shortcuts import render
from rest_framework.response import Response
from django.contrib.auth.tokens import default_token_generator
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from django.utils.encoding import force_bytes, force_str
from django.contrib.auth.models import User
from django.contrib.auth.forms import PasswordResetForm, SetPasswordForm
from django.template.loader import render_to_string
from django.core.mail import send_mail
from django.conf import settings
from django.utils.translation import gettext_lazy as _
from rest_framework.permissions import AllowAny
from dj_rest_auth.serializers import PasswordResetConfirmSerializer


class PasswordResetView(generics.GenericAPIView):
    def post(self, request, *args, **kwargs):
        form = PasswordResetForm(request.data)
        if form.is_valid():
            user = User.objects.get(email=form.cleaned_data["email"])
            token = default_token_generator.make_token(user)
            uid = urlsafe_base64_encode(force_bytes(user.pk))
            reset_url = f"{settings.FRONTEND_URL}/reset-password/{uid}/{token}/"
            email_subject = "Password Reset Requested"
            email_body = render_to_string(
                "password_reset_email.html",
                {
                    "reset_url": reset_url,
                    "user": user,
                },
            )
            send_mail(
                email_subject, email_body, settings.DEFAULT_FROM_EMAIL, [user.email]
            )
            return Response(
                {"message": "Password reset email sent"}, status=status.HTTP_200_OK
            )
        return Response(form.errors, status=status.HTTP_400_BAD_REQUEST)


class PasswordResetConfirmView(generics.GenericAPIView):
    def post(self, request, uidb64=None, token=None, *args, **kwargs):
        try:
            uid = force_str(urlsafe_base64_decode(uidb64))
            user = User.objects.get(pk=uid)
            if not default_token_generator.check_token(user, token):
                return Response(
                    {"error": "Invalid token"}, status=status.HTTP_400_BAD_REQUEST
                )
        except (TypeError, ValueError, OverflowError, User.DoesNotExist):
            user = None
        if user is not None:
            form = SetPasswordForm(user, request.data)
            if form.is_valid():
                form.save()
                return Response(
                    {"message": "Password has been reset"}, status=status.HTTP_200_OK
                )
            return Response(form.errors, status=status.HTTP_400_BAD_REQUEST)
        return Response({"error": "Invalid token"}, status=status.HTTP_400_BAD_REQUEST)


# Reset Password Confirm Web Page
def password_reset_confirm(request, uidb64, token):
    return render(
        request, "reset_password_confirm.html", context={"uid": uidb64, "token": token}
    )


class CustomPasswordResetConfirmView(GenericAPIView):
    serializer_class = PasswordResetConfirmSerializer
    permission_classes = (AllowAny,)
    throttle_scope = "dj_rest_auth"

    def get(self, request, *args, **kwargs):
        return render(
            request,
            "custom_password_reset_confirm.html",
            context={"uid": kwargs.get("uidb64"), "token": kwargs.get("token")},
        )

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(
            data={
                "uid": request.data.get("uid"),
                "token": request.data.get("token"),
                "new_password1": request.data.get("new_password1"),
                "new_password2": request.data.get("new_password2"),
            }
        )
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(
            {"detail": _("Password has been reset with the new password.")},
            status=status.HTTP_200_OK,
        )
