import 'package:flutter/material.dart';

/// Day / week / month tabs on colored app bars (selected tab = card pill).
TabBar buildDwmTabBar(
  BuildContext context, {
  required List<Tab> tabs,
  ValueChanged<int>? onTap,
}) {
  final theme = Theme.of(context);
  return TabBar(
    tabs: tabs,
    onTap: onTap,
    indicatorSize: TabBarIndicatorSize.tab,
    indicator: BoxDecoration(
      color: theme.cardColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
    labelColor: theme.colorScheme.onSurface,
    unselectedLabelColor: Colors.white,
    labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
  );
}
