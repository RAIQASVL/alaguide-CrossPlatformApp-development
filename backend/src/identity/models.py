from django.db import models
from core.models import User


# AllAuth
class SocialProvider(models.Model):
    provider = models.CharField(max_length=50)
    client_id = models.CharField(max_length=255, default=None)
    secret = models.CharField(max_length=255, default=None)
    key = models.CharField(max_length=255, blank=True, null=True, default=None)
    user_id = models.ForeignKey(
        User,
        db_column="user_id",
        on_delete=models.CASCADE,
        null=False,
        default=None,
    )

    def __str__(self):
        return self.provider

    class Meta:
        managed = True
        db_table = "SocialProvider"

