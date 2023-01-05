import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_band_fit_platform_interface.dart';

/// An implementation of [FlutterBandFitPlatform] that uses method channels.
class MethodChannelFlutterBandFit extends FlutterBandFitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_band_fit');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
