import os
from django.shortcuts import render
import googlemaps
from google.cloud import kms
from .kms_utils import get_api_key


project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")
key_name = os.environ.get("GOOGLE_CLOUD_KMS_KEY_NAME")


# Description the API Key
def get_api_key():
    """Fetches and decrypts the Google Maps API key from Cloud KMS."""
    client = kms.KeyManagementServiceAsyncClient()
    key_path = f"projects/{project_id}/locations/global/keyRings/google-maps-api-key/cryptoKeys/{key_name}"
    response = client.decrypt(name=key_path, ciphertext=b"")
    return response.plaintext.decode("utf-8")


""" This function retrieves the encrypted API key from Cloud KMS 
using the project ID and key name retrieved from environment variables.
It then decrypts the key and returns it as a string. """

# Map Data Implementation


