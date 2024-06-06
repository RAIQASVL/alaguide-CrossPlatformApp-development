class Country {
  final int countryId;
  final String country;

  Country({
    required this.countryId,
    required this.country,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      countryId: json['country_id'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country_id': countryId,
      'country': country,
    };
  }
}
