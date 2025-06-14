import 'package:flutter/material.dart';
import 'package:glass_effect/models/particle.dart';


class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Offset touchPosition;

  const ParticlePainter(this.particles, this.touchPosition);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint =
          Paint()
            ..color = particle.color
            ..style = PaintingStyle.fill;

      canvas.drawCircle(particle.position, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
