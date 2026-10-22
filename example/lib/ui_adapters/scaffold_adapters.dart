import 'package:vvk_ui_kit/vvk_ui_kit.dart' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/core/constants/global_constants.dart';
import 'package:flutter_band_fit_app/ui_adapters/band_app_bar_actions.dart';

class VitalColoredAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VitalColoredAppBar({
    super.key,
    required this.title,
    required this.accentColor,
    this.actions,
    this.onBack,
  });

  final String title;
  final Color accentColor;
  final List<Widget>? actions;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ui.UIAppBar.accent(
      title: title,
      accentColor: accentColor,
      onBack: onBack,
      actions: [
        ...?actions,
        ...bandAppBarActions(),
      ],
    );
  }
}

class SettingsPageScaffold extends StatelessWidget {
  const SettingsPageScaffold({
    super.key,
    required this.title,
    required this.body,
    this.onBack,
    this.floatingActionButton,
    this.onSave,
    this.accentColor,
  });

  final String title;
  final Widget body;
  final VoidCallback? onBack;
  final Widget? floatingActionButton;
  final VoidCallback? onSave;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    return ui.UISettingsPageScaffold(
      title: title,
      body: body,
      onBack: onBack,
      floatingActionButton: floatingActionButton,
      onSave: onSave,
      saveFabTooltip: textSave,
      accentColor: accentColor ?? AppColors.primaryTeal,
      appBarActions: bandAppBarActions(),
    );
  }
}

class AccentTabDetailScaffold extends StatelessWidget {
  const AccentTabDetailScaffold({
    super.key,
    required this.title,
    required this.tabs,
    required this.tabViews,
    this.accentColor,
    this.onBack,
  });

  final String title;
  final List<Tab> tabs;
  final List<Widget> tabViews;
  final Color? accentColor;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return ui.UIAccentTabDetailScaffold(
      title: title,
      tabs: tabs,
      tabViews: tabViews,
      accentColor: accentColor ?? AppColors.primaryTeal,
      onBack: onBack,
      appBarActions: bandAppBarActions(),
    );
  }
}

class DetailActivityHeader extends StatelessWidget {
  const DetailActivityHeader({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ui.UIDetailActivityHeader(label: label);
  }
}

class VitalDetailBody extends StatelessWidget {
  const VitalDetailBody({
    super.key,
    required this.activityLabel,
    required this.dateTitle,
    required this.isNextDisabled,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.chart,
    this.belowChart = const [],
  });

  final String activityLabel;
  final String dateTitle;
  final bool isNextDisabled;
  final VoidCallback onPreviousDay;
  final VoidCallback? onNextDay;
  final Widget chart;
  final List<Widget> belowChart;

  @override
  Widget build(BuildContext context) {
    return ui.UIDetailScrollLayout(
      activityLabel: activityLabel,
      dateTitle: dateTitle,
      isNextDisabled: isNextDisabled,
      onPreviousDay: onPreviousDay,
      onNextDay: onNextDay,
      chart: chart,
      belowChart: belowChart,
    );
  }
}

class VitalTabDetailScaffold extends StatelessWidget {
  const VitalTabDetailScaffold({
    super.key,
    required this.title,
    required this.accentColor,
    required this.tabs,
    required this.tabViews,
    this.onBack,
    this.onTabTap,
    this.header,
    this.tabViewPhysics,
    this.centerTitle = false,
  });

  final String title;
  final Color accentColor;
  final List<Tab> tabs;
  final List<Widget> tabViews;
  final VoidCallback? onBack;
  final ValueChanged<int>? onTabTap;
  final Widget? header;
  final ScrollPhysics? tabViewPhysics;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return ui.UITabbedDetailScaffold(
      title: title,
      accentColor: accentColor,
      tabs: tabs,
      tabViews: tabViews,
      onBack: onBack,
      onTabTap: onTabTap,
      header: header,
      tabViewPhysics: tabViewPhysics,
      centerTitle: centerTitle,
      appBarActions: bandAppBarActions(),
    );
  }
}
