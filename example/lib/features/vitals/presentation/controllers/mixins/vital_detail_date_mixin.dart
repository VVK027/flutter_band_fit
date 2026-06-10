import 'package:flutter_band_fit_app/core/exports/band_exports.dart';

/// Shared day navigation for vitals detail screens.
mixin VitalDetailDateMixin on GetxController {
  final DateTime todayTime = DateTime.now();
  final currentDateTime = DateTime.now().obs;
  final dateTitle = ''.obs;
  final isNextDisable = true.obs;

  String formatDetailDayTitle(DateTime dateTime) {
    final firstDay = dateTime.day.toString();
    final month = calMonths[dateTime.month - 1];
    final week = calWeeks[dateTime.weekday - 1];
    return '$firstDay, $month ($week)';
  }

  void updateDateHeader(DateTime dateTime) {
    dateTitle.value = formatDetailDayTitle(dateTime);
  }

  void syncSelectedDay(DateTime dateTime) {
    currentDateTime.value = dateTime;
    isNextDisable.value = isSameCalendarDay(todayTime, dateTime);
    updateDateHeader(dateTime);
  }

  bool isSameCalendarDay(DateTime a, DateTime b) {
    return a.toString().substring(0, 10).trim() ==
        b.toString().substring(0, 10).trim();
  }

  Future<void> navigatePrevious(
      Future<void> Function(DateTime day) loadDay) async {
    final time = GlobalMethods.getOneDayBackward(currentDateTime.value);
    isNextDisable.value = false;
    currentDateTime.value = time;
    await loadDay(time);
  }

  Future<void> navigateNext(Future<void> Function(DateTime day) loadDay) async {
    if (isNextDisable.value) return;
    final next = GlobalMethods.getOneDayForward(currentDateTime.value);
    if (isSameCalendarDay(todayTime, next)) {
      isNextDisable.value = true;
    }
    currentDateTime.value = next;
    await loadDay(next);
  }

  Future<void> pickCalendarDay(
    BuildContext context,
    Future<void> Function(DateTime day) loadDay,
  ) async {
    final picked = await GlobalMethods.selectCalenderDate(
      context,
      currentDateTime.value,
    );
    syncSelectedDay(picked);
    await loadDay(picked);
  }
}
