from django.contrib.auth.models import User
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    help = "Display a list of superusers"

    def handle(self, *args, **options):
        superusers = User.objects.filter(is_superuser=True)
        if superusers.exists():
            self.stdout.write(self.style.SUCCESS("Superusers: "))
            for user in superusers:
                self.stdout.write("- {}".format(user.username))
        else:
            self.stdout.write(self.style.NOTICE("No superusers found"))
