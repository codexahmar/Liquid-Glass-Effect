import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:glass_effect/models/light_beam.dart';
import 'package:glass_effect/models/particle.dart';
import 'package:glass_effect/models/settings.dart';
import 'package:glass_effect/painters/light_beam_painter.dart';
import 'package:glass_effect/painters/particle_painter.dart';
import 'package:glass_effect/widgets/control_panel.dart';
import 'package:glass_effect/widgets/liquid_glass.dart' ;


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlassSettings _settings = GlassSettings();
  final List<IconData> _icons = [
    Icons.apple,
    Icons.android,
    Icons.window,
    Icons.ac_unit,
    Icons.star,
    Icons.favorite,
    Icons.bolt,
    Icons.water_drop,
  ];

  int _currentIconIndex = 0;
  Offset _position = const Offset(100, 200);
  double _tiltX = 0;
  double _tiltY = 0;
  double _velocity = 0;

  bool _showControls = false;
  late Ticker _ticker;
  late Color _targetColor;
  late Color _currentColor;
  final Random _random = Random();
  final List<Particle> _particles = [];
  final List<LightBeam> _lightBeams = [];
  double _liquidWobble = 0.0;

  @override
  void initState() {
    super.initState();
    _targetColor = Colors.primaries[_random.nextInt(Colors.primaries.length)];
    _currentColor = _targetColor;

    for (int i = 0; i < 30; i++) {
      _particles.add(Particle(_random));
    }

    for (int i = 0; i < 5; i++) {
      _lightBeams.add(LightBeam(_random));
    }

    _ticker = createTicker((elapsed) {
      setState(() {
        _updatePhysics();
        _updateParticles();
        _updateLightBeams();
        _updateColors();
        if (_settings.showLiquidEffect) {
          _liquidWobble = sin(elapsed.inMilliseconds / 300) * 2;
        }
      });
    });
    _ticker.start();
  }

  void _updatePhysics() {
    _velocity *= 0.98;
    _tiltX *= 0.9;
    _tiltY *= 0.9;

    _position = Offset(
      (_position.dx).clamp(
        0,
        MediaQuery.sizeOf(context).width - _settings.size,
      ),
      (_position.dy).clamp(
        0,
        MediaQuery.sizeOf(context).height - _settings.size,
      ),
    );
  }

  void _updateParticles() {
    for (final particle in _particles) {
      particle.update(_position);
    }
  }

  void _updateLightBeams() {
    for (final beam in _lightBeams) {
      beam.update();
    }
  }

  void _updateColors() {
    _currentColor = Color.lerp(_currentColor, _targetColor, 0.01)!;
    if (_currentColor.value.toRadixString(16).substring(0, 6) ==
        _targetColor.value.toRadixString(16).substring(0, 6)) {
      _targetColor = Colors.primaries[_random.nextInt(Colors.primaries.length)];
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 4),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  _currentColor,
                  _currentColor.withOpacity(0.7),
                  _currentColor.withOpacity(0.3),
                ],
                center: Alignment.topRight,
                radius: 1.5,
              ),
            ),
          ),

          CustomPaint(
            painter: ParticlePainter(_particles, _position),
            size: Size.infinite,
          ),

          if (_settings.showReflection)
            CustomPaint(
              painter: LightBeamPainter(_lightBeams),
              size: Size.infinite,
            ),

          Positioned(
            left: _position.dx,
            top: _position.dy,
            child: GestureDetector(
              onPanStart: (_) => _velocity = 0,
              onPanUpdate: (details) {
                setState(() {
                  _position += details.delta;
                  _velocity = details.delta.distance;
                  _tiltX = (details.delta.dx / 5).clamp(-15, 15);
                  _tiltY = (details.delta.dy / 5).clamp(-15, 15);
                });
              },
              onPanEnd: (_) {
                setState(() {
                  _tiltX = _tiltY = 0;
                });
              },
              onDoubleTap: () {
                setState(() {
                  _currentIconIndex = (_currentIconIndex + 1) % _icons.length;
                });
              },
              child: Transform(
                transform:
                    Matrix4.identity()
                      ..rotateX(_tiltY * 0.005)
                      ..rotateY(_tiltX * 0.005),
                alignment: Alignment.center,
                child: LiquidGlass(
                  blur: _settings.blur,
                  opacity: _settings.opacity,
                  radius: _settings.radius + _liquidWobble,
                  borderOpacity: _settings.borderOpacity,
                  glassColor: _settings.glassColor,
                  borderColor: _settings.borderColor,
                  size: _settings.size,
                  icon: _icons[_currentIconIndex],
                  showReflection: _settings.showReflection,
                ),
              ),
            ),
          ),

          const Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'LIQUID GLASS',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 5,
                ),
              ),
            ),
          ),

          if (_showControls)
            ControlPanel(
              settings: _settings,
              onSettingsChanged: () => setState(() {}),
              onColorChanged: (color) {
                setState(() {
                  _settings.glassColor = color;
                  _settings.borderColor = color;
                });
              },
            ),

          Positioned(
            bottom: _showControls ? 420 : 40,
            right: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  onPressed:
                      () => setState(() => _showControls = !_showControls),
                  backgroundColor: Colors.white.withOpacity(0.2),
                  elevation: 0,
                  child: Icon(
                    _showControls ? Icons.close : Icons.tune,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _currentIconIndex =
                          (_currentIconIndex + 1) % _icons.length;
                    });
                  },
                  backgroundColor: Colors.white.withOpacity(0.2),
                  elevation: 0,
                  child: const Icon(Icons.refresh, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
