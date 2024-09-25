import 'package:dio/dio.dart';
import 'package:frontend/constants/api_url_constants.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ));
  }

  Future<Response<dynamic>> get(String path,
      {required Map<String, String> headers}) async {
    try {
      final response = await _dio.get(path, options: Options(headers: headers));
      return response;
    } catch (e) {
      print('Error in GET request: $e');
      rethrow;
    }
  }

  Future<Response<dynamic>> post(String path, dynamic data,
      {required Map<String, String> headers}) async {
    try {
      final response =
          await _dio.post(path, data: data, options: Options(headers: headers));
      return response;
    } catch (e) {
      print('Error in POST request: $e');
      rethrow;
    }
  }

  Future<Response<dynamic>> put(String path, dynamic data,
      {required Map<String, String> headers}) async {
    try {
      final response =
          await _dio.put(path, data: data, options: Options(headers: headers));
      return response;
    } catch (e) {
      print('Error in PUT request: $e');
      rethrow;
    }
  }

  // Add other methods (delete, etc.) as needed
}
