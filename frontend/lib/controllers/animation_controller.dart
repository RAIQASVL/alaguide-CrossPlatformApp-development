import 'package:flutter/material.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimatedLocationButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimatedLocationButton({super.key, required this.onPressed});

  @override
  _AnimatedLocationButtonState createState() => _AnimatedLocationButtonState();
}

class _AnimatedLocationButtonState extends State<AnimatedLocationButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.my_location,
            color: Colors.black,
            size: 28,
          ),
        ),
      ),
    );
  }
}


class AnimatedMenuButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimatedMenuButton({super.key, required this.onPressed});

  @override
  _AnimatedMenuButtonState createState() => _AnimatedMenuButtonState();
}

class _AnimatedMenuButtonState extends State<AnimatedMenuButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: const Icon(
            Icons.menu,
            color: Colors.black,
            size: 28,
          ),
        ),
      ),
    );
  }
}


class AnimationDarkLightModeButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimationDarkLightModeButton({super.key, required this.onPressed});

  @override
  _AnimationDarkLightModeButtonState createState() => _AnimationDarkLightModeButtonState();
}

class _AnimationDarkLightModeButtonState extends State<AnimationDarkLightModeButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final themeNotifier = ref.read(themeProvider.notifier);
        final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;

        return GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) => _controller.reverse(),
          onTapCancel: () => _controller.reverse(),
          onTap: () {
            themeNotifier.toggleTheme();
          },
          child: ScaleTransition(
            scale: _animation,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: isDarkMode ? Colors.black : Colors.white,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }
}