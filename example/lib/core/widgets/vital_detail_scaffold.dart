import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/core/widgets/fixed_section_list.dart';
import 'package:flutter_band_fit_app/app/theme/app_colors.dart';
import 'package:flutter_band_fit_app/core/widgets/app_ui_components.dart';
import 'package:flutter_band_fit_app/core/widgets/settings_widgets.dart';
import 'package:flutter_band_fit_app/core/widgets/detail_date_navigator.dart';
import 'package:flutter_band_fit_app/core/widgets/dwm_tab_bar.dart';
import 'package:flutter_band_fit_app/core/widgets/theme_toggle_button.dart';

/// Accent app bar used on vitals detail screens (HR, BP, SpO2, etc.).
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
    final onBar = VitalColoredAppBar.contrastOn(accentColor);
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 3,
      shadowColor: accentColor.withValues(alpha: 0.35),
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: onBar, size: 20),
        onPressed: onBack ?? () => Navigator.of(context).pop(),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: onBar,
          fontWeight: FontWeight.w700,
          fontSize: 18,
          letterSpacing: -0.2,
        ),
      ),
      foregroundColor: onBar,
      iconTheme: IconThemeData(color: onBar),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accentColor,
              Color.lerp(accentColor, Colors.black, 0.12)!,
            ],
          ),
        ),
      ),
      backgroundColor: accentColor,
      actions: [
        ...?actions,
        IconTheme(
          data: IconThemeData(color: onBar),
          child: const ThemeToggleButton(),
        ),
      ],
    );
  }

  static Color contrastOn(Color background) {
    return background.computeLuminance() > 0.45 ? Colors.black87 : Colors.white;
  }
}

/// Standard settings-style screen (reminders, DND, activity monitor).
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
    final theme = Theme.of(context);
    final accent = accentColor ?? AppColors.primaryTeal;
    final onBar = VitalColoredAppBar.contrastOn(accent);
    final fab = floatingActionButton ??
        (onSave != null ? SettingsSaveFab(onPressed: onSave!) : null);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: onBar, size: 20),
          onPressed: onBack ?? () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: onBar,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: -0.2,
          ),
        ),
        foregroundColor: onBar,
        iconTheme: IconThemeData(color: onBar),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accent,
                Color.lerp(accent, Colors.black, 0.12)!,
              ],
            ),
          ),
        ),
        backgroundColor: accent,
        actions: [
          IconTheme(
            data: IconThemeData(color: onBar),
            child: const ThemeToggleButton(),
          ),
        ],
      ),
      body: SafeArea(child: body),
      floatingActionButton: fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

/// Tabbed detail screen with gradient app bar (dial faces, etc.).
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
    return VitalTabDetailScaffold(
      title: title,
      accentColor: accentColor ?? AppColors.primaryTeal,
      tabs: tabs,
      tabViews: tabViews,
      onBack: onBack,
      centerTitle: true,
    );
  }
}

/// Activity description under the app bar.
class DetailActivityHeader extends StatelessWidget {
  const DetailActivityHeader({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DetailInfoBanner(text: label);
  }
}

/// Date navigation + optional chart slot with [RepaintBoundary].
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
    return FixedSectionListView(
      sections: [
        DetailActivityHeader(label: activityLabel),
        DetailDateNavigator(
          dateTitle: dateTitle,
          isNextDisabled: isNextDisabled,
          onPrevious: onPreviousDay,
          onNext: onNextDay,
        ),
        RepaintBoundary(child: chart),
        ...belowChart,
      ],
    );
  }
}

/// Tab bar under a colored app bar (activities, sleep, temperature, dial faces).
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
    final onBar = VitalColoredAppBar.contrastOn(accentColor);
    final theme = Theme.of(context);
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: centerTitle,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: onBar, size: 20),
            onPressed: onBack ?? () => Navigator.of(context).pop(),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: onBar,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: -0.2,
            ),
          ),
          foregroundColor: onBar,
          iconTheme: IconThemeData(color: onBar),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor,
                  Color.lerp(accentColor, const Color(0xFF0F766E), 0.25)!,
                ],
              ),
            ),
          ),
          backgroundColor: accentColor,
          actions: [
            IconTheme(
              data: IconThemeData(color: onBar),
              child: const ThemeToggleButton(),
            ),
          ],
          bottom: buildDwmTabBar(
            context,
            tabs: tabs,
            onTap: onTabTap,
          ),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (header != null) header!,
              Expanded(
                child: TabBarView(
                  physics: tabViewPhysics,
                  children: tabViews,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
