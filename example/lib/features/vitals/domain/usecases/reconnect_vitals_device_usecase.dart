import 'package:flutter/widgets.dart';
import 'package:flutter_band_fit_app/features/vitals/domain/repositories/vitals_sync_repository.dart';

class ReconnectVitalsDeviceUseCase {
  ReconnectVitalsDeviceUseCase(this._repository);

  final VitalsSyncRepository _repository;

  Future<bool> call(BuildContext context) {
    return _repository.reconnectWithSavedDevice(context);
  }
}
