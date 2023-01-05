import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_band_fit_method_channel.dart';

abstract class FlutterBandFitPlatform extends PlatformInterface {
  /// Constructs a FlutterBandFitPlatform.
  FlutterBandFitPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterBandFitPlatform _instance = MethodChannelFlutterBandFit();

  /// The default instance of [FlutterBandFitPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterBandFit].
  static FlutterBandFitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterBandFitPlatform] when
  /// they register themselves.
  static set instance(FlutterBandFitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
