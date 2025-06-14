import 'dart:math';

class LightBeam {
  double y;
  double height;
  double speed;
  double opacity;
  double width;

  LightBeam(Random random)
    : y = random.nextDouble() * 1000,
      height = random.nextDouble() * 300 + 100,
      speed = random.nextDouble() * 2 + 1,
      opacity = random.nextDouble() * 0.1 + 0.05,
      width = random.nextDouble() * 2 + 1;

  void update() {
    y += speed;
    if (y > 1000 + height) {
      y = -height;
    }
  }
}
