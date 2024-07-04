import 'package:flutter/material.dart';

class AnimationManager {
  late AnimationController controller;

  AnimationManager(TickerProvider vsync) {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1500),
    );
  }

  void startAnimation() {
    controller.forward();
  }

  void dispose() {
    controller.dispose();
  }
}