import 'package:flutter_band_fit_app/core/exports/vitals_imports.dart';
import 'package:flutter_band_fit_app/core/constants/widget_keys.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/activities_details_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/details/activities_details_tabs.dart';

class ActivitiesDetailsBody extends GetView<ActivitiesDetailsController> {
  const ActivitiesDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return VitalTabDetailScaffold(
      key: const Key(WidgetKeys.vitalTabDetailScaffold),
      title: textPhysicalActivities,
      accentColor: darkStepsColor,
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
      tabViews: const [
        ActivitiesDayTab(
          key: Key(WidgetKeys.activitiesDayTab),
        ),
        ActivitiesWeekTab(
          key: Key(WidgetKeys.activitiesWeekTab),
        ),
        ActivitiesMonthTab(
          key: Key(WidgetKeys.activitiesMonthTab),
        ),
      ],
    );
  }
}
