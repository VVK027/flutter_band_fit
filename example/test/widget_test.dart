import 'package:flutter_band_fit_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  testWidgets('BandFitApp builds vitals route', (WidgetTester tester) async {
    await GetStorage.init();
    await tester.pumpWidget(const BandFitApp());
    await tester.pump();
    expect(find.byType(BandFitApp), findsOneWidget);
  });
}
