import 'package:flutter/material.dart';

class GlassSettings {
  double blur;
  double opacity;
  double radius;
  double borderOpacity;
  Color glassColor;
  Color borderColor;
  double size;
  bool showReflection;
  bool showLiquidEffect;

  GlassSettings({
    this.blur = 15.0,
    this.opacity = 0.2,
    this.radius = 40.0,
    this.borderOpacity = 0.3,
    this.glassColor = Colors.white,
    this.borderColor = Colors.white,
    this.size = 200.0,
    this.showReflection = true,
    this.showLiquidEffect = true,
  });
}
