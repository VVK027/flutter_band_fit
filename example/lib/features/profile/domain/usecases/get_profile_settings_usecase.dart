import 'package:flutter_band_fit_app/features/profile/domain/repositories/profile_settings_repository.dart';

class GetProfileSettingsUseCase {
  GetProfileSettingsUseCase(this._repository);

  final ProfileSettingsRepository _repository;

  ProfileSettings call() => _repository.getSettings();
}
