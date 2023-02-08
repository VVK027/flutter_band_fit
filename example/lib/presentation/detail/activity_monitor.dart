import 'package:flutter/cupertino.dart';
import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:get/get.dart';

class ActivityMonitor extends StatefulWidget{
  const ActivityMonitor({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ActivityMonitorState();
  }

}
class ActivityMonitorState extends State<ActivityMonitor>{

  bool selectHrMonitor = false;
  bool selectTempMonitor = false;
  bool selectOxygenMonitor = false;

  final  _activityServiceProvider = Get.put(ActivityServiceProvider());

  @override
  void initState() {
    //_activityServiceProvider = Provider.of<ActivityServiceProvider>(context, listen: false);
    super.initState();
    assignValues();
  }

  Future<void> assignValues() async{
    setState(() {
      selectHrMonitor = _activityServiceProvider.getHR24Enabled;
      selectTempMonitor = _activityServiceProvider.getTemperature24Enabled;
      selectOxygenMonitor = _activityServiceProvider.getOxygen24Enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //title: Text('Devices and Accounts'),
        backgroundColor: Colors.white,
        // elevation: 0,
        title: const Text(textMonitoringOptions,//'Devices and Accounts',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
          onPressed: () {
            // Navigator.of(context).pop();
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
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              padding: const EdgeInsets.all(8.0),
              child: const Center(child: Text(textConfigureMonitoring, textAlign: TextAlign.center)),
            ),
            const SizedBox(
              height: 8.0,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectHrMonitor = !selectHrMonitor;
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
                      Padding(
                        padding: const EdgeInsets.only(left: 0, top: 0,right: 8.0, bottom: 0.0),
                        child: Image.asset('assets/fit/heart.png',
                          width: 20.0,
                          height: 20.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: const Text(textHeartRateMonitoring, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          value: selectHrMonitor,
                          onChanged: (bool value) {
                            setState(() {
                              selectHrMonitor = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const Flexible(
                    fit: FlexFit.loose ,
                    child: Text(text24HrHeartRateTest, style: TextStyle(fontSize: 14)),
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
                  selectTempMonitor = !selectTempMonitor;
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
                      Padding(
                        padding: const EdgeInsets.only(left: 0, top: 0,right: 8.0, bottom: 0.0),
                        child: Image.asset('assets/fit/temperature.png',
                          width: 21.0,
                          height: 21.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: const Text(textBodyTemperatureMonitoring, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          value: selectTempMonitor,
                          onChanged: (bool value) {
                            setState(() {
                              selectTempMonitor = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const Flexible(
                    fit: FlexFit.loose ,
                    child: Text(text24HrTempTest, style: TextStyle(fontSize: 14)),
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
                  selectOxygenMonitor = !selectOxygenMonitor;
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
                      Padding(
                        padding: const EdgeInsets.only(left: 0, top: 0,right: 8.0, bottom: 0.0),
                        child: Image.asset('assets/fit/blood_oxygen.png',
                          width: 21.0,
                          height: 21.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: const Text(textBodyOxygenMonitoring, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          value: selectOxygenMonitor,
                          onChanged: (bool value) {
                            setState(() {
                              selectOxygenMonitor = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const Flexible(
                    fit: FlexFit.loose ,
                    child: Text(text24HrOxygen, style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),

            const Divider(
              thickness: 1.0,
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
          if(_activityServiceProvider.getHR24Enabled != selectHrMonitor){
            debugPrint('inside hr24 update >> $selectHrMonitor');

            await _activityServiceProvider.set24HrHeartRate(selectHrMonitor);
          }
          if(_activityServiceProvider.getTemperature24Enabled != selectTempMonitor){
            debugPrint('inside temp update >> $selectTempMonitor');
            await _activityServiceProvider.set24HrTemperatureTest(selectTempMonitor);

          }

          if(_activityServiceProvider.getOxygen24Enabled != selectOxygenMonitor){
            debugPrint('inside oxygen update >> $selectOxygenMonitor');
            await _activityServiceProvider.set24HrOxygen(selectOxygenMonitor);
          }

          if (mounted) {
            // Navigator.of(context).pop();
            GlobalMethods.navigatePopBack();
          }
        },
        tooltip: textSaveContinue,
        child: const Icon(Icons.done),
      ),
    );
  }

}