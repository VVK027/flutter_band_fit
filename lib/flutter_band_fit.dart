
import 'flutter_band_fit_platform_interface.dart';

class FlutterBandFit {
  Future<String?> getPlatformVersion() {
    return FlutterBandFitPlatform.instance.getPlatformVersion();
  }
}
