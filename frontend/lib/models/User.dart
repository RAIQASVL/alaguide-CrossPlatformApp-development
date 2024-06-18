import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  String? _token;
  String? _email;

  String? get token => _token;
  String? get email => _email;

  void login(String token, String email) {
    _token = token;
    _email = email;
    notifyListeners();
  }

  void logout() {
    _token = null;
    _email = null;
    notifyListeners();
  }
}
