import 'dart:convert';
import 'package:http/http.dart' as http;
import "package:frontend/models/city_model.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CityService {
  static const String baseUrl = 'http://192.168.1.235:8000/api/v1';

  Future<List<City>> fetchCities() async {
    try {
      print('Fetching cities from: $baseUrl/cities/');
      final response = await http.get(Uri.parse('$baseUrl/cities/'));
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> citiesJson = json.decode(response.body);
        print('Parsed JSON: $citiesJson');

        List<City> cities = citiesJson.map((cityJson) {
          print('Processing city: $cityJson');
          return City.fromJson(cityJson);
        }).toList();

        print('Processed cities: $cities');
        return cities;
      } else {
        throw Exception('Failed to load cities: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching cities: $e');
      throw Exception('Failed to load cities: $e');
    }
  }

  Future<int> fetchObjectCount(String name) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/alaguideobjects/?city=$name'));
      print('Request URL: $baseUrl/alaguideobjects/?city=$name');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> objectsJson = json.decode(response.body);
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
