import 'package:flutter/material.dart';
import 'package:glass_effect/models/settings.dart';
import 'package:glass_effect/widgets/toggle_button.dart';


class ControlPanel extends StatelessWidget {
  final GlassSettings settings;
  final VoidCallback onSettingsChanged;
  final Function(Color) onColorChanged;

  const ControlPanel({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildSliderControl("BLUR", settings.blur, 0, 30, (v) {
                settings.blur = v;
                onSettingsChanged();
              }),
              _buildSliderControl("OPACITY", settings.opacity, 0, 1, (v) {
                settings.opacity = v;
                onSettingsChanged();
              }),
              _buildSliderControl("RADIUS", settings.radius, 0, 100, (v) {
                settings.radius = v;
                onSettingsChanged();
              }),
              _buildSliderControl("BORDER", settings.borderOpacity, 0, 1, (v) {
                settings.borderOpacity = v;
                onSettingsChanged();
              }),
              _buildSliderControl("SIZE", settings.size, 100, 300, (v) {
                settings.size = v;
                onSettingsChanged();
              }),
              const SizedBox(height: 16),
              Row(
                children: [
                  ToggleButton(
                    label: "REFLECTION",
                    value: settings.showReflection,
                    onChanged: (v) {
                      settings.showReflection = v;
                      onSettingsChanged();
                    },
                    activeColor: settings.glassColor,
                  ),
                  const SizedBox(width: 16),
                  ToggleButton(
                    label: "LIQUID",
                    value: settings.showLiquidEffect,
                    onChanged: (v) {
                      settings.showLiquidEffect = v;
                      onSettingsChanged();
                    },
                    activeColor: settings.glassColor,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    Colors.primaries.sublist(0, 12).map((color) {
                      return GestureDetector(
                        onTap: () => onColorChanged(color),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  settings.glassColor == color
                                      ? Colors.white
                                      : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderControl(
    String label,
    double value,
    double min,
    double max,
    void Function(double) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              Text(
                value.toStringAsFixed(1),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Slider(value: value, min: min, max: max, onChanged: onChanged),
        ],
      ),
    );
  }
}
