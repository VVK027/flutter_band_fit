import 'package:flutter_band_fit_app/core/exports/band_exports.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/features/health/data/repositories/health_bind_repository_impl.dart';
import 'package:flutter_band_fit_app/features/health/domain/usecases/is_bound_to_device_usecase.dart';
import 'package:flutter_band_fit_app/features/health/domain/usecases/unbind_health_device_usecase.dart';
import 'package:health/health.dart';

enum HealthBindAppState {
  dataNotFetched,
  fetchingData,
  dataReady,
  noData,
}

class AppleGoogleBindController extends GetxController {
  AppleGoogleBindController({required this.deviceTypeName});

  final String deviceTypeName;
  late final UnbindHealthDeviceUseCase _unbindHealthDeviceUseCase;
  late final IsBoundToDeviceUseCase _isBoundToDeviceUseCase;
  final Health _health = Health();

  final isBounded = false.obs;
  final physicalActStatus = false.obs;
  final locationPermission = false.obs;
  final appState = HealthBindAppState.dataNotFetched.obs;

  final _healthDataList = <HealthDataPoint>[].obs;

  @override
  void onInit() {
    super.onInit();
    final repository = HealthBindRepositoryImpl(Get.find<ActivityServiceProvider>());
    _unbindHealthDeviceUseCase = UnbindHealthDeviceUseCase(repository);
    _isBoundToDeviceUseCase = IsBoundToDeviceUseCase(repository);
    _health.configure();
    initialize();
  }

  Future<bool> askPhysicalGranted() async {
    var permission = await Permission.activityRecognition.status;
    if (permission.isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.activityRecognition.request().isGranted) {
      return true;
    } else {
      permission = await Permission.activityRecognition.request();
    }
    return permission.isGranted;
  }

  Future<bool> locationPermissionsGranted() async {
    var permission = await Permission.location.status;
    if (permission.isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.location.request().isGranted) {
      return true;
    } else {
      permission = await Permission.location.request();
    }
    return permission.isGranted;
  }

  Future<bool> initialize() async {
    final physicalAct = await askPhysicalGranted();
    final locationGranted = await locationPermissionsGranted();
    physicalActStatus.value = physicalAct;
    locationPermission.value = locationGranted;
    return physicalAct && locationGranted;
  }

  Future<void> fetchData() async {
    final endDateTime = DateTime.now();
    final start = endDateTime.subtract(const Duration(days: 10));

    const types = [
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.HEART_RATE,
      HealthDataType.STEPS,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.BODY_TEMPERATURE,
      HealthDataType.SLEEP_IN_BED,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.WORKOUT,
    ];
    final permissions = List<HealthDataAccess>.filled(12, HealthDataAccess.READ);

    const sleepTypes = [
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.SLEEP_IN_BED,
    ];

    appState.value = HealthBindAppState.fetchingData;
    final accessWasGranted =
        await _health.requestAuthorization(types, permissions: permissions);

    if (!accessWasGranted) {
      appState.value = HealthBindAppState.dataNotFetched;
      return;
    }

    try {
      final healthData = await _health.getHealthDataFromTypes(
        types: types,
        startTime: start,
        endTime: endDateTime,
      );
      final healthSleepData = await _health.getHealthDataFromTypes(
        types: sleepTypes,
        startTime: start,
        endTime: endDateTime,
      );

      if (healthData.isNotEmpty) {
        final merged = _health.removeDuplicates([
          ...healthData,
          ...healthSleepData,
        ]);
        _healthDataList.assignAll(merged);
        appState.value = merged.isEmpty
            ? HealthBindAppState.noData
            : HealthBindAppState.dataReady;
      } else {
        appState.value = HealthBindAppState.noData;
      }
    } catch (e) {
      debugPrint('AppleGoogleBindController.fetchData>> $e');
      appState.value = HealthBindAppState.dataNotFetched;
    }
  }

  Future<void> onBindTap() async {
    if (isBounded.value) {
      await _unbindHealthDeviceUseCase();
      isBounded.value = false;
      return;
    }
    if (!physicalActStatus.value || !locationPermission.value) {
      final ok = await initialize();
      if (!ok) return;
    }
    await fetchData();
  }

  void goBack() {
    if (_isBoundToDeviceUseCase(deviceTypeName)) {
      debugPrint('goDashboard_inside_if');
    } else {
      Get.back<void>();
    }
  }
}
