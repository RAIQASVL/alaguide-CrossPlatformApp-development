import 'package:google_maps_flutter/google_maps_flutter.dart';

class AlaguideObject {
  final int? ala_object_id;
  final String? image_url;
  final String? audio_url;
  final String? author;
  final String? guide;
  final String? description;
  final String? country;
  final String? city;
  final String? category;
  final String? landmark;
  final String? title;
  final LatLng coordinates;

  AlaguideObject({
    required this.ala_object_id,
    required this.image_url,
    required this.audio_url,
    required this.author,
    required this.guide,
    required this.description,
    required this.country,
    required this.city,
    required this.category,
    required this.landmark,
    required this.title,
    required this.coordinates,
  });

  factory AlaguideObject.fromJson(Map<String, dynamic> json) {
    return AlaguideObject(
      ala_object_id: json['ala_object_id'],
      image_url: json['image_url'],
      audio_url: json['audio_url'],
      author: json['author'],
      guide: json['guide'],
      description: json['description'],
      country: json['country'],
      city: json['city'],
      category: json['category'],
      landmark: json['landmark'],
      title: json['title'],
      coordinates: LatLng(
        // Используем проверку типа и приведение к double
        json['latitude'] is double
            ? json['latitude']
            : double.parse(json['latitude'].toString()),
        json['longitude'] is double
            ? json['longitude']
            : double.parse(json['longitude'].toString()),
      ),
    );
  }
}