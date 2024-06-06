class AccountUser {
  final int userId;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final int defaultCountryId;
  final int defaultCityId;
  final String preferredLanguage;

  AccountUser({
    required this.userId,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.defaultCountryId,
    required this.defaultCityId,
    required this.preferredLanguage,
  });

  factory AccountUser.fromJson(Map<String, dynamic> json) {
    return AccountUser(
      userId: json['user_id'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json[' email'],
      defaultCountryId: json['default_country_id'],
      defaultCityId: json['default_city_id'],
      preferredLanguage: json['preferred_language'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'defaultCountryId': defaultCountryId,
      'defaultCityId': defaultCityId,
      'preferredLanguage': preferredLanguage,
    };
  }
}
