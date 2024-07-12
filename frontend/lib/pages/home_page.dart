import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/providers/auth_providers.dart';
import 'package:frontend/models/user_models.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
          color: isDarkMode ? Colors.white : const Color(0xff1D1617),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              color: isDarkMode ? Colors.white : const Color(0xff1D1617),
              onPressed: () {
                ref.read(themeProvider.notifier).toggleTheme();
                _controller.forward(from: 0);
              },
            ).animate(controller: _controller, effects: [ScaleEffect()]),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (user != null) ...[
                        UserProfileWidget(user: user),
                      ] else ...[
                        Text(
                          'Welcome to\nALAGUIDE\nAudio Tour Guide',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ).animate().fadeIn().slideY(),
                        SizedBox(height: 20),
                        Text(
                          'Discover amazing places with our audio guides.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ).animate().fadeIn().slideY(),
                      ],
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          if (!isLoggedIn) {
                            Navigator.pushNamed(context, '/auth');
                          } else {
                            ref.read(authProvider.notifier).clearUser();
                            ref.read(authStateProvider.notifier).state = false;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Logged out successfully')),
                            );
                          }
                        },
                        child: Text(
                          isLoggedIn ? 'Logout' : 'Login / Register',
                          selectionColor: Colors.black,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isLoggedIn
                              ? Color.fromARGB(255, 151, 204, 248)
                              : Color.fromARGB(255, 164, 246, 238),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ).animate().fadeIn().slideY(),
                      if (isLoggedIn) ...[
                        SizedBox(height: 40),
                        Text(
                          'Quick Actions',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 20),
                        QuickActionGrid(),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class UserProfileWidget extends ConsumerWidget {
  final User user;

  const UserProfileWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: user.avatarUrl != null
              ? NetworkImage(user.avatarUrl!)
              : AssetImage('assets/default_avatar.png') as ImageProvider,
        ),
        SizedBox(height: 20),
        Text(
          '${user.firstName} ${user.lastName}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 10),
        Text(
          user.email ?? '',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/edit-profile');
          },
          child: Text(
            'Edit Profile',
            selectionColor: Colors.black,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 247, 233, 106),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ).animate().fadeIn().slideY(),
      ],
    );
  }
}

class QuickActionGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.5,
      children: [
        QuickActionItem(
          icon: Icons.favorite,
          label: 'Favorites',
          onTap: () => Navigator.pushNamed(context, '/favorites'),
        ),
        QuickActionItem(
          icon: Icons.map,
          label: 'Explore',
          onTap: () => Navigator.pushNamed(context, '/explore'),
        ),
        QuickActionItem(
          icon: Icons.history,
          label: 'History',
          onTap: () => Navigator.pushNamed(context, '/history'),
        ),
        QuickActionItem(
          icon: Icons.settings,
          label: 'Settings',
          onTap: () => Navigator.pushNamed(context, '/settings'),
        ),
      ],
    );
  }
}

class QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const QuickActionItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30),
            SizedBox(height: 5),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    ).animate().fadeIn().scale();
  }
}
