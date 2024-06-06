class AlaguideObject {
  final int alaObjectId;
  final String landmark;
  final String description;
  final String city;
  final String category;
  final String latitude;
  final String longitude;
  final String imageUrl;
  final String audioUrl;

  AlaguideObject({
    required this.alaObjectId,
    required this.landmark,
    required this.description,
    required this.city,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.audioUrl,
  });

// Function to convert JSON data into an AlaguideObject
  factory AlaguideObject.fromJson(Map<String, dynamic> json) {
    return AlaguideObject(
      alaObjectId: json['ala_object_id'],
      landmark: json['landmark'],
      description: json['description'],
      city: json['city'],
      category: json['category'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      imageUrl: json['image_url'],
      audioUrl: json['audio_url'],
    );
  }

  // Function to convert AlaguideObject into JSON
  Map<String, dynamic> toJson() {
    return {
      'ala_object_id': alaObjectId,
      'landmark': landmark,
      'description': description,
      'city': city,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'image_url': imageUrl,
      'audio_url': audioUrl,
    };
  }
}
