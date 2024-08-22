import 'package:frontend/services/api_service.dart';
import 'package:frontend/models/city_model.dart';

class CityService {
  final ApiService _apiService = ApiService();

  Future<List<City>> fetchCities() async {
    try {
      final response = await _apiService.get('/api/v1/cities', headers: {});

      if (response.statusCode == 200) {
        final List<dynamic> citiesJson = response.data;
        return citiesJson.map((cityJson) => City.fromJson(cityJson)).toList();
      } else {
        throw Exception(
            'Failed to load cities: ${response.statusCode} - ${response.statusMessage}');
      }
    } catch (e) {
      print('Error fetching cities: $e');
      rethrow;
    }
  }
}
