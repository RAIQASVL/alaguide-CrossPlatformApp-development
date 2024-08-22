import 'package:frontend/services/api_service.dart';
import 'package:frontend/models/alaguide_object_model.dart';

class ContentService {
  final ApiService _apiService = ApiService();

  Future<List<AlaguideObject>> fetchAlaguideObjects() async {
    try {
      final response =
          await _apiService.get('/api/v1/alaguideobjects', headers: {});

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        return jsonData.map((json) => AlaguideObject.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load Alaguide objects: ${response.statusCode} - ${response.statusMessage}');
      }
    } catch (e) {
      print('Error fetching Alaguide objects: $e');
      rethrow;
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
