class MapData {
  final String name;
  final Map<String, dynamic> data;

  MapData({
    required this.name,
    required this.data,
  });

  factory MapData.fromJson(Map<String, dynamic> json) {
    return MapData(
      name: json['name'],
      data: json['data'] != null ? Map<String, dynamic>.from(json['data']) : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data': data,
    };
  }
}
