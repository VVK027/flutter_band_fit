abstract class HealthBindRepository {
  Future<void> unbindHealthDevice();

  String getConnectedDeviceName();
}
