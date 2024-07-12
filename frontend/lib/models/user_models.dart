class User {
  final int? id;
  String? token;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;

  User({
    this.id,
    this.token,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["pk"],
      username: json["username"],
      email: json["email"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      avatarUrl: json["avatar_url"],
    );
  }

  User copyWith({
    int? id,
    String? token,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      token: token ?? this.token,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
