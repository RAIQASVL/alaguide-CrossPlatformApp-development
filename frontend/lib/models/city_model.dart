import 'package:google_maps_flutter/google_maps_flutter.dart';

class City {
  final int cityId;
  final String name;
  final String description;
  final LatLng coordinates;
  final String country;

  City({
    required this.cityId,
    required this.name,
    required this.description,
    required this.coordinates,
    required this.country,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityId: json['city_id'],
      name: json['city'],
      description: json['description'],
      coordinates: LatLng(
        double.parse(json['latitude']),
        double.parse(json['longitude']),
      ),
      country: json['country'],
    );
  }

  City copyWith({
    int? cityId,
    String? name,
    String? description,
    LatLng? coordinates,
    String? country,
  }) {
    return City(
      cityId: cityId ?? this.cityId,
      name: name ?? this.name,
      description: description ?? this.description,
      coordinates: coordinates ?? this.coordinates,
      country: country ?? this.country,
    );
  }
}
