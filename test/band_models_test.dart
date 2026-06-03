import 'package:flutter_band_fit/flutter_band_fit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BandDeviceModel', () {
    test('round-trips through fromJson and toJson', () {
      const json = <String, dynamic>{
        'name': 'UTE Band',
        'address': 'AA:BB:CC:DD:EE:FF',
        'identifier': 'band-1',
      };
      final model = BandDeviceModel.fromJson(json);
      expect(model.toJson(), json);
    });
  });

  group('BandSleepModel', () {
    test('round-trips through fromJson and toJson', () {
      const json = <String, dynamic>{
        'calender': '2024-01-01',
        'state': 'deep',
        'startTime': '23:00',
        'endTime': '07:00',
        'startTimeNum': '1',
        'endTimeNum': '2',
        'startDateTime': '2024-01-01 23:00',
        'endDateTime': '2024-01-02 07:00',
      };
      expect(BandSleepModel.fromJson(json).toJson(), json);
    });
  });

  group('BandHRModel', () {
    test('round-trips through fromJson and toJson', () {
      const json = <String, dynamic>{
        'calender': '2024-01-01',
        'time': '12:00',
        'dateTime': '2024-01-01 12:00',
        'rate': '72',
      };
      expect(BandHRModel.fromJson(json).toJson(), json);
    });
  });

  group('BandBPModel', () {
    test('round-trips through fromJson and toJson', () {
      const json = <String, dynamic>{
        'calender': '2024-01-01',
        'time': '12:00',
        'dateTime': '2024-01-01 12:00',
        'high': '120',
        'low': '80',
      };
      expect(BandBPModel.fromJson(json).toJson(), json);
    });
  });

  group('BandStepsModel', () {
    test('round-trips through fromJson and toJson', () {
      const json = <String, dynamic>{'step': '5000', 'time': '18:00'};
      expect(BandStepsModel.fromJson(json).toJson(), json);
    });
  });

  group('BandStepsDataModel', () {
    test('round-trips through fromJson and toJson', () {
      const json = <String, dynamic>{
        'calender': '2024-01-01',
        'time': '12:00',
        'dateTime': '2024-01-01 12:00',
        'step': '1000',
        'distance': '0.8',
        'calories': '50',
      };
      expect(BandStepsDataModel.fromJson(json).toJson(), json);
    });
  });

  group('BandOxygenModel', () {
    test('round-trips through fromJson and toJson', () {
      const json = <String, dynamic>{
        'calender': '2024-01-01',
        'time': '12:00',
        'value': '98',
      };
      expect(BandOxygenModel.fromJson(json).toJson(), json);
    });
  });

  group('BandTempModel', () {
    test('round-trips through fromJson and toJson', () {
      const json = <String, dynamic>{
        'calender': '2024-01-01',
        'time': '12:00',
        'dateTime': '2024-01-01 12:00',
        'inCelsius': '36.5',
        'inFahrenheit': '97.7',
      };
      expect(BandTempModel.fromJson(json).toJson(), json);
    });
  });

  group('BandDialModel', () {
    test('round-trips through fromJson and toJson', () {
      const json = <String, dynamic>{
        'id': '1',
        'title': 'Dial',
        'author': 'UTE',
        'resource': 'url',
        'preview': 'preview',
        'dpi': '240',
        'capacity': '100',
        'download_num': '10',
      };
      final model = BandDialModel.fromJson(json);
      expect(model.downloadNum, '10');
      expect(model.toJson(), json);
    });
  });
}
