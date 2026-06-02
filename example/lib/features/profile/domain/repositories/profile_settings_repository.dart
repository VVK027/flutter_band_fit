class ProfileSettings {
  const ProfileSettings({
    required this.targetedSteps,
    required this.screenOffTime,
    required this.isCelsius,
    required this.raiseHandWakeUp,
  });

  final String targetedSteps;
  final String screenOffTime;
  final bool isCelsius;
  final bool raiseHandWakeUp;
}

abstract class ProfileSettingsRepository {
  ProfileSettings getSettings();
}
