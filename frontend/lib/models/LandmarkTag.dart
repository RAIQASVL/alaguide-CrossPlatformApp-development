class LandmarkTag {
  final int landmarkTagId;
  final int landmarkId;
  final int tagId;

  LandmarkTag({
    required this.landmarkTagId,
    required this.landmarkId,
    required this.tagId,
  });

  factory LandmarkTag.fromJson(Map<String, dynamic> json) {
    return LandmarkTag(
      landmarkTagId: json['landmark_tag_id'],
      landmarkId: json['landmark_id'],
      tagId: json['tag_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'landmark_tag_id': landmarkTagId,
      'landmark_id': landmarkId,
      'tag_id': tagId,
    };
  }
}
