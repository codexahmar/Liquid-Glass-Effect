import 'package:flutter/material.dart';
import 'package:glass_effect/models/light_beam.dart';

class LightBeamPainter extends CustomPainter {
  final List<LightBeam> beams;

  const LightBeamPainter(this.beams);

  @override
  void paint(Canvas canvas, Size size) {
    for (final beam in beams) {
      final paint =
          Paint()
            ..color = Colors.white.withOpacity(beam.opacity)
            ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromLTWH(size.width * 0.3, beam.y, beam.width, beam.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
