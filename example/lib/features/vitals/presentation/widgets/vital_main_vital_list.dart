import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/core/widgets/vital_data_widget.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/views/details/blood_pressure_details.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/views/details/heart_rate_detail.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/views/details/oxygen_detail.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/views/details/sleep_details.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/views/details/temperature_details.dart';

class VitalMainVitalList extends StatelessWidget {
  const VitalMainVitalList({
    super.key,
    required this.provider,
    required this.isSyncBlocked,
    required this.onSyncBlockedTap,
  });

  final ActivityServiceProvider provider;
  final bool Function() isSyncBlocked;
  final void Function(BuildContext context) onSyncBlockedTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RepaintBoundary(
          child: _VitalTile(
            onTap: () => GlobalMethods.navigateTo(
              HeartRateDetail(
                displayTitle: Activity.heartRate.name,
                activityLabel: Activity.heartRate.textLabel,
              ),
            ),
            child: VitalDataWidget(
              imagePath: 'assets/fit/heart.png',
              title: textHeartRate,
              value: provider.getHRValue,
              units: 'bpm',
              minutes: '',
              time: provider.getHRDateTime,
              accentColor: heartRateColor,
            ),
          ),
        ),
        RepaintBoundary(
          child: _VitalTile(
            onTap: () => GlobalMethods.navigateTo(
              SleepDetails(
                displayTitle: Activity.sleepDuration.name,
                activityLabel: Activity.sleepDuration.textLabel,
              ),
            ),
            child: VitalDataWidget(
              imagePath: 'assets/fit/sleep.png',
              title: textSleepDuration,
              value: provider.getSleepHrs,
              units: '',
              minutes: provider.getSleepMinutes,
              time: provider.getSleepHrsDateTime,
              accentColor: sleepLightColor,
            ),
          ),
        ),
        RepaintBoundary(
          child: _VitalTile(
            onTap: () {
              if (isSyncBlocked()) {
                onSyncBlockedTap(context);
              } else {
                GlobalMethods.navigateTo(
                  BloodPressureDetails(
                    displayTitle: Activity.bp.name,
                    activityLabel: Activity.bp.textLabel,
                  ),
                );
              }
            },
            child: VitalDataWidget(
              imagePath: 'assets/fit/blood_pressure.png',
              title: textBP,
              value: provider.getBloodPressure,
              units: 'mmHg',
              minutes: '',
              time: provider.getBpDateTime,
              accentColor: bpColor,
            ),
          ),
        ),
        RepaintBoundary(
          child: _VitalTile(
            onTap: () {
              if (isSyncBlocked()) {
                onSyncBlockedTap(context);
              } else {
                GlobalMethods.navigateTo(
                  OxygenDetail(
                    displayTitle: Activity.oxygen.name,
                    activityLabel: Activity.oxygen.textLabel,
                  ),
                );
              }
            },
            child: VitalDataWidget(
              imagePath: 'assets/fit/oxygen.png',
              title: textSpo2,
              value: provider.getOxygenValue,
              units: '%',
              minutes: '',
              time: provider.getOxygenDateTime,
              accentColor: oxygenColorDark,
            ),
          ),
        ),
        RepaintBoundary(
          child: _VitalTile(
            onTap: () {
              if (isSyncBlocked()) {
                onSyncBlockedTap(context);
              } else {
                GlobalMethods.navigateTo(
                  TemperatureDetails(
                    displayTitle: Activity.temperature.name,
                    activityLabel: Activity.temperature.textLabel,
                  ),
                );
              }
            },
            child: VitalDataWidget(
              imagePath: 'assets/fit/temperature.png',
              title: textTemperature,
              value: provider.getTemperature,
              units: provider.getIsCelsius ? tempInCelsius : tempInFahrenheit,
              minutes: '',
              time: provider.getTemperatureDateTime,
              accentColor: temperatureColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _VitalTile extends StatelessWidget {
  const _VitalTile({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: child);
  }
}
