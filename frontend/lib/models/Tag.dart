class Tag {
  final int tagId;
  final String tag;

  Tag({
    required this.tagId,
    required this.tag,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      tagId: json['tag_id'],
      tag: json['tag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tag_id': tagId,
      'tag': tag,
    };
  }
}
