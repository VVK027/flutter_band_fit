import 'package:flutter_band_fit/flutter_band_fit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BandFitConstants channel names', () {
    test('exposes stable method and event channel identifiers', () {
      expect(BandFitConstants.BAND_METHOD_CHANNEL, 'smartMethodChannel');
      expect(BandFitConstants.BAND_EVENT_CHANNEL, 'smartEventChannel');
      expect(BandFitConstants.BAND_BP_TEST_CHANNEL, 'smartBPTestChannel');
    });
  });

  group('spirometer enum extensions', () {
    test('MeasureMode.name matches index order', () {
      expect(MeasureMode.ALL.name, 'ALL');
      expect(MeasureMode.MV.name, 'MV');
    });

    test('Smoke, Sex, and Standard extensions expose expected names', () {
      expect(Smoke.NOSMOKE.name, 'NOSMOKE');
      expect(Sex.FEMALE.name, 'FEMALE');
      expect(Standard.USA.name, 'USA');
    });
  });
}
