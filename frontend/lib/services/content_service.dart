import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/alaguide_object_model.dart';

class ContentService {
  static const String baseUrl = 'http://192.168.1.235:8000/api/v1';

  Future<List<AlaguideObject>> fetchAlaguideObjects() async {
    final response = await http.get(Uri.parse('$baseUrl/alaguideobjects'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => AlaguideObject.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Alaguide objects');
    }
  }

  Future<int> fetchObjectCount(int ala_object_id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/alaguideobjects/'));

      if (response.statusCode == 200) {
        List<dynamic> objectsJson = json.decode(response.body);

        return objectsJson.length;
      } else {
        throw Exception(
            'Failed to load objects for city $ala_object_id: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching object count for city $ala_object_id: $e');
      throw Exception(
          'Failed to load object count for city $ala_object_id: $e');
    }
  }
}
