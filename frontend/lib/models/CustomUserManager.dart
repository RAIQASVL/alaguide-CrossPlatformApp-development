// models/custom_user_manager.dart
class CustomUserManager {
  final String email;
  final String password;
  final Map<String, dynamic> extraFields;

  CustomUserManager(
      {required this.email, required this.password, required this.extraFields});

  factory CustomUserManager.fromJson(Map<String, dynamic> json) {
    return CustomUserManager(
      email: json['email'],
      password: json['password'],
      extraFields: Map<String, dynamic>.from(json['extra_fields']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'extra_fields': extraFields,
    };
  }
}
