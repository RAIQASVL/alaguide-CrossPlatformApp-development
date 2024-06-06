class City {
  final int cityId;
  final String city;

  City({
    required this.cityId,
    required this.city,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityId: json['city_id'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city_id': cityId,
      'city': city,
    };
  }
}
