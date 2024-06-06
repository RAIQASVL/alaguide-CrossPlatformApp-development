class SocialProvider {
  final String provider;
  final String clientId;
  final String secret;
  final String key;
  final int userId;

  SocialProvider({
    required this.provider,
    required this.clientId,
    required this.secret,
    required this.key,
    required this.userId,
  });

  factory SocialProvider.fromJson(Map<String, dynamic> json) {
    return SocialProvider(
      provider: json['provider'],
      clientId: json['client_id'],
      secret: json['secret'],
      key: json['key'] ?? '', // assuming 'key' can be null
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'client_id': clientId,
      'secret': secret,
      'key': key,
      'user_id': userId,
    };
  }
}
