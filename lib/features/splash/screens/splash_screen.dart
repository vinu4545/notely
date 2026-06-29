import 'package:flutter/material.dart';

import '../../../shared/widgets/animated_background.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Center(
            child: Text(
              "Splash Coming...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}