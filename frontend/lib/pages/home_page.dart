import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/providers/auth_providers.dart';
import 'package:frontend/models/user_models.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
    final isLoggedIn = ref.watch(authStateProvider);

    String _getGreeting() {
      final hour = DateTime.now().hour;
      final firstName = user?.firstName ?? '';
      if (hour < 12) {
        return AppLocalizations.of(context)!.goodMorning(firstName);
      } else if (hour < 18) {
        return AppLocalizations.of(context)!.goodAfternoon(firstName);
      } else {
        return AppLocalizations.of(context)!.goodEvening(firstName);
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        leading: BackButton(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              color: isDarkMode ? Colors.white : Colors.black,
              onPressed: () {
                ref.read(themeProvider.notifier).toggleTheme();
                _controller.forward(from: 0);
              },
            ).animate(controller: _controller, effects: [const ScaleEffect()]),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _getGreeting(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
              ).animate().fadeIn().slideY(),
              const SizedBox(height: 20),
              if (user != null) ...[
                UserProfileWidget(user: user),
              ] else ...[
                Text(
                  AppLocalizations.of(context)!.welcome,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                ).animate().fadeIn().slideY(),
              ],
              const SizedBox(height: 40),
              if (user != null) ...[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/my_account');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 151, 204, 248),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.myAccount,
                    style: TextStyle(
                      color: isDarkMode ? Colors.black : Colors.black,
                    ),
                  ),
                ).animate().fadeIn().slideY(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfileWidget extends ConsumerWidget {
  final User user;

  const UserProfileWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: user.avatarUrl != null
              ? NetworkImage(user.avatarUrl!)
              : const AssetImage('assets/images/default_avatar.png')
                  as ImageProvider,
          backgroundColor: isDarkMode ? Colors.white : Colors.white,
        ),
        const SizedBox(height: 20),
        Text(
          '${user.firstName} ${user.lastName}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
