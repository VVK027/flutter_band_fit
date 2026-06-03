import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/core/widgets/theme_toggle_button.dart';

/// Theme-aware scaffold; isolates app bar from body rebuilds when possible.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.showThemeToggle = false,
    this.leading,
    this.automaticallyImplyLeading = true,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool showThemeToggle;
  final Widget? leading;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mergedActions = <Widget>[
      if (showThemeToggle) const ThemeToggleButton(),
      ...?actions,
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: title == null
          ? null
          : AppBar(
              title: Text(title!),
              leading: leading,
              automaticallyImplyLeading: automaticallyImplyLeading,
              actions: mergedActions.isEmpty ? null : mergedActions,
            ),
      body: SafeArea(
        bottom: bottomNavigationBar == null,
        child: body,
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar == null
          ? null
          : SafeArea(top: false, child: bottomNavigationBar!),
    );
  }
}

/// Detail screens with gradient-style app bar colors from theme.
class AppDetailScaffold extends StatelessWidget {
  const AppDetailScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.appBarColor,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Color? appBarColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final barColor = appBarColor ?? theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: barColor,
        foregroundColor: theme.colorScheme.onPrimary,
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
        title: Text(
          title,
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
        actions: actions,
      ),
      body: SafeArea(child: RepaintBoundary(child: body)),
    );
  }
}
