import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/alaguide_object_model.dart';

class ContentService {
  static const String baseUrl = 'http://localhost:8000/api/v1';

  Future<List<AlaguideObject>> fetchAlaguideObjects() async {
    final response = await http.get(Uri.parse('$baseUrl/alaguideobjects'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => AlaguideObject.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Alaguide objects');
    }
  }
}
