import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/core/constants/global_constants.dart';

/// Full-width primary action bar used on vitals detail screens (BP, SpO₂, temperature).
class VitalStartButtonBar extends StatelessWidget {
  const VitalStartButtonBar({
    super.key,
    required this.accentColor,
    required this.onPressed,
    this.label = textStart,
    this.enabled = true,
  });

  final Color accentColor;
  final VoidCallback? onPressed;
  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onAccent =
        accentColor.computeLuminance() > 0.4 ? Colors.black87 : Colors.white;

    return Material(
      color: theme.scaffoldBackgroundColor,
      elevation: 0,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: enabled ? onPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: onAccent,
                disabledBackgroundColor: accentColor.withValues(alpha: 0.45),
                disabledForegroundColor: onAccent.withValues(alpha: 0.7),
                elevation: enabled ? 2 : 0,
                shadowColor: accentColor.withValues(alpha: 0.35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              child: Text(label),
            ),
          ),
        ),
      ),
    );
  }
}
