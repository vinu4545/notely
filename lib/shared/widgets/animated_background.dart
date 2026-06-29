import 'package:flutter/material.dart';

import '../../app/theme/app_gradients.dart';

class AnimatedBackground extends StatelessWidget {
  final Widget child;

  const AnimatedBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        // Background Gradient
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppGradients.primary,
          ),
          child: SizedBox.expand(),
        ),

        // Pink Orb
        Positioned(
          top: -120,
          right: -80,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(.10),
            ),
          ),
        ),

        // Orange Orb
        Positioned(
          bottom: -120,
          left: -100,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(.08),
            ),
          ),
        ),

        child,
      ],
    );
  }
}