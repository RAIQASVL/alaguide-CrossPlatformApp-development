class AudioBook {
  final int audiobookId;
  final int landmarkId;
  final String title;
  final String description;
  final String audioUrl;

  AudioBook({
    required this.audiobookId,
    required this.landmarkId,
    required this.title,
    required this.description,
    required this.audioUrl,
  });

  factory AudioBook.fromJson(Map<String, dynamic> json) {
    return AudioBook(
      audiobookId: json['audiobook_id'],
      landmarkId: json['landmark_id'],
      title: json['title'],
      description: json['description'],
      audioUrl: json['audio_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'audiobook_id': audiobookId,
      'landmark_id': landmarkId,
      'title': title,
      'description': description,
      'audio_url': audioUrl,
    };
  }
}
