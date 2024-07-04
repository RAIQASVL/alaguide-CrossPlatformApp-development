import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/themes/app_theme.dart';
import 'package:frontend/pages/splash_screen.dart';
import 'package:frontend/pages/map_page.dart';
import 'package:frontend/pages/auth_page.dart';
import 'package:frontend/pages/forgot_password_page.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/providers/theme_provider.dart';


void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'ALAGUIDE',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/map': (context) => const MapPage(),
        '/auth': (context) => const AuthPage(),
        '/forgot_password': (context) => const ForgotPasswordPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}