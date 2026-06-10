import 'package:flutter/material.dart';

/// Date pager row reused on vital detail screens (theme-aware, minimal rebuild scope).
class DetailDateNavigator extends StatelessWidget {
  const DetailDateNavigator({
    super.key,
    required this.dateTitle,
    required this.isNextDisabled,
    required this.onPrevious,
    required this.onNext,
  });

  final String dateTitle;
  final bool isNextDisabled;
  final VoidCallback onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          iconSize: 20,
          onPressed: onPrevious,
          icon: Icon(Icons.arrow_back_ios_outlined, color: onSurface),
        ),
        Text(dateTitle, style: Theme.of(context).textTheme.titleMedium),
        IconButton(
          iconSize: 20,
          onPressed: isNextDisabled ? null : onNext,
          icon: Icon(
            Icons.arrow_forward_ios_outlined,
            color:
                isNextDisabled ? onSurface.withValues(alpha: 0.35) : onSurface,
          ),
        ),
      ],
    );
  }
}
