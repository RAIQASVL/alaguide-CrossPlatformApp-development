import 'dart:convert';

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

  Future<int> fetchObjectCount(String name) async {
    try {
      final response = await _apiService
          .get('/api/v1/alaguideobjects/?city=$name', headers: {});
      print('Request URL: $_apiService/api/v1/alaguideobjects/?city=$name');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.data}');

      if (response.statusCode == 200) {
        List<dynamic> objectsJson = response.data;
        return objectsJson.length;
      } else {
        throw Exception(
            'Failed to load objects for city $name: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching object count for city $name: $e');
      throw Exception('Failed to load object count for city $name: $e');
    }
  }
}
