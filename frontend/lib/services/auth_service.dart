import 'package:flutter/material.dart';
import 'package:frontend/models/user_models.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:frontend/services/api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<User?> signIn(
      String email, String password, BuildContext context) async {
    try {
      final response = await _apiService.post(
        '/account/login/',
        {'email': email, 'password': password}, headers: null,
        // No headers needed for this request
      );

      if (response.statusCode == 200) {
        final token = response.data['key'];
        var box = await Hive.openBox('tokenBox');
        await box.put('token', token);

        return await getUser(token);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
    return null;
  }

  Future<User?> getUser(String token) async {
    try {
      final response = await _apiService.get(
        '/account/user/',
        headers: {'Authorization': 'Token $token'},
      );

      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        user.token = token;
        return user;
      }
    } catch (e) {
      print('Failed to get user: ${e.toString()}');
    }
    return null;
  }

  Future<User?> signUp(String email, String password, String firstName,
      String lastName, BuildContext context) async {
    try {
      final response = await _apiService.post(
        '/registration/',
        {
          'email': email,
          'password1': password,
          'password2': password,
          'first_name': firstName,
          'last_name': lastName,
        },
        headers: null,
        // No headers needed for this request
      );

      if (response.statusCode == 201) {
        final user = User.fromJson(response.data);
        return user;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: ${e.toString()}')),
      );
    }
    return null;
  }

  Future<bool> resetPassword(String email, BuildContext context) async {
    try {
      final response = await _apiService.post(
        '/account/password/reset/',
        {'email': email}, headers: null,
        // No headers needed for this request
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset email sent')),
        );
        return true;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset failed: ${e.toString()}')),
      );
    }
    return false;
  }
}
