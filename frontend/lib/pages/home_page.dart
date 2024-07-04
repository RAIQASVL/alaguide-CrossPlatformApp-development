import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/theme_provider.dart';

final authStateProvider = StateProvider<bool>((ref) => false);

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(authStateProvider);
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Home'),
        leading: BackButton(
            color: isDarkMode ? Colors.white : const Color(0xff1D1617)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 0, right: 16),
            child: IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              color: Colors.grey,
              onPressed: () {
                ref.read(themeProvider.notifier).toggleTheme();
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isAuthenticated
                  ? UserInfoWidget()
                  : Text('You are not logged in'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (!isAuthenticated) {
                    Navigator.pushNamed(context, '/auth');
                  } else {
                    // Here you can add logic for exit from the system
                    ref.read(authStateProvider.notifier).state = false;
                  }
                },
                child: Text(isAuthenticated ? 'Logout' : 'Login / Register'),
              ),
              SizedBox(height: 20),
              Text('Current theme: ${isDarkMode ? "Dark" : "Light"}'),
              Switch(
                value: isDarkMode,
                onChanged: (value) {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Welcome, User!'),
        SizedBox(height: 20),
        Text('User Info:'),
        // Add more user info here
      ],
    );
  }
}
