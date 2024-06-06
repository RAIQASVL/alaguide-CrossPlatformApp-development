class Landmark {
  final int landmarkId;
  final String landmark;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final int cityId;
  final int categoryId;

  Landmark({
    required this.landmarkId,
    required this.landmark,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.cityId,
    required this.categoryId,
  });

  factory Landmark.fromJson(Map<String, dynamic> json) {
    return Landmark(
      landmarkId: json['landmark_id'],
      landmark: json['landmark'],
      description: json['description'],
      imageUrl: json['image_url'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      cityId: json['city_id'],
      categoryId: json['category_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'landmark_id': landmarkId,
      'landmark': landmark,
      'description': description,
      'image_url': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'city_id': cityId,
      'category_id': categoryId,
    };
  }
}
