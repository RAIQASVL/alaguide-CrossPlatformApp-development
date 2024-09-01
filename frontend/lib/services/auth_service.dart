import 'package:flutter/material.dart';
import 'package:frontend/models/user_models.dart';
import 'package:frontend/services/api_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final String _boxName = 'tokenBox';
  late Box<String> _tokenBox;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AuthService() {
    _initialize();
  }

  Future<void> _initialize() async {
    _tokenBox = await Hive.openBox<String>(_boxName);
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final response = await _apiService.post(
        '/account/login/',
        {'email': email, 'password': password},
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final token = response.data['key'];
        await _tokenBox.put('token', token);

        return await getUser(token);
      }
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
    return null;
  }

  Future<User?> signUp(String email, String password, String firstName,
      String lastName, String username) async {
    try {
      final response = await _apiService.post(
        '/registration/',
        {
          'email': email,
          'password1': password,
          'password2': password,
          'first_name': firstName,
          'last_name': lastName,
          'username': username,
        },
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final djangoToken = response.data['key'];
        await _tokenBox.put('token', djangoToken);

        return await getUser(djangoToken);
      }
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
    return null;
  }

  Future<void> resetPassword(String email) async {
    try {
      await _apiService.post(
        '/account/password/reset/',
        {'email': email},
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  Future<void> confirmPasswordReset(String code, String newPassword) async {
    try {
      await _apiService.post(
        '/account/password/reset/confirm/',
        {
          'token': code,
          'new_password1': newPassword,
          'new_password2': newPassword,
        },
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      throw Exception('Password reset confirmation failed: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      final token = _tokenBox.get('token');
      if (token != null) {
        await _apiService.post(
          '/account/logout/',
          {},
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json'
          },
        );
        await _tokenBox.delete('token');
      }
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
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
      throw Exception('Failed to get user: ${e.toString()}');
    }
    return null;
  }

  Future<User?> updateUser(User updatedUser) async {
    try {
      final token = _tokenBox.get('token');
      if (token == null) {
        throw Exception('User is not authenticated');
      }

      final response = await _apiService.put(
        '/account/user/',
        updatedUser.toJson(),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final updatedUserData = User.fromJson(response.data);
        return updatedUserData;
      }
    } catch (e) {
      throw Exception('Failed to update user: ${e.toString()}');
    }
    return null;
  }
}
