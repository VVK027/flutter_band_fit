import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/features/profile/domain/repositories/profile_settings_repository.dart';

class ProfileSettingsRepositoryImpl implements ProfileSettingsRepository {
  ProfileSettingsRepositoryImpl(this._provider);

  final ActivityServiceProvider _provider;

  @override
  ProfileSettings getSettings() {
    return ProfileSettings(
      targetedSteps: _provider.getTargetedSteps,
      screenOffTime: _provider.getScreenOffTime,
      isCelsius: _provider.getIsCelsius,
      raiseHandWakeUp: _provider.getRaiseHandWakeUp,
    );
  }
}
