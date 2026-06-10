import 'package:flutter_band_fit_app/core/exports/vitals_imports.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/controllers/activities_details_controller.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/widgets/details/activities_details_tabs.dart';

class ActivitiesDetailsBody extends GetView<ActivitiesDetailsController> {
  const ActivitiesDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return VitalTabDetailScaffold(
      title: textPhysicalActivities,
      accentColor: darkStepsColor,
      onBack: () => Get.back<void>(),
      onTabTap: (index) {
        controller.selectedPage = index;
        controller.notifyChartTab();
      },
      tabs: buildDWMTabs(),
      tabViewPhysics: const NeverScrollableScrollPhysics(),
      header: DetailActivityHeader(label: controller.activityLabel),
      tabViews: const [
        ActivitiesDayTab(),
        ActivitiesWeekTab(),
        ActivitiesMonthTab(),
      ],
    );
  }
}
