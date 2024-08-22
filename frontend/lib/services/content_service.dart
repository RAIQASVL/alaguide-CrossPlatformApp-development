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
}
