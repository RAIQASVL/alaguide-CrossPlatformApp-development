import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/models/user_models.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (user != null) ...[
                  UserInfoWidget(user: user),
                ] else ...[
                  Text(
                    'Welcome to Our App!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Please log in or register to access all features.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (user == null) {
                      Navigator.pushNamed(context, '/auth');
                    } else {
                      // Logout logic
                      ref.read(authProvider.notifier).clearUser();
                      ref.read(authStateProvider.notifier).state = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Logged out successfully')),
                      );
                    }
                  },
                  child: Text(user != null ? 'Logout' : 'Login / Register'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: user != null ? Colors.yellow : Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
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
      ),
    );
  }
}

class UserInfoWidget extends StatelessWidget {
  final User user;

  const UserInfoWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Welcome, ${user.firstName}!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 20),
        Text(
          'User Info:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 10),
        UserInfoItem(
            label: 'Name', value: '${user.firstName} ${user.lastName}'),
        UserInfoItem(label: 'Email', value: user.email ?? 'N/A'),
        UserInfoItem(label: 'Username', value: user.username ?? 'N/A'),
      ],
    );
  }
}

class UserInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const UserInfoItem({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
