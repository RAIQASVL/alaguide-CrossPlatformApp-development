import os
from django.core.files import File
from django.core.management.base import BaseCommand
from core.models import AudioBook, Landmark

from server.settings import BASE_DIR


class Command(BaseCommand):
    help = 'Load audio files into the database'

    def add_arguments(self, parser):
        parser.add_argument('audio_directory', type=str, help='The directory containing the audio files')

    def handle(self, *args, **kwargs):
        audio_directory = os.path.abspath(os.path.join(BASE_DIR, kwargs['audio_directory']))

        if not os.path.isdir(audio_directory):
            self.stderr.write(self.style.ERROR(f'Provided audio directory does not exist: {audio_directory}'))
            return

        self.load_audio_files(audio_directory)

    def load_audio_files(self, audio_directory):
        files = os.listdir(audio_directory)
        audio_formats = ('.wav', '.mp3', '.flac')
        count = 0

        for filename in files:
            
            filename = ('Botanical Garden.wav')
            
            if filename.lower().endswith(audio_formats):
                # Extract landmark name from filename
                landmark_name = 'Botanical Garden'

                # Try to retrieve the corresponding Landmark object
                try:
                    landmark_object = Landmark.objects.get(landmarkname=landmark_name)
                except Landmark.DoesNotExist:
                    # Handle missing landmark
                    self.stdout.write(self.style.WARNING(f"Landmark '{landmark_name}' not found for '{filename}'. Skipping file."))
                    continue

                # Create and save the AudioBook instance
                audio = AudioBook.objects.create(landmark_id=landmark_object)

                # Add the audio file
                with open(os.path.join(audio_directory, filename), 'rb') as audio_file:
                    audio.audio_file.save(os.path.basename(filename), File(audio_file))

                count += 1

        self.stdout.write(self.style.SUCCESS(f'Successfully loaded {count} audio files'))


# Function to extract landmark name from filename (replace with your specific logic)
import re

def get_landmark_from_filename(filename):
    pattern = r"^(.*)\.wav" # This pattern extracts everything before the first underscore
    match = re.match(pattern, filename)
    if match:
        return match.group(1)  # Return the captured group (landmark name)
    else:
        return None  # Return None if no match is found




# Absolute Path Selection in SHELL
# >>> import os
# >>> directory = "../../media/audio/"
# >>> filename = "mixkit-night-forest-with-insects-2414.wav"
# >>> absolute_path = os.path.abspath(os.path.join(directory, filename))
# >>> print(absolute_path)
# /Users/raiqasvl/Enterprise/apps_development/alaguide_arc/media/audio/mixkit-night-forest-with-insects-2414.wav