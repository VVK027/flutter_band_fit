import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/core/utils/shared_service.dart';
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
  final onlineLoadError = RxnString();
  final showingCachedDials = false.obs;

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
    var mac = provider.getDeviceMacAddress.replaceAll(':', '').trim();
    var name = provider.getDeviceSWName.trim();
    if (mac.isEmpty) {
      mac = sharedService.getDeviceMacAddress().replaceAll(':', '').trim();
    }
    if (name.isEmpty) {
      name = sharedService.getDeviceName().trim();
    }
    if (mac.isEmpty) {
      return;
    }
    deviceBleName = name.isNotEmpty ? name : 'RB112TRQC';
    deviceMacAddress = mac;
  }

  String get _cacheKey => dialFaceCacheKey(
        bleName: deviceBleName,
        mac: deviceMacAddress,
        dpi: deviceDpi,
        compatible: deviceCompatible,
        shape: deviceShape,
      );

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
          await loadOnlineDials(refresh: true);
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
      onError: (error) => debugPrintI('dialListenersError: $error'),
      onDone: () => debugPrintI('dialListenersOnDone'),
    );
  }

  void _applyDeviceInfoMap(Map<String, dynamic> jsonData) {
    final bleName = jsonData['bleName']?.toString().trim() ?? '';
    final mac = jsonData['mac']?.toString().replaceAll(':', '').trim() ?? '';
    if (bleName.isNotEmpty) {
      deviceBleName = bleName;
    }
    if (mac.isNotEmpty) {
      deviceMacAddress = mac;
    }
    deviceDpi = jsonData['dpi']?.toString() ?? deviceDpi;
    deviceMaxCapacity = jsonData['maxCapacity']?.toString() ?? deviceMaxCapacity;
    deviceShape = jsonData['shape']?.toString() ?? deviceShape;
    deviceCompatible = jsonData['compatible']?.toString() ?? deviceCompatible;
    update();
  }

  bool _restoreCachedOnlineDials() {
    final cached = sharedService.getCachedOnlineDials(_cacheKey);
    final models = dialFacesFromCachedJson(cached);
    if (models.isEmpty) {
      showingCachedDials.value = false;
      return false;
    }
    onlineDials.assignAll(models);
    _onlinePageKey = models.length;
    hasMoreOnline.value = false;
    showingCachedDials.value = true;
    onlineLoadError.value = null;
    return true;
  }

  Future<void> _persistOnlineDials(List<BandDialModel> models) async {
    if (models.isEmpty) {
      return;
    }
    await sharedService.setCachedOnlineDials(
      _cacheKey,
      dialFacesToCachedJson(models),
    );
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
      onlineLoadError.value = null;
      showingCachedDials.value = false;
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
      final response = await request.send().timeout(
        const Duration(seconds: 25),
        onTimeout: () {
          throw Exception('Dial catalog request timed out');
        },
      );
      if (response.statusCode != 200) {
        onlineLoadError.value =
            'Unable to load dial faces (HTTP ${response.statusCode}).';
        if (refresh) {
          _restoreCachedOnlineDials();
        }
        return;
      }
      final responseStr = await response.stream.bytesToString();
      final responseData = json.decode(responseStr) as Map<String, dynamic>;
      final flag = responseData['flag'];
      if (flag is! num || flag <= 0) {
        debugPrintI(
          'loadOnlineDials: API flag=$flag msg=${responseData['msg']} '
          'btname=$deviceBleName mac=$deviceMacAddress dpi=$deviceDpi '
          'compatible=$deviceCompatible shape=$deviceShape',
        );
        if (refresh && onlineDials.isEmpty) {
          onlineLoadError.value = textNoOnlineDialFaces;
          _restoreCachedOnlineDials();
        }
        return;
      }
      final dataList = responseData['list'] as List<dynamic>? ?? [];
      final models = dataList
          .map(
            (e) => dialFaceFromApiJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList();
      onlineDials.addAll(models);
      _onlinePageKey += models.length;
      hasMoreOnline.value = models.length >= _pageSize;
      onlineLoadError.value = null;
      showingCachedDials.value = false;
      if (refresh && models.isNotEmpty) {
        await _persistOnlineDials(onlineDials.toList());
      }
    } catch (e) {
      debugPrintI('loadOnlineDials: $e');
      if (isDialFaceNetworkError(e)) {
        onlineLoadError.value = textDialFacesNeedInternet;
      } else {
        onlineLoadError.value = textNoOnlineDialFaces;
      }
      if (refresh) {
        _restoreCachedOnlineDials();
      }
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
      final response = await http
          .get(Uri.parse(item.resource))
          .timeout(const Duration(seconds: 60));
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
      debugPrintI('downloadAndSyncDial: $e');
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
      debugPrintI('_deleteDownloadedFile: $e');
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
