import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Particle {
  Offset position;
  Offset velocity;
  double radius;
  Color color;
  double baseSpeed;

  Particle(Random random)
    : position = Offset(random.nextDouble() * 500, random.nextDouble() * 1000),
      velocity = Offset(
        (random.nextDouble() - 0.5) * 0.5,
        (random.nextDouble() - 0.5) * 0.5,
      ),
      radius = random.nextDouble() * 3 + 1,
      color = Colors.white.withOpacity(random.nextDouble() * 0.2 + 0.05),
      baseSpeed = random.nextDouble() * 0.5 + 0.1;

  void update(Offset glassPosition) {
    position += velocity * baseSpeed;

    final distance = (position - glassPosition).distance;
    if (distance < 150) {
      final direction = (position - glassPosition).normalized;
      position += direction * (150 - distance) * 0.03;
    }

    if (position.dx < 0 || position.dx > 500) {
      velocity = Offset(-velocity.dx, velocity.dy);
    }
    if (position.dy < 0 || position.dy > 1000) {
      velocity = Offset(velocity.dx, -velocity.dy);
    }
  }
}

extension on Offset {
  Offset get normalized => distance == 0 ? this : this / distance;
}
