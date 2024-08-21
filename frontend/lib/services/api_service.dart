import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      // baseUrl: 'http://10.0.2.2:8000', // Use this for Android emulator
      baseUrl: 'http://localhost:8000', // Use this for iOS simulator or web
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ));
  }

  Future<Response> get(String path,
      {required Map<String, String> headers}) async {
    try {
      final response = await _dio.get(path, options: Options(headers: headers));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String path, dynamic data, {required headers}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Add other methods (put, delete, etc.) as needed
}
