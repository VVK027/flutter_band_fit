import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/features/health/domain/repositories/health_bind_repository.dart';

class HealthBindRepositoryImpl implements HealthBindRepository {
  HealthBindRepositoryImpl(this._provider);

  final ActivityServiceProvider _provider;

  @override
  String getConnectedDeviceName() => _provider.getDeviceSWName;

  @override
  Future<void> unbindHealthDevice() {
    return _provider.updateUserDeviceConnection(false, false, '', '');
  }
}
