import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/user_models.dart';

final authStateProvider = StateProvider<bool>((ref) => false);

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(null);

  void setUser(User user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});
