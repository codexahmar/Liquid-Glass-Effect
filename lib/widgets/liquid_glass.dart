import 'package:flutter/material.dart';
import 'dart:ui';

class LiquidGlass extends StatelessWidget {
  final double blur;
  final double opacity;
  final double radius;
  final double borderOpacity;
  final Color glassColor;
  final Color borderColor;
  final double size;
  final IconData icon;
  final bool showReflection;

  const LiquidGlass({
    super.key,
    required this.blur,
    required this.opacity,
    required this.radius,
    required this.borderOpacity,
    required this.glassColor,
    required this.borderColor,
    required this.size,
    required this.icon,
    this.showReflection = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    glassColor.withOpacity(opacity),
                    glassColor.withOpacity(opacity * 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  color: borderColor.withOpacity(borderOpacity),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: size * 0.3,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
          ),
        ),

        if (showReflection)
          Positioned(
            top: size * 0.1,
            left: size * 0.1,
            child: Transform.rotate(
              angle: -0.3,
              child: Container(
                width: size * 0.4,
                height: size * 0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
