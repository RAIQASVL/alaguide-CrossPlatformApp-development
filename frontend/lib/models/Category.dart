class Category {
  final int categoryId;
  final String category;

  Category({
    required this.categoryId,
    required this.category,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'category': category,
    };
  }
}
