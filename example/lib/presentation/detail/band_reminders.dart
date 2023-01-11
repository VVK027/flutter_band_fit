import 'package:flutter/cupertino.dart';
import 'package:flutter_band_fit_app/common/common_imports.dart';

class BandReminders extends StatefulWidget{
  const BandReminders({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BandRemindersState();
  }
  
}
class BandRemindersState extends State<BandReminders>{

  bool selectSecondaryReminder = false;
  bool selectSmsReminder = false;
  bool selectCallReminder = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //title: Text('Devices and Accounts'),
        backgroundColor: Colors.white,
        // elevation: 0,
        title: const Text('Smart Band Reminders',//'Devices and Accounts',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
         onPressed: () {
           Navigator.of(context).pop();
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
              child: const Center(child: Text('Its Mandatory that the phone needs to be connected to the device, do not turn off Bluetooth', textAlign: TextAlign.center)),
            ),
            const SizedBox(
              height: 8.0,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectSecondaryReminder = !selectSecondaryReminder;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 0, top: 0,right: 4.0, bottom: 0.0),
                        child: Icon(
                          Icons.people_rounded,
                         // Icons.personal_injury_outlined,
                          color: Colors.black54,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //padding: EdgeInsets.all(8.0),
                          //child: Text(Utils.tr(context, 'string_raise_hand_label'), style: TextStyle(fontSize: 16)),
                          child: const Text('Secondary Reminder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          value: selectSecondaryReminder,
                          onChanged: (bool value) {
                            setState(() {
                              selectSecondaryReminder = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const Flexible(
                    fit: FlexFit.loose ,
                    child: Text('In case of continuous time without exercise, the device will vibrate for reminding', style: TextStyle(fontSize: 14)),
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
                  selectSmsReminder = !selectSmsReminder;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 0, top: 0,right: 4.0, bottom: 0.0),
                        child: Icon(
                          Icons.sms_outlined,
                          color: Colors.black54,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //padding: EdgeInsets.all(8.0),
                          //child: Text(Utils.tr(context, 'string_raise_hand_label'), style: TextStyle(fontSize: 16)),
                          child: const Text('SMS Reminder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          value: selectSmsReminder,
                          onChanged: (bool value) {
                            setState(() {
                              selectSmsReminder = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const Flexible(
                      fit: FlexFit.loose ,
                      child: Text('The phone receives a text message and the device vibrates an alert', style: TextStyle(fontSize: 14))
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
                  selectCallReminder = !selectCallReminder;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 0, top: 0,right: 4.0, bottom: 0.0),
                        child: Icon(
                          Icons.call_outlined,
                          color: Colors.black54,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //padding: EdgeInsets.all(8.0),
                          //child: Text(Utils.tr(context, 'string_raise_hand_label'), style: TextStyle(fontSize: 16)),
                          child: const Text('Call Reminder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          value: selectCallReminder,
                          onChanged: (bool value) {
                            setState(() {
                              selectCallReminder = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const Flexible(
                    fit: FlexFit.loose ,
                      child: Text('The phone has an incoming call and the device will vibrate', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1.0,
            ),
            /*Divider(
              // thickness: 1.0,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectCallReminder = !selectCallReminder;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      'assets/fit/goal.png',
                      width: 30.0,
                      height: 30.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('Call Reminder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('The phone needs to be connected to the device, do not turn off Bluetooth', style: TextStyle(fontSize: 14)),
                        ),
                       *//* Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [

                            Expanded(
                              child: Container(
                                //padding: EdgeInsets.all(8.0),
                                //child: Text(Utils.tr(context, 'string_raise_hand_label'), style: TextStyle(fontSize: 16)),
                                child: Text('Call Reminder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                              ),
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: selectCallReminder,
                                onChanged: (bool value) {
                                  setState(() {
                                    selectCallReminder = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: Text('The phone needs to be connected to the device, do not turn off Bluetooth', style: TextStyle(fontSize: 14))),*//*
                      ],
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: selectCallReminder,
                      onChanged: (bool value) {
                        setState(() {
                          selectCallReminder = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),*/
            const SizedBox(
              height: 21.0,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () async {

        },
        tooltip: textSaveContinue,
        child: const Icon(Icons.done),
      ),
    );
  }
  
}