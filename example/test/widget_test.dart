import 'package:flutter/services.dart';
import 'package:flutter_band_fit_app/app/bindings/initial_binding.dart';
import 'package:flutter_band_fit_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProviderChannel =
      MethodChannel('plugins.flutter.io/path_provider');

  setUp(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (call) async {
      if (call.method == 'getApplicationDocumentsDirectory') {
        return '/tmp';
      }
      return null;
    });
    await GetStorage.init();
    InitialBinding().dependencies();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
    Get.reset();
  });

  testWidgets('BandFitApp builds vitals route', (WidgetTester tester) async {
    await tester.pumpWidget(const BandFitApp());
    await tester.pump();
    expect(find.byType(BandFitApp), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
  });
}
