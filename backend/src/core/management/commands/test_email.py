import random
import string
from django.core.management.base import BaseCommand
from django.core.mail import send_mail
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from django.utils.encoding import force_bytes, force_str
from django.contrib.auth.tokens import default_token_generator
from django.template.loader import render_to_string
from django.conf import settings
from user.models import User

class Command(BaseCommand):
    help = 'Test email sending and activation'

    def handle(self, *args, **kwargs):
        # Generate a random username
        username = 'testuser_' + ''.join(random.choices(string.ascii_lowercase + string.digits, k=6))
        email = username + '@example.com'

        # Test email sending
        user = User.objects.create_user(username=username, email=email, password='password123')
        uid = urlsafe_base64_encode(force_bytes(user.pk))
        token = default_token_generator.make_token(user)
        activation_url = f"{settings.ACTIVATION_URL}?uid={uid}&token={token}"
        email_subject = 'Activate Your Account'
        email_message = render_to_string('activation_email.html', {
            'user': user,
            'activation_url': activation_url
        })
        send_mail(email_subject, email_message, settings.DEFAULT_FROM_EMAIL, [user.email])

        self.stdout.write(f"Sent email to: {user.email}")
        self.stdout.write(f"Activation URL: {activation_url}")

        # Prompt for uid and token
        uid_input = input("Enter the uid from the email: ")
        token_input = input("Enter the token from the email: ")

        # Test email activation
        try:
            uid = force_str(urlsafe_base64_decode(uid_input))
            user = User.objects.get(pk=uid)
        except (TypeError, ValueError, OverflowError, User.DoesNotExist):
            user = None

        if user is not None and default_token_generator.check_token(user, token_input):
            user.is_active = True
            user.save()
            self.stdout.write(f"Account activated successfully for user: {user.username}")
        else:
            self.stdout.write("Invalid activation link")
