import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/features/vitals/presentation/dial/dial_face_catalog.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DialFaceDetailsController extends GetxController {
  ActivityServiceProvider get provider => Get.find<ActivityServiceProvider>();

  final onlineDials = <BandDialModel>[].obs;
  final isInitializing = true.obs;
  final isLoadingOnline = false.obs;
  final hasLoadedOnlineOnce = false.obs;
  final hasMoreOnline = true.obs;

  String deviceBleName = '';
  String deviceMacAddress = '';
  String deviceDpi = '240*280';
  String deviceMaxCapacity = '1048576';
  String deviceShape = '1';
  String deviceCompatible = '0';

  String downloadFilePath = '';
  int _onlinePageKey = 0;
  static const int _pageSize = 18;

  @override
  void onInit() {
    super.onInit();
    _applyDefaultDeviceInfo();
    _listenDialEvents();
    Future<void>.delayed(Duration.zero, _initializeDialScreen);
  }

  @override
  void onClose() {
    provider.cancelBPEvents();
    provider.resumeEventListeners();
    provider.stopOnlineDialData();
    super.onClose();
  }

  void _applyDefaultDeviceInfo() {
    final mac = provider.getDeviceMacAddress.replaceAll(':', '');
    if (mac.isEmpty) {
      return;
    }
    deviceBleName = provider.getDeviceSWName.isNotEmpty
        ? provider.getDeviceSWName
        : 'RB112TRQC';
    deviceMacAddress = mac;
  }

  Future<void> _initializeDialScreen() async {
    isInitializing.value = true;
    try {
      provider.pauseEventListeners();
      await provider.readOnlineDialConfig();
      final info = await provider.fetchDeviceDataInfo();
      if (info != null) {
        _applyDeviceInfoMap(info);
      }
      await loadOnlineDials(refresh: true);
    } finally {
      isInitializing.value = false;
    }
  }

  void _listenDialEvents() {
    provider.receiveBPListeners(
      onDataUpdate: (data) async {
        final eventData = data is String
            ? jsonDecode(data) as Map<String, dynamic>
            : Map<String, dynamic>.from(data as Map);
        final result = eventData['result'].toString();
        final status = eventData['status'].toString();
        final jsonData = eventData['data'];

        if (result == BandFitConstants.GET_DEVICE_DATA_INFO &&
            status == BandFitConstants.SC_SUCCESS &&
            jsonData != null) {
          _applyDeviceInfoMap(Map<String, dynamic>.from(jsonData as Map));
        } else if (result == BandFitConstants.WATCH_DIAL_PROGRESS_STATUS &&
            status == BandFitConstants.SC_SUCCESS) {
          final syncProcess = jsonData?['progress'] as int? ?? 0;
          if (provider.getSyncDialProgress < syncProcess) {
            provider.updateDialSyncingProgress(syncProcess);
            if (syncProcess == 100) {
              provider.updateDialSyncUI(false, false, true);
              provider.updateDialSyncingProgress(0);
              await _deleteDownloadedFile();
            }
          } else {
            provider.updateDialSyncingProgress(syncProcess);
            provider.updateDialSyncUI(false, true, false);
          }
        } else if (result == BandFitConstants.PREPARE_SEND_ONLINE_DIAL &&
            status == BandFitConstants.SC_SUCCESS) {
          if (downloadFilePath.isNotEmpty) {
            await Future<void>.delayed(const Duration(milliseconds: 600));
            await syncDownloadedDial();
          }
        } else if (result == BandFitConstants.DEVICE_DISCONNECTED &&
            status == BandFitConstants.SC_SUCCESS) {
          final connected = await provider.checkIsDeviceConnected();
          if (!connected) {
            GlobalMethods.navigatePopBack();
          }
        }
      },
      onError: (error) => debugPrint('dialListenersError: $error'),
      onDone: () => debugPrint('dialListenersOnDone'),
    );
  }

  void _applyDeviceInfoMap(Map<String, dynamic> jsonData) {
    deviceBleName = jsonData['bleName']?.toString() ?? deviceBleName;
    deviceMacAddress = jsonData['mac']?.toString() ?? deviceMacAddress;
    deviceDpi = jsonData['dpi']?.toString() ?? deviceDpi;
    deviceMaxCapacity = jsonData['maxCapacity']?.toString() ?? deviceMaxCapacity;
    deviceShape = jsonData['shape']?.toString() ?? deviceShape;
    deviceCompatible = jsonData['compatible']?.toString() ?? deviceCompatible;
    update();
  }

  Future<void> loadOnlineDials({bool refresh = false}) async {
    if (isLoadingOnline.value) {
      return;
    }
    if (refresh) {
      _onlinePageKey = 0;
      onlineDials.clear();
      hasMoreOnline.value = true;
      hasLoadedOnlineOnce.value = false;
    }
    if (!hasMoreOnline.value) {
      return;
    }

    isLoadingOnline.value = true;
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(dialFaceGetWatchesUrl),
      );
      request.fields.addAll({
        'content':
            '{"compatible":"$deviceCompatible","shape":"$deviceShape","limit":"$_onlinePageKey,18","maxCapacity":"$deviceMaxCapacity",'
            '"appkey":"$dialFaceYcAppKey","language":"en","sort":"1","type":"0","btname":"$deviceBleName","dpi":"$deviceDpi","mac":"$deviceMacAddress"}',
      });
      final response = await request.send();
      if (response.statusCode != 200) {
        return;
      }
      final responseStr = await response.stream.bytesToString();
      final responseData = json.decode(responseStr) as Map<String, dynamic>;
      final flag = responseData['flag'];
      if (flag is! num || flag <= 0) {
        return;
      }
      final dataList = responseData['list'] as List<dynamic>? ?? [];
      final models = dataList
          .map(
            (e) => BandDialModel.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList();
      onlineDials.addAll(models);
      _onlinePageKey += models.length;
      hasMoreOnline.value = models.length >= _pageSize;
    } catch (e) {
      debugPrint('loadOnlineDials: $e');
    } finally {
      isLoadingOnline.value = false;
      hasLoadedOnlineOnce.value = true;
    }
  }

  Future<void> downloadAndSyncDial(BandDialModel item) async {
    provider.updateDialSyncUI(true, false, false);
    try {
      final dir = await getTemporaryDirectory();
      final fileName =
          '${item.title}_${DateTime.now().millisecondsSinceEpoch}.bin';
      final file = File('${dir.path}/$fileName');
      final response = await http.get(Uri.parse(item.resource));
      if (response.statusCode != 200) {
        provider.updateDialSyncUI(false, false, false);
        return;
      }
      final bytes = response.bodyBytes;
      await file.writeAsBytes(bytes, flush: true);
      downloadFilePath = file.path;
      provider.updateDialDownloadProgress(100);
      provider.updateDialSyncUI(false, true, false);
      if (Platform.isIOS) {
        await syncDownloadedDial();
      } else {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        await provider.prepareSendOnlineDialData();
      }
    } catch (e) {
      debugPrint('downloadAndSyncDial: $e');
      provider.updateDialSyncUI(false, false, false);
    }
  }

  Future<void> syncDownloadedDial() async {
    final file = File(downloadFilePath);
    if (!await file.exists()) {
      provider.updateDialSyncUI(false, false, false);
      return;
    }
    provider.updateDialSyncingProgress(0);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    await provider.sendOnlineDialPath(downloadFilePath);
  }

  Future<void> _deleteDownloadedFile() async {
    if (downloadFilePath.isEmpty) {
      return;
    }
    try {
      final file = File(downloadFilePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('_deleteDownloadedFile: $e');
    }
  }

  String formatCapacityKb(String capacity) {
    final value = double.tryParse(capacity);
    if (value == null) {
      return capacity;
    }
    return '${(value / 1024).toStringAsFixed(1)}KB';
  }

  String formatDownloadCount(String downloadNum) {
    final value = double.tryParse(downloadNum);
    if (value == null) {
      return downloadNum;
    }
    return '${((value / 1000) + 1).toStringAsFixed(1)}k+';
  }
}
