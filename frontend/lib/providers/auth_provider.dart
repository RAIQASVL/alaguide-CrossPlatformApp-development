import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final authStateProvider = StateProvider<bool>((ref) => false);


class AuthService {
  void signUp(String email, String password, BuildContext context, String firstName, String lastName) {
    // Implement sign up logic
  }

  void signIn(String email, String password, BuildContext context) {
    // Implement sign in logic
  }
}
