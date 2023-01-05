import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_band_fit/flutter_band_fit.dart';
import 'package:flutter_band_fit/flutter_band_fit_platform_interface.dart';
import 'package:flutter_band_fit/flutter_band_fit_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterBandFitPlatform
    with MockPlatformInterfaceMixin
    implements FlutterBandFitPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterBandFitPlatform initialPlatform = FlutterBandFitPlatform.instance;

  test('$MethodChannelFlutterBandFit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterBandFit>());
  });

  test('getPlatformVersion', () async {
    FlutterBandFit flutterBandFitPlugin = FlutterBandFit();
    MockFlutterBandFitPlatform fakePlatform = MockFlutterBandFitPlatform();
    FlutterBandFitPlatform.instance = fakePlatform;

    expect(await flutterBandFitPlugin.getPlatformVersion(), '42');
  });
}
