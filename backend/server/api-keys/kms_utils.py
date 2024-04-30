import os
from google.cloud import kms


def get_api_key():
    """Retrieves the Google Maps API key securely from Google Cloud KMS."""
    
    # Retrieve project ID and key name from environment variables (assuming they're set)
    project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")
    key_name = os.environ.get("GOOGLE_CLOUD_KMS_KEY_NAME")
    
    # Validate environment variables
    if not project_id or not key_name:
        raise ValueError("Missing environment variables for KMS access. Set GOOGLE_CLOUD_PROJECT and GOOGLE_CLOUD_KMS_KEY_NAME.")
    
    # Create KMS client using project ID
    kms_client = kms.Client(project=project_id)
    
    # Construct KMS key name (replace with your actual key format if it differs)
    key_name = f"projects/{project_id}/locations/global/keyRings/default/cryptoKeys/{key_name}"
    
    # Get the secret value (API key) from KMS
    try:
        response = kms_client.decrypt(ciphertext=kms_client.encrypt(plaintext=b"your_api_key_placeholder").ciphertext)
        api_key = response.plaintext.decode('utf-8')
        return api_key
    except ClientError as error:
        raise ValueError(f"Error retrieving API key from KMS: {error}")
    
    

