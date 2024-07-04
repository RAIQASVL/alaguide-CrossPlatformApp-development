import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/services/landmark_service.dart';
import 'package:frontend/models/landmark.dart';


class LandmarkService extends StateNotifier<List<Landmark>> {
  LandmarkService() : super([]);

  Future<void> fetchLandmarks() async {
    try {
      final response = await http.get(Uri.parse('YOUR_BACKEND_API_URL/landmarks'));
      if (response.statusCode == 200) {
        List<dynamic> landmarksJson = json.decode(response.body);
        state = landmarksJson.map((json) => Landmark.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load landmarks');
      }
    } catch (e) {
      print('Error fetching landmarks: $e');
      // Show error message to user
    }
  }
}