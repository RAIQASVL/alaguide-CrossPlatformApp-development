class UserReview {
  final int reviewId;
  final String text;
  final double rating;
  final DateTime datePosted;
  final int userId;
  final int landmarkId;

  UserReview({
    required this.reviewId,
    required this.text,
    required this.rating,
    required this.datePosted,
    required this.userId,
    required this.landmarkId,
  });

  factory UserReview.fromJson(Map<String, dynamic> json) {
    return UserReview(
      reviewId: json['review_id'],
      text: json['text'],
      rating: json['rating'],
      datePosted: DateTime.parse(json['date_posted']),
      userId: json['user_id'],
      landmarkId: json['landmark_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'review_id': reviewId,
      'text': text,
      'rating': rating,
      'date_posted': datePosted.toIso8601String(),
      'user_id': userId,
      'landmark_id': landmarkId,
    };
  }
}
