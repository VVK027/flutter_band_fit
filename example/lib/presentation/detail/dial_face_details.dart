/*
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_band_fit_app/common/common_imports.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
//import 'package:workmanager/workmanager.dart';
//import 'package:flutter_downloader/flutter_downloader.dart';

const String getWatchesUrl ='https://www.ute-tech.com.cn/ci-yc/index.php/api/client/getWatchs';
const String addWatchUrl ='https://www.ute-tech.com.cn/ci-yc/index.php/api/client/addWatch';
const String ycAppKey ='dcd05f241b65ec7b6af0bbe6f05145c2'; // dcd05f241b65ec7b6af0bbe6f05145c2

List<BandDialModel> recommendedDialList =[
  BandDialModel({"id": "100947", "title": "D2078001","author": "UTE","resource": "https://update.ute-tech.com.cn/watch/all/all/resource/1630920630_7948.bin",
  "preview": "https://update.ute-tech.com.cn/watch/all/all/preview/1630920630_2912.png","dpi": "240*280", "capacity": "364170", "download_num": "51981"}),
];

class DialFaceDetails extends StatefulWidget{
  const DialFaceDetails({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DialFaceDetailsState();
  }
  
}
class DialFaceDetailsState extends State<DialFaceDetails>{
  final ReceivePort _port = ReceivePort();
  int selectedPage = 0;
  //String lang;

  List<Widget> _buildTabs() {
    return <Widget>[
      Tab(
        child: Align(
          alignment: Alignment.center,
           child: Text(Utils.tr(context, 'string_recommend_face')),
        ),
      ),
      Tab(
        child: Align(
          alignment: Alignment.center,
          child: Text(Utils.tr(context, 'string_searchdocty_online')),
        ),

      ),
    ];
  }

  late StateSetter actionState;

  final  _activityServiceProvider = Get.put(ActivityServiceProvider());

  final int _pageSize = 18;
  final PagingController<int, BandDialModel> _pagingController = PagingController(firstPageKey: 0);
  String downloadFilePath ='';

  //int dialDownloadProgress = 0;
  //dial related flags
  //int syncDialProgress = 0;
  bool dialDownloading = false;
  bool dialSyncing = false;
  bool dialSyncDone = false;

  bool statusReconnected = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String deviceBleName = '', deviceMacAddress = '', deviceDpi = '', deviceMaxCapacity = '', deviceShape = '', deviceCompatible = '';

  @override
  void initState() {
  // _activityServiceProvider = Provider.of<ActivityServiceProvider>(context, listen: false);
    //_activityServiceProvider.readOnlineDialConfig();
    super.initState();
    listenResults();
    Future.delayed(Duration.zero, () {
      initializeData();
      _pagingController.addPageRequestListener((pageKey) {
        print('pageKey>>$pageKey');
        _fetchPage(pageKey);
      });
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _unbindBackgroundIsolate();
    _activityServiceProvider.cancelBPEvents();
    _activityServiceProvider.resumeEventListeners();
    _activityServiceProvider.stopOnlineDialData();
    super.dispose();
  }

   */
/*void callbackBandWatch() {
    Workmanager().executeTask((task, inputData) async {
      print('WorkService' + "callbackDispatcher");
      String pathDataStatus = await _activityServiceProvider.sendOnlineDialPath(downloadFilePath);
      debugPrint('pathDataStatus>> $pathDataStatus');
      if(pathDataStatus.isNotEmpty){
        await Future.delayed(const Duration(seconds: 1));
      // Utils.showToastMessage(context, Utils.tr(context, 'string_sync_started'));
      }
      return Future.value(true);
    });
  }*//*


  Future<void> listenResults() async{
    _activityServiceProvider.pauseEventListeners();
    _activityServiceProvider.receiveBPListeners(
      onDataUpdate: (data) async {
        debugPrint("dialListeners>> " + data.toString());
        var eventData = jsonDecode(data);
        String result = eventData['result'].toString();
        String status = eventData['status'].toString();
        var jsonData = eventData['data'];
        if (result == BandFitConstants.GET_DEVICE_DATA_INFO){
          if (status == BandFitConstants.SC_SUCCESS) {
            if (jsonData != null) {

              String bleName = jsonData['bleName'].toString();
              String mac = jsonData['mac'].toString();
              String dpi = jsonData['dpi'].toString();
              String maxCapacity = jsonData['maxCapacity'].toString();
              String shape = jsonData['shape'].toString();
              String compatible = jsonData['compatible'].toString();
              String dialSupport = jsonData['dialSupport'].toString();

              debugPrint('dialSupport>> $dialSupport');

              setState(() {
                deviceBleName = bleName;
                deviceMacAddress = mac;
                deviceDpi = dpi;
                deviceMaxCapacity = maxCapacity;
                deviceShape = shape;
                deviceCompatible = compatible;
              });

              debugPrint('deviceBleName>> $deviceBleName');
              debugPrint('deviceMacAddress>> $deviceMacAddress');
              debugPrint('deviceDpi>> $deviceDpi');
              debugPrint('deviceMaxCapacity>> $deviceMaxCapacity');
              debugPrint('deviceShape>> $deviceShape');
              debugPrint('deviceCompatible>> $deviceCompatible');

            }
            else{
              //set default
              String macAddress = _activityServiceProvider.getDeviceMacAddress;
              debugPrint('macAddress>> $macAddress');
              if (macAddress!=null && macAddress.isNotEmpty) {
                String reviseMacAddress = macAddress.replaceAll(':', '');
                debugPrint('reviseMacAddress>> $reviseMacAddress');
                setState(() {
                  deviceBleName = "RB112TRQC";
                  deviceMacAddress = reviseMacAddress;
                  deviceDpi = "240*280";
                  deviceMaxCapacity = "1048576";
                  deviceShape = "1";
                  deviceCompatible = "0";
                });
              }
            }

          }
        }
        else if(result == BandFitConstants.WATCH_DIAL_PROGRESS_STATUS){
          if (status == BandFitConstants.SC_SUCCESS) {
            int syncProcess = jsonData['progress'] ?? 0;
            debugPrint('syncProcess>> $syncProcess');
            if (_activityServiceProvider.getSyncDialProgress < syncProcess) {
              _activityServiceProvider.updateDialSyncingProgress(syncProcess);
              if (syncProcess > 0 && syncProcess == 100) {
                _activityServiceProvider.updateDialSyncUI(false, false, true);
                _activityServiceProvider.updateDialSyncingProgress(0);
                deleteExistingFile();
              }
            }else  {
              _activityServiceProvider.updateDialSyncingProgress(syncProcess);
              _activityServiceProvider.updateDialSyncUI(false, true, false);
            }
            debugPrint('syncDialProgress>> ${_activityServiceProvider.getSyncDialProgress}');
          }
        }
        else if(result == BandFitConstants.PREPARE_SEND_ONLINE_DIAL){
          if (status == BandFitConstants.SC_SUCCESS) {
            //prepareSendOnlineDialData
            //String watchStatus = await _activityServiceProvider.listenWatchDialProgress();
           // debugPrint('watchStatus>> $watchStatus');
           // if (watchStatus.isNotEmpty) {
              debugPrint('inside status>> $downloadFilePath');
              if (downloadFilePath !=null && downloadFilePath.isNotEmpty) {
                await Future.delayed(const Duration(milliseconds: 600));
                await startSyncingDialData();
              }
            //}
          }
        }
        else if(result == BandFitConstants.SEND_ONLINE_DIAL_FAIL){
          if (status == BandFitConstants.SC_SUCCESS) {
            // dial sync got failure

          }
        }
        else if(result == BandFitConstants.READ_ONLINE_DIAL_CONFIG){
          if (status == BandFitConstants.SC_SUCCESS) {

          }
        }
        else if (result == BandFitConstants.DEVICE_CONNECTED){
          if (status == BandFitConstants.SC_SUCCESS) {
            if (statusReconnected) {
              Navigator.pop(context);
            }
          }
        }
        else if (result == BandFitConstants.DEVICE_DISCONNECTED) {
          if (status == BandFitConstants.SC_SUCCESS) {
            bool alreadyConnected = await _activityServiceProvider.checkIsDeviceConnected();
            debugPrint('alreadyConnected>> $alreadyConnected');
            if (!alreadyConnected) {
              Navigator.pop(context);
              if (mounted) {
                retryConnection(context);
              }
            }else{
              debugPrint('inside_else_disconnect>> $alreadyConnected');
            }
          }
        }
        // else if (result == BandFitConstants.SYNC_BLE_WRITE_SUCCESS) {
        //   if (status == BandFitConstants.SC_SUCCESS) {
        //     await Future.delayed(const Duration(seconds: 1));
        //   }
        // }
        // else if (result == BandFitConstants.SYNC_BLE_WRITE_FAIL) {
        //   if (status == BandFitConstants.SC_SUCCESS) {
        //
        //   }
        // }

        else{
          debugPrint("dialListeners::>> no result found");
           if (mounted) {
            _activityServiceProvider.updateEventResult(eventData, context);
           }
        }
      },
      onError: (error) {
        debugPrint("dialListenersError::>> " + error.toString());
      },
      onDone: () {
        debugPrint("dialListenersOnDone::>> ");
      },
    );
   // _activityServiceProvider.resumeBPListeners();
  }

  Future<void> deleteExistingFile() async {
    try{
      File file = File(downloadFilePath);
      bool fileExists = await file.exists();
      print('deleteExistingFile>> $fileExists');
      if (Platform.isAndroid) {
        if (fileExists) {
          file.delete();
        }
      }
    }catch(exp){
      print('deleteExistingFileExp>> $exp');
    }
  }

  Future<void> initializeData() async {
    await fetchDeviceData();
    //lang = await Utils.getLanguage();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(regDownloadCallback);
  }

  void retryConnection(BuildContext context) {
    GlobalMethods.showAlertDialogWithFunction(context, deviceDisconnected, deviceDisconnectedMsg, reconnectText, () async {
      debugPrint("pressed_ok");
      Navigator.of(context).pop();
      //Utils.showLoading(context, false, title: reconnectingText);
      bool statusReconnect = await _activityServiceProvider.connectDeviceWithMacAddress(context);
      setState(() {
        statusReconnected = statusReconnect;
      });
    });
  }

  Future<void> fetchDeviceData() async{
    String readStatus = await _activityServiceProvider.readOnlineDialConfig();
    debugPrint('readStatus>> $readStatus');
    // await Future.delayed(const Duration(milliseconds: 600));
    // String onlineStatus = await _activityServiceProvider.prepareSendOnlineDialData();
    // debugPrint('fetchOnlineStatus>> $onlineStatus');
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) async {
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      //updateProgress(progress);
      _activityServiceProvider.updateDialDownloadProgress(progress);
      if (status == DownloadTaskStatus.complete) {
       // XsProgressHud.hide();
      // Utils.showToastMessage(context,Utils.tr(context, 'string_download_success'));
        await _activityServiceProvider.updateDialSyncUI(false, true, false);

        if (Platform.isIOS) {
          await startSyncingDialData();
        }else{
          await Future.delayed(const Duration(milliseconds: 500));
          String onlineStatus = await _activityServiceProvider.prepareSendOnlineDialData();
          debugPrint('onlineStatus>> $onlineStatus');
          //await Future.delayed(const Duration(milliseconds: 600));
        }

        //await startSyncingDialData();
      } else if (status == DownloadTaskStatus.failed) {
       // XsProgressHud.hide();
      // Utils.showToastMessage(context, Utils.tr(context, 'string_download_error'));
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void regDownloadCallback(String id, DownloadTaskStatus status, int progress) {
    //if (debug) {
    // debugPrint('Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
   // }
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  void updateProgress(int progress) {
    _activityServiceProvider.updateDialDownloadProgress(progress);
    //if(mounted) {
    //   setState(() {
    //     dialDownloadProgress = progress;
    //   });
   // }
    // }else{
    //   setState(() {
    //     dialDownloadProgress = 0;
    //   });
    // }
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      //lang = await Utils.getLanguage();

      debugPrint('pageKey>> $pageKey >> _pageSize>> $_pageSize >> macAddress $deviceMacAddress >>lang>> en');
      var request = http.MultipartRequest('POST', Uri.parse(getWatchesUrl));
      request.fields.addAll({
        'content': '{"compatible":"$deviceCompatible","shape":"$deviceShape","limit":"$pageKey,18","maxCapacity":"$deviceMaxCapacity",'
                '"appkey":"$ycAppKey","language":"en","sort":"1","type":"0","btname":"$deviceBleName","dpi":"$deviceDpi","mac":"$deviceMacAddress"}'
      });
      debugPrint('request.fields>> ${request.fields}');
      http.StreamedResponse response = await request.send();
      debugPrint('request.response>> ${response}');
      if (response.statusCode == 200) {
        final responseStr = await response.stream.bytesToString();
        debugPrint('responseStr>> $responseStr');
        Map<String, dynamic> responseData = json.decode(responseStr);
        int flag = responseData['flag'];
        String msg = responseData['msg'];
        String count = responseData['count'];
        debugPrint('flag>> $flag');
        debugPrint('msg>> $msg');
        debugPrint('count>> $count');

        if (flag > 0) {
          List<dynamic> dataList = responseData['list'] as List<dynamic>;
          //log('dataList>> $dataList');

          List<BandDialModel> modelList = [];
          for (var element in dataList) {
            modelList.add(BandDialModel(element));
          }
          debugPrint('modelList>> ${modelList.length}');
          final isLastPage = modelList.length < _pageSize;
          if (isLastPage) {
            _pagingController.appendLastPage(modelList);
          } else {
            final nextPageKey = pageKey + modelList.length;
            _pagingController.appendPage(modelList, nextPageKey);
          }
        } else {
          debugPrint('reasonPhrase>> Invalid Flag!!!');
        }
        // setState(() {
        //   dialModelList = modelList;
        // });
      } else {
        debugPrint('reasonPhrase>${response.reasonPhrase}');
      }
    } catch (error) {
      if (mounted) {
        _pagingController.error = error;
      }
    }
  }

  Future<void> startDownloadGetPath(BuildContext context, BandDialModel dialItem) async {
    debugPrint('resourcePath>> ${dialItem.resource}');
    var status = await Permissions.storagePermissionsGranted();
    if (status) {

      var appDir = await Utils.getDownloadFolder();
      String basename = dialItem.title + DateTime.now().toLocal().millisecond.toString();
      String taskId = await FlutterDownloader.enqueue(
        url: dialItem.resource,
        savedDir: appDir,
        fileName: '$basename.bin',
        showNotification: false,
        // show download progress in status bar (for Android)
        openFileFromNotification: false, // click on notification to open downloaded file (for Android)
      );

      debugPrint('taskId>> $taskId');

      String filePath = appDir + '/$basename.bin';
      debugPrint('filePath>> $filePath');
      setState(() {
        downloadFilePath = filePath;
      });
      //await addWatch(dialItem.id);
      //if (Platform.isIOS) {
        // if (downloadFilePath != null && downloadFilePath.isNotEmpty) {
        //   await Future.delayed(const Duration(seconds: 1));
        //   await startSyncingDialData();
        // }
      // }else{
      //   await Future.delayed(const Duration(milliseconds: 600));
      //   String onlineStatus = await _activityServiceProvider.prepareSendOnlineDialData();
      //   debugPrint('onlineStatus>> $onlineStatus');
      //   await Future.delayed(const Duration(milliseconds: 600));
      // }
      // String watchStatus = await _activityServiceProvider.listenWatchDialProgress();
      // debugPrint('watchStatus>> $watchStatus');
      // ByteData bytes = await rootBundle.load('assets/placeholder.png');
    } else {
      if (Platform.isAndroid) {
        //Utils.showPermissionDialog(context, textStoragePermission, true);
      }
    }
  }

  Future<void> startSyncingDialData() async {
    try {
      File file = File(downloadFilePath);
      bool fileExists = await file.exists();
      debugPrint('file.exists()>> $fileExists');
      debugPrint('file.existsSync()>> ${file.existsSync()}');
      if (fileExists) {
        //dynamic byteData = await file.readAsBytes();
        //debugPrint('byteData>> $byteData');
        //String byteDataStatus = await _activityServiceProvider.sendOnlineDialData(byteData);
        //callbackBandWatch();
        _activityServiceProvider.updateDialSyncingProgress(0);
        await Future.delayed(const Duration(milliseconds: 500));
        String pathDataStatus = await _activityServiceProvider.sendOnlineDialPath(downloadFilePath);
        debugPrint('pathDataStatus>> $pathDataStatus');
        if(pathDataStatus.isNotEmpty){
          await Future.delayed(const Duration(seconds: 1));
        // Utils.showToastMessage(context, Utils.tr(context, 'string_sync_started'));
        }
      }else{
      // Utils.showToastMessage(context,Utils.tr(context, 'string_download_not_exist'));
        _activityServiceProvider.updateDialSyncingProgress(0);
        Navigator.of(context).pop();
      }
    }catch(exp){
      debugPrint('fileExp::>> $exp');
    }
  }

  Future<void> addWatch(String id) async {
    var request = http.MultipartRequest('POST', Uri.parse(addWatchUrl));
    request.fields.addAll({
      'content': '{"appkey":"$ycAppKey","btname":"$deviceBleName","id":"$id"}'
    });
    debugPrint('addWatch.fields>> ${request.fields}');
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final responseStr = await response.stream.bytesToString();
      debugPrint('addWatchResponse>> $responseStr');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Consumer<ActivityServiceProvider>(
        builder: (context, provider, childWidget) => Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: darkStepsColor,
            elevation: 2,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            //iconTheme: IconThemeData(color: Colors.white),
            title: Text(textDialFaces, style: const TextStyle(color: Colors.white)),
            actions: const <Widget>[],
            bottom: TabBar(
              //  labelColor: Colors.blueGrey,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)), color: Colors.white),
              tabs: _buildTabs(),
              onTap: (value) {
                //debugPrint('Pressed $value');
                setState(() {
                  selectedPage = value;
                });
              },
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
             */
/* Container(
                margin: EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0),
                //margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                padding: EdgeInsets.all(4.0),
                child: Center(
                    child: Text('', textAlign: TextAlign.center)),
              ),*//*

              const SizedBox(
                height: 8.0,
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    recommendedGridList(context),
                    refreshGridList(context),
                  ],
                ),
              ),
              */
/* SizedBox(
                height: 2.0,
              ),*//*

              //loadBottomView(selectedPage)
              //loadBottomView(selectedPage)
            ],
          ),
        ),
      ),
    );
  }

  Widget recommendedGridList(BuildContext context){
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.95,
        crossAxisSpacing: 8,
        mainAxisSpacing: 16,
        crossAxisCount: 3,
      ),
      shrinkWrap: true,
      itemCount: recommendedDialList.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (BuildContext context, int index) {
        return  GestureDetector(
          onTap: () async {
            // String resourcePath = recommendedDialList[index].resource;
            // String title = recommendedDialList[index].title;
            // await startDownloadGetPath(context, recommendedDialList[index]);
            await _activityServiceProvider.updateDialSyncUI(false, false, false);
            showDialDetailsDialog(recommendedDialList[index]).then((value) async {
              debugPrint('returnValue==$value');
              await Future.delayed(const Duration(seconds: 2));
              if (value!=null && value) {
                Navigator.of(context).pop();
              }
            });
          },
          child: CachedNetworkImage(
            imageUrl: recommendedDialList[index].preview,
            imageBuilder: (context, imageProvider) => Container(
              margin: const EdgeInsets.all(4.0),
              // padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                  // colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget refreshGridList(BuildContext context){
    return  CustomScrollView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
     // center: ,
      slivers: [
        PagedSliverGrid<int, BandDialModel>(
          pagingController: _pagingController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.95,
            crossAxisSpacing: 8,
            mainAxisSpacing: 16,
            crossAxisCount: 3,
          ),
          showNewPageProgressIndicatorAsGridChild: false,
          showNewPageErrorIndicatorAsGridChild: false,
          showNoMoreItemsIndicatorAsGridChild: false,
          builderDelegate: PagedChildBuilderDelegate<BandDialModel>(
            itemBuilder: (context, item, index) => GestureDetector(
              onTap: () async {
               // String resourcePath = item.resource;
               // String title = item.title;
               // await startDownloadGetPath(context,item);
                await _activityServiceProvider.updateDialSyncUI(false, false, false);
                showDialDetailsDialog(item).then((value) async {
                  debugPrint('returnValue==$value');
                  await Future.delayed(const Duration(seconds: 2));
                  if (value!=null && value) {
                    Navigator.of(context).pop();
                  }
                });
              },
              child: CachedNetworkImage(
                imageUrl: item.preview,
                imageBuilder: (context, imageProvider) => Container(
                  margin: const EdgeInsets.all(4.0),
                 // padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
                      // colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
    */
/*return PagedListView<int, BandDialModel>.separated(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<BandDialModel>(
        animateTransitions: true,
        itemBuilder: (context, item, index) => ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: CachedNetworkImageProvider(item.preview),
          ),
          title: Text(item.title),
        ),
      ),
      separatorBuilder: (context, index) => const Divider(),
    );*//*

  }

  Future<dynamic> showDialDetailsDialog(BandDialModel item) {
   String capacitySize = (double.tryParse(item.capacity)!/1024).toStringAsFixed(1);
   String downloadSize = ((double.tryParse(item.download_num)!/1000)+1).toStringAsFixed(1);

   //final provider = Provider.of<ActivityServiceProvider>(context, listen: false);
  // debugPrint('providerProgress>> ${_activityServiceProvider.getSyncDialProgress}');
  // debugPrint('downloadProgress1234>> ${_activityServiceProvider.getDialDownloadProgress}');
   final dialogContextCompleter = Completer();

   showDialog(
      context: _scaffoldKey.currentContext,
      barrierDismissible: false,
      builder: (context) =>  Consumer<ActivityServiceProvider>(
        builder: (context, provider, _) {
          debugPrint('provider.isDialSyncDone>> ${provider.isDialSyncDone}');
          if (provider.isDialSyncDone) {
            debugPrint('dialogContextCompleter.isCompleted>> ${dialogContextCompleter.isCompleted}');
            if(!dialogContextCompleter.isCompleted){
              dialogContextCompleter.complete(true);
            }
          }
          return  Dialog(
            elevation: 4.0,
            backgroundColor: Colors.white,
            child: StatefulBuilder(
              builder: (context, StateSetter state) {
                actionState = state;
                return  SizedBox(
                  width: double.infinity,
                  //height: MediaQuery.of(context).size.height * 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 4.0, left: 4.0, right: 4.0),
                        child: Text(item.title,  style: const TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600), softWrap: true,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0, bottom: 4.0, left: 4.0, right: 4.0),
                        child: Text("${capacitySize}KB   ${downloadSize}k+ ${textDownloads}",style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300), softWrap: true,),
                      ),
                      const Divider( thickness: 1.2),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CachedNetworkImage(
                        imageUrl: item.preview,
                        width: 230,
                        height: 230,
                        */
/* imageBuilder: (context, imageProvider) => Container(
                      margin: EdgeInsets.all(8.0),
                      // padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                          // colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn),
                        ),
                      ),
                    ),*//*

                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      SizedBox(
                        height: 70.0,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: provider.isDialSyncDone? Colors.lightGreen :Colors.blueAccent[200],
                              // onPrimary: Colors.blue,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                              )
                          ),
                          child: (provider.isDialDownloading || provider.isDialSyncing || provider.isDialSyncDone)? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const SizedBox(width: 12),
                              (provider.isDialDownloading || provider.isDialSyncing)? const CircularProgressIndicator(color: Colors.white):const Icon(Icons.check_circle_outline, color: Colors.white, size: 30),
                              //Icon(Icons.done,size: 52,color: Colors.white),
                              const SizedBox(width: 14),
                              Expanded(child: Text(provider.isDialDownloading?'${textDownloadingFile}...(${provider.getDialDownloadProgress})':provider.isDialSyncDone? textSyncDoneSuccess:'${textSynchronizing}..(${provider.getSyncDialProgress})',
                                  maxLines:1,style: const TextStyle(color: Colors.white, fontSize: 16.0)),)
                            ],
                          ): Text(textSynchronousDial, maxLines: 1, style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          ),
                          onPressed: () async {
                            if (provider.isDialSyncDone) {
                              Navigator.of(context).pop();
                            }else{
                              if (!provider.isDialDownloading && !provider.isDialSyncing) {
                                await provider.updateDialSyncUI(true, false, false);
                                await startDownloadGetPath(context, item);
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
   return dialogContextCompleter.future;
  }
}*/
