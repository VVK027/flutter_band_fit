import 'package:flutter/cupertino.dart';
import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:get/get.dart';

class DoNotDisturb extends StatefulWidget{
  const DoNotDisturb({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DoNotDisturbState();
  }

}
class DoNotDisturbState extends State<DoNotDisturb>{

  bool enableMessageOn = false;
  bool enableMotorOn = false;
  //bool enableDoNotDisturb = false;

  final  _activityServiceProvider = Get.put(ActivityServiceProvider());

  TimeOfDay _startTime = const TimeOfDay(hour: 22, minute: 00);
  TimeOfDay _endTime = const TimeOfDay(hour: 08, minute: 00);


  @override
  void initState() {
    // _activityServiceProvider = Provider.of<ActivityServiceProvider>(context, listen: false);
    //_activityServiceProvider.fetchAllJudgement();
    super.initState();

    assignValues();
  }

  Future<void> assignValues() async{
    await _activityServiceProvider.callQuickSwitchSettingStatus();
    // await Future.delayed(const Duration(seconds: 1));
    setState(() {
      enableMessageOn = _activityServiceProvider.getMessagesOnEnabled;
      enableMotorOn = _activityServiceProvider.getMotorVibrateEnabled;
      //enableDoNotDisturb = _activityServiceProvider.getDndEnabled;
    });

    if (_activityServiceProvider.getDndEnabled && _activityServiceProvider.getDNDEnabledTime.isNotEmpty) {
      String enabledTime = _activityServiceProvider.getDNDEnabledTime;
      List<String> times = enabledTime.split(':');
      debugPrint('times>> $times');
      if(times.isNotEmpty){
        _startTime = TimeOfDay(hour: int.parse(times[0]),minute: int.parse(times[1]));
        _endTime = TimeOfDay(hour: int.parse(times[2]),minute: int.parse(times[3]));
      }
    }
    setState(() { });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetBuilder<ActivityServiceProvider>(
        builder: (provider) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              //title: Text('Devices and Accounts'),
              backgroundColor: Colors.white,
              // elevation: 0,
              title: const Text(textDoNotDisturb,//'Devices and Accounts',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
                onPressed: () {
                  //Navigator.of(context).pop();
                  GlobalMethods.navigatePopBack();
                },
              ),
              actions: const [],
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                    padding: const EdgeInsets.all(8.0),
                    child: const Center(child: Text(textDoNotDisturbLabel, textAlign: TextAlign.center, style: TextStyle( fontSize: 12),)),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      // setState(() {
                      //   enableDoNotDisturb = !enableDoNotDisturb;
                      // });
                      provider.updateOnlyDoNotDisturbEnable(!provider.getDndEnabled);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Text(textDoNotDisturb, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                // value: provider.getDndEnabled ?true: enableDoNotDisturb,
                                value: provider.getDndEnabled,
                                onChanged: (bool value) {
                                  provider.updateOnlyDoNotDisturbEnable(value);
                                  // setState(() {
                                  //   enableDoNotDisturb = value;
                                  // });
                                },
                              ),
                            ),
                          ],
                        ),
                        const Flexible(
                          fit: FlexFit.loose ,
                          child: Text(textDNDTimeMsg, style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  const Divider(// thickness: 1.0,
                  ),
                  GestureDetector(
                    onTap: () async{
                      //if (provider.getDndEnabled ? true: enableDoNotDisturb) {
                      if (provider.getDndEnabled) {
                        await _selectStartTime(helpText: textSelectStartTime, confirmText: 'Ok',cancelText: 'Cancel');
                      }
                    },
                    //onTap: enableDoNotDisturb ?_selectStartTime() :null,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(textStartTime, style: TextStyle(fontSize: 16, color: provider.getDndEnabled? Colors.black : Colors.grey[400])),
                          ),
                          Text(_startTime.format(context),//_startTime.toString().trim().split(' ')[0],
                              style: TextStyle(fontSize: 16, color: provider.getDndEnabled? Colors.blueAccent:Colors.grey[400])),
                        ],
                      ),
                    ),
                  ),
                  const Divider(// thickness: 1.0,
                  ),
                  GestureDetector(
                    onTap: () async{
                      //if (provider.getDndEnabled ?true: enableDoNotDisturb) {
                      if (provider.getDndEnabled) {
                        await _selectEndTime(helpText: textSelectEndTime, confirmText: okText,cancelText: cancelText);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(textEndTime, style: TextStyle(fontSize: 16, color: provider.getDndEnabled? Colors.black : Colors.grey[400])),
                          ),
                          Text(_endTime.format(context), style: TextStyle(fontSize: 16, color:provider.getDndEnabled ? Colors.blueAccent:Colors.grey[400])),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1.0,
                  ),
                  const Text(textDNDAdditionalMsg, style: TextStyle(fontSize: 12) ),
                  const Divider(// thickness: 1.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        enableMessageOn = !enableMessageOn;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Text(textDNDDisableReminder, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: enableMessageOn,
                                onChanged: (bool value) {
                                  setState(() {
                                    enableMessageOn = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const Flexible(
                          fit: FlexFit.loose ,
                          child: Text(textDNDDisableReminderMsg, style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        enableMotorOn = !enableMotorOn;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Expanded(
                              child: Text(textDNDDisableBandVibration, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: enableMotorOn,
                                onChanged: (bool value) {
                                  setState(() {
                                    enableMotorOn = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const Flexible(
                          fit: FlexFit.loose ,
                          child: Text(textDNDDisableBandVibrationMsg, style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 21.0,
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              mini: true,
              onPressed: () async {
                bool isConnected = await _activityServiceProvider.checkIsDeviceConnected();
                if (isConnected) {
                  //if (enableDoNotDisturb) {
                  if (provider.getDndEnabled) {
                    // is dnd is enabled or disabled
                    // get the from and end hours/min
                    debugPrint('_startTime.hour>>${ _startTime.hour}');
                    debugPrint('_startTime.minute>>${_startTime.minute}');
                    debugPrint('_endTime.hour>>${ _endTime.hour}');
                    debugPrint('_endTime.minute>>${_endTime.minute}');

                    //debugPrint('_startTime.hourOfPeriod>>${_startTime.period.index}');
                    //debugPrint('_endTime.hourOfPeriod>>${_endTime.periodOffset}');
                    //period.index == 0 (AM), period.index ==1 (PM)
                    if(_startTime.period.index == _endTime.period.index){
                      // debugPrint('_startTime.hour11>>${ _startTime.hour}');
                      // debugPrint('_endTime.hour11>>${ _endTime.hour}');

                      if (_startTime.hour == _endTime.hour) {
                        GlobalMethods.showAlertDialog(context, textSelSameTimings, textSelSameTimingsMsg);
                      }if(_startTime.hour > _endTime.hour){
                        GlobalMethods.showAlertDialog(context, textInvalidTimePeriod, textInvalidTimePeriodMsg);
                      }
                    }
                  }

                  await  _activityServiceProvider.setDoNotDisturbEnable(isMessageOn: enableMessageOn, isMotorOn: enableMotorOn,
                      disturbTimeSwitch:  provider.getDndEnabled, fromHr: _startTime.hour.toString(), fromMin: _startTime.minute.toString(), toHour: _endTime.hour.toString(), toMin: _endTime.minute.toString());
                  updateStatusResult();
                }else{
                  retryConnection(context);
                }
              },
              tooltip: textSaveContinue,
              child: const Icon(Icons.done),
            ),
          );
        }
    );
  }

  void updateStatusResult(){
    GlobalMethods.showAlertDialogWithFunction(context,textDNDStatus,textDNDStatusMsg, okText, () async {
      //Navigator.of(context).pop();
      //Navigator.pop(context);
      GlobalMethods.navigatePopBack();
    });
  }

  void retryConnection(BuildContext context) {
    GlobalMethods.showAlertDialogWithFunction(context, deviceDisconnected,
        deviceDisconnectedMsg, reconnectText, () async {
          //debugPrint("pressed_ok");
          //Navigator.of(context).pop();
          GlobalMethods.navigatePopBack();
          //Utils.showWaiting(context, false);
          bool statusReconnect = await _activityServiceProvider.connectDeviceWithMacAddress(context);
          debugPrint('statusReconnect>>$statusReconnect');
          if (statusReconnect) {
            // Navigator.of(context).pop();
            GlobalMethods.navigatePopBack();
          }
        });
  }

  Future<void> _selectStartTime({String? helpText, String? confirmText, String? cancelText}) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: helpText,
      confirmText: confirmText,
      cancelText: cancelText,
    );
    if (newTime != null) {
      setState(() {
        _startTime = newTime;
      });
    }
  }

  Future<void> _selectEndTime({String? helpText, String? confirmText, String? cancelText}) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _endTime,
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: helpText,
      confirmText: confirmText,
      cancelText: cancelText,
    );
    if (newTime != null) {
      setState(() {
        _endTime = newTime;
      });
    }
  }
}