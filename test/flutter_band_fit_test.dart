import 'package:flutter/services.dart';
import 'package:flutter_band_fit/flutter_band_fit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const methodChannel = MethodChannel(BandFitConstants.BAND_METHOD_CHANNEL);

  late FlutterBandFit bandFit;

  setUp(() {
    bandFit = FlutterBandFit.private(
      methodChannel,
      const EventChannel(BandFitConstants.BAND_EVENT_CHANNEL),
      const EventChannel(BandFitConstants.BAND_BP_TEST_CHANNEL),
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, null);
    bandFit.dispose();
  });

  group('FlutterBandFit method channel', () {
    test('initializeDeviceConnection returns trimmed platform string', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannel, (call) async {
        if (call.method == BandFitConstants.DEVICE_INITIALIZE) {
          return '  ready  ';
        }
        return null;
      });

      expect(await bandFit.initializeDeviceConnection(), 'ready');
    });

    test('connectLastDeviceAddress coerces null to false', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannel, (call) async {
        if (call.method == BandFitConstants.CONNECT_LAST_DEVICE) {
          return null;
        }
        return null;
      });

      expect(await bandFit.connectLastDeviceAddress(), isFalse);
    });

    test('startSearchingDevices maps device list from response body', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannel, (call) async {
        if (call.method == BandFitConstants.START_DEVICE_SEARCH) {
          return <String, dynamic>{
            'data': <Map<String, String>>[
              <String, String>{
                'name': 'Band One',
                'address': '11:22:33',
                'identifier': 'id-1',
              },
            ],
          };
        }
        return null;
      });

      final devices = await bandFit.startSearchingDevices();
      expect(devices, hasLength(1));
      expect(devices.first.name, 'Band One');
      expect(devices.first.address, '11:22:33');
      expect(devices.first.identifier, 'id-1');
    });

    test('startSearchingDevices returns empty list when data is not a list',
        () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannel, (call) async {
        if (call.method == BandFitConstants.START_DEVICE_SEARCH) {
          return <String, dynamic>{'data': 'invalid'};
        }
        return null;
      });

      expect(await bandFit.startSearchingDevices(), isEmpty);
    });

    test('fetchDeviceDataInfo decodes JSON string payloads', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannel, (call) async {
        if (call.method == BandFitConstants.GET_DEVICE_DATA_INFO) {
          return '{"battery":"80"}';
        }
        return null;
      });

      final info = await bandFit.fetchDeviceDataInfo();
      expect(info['battery'], '80');
    });

    test('fetchOverAllByDate wraps failure status without data map', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannel, (call) async {
        if (call.method == BandFitConstants.FETCH_OVERALL_BY_DATE) {
          return BandFitConstants.SC_FAILURE;
        }
        return null;
      });

      final result = await bandFit.fetchOverAllByDate('2024-06-01');
      expect(result['status'], BandFitConstants.SC_FAILURE);
      expect(result['data'], '');
    });

    test('fetchOverAllByDate wraps successful map payloads', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannel, (call) async {
        if (call.method == BandFitConstants.FETCH_OVERALL_BY_DATE) {
          return <String, dynamic>{'steps': 1000};
        }
        return null;
      });

      final result = await bandFit.fetchOverAllByDate('2024-06-01');
      expect(result['status'], BandFitConstants.SC_SUCCESS);
      expect(result['data'], isA<Map<String, dynamic>>());
      expect((result['data'] as Map)['steps'], 1000);
    });

    test('connectDevice forwards bind arguments to the platform', () async {
      Map<String, dynamic>? bindArgs;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannel, (call) async {
        if (call.method == BandFitConstants.BIND_DEVICE) {
          final raw = call.arguments;
          if (raw is Map) {
            bindArgs = raw.map(
              (key, value) => MapEntry(key.toString(), value),
            );
          }
          return true;
        }
        return null;
      });

      const device = BandDeviceModel(
        name: 'UTE',
        address: 'AA:BB',
        identifier: 'id',
      );
      expect(await bandFit.connectDevice(device), isTrue);
      expect(bindArgs?['name'], 'UTE');
      expect(bindArgs?['address'], 'AA:BB');
    });

    test('set24HeartRate sends enable flag as string', () async {
      Map<String, String>? params;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannel, (call) async {
        if (call.method == BandFitConstants.SET_24_HEART_RATE) {
          params = (call.arguments as Map).cast<String, String>();
          return 'ok';
        }
        return null;
      });

      await bandFit.set24HeartRate(true);
      expect(params?['enable'], 'true');
    });

    test('checkConnectionStatus aliases checkConectionStatus', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannel, (call) async {
        if (call.method == BandFitConstants.CHECK_CONNECTION_STATUS) {
          return true;
        }
        return null;
      });

      expect(await bandFit.checkConnectionStatus(), isTrue);
      expect(await bandFit.checkConectionStatus(), isTrue);
    });
  });
}
