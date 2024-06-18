import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/AccountUser.dart';
import '../models/AlaguideObject.dart';
import '../models/AudioBook.dart';
import '../models/Category.dart';
import '../models/City.dart';
import '../models/Country.dart';
import '../models/CustomUserManager.dart';
import '../models/Tag.dart';
import '../models/Landmark.dart';
import '../models/LandmarkTag.dart';
import '../models/LikeRating.dart';
import '../models/MapData.dart';
import '../models/SocialProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // 1. AllAuth User Module 
  // Authentication and Authorization - Django Allauth 

  // urlpatterns = [
  //     path("home/", TemplateView.as_view(template_name="dashboard/home.html"), name="home"),
  //     path("accounts/", include("allauth.urls")),
  //     path("accounts/login/", LoginView.as_view(), name="account_login"),
  //     path("accounts/signup/", SignupView.as_view(), name="account_signup"),
  //     path("accounts/logout/", LogoutView.as_view(), name="account_logout"),
  //     path("accounts/password/set/", PasswordSetView.as_view(), name="account_set_password"),
  //     path("accounts/password/change/", PasswordChangeView.as_view(), name="account_change_password"),
  //     path("accounts/password/reset/", PasswordResetView.as_view(), name="account_reset_password"),
  //     path("accounts/password/reset/<uidb64>/<token>/", PasswordResetFromKeyView.as_view(), name="account_reset_password_from_key"),
  //     path("accounts/email/", EmailView.as_view(), name="account_email"),
  //     path("accounts/confirm-email/<key>/", ConfirmEmailView.as_view(), name="account_confirm_email"),
  // ]

  ?????

  Future<CustomUserManager> createUser(
      String email, String password, Map<String, dynamic> extraFields) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authorization/accounts/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password1': password,
        'password2': password,
        ...extraFields,
      }),
    );
    if (response.statusCode == 201) {
      return CustomUserManager.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authorization/accounts/login/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'login': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> logout(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authorization/accounts/logout/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to logout');
    }
  }

  // Other Modules
  Future<List<AccountUser>> fetchAccountUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/account_users'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => AccountUser.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load account users');
    }
  }

  Future<List<Country>> fetchCountries() async {
    final response = await http.get(Uri.parse('$baseUrl/countries/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Country.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }

  Future<List<City>> fetchCities() async {
    final response = await http.get(Uri.parse('$baseUrl/cities/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => City.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load cities');
    }
  }

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Landmark>> fetchLandmark() async {
    final response = await http.get(Uri.parse('$baseUrl/landmarks/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Landmark.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load landmarks');
    }
  }

  Future<List<AudioBook>> fetchAudioBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/audio_books/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => AudioBook.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load audio books');
    }
  }

  Future<List<AlaguideObject>> fetchAlaguideObjects() async {
    final response = await http.get(Uri.parse('$baseUrl/alaguide_objects/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => AlaguideObject.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load alaguide objects');
    }
  }

  Future<List<Tag>> fetchTag() async {
    final response = await http.get(Uri.parse('$baseUrl/tags/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Tag.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load tags');
    }
  }

  Future<List<LandmarkTag>> fetchLandmarkTags() async {
    final response = await http.get(Uri.parse('$baseUrl/landmark_tags/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => LandmarkTag.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load landmark tags');
    }
  }

  Future<List<LikeRating>> fetchLikeRatings() async {
    final response = await http.get(Uri.parse('$baseUrl/like_ratings/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => LikeRating.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load like ratings');
    }
  }

  Future<List<SocialProvider>> fetchSocialProviders() async {
    final response = await http.get(Uri.parse('$baseUrl/social_providers/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => SocialProvider.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load social providers');
    }
  }

  Future<List<MapData>> fetchMapData() async {
    final response = await http.get(Uri.parse('$baseUrl/map_data/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => MapData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load map data');
    }
  }
}
