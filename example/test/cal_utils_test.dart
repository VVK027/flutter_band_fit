import 'package:flutter_band_fit_app/core/utils/cal_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('cal_utils', () {
    test('getDistanceWithSteps formats distance from step count', () {
      expect(getDistanceWithSteps(1000), '0.76');
    });

    test('getAgeFromDateOfBirth subtracts years with month/day adjustment', () {
      final now = DateTime.now();
      final dob = DateTime(now.year - 30, now.month, now.day);
      expect(getAgeFromDateOfBirth(dob), 30);
    });

    test('getAgeFromDateOfBirth rejects future birth dates', () {
      final future = DateTime.now().add(const Duration(days: 1));
      expect(() => getAgeFromDateOfBirth(future), throwsA(isA<String>()));
    });

    test('getMetForActivity returns tiered MET values by speed', () {
      expect(getMetForActivity(1.5), 2.0);
      expect(getMetForActivity(2.0), 2.8);
      expect(getMetForActivity(4.2), 7.0);
      expect(getMetForActivity(6.0), 9.8);
    });

    test('harrisBenedictRmr differs by gender', () {
      final male = harrisBenedictRmr(Gender.MALE.name, 70, 30, 175);
      final female = harrisBenedictRmr(Gender.FEMALE.name, 70, 30, 175);
      expect(male, isNot(female));
      expect(male, greaterThan(0));
      expect(female, greaterThan(0));
    });

    test('unit conversions round-trip expected scales', () {
      expect(centimeterToMeters(100), 1.0);
      expect(meterToCentimer(1.0), 100.0);
      expect(kilometersToMiles(1), closeTo(0.62137, 0.00001));
      expect(secondsToHours(3600), 1.0);
    });
  });
}
