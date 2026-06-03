import 'package:flutter/material.dart';

/// Full-screen scrim with a centered card while [visible] is true.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.visible,
    required this.child,
    this.message,
    this.subtitle,
  });

  final bool visible;
  final Widget child;
  final String? message;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        if (visible)
          Positioned.fill(
            child: AbsorbPointer(
              child: ColoredBox(
                color: theme.colorScheme.scrim.withValues(alpha: 0.52),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Material(
                      color: theme.cardColor,
                      elevation: 8,
                      shadowColor: theme.shadowColor.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 28,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            if (message != null) ...[
                              const SizedBox(height: 20),
                              Text(
                                message!,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                            if (subtitle != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                subtitle!,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.65),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
