import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/user_models.dart';
import 'package:frontend/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});

final authStateProvider = StateProvider<bool>((ref) => false);

class AuthNotifier extends StateNotifier<User?> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(null);

  void setUser(User user) => state = user;
  void clearUser() => state = null;

  Future<User?> signIn(String email, String password) async {
    try {
      final user = await _authService.signIn(email, password);
      if (user != null) {
        state = user;
      }
      return user;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<User?> signUp(String email, String password, String firstName,
      String lastName, String username) async {
    try {
      final user = await _authService.signUp(
          email, password, firstName, lastName, username);
      if (user != null) {
        state = user;
      }
      return user;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  Future<void> confirmPasswordReset(String code, String newPassword) async {
    try {
      await _authService.confirmPasswordReset(code, newPassword);
    } catch (e) {
      throw Exception('Password reset confirmation failed: ${e.toString()}');
    }
  }

  Future<User?> updateUser(User updatedUser) async {
    try {
      final user = await _authService.updateUser(updatedUser);
      if (user != null) {
        state = user;
      }
      return user;
    } catch (e) {
      throw Exception('Update failed: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      state = null;
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }
}
