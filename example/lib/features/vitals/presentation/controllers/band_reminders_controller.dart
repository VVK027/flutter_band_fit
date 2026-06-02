import 'package:flutter_band_fit_app/core/exports/band_exports.dart';

class BandRemindersController extends GetxController {
  final selectSecondaryReminder = false.obs;
  final selectSmsReminder = false.obs;
  final selectCallReminder = false.obs;

  void toggleSecondary() => selectSecondaryReminder.toggle();
  void toggleSms() => selectSmsReminder.toggle();
  void toggleCall() => selectCallReminder.toggle();
}
