class LikeRating {
  final int likeRatingId;
  final int userId;
  final int landmarkId;
  final String type;
  final DateTime dateLikedOrRated;

  LikeRating({
    required this.likeRatingId,
    required this.userId,
    required this.landmarkId,
    required this.type,
    required this.dateLikedOrRated,
  });

  factory LikeRating.fromJson(Map<String, dynamic> json) {
    return LikeRating(
      likeRatingId: json['like_rating_id'],
      userId: json['user_id'],
      landmarkId: json['landmark_id'],
      type: json['type'],
      dateLikedOrRated: DateTime.parse(json['date_liked_or_rated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'like_rating_id': likeRatingId,
      'user_id': userId,
      'landmark_id': landmarkId,
      'type': type,
      'date_liked_or_rated': dateLikedOrRated.toIso8601String(),
    };
  }
}
