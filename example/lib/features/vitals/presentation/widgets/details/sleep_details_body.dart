import 'package:flutter_band_fit_app/core/exports/vitals_imports.dart';
import 'package:flutter_band_fit_app/core/constants/widget_keys.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/sleep_details_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/details/sleep_details_tabs.dart';

/// Sleep detail screen with day / week / month tabs and stage breakdown charts.
class SleepDetailsBody extends GetView<SleepDetailsController> {
  const SleepDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return VitalTabDetailScaffold(
      key: const Key(WidgetKeys.vitalTabDetailScaffold),
      title: controller.displayTitle,
      accentColor: sleepLightColor,
      onBack: () => Get.back<void>(),
      onTabTap: (index) {
        controller.selectedPage = index;
        controller.notifyChartTab();
      },
      tabs: buildDWMTabs(),
      tabViewPhysics: const NeverScrollableScrollPhysics(),
      header: DetailActivityHeader(
          key: const Key(WidgetKeys.detailActivityHeader),
          label: controller.activityLabel),
      centerTitle: true,
      tabViews: const [
        SleepDayTab(),
        SleepWeekTab(),
        SleepMonthTab(),
      ],
    );
  }
}
