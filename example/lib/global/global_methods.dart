import 'package:flutter/cupertino.dart';
import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:path_provider/path_provider.dart';

class GlobalMethods {

  static navigateTo(dynamic page){
    Get.to(page);
  }

  static navigatePopBack(){
    Get.back();
  }

  static showSnackBar(){
    Get.snackbar('GetX Snackbar', 'Yay! Awesome GetX Snackbar',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.tealAccent);
  }
  static showDefaultDialog(){
    Get.defaultDialog(title: 'GetX Alert',
        middleText: 'Simple GetX alert', textConfirm: 'Okay', confirmTextColor: Colors.white,
        textCancel: 'Cancel');
  }
  static showMaterialBanner(BuildContext context){
    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
        content: const Text('Hello, I am a Material Banner'),
        leading: const Icon(Icons.error),
        padding: const EdgeInsets.all(15),
        backgroundColor: Colors.lightGreenAccent,
        contentTextStyle: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Agree',
              style: TextStyle(color: Colors.purple),
            ),
          ),
          TextButton(
            onPressed: () {
              // ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.purple),
            ),
          ),
        ]
    ));
  }

  //Related to GFit
  static List<DateTime> calReqDataDateTimeList(String lastSyncDate) {
    debugPrint('lastSyncDate>>> $lastSyncDate');
    // lastSyncDate = '20220224';
    List<DateTime> reqDataDT = [];
    DateTime currDT = DateTime.now();
    var myLastSyncDT = DateTime.parse(lastSyncDate);
    debugPrint('lastSyncGap>>> ${currDT.difference(myLastSyncDT).inDays}');
    int myLastSuncGap = currDT.difference(myLastSyncDT).inDays;
    // if (myLastSuncGap > 3) {
    //   myLastSuncGap = 3;
    // }
    int i = 0;
    while (i < myLastSuncGap + 1) {
      reqDataDT.add(DateTime(
          currDT.subtract(Duration(days: i)).year,
          currDT.subtract(Duration(days: i)).month,
          currDT.subtract(Duration(days: i)).day));

      // if (i == 0) {
      //   reqDataDT.add(DateTime(currDT.year, currDT.month, currDT.day));
      // } else if (i == 1) {
      //   reqDataDT.add(DateTime(
      //       currDT.subtract(Duration(days: 1)).year,
      //       currDT.subtract(Duration(days: 1)).month,
      //       currDT.subtract(Duration(days: 1)).day));
      // } else if (i == 2) {
      //   reqDataDT.add(DateTime(
      //       currDT.subtract(Duration(days: 2)).year,
      //       currDT.subtract(Duration(days: 2)).month,
      //       currDT.subtract(Duration(days: 2)).day));
      // }
      i++;
    }

    return reqDataDT;
  }

  static String getBPConditions(int systolic, int diastolic) {
    debugPrint('_mySys>>> $systolic');
    debugPrint('_myDia>>> $diastolic');
    String myBPCondition = '';
    if ((systolic < 110 || systolic > 140) || (diastolic < 70 || diastolic > 90)) {
      myBPCondition = 'Need Doctor Advice';
    } else {
      myBPCondition = 'Normal';
    }
    return myBPCondition;
  }

  static String getHeartRateConditions(int todayTotalNoBpm) {
    debugPrint('todayTotalNoBpm>>> $todayTotalNoBpm');
    String myHRCondition = '';
    if((todayTotalNoBpm < 60 || todayTotalNoBpm > 85)) {
      myHRCondition = 'Need Doctor Advice';
    }else{
      myHRCondition = 'Normal';
    }
    return myHRCondition;
  }

  static String getSleepingConditions(int sleepingHr) {
    debugPrint('sleepingHr>>> $sleepingHr');
    String myCondition = '';
    if((sleepingHr < 4)) {
      myCondition = 'Need Doctor Advice';
    }else{
      myCondition = 'Normal';
    }
    return myCondition;
  }

  static String getSpo2Conditions(int spo2Value) {
    debugPrint('spo2Value>>> $spo2Value');
    String myCondition = '';
    if((spo2Value < 88)) {
      myCondition = 'Need Doctor Advice';
    }else{
      myCondition = 'Normal';
    }
    return myCondition;
  }

  static String getTempConditions(int myBodyTemp) {
    debugPrint('myBodyTemp>>> $myBodyTemp');
    String myHRCondition = '';
    if((myBodyTemp < 36 || myBodyTemp > 38)) {
      myHRCondition = 'Need Doctor Advice';
    }else{
      myHRCondition = 'Normal';
    }
    return myHRCondition;
  }

  static getConditionColor(String status) {
    debugPrint('status>>> $status');
    if (status.trim() == 'Need Doctor Advice') {
      return Colors.red;
    } else if (status.trim() == 'Normal') {
      return Colors.green;
    }
    return Colors.green;
  }

  // For getting next month
  static DateTime getOneMonthForwardGFit(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month+1, dateTime.day);
  }

  static int calculateStepDuration(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day,from.hour,from.minute,from.second);
    to = DateTime(to.year, to.month, to.day,to.hour,to.minute,to.second);
    return (to.difference(from).inSeconds);
  }

  // static Future<String> getDeviceType() async {
  //   return await SharedPref().getString('stDeviceType', 'DoctyM')??'DoctyM';
  // }

  /*static List<int> getWeakDayList(int number) {
    List<int> weatherForcastingDaysList=[];
    for(int i=0;i<number;i++) {
      weatherForcastingDaysList.add(DateTime.now().add(Duration(days: i)).day);
    }
    return weatherForcastingDaysList;
  }*/

  static int getAgeFromDOB(String dOB) {
    try {
      DateTime dateOfBirth = DateTime.parse(dOB).toLocal();
      int age = DateTime.now().year - dateOfBirth.year;
      return age;
    } catch (error) {
      debugPrint("age error $error");
      return 18;
    }
  }



  static getColor(status) {
    if (status.toString().toLowerCase().trim() == 'bmi_under_weight') {
      return Colors.red;
    } else if (status.toString().toLowerCase().trim() == 'bmi_fit') {
      return Colors.green;
    } else if (status.toString().toLowerCase().trim() == 'bmi_over_weight') {
      return Colors.yellow;
    } else if (status.toString().toLowerCase().trim() == 'bmi_obese') {
      return const Color(0xffCA5353);
    }
    return Colors.green;
  }

  static Future<String> selectGoalSteps(BuildContext context, String tempSelectedSteps) async {
    debugPrint('inside goals');
    debugPrint('tempSelectedSteps>> $tempSelectedSteps');
    // goalTextTitle
    String? selectedSteps = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return Container(
          height: 310,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButtonWidget(
                      title: cancelText,
                      onPressed: () {
                        // Navigator.of(context).pop();
                        GlobalMethods.navigatePopBack();
                      },
                    ),
                    CupertinoButtonWidget(
                      title: doneText,
                      onPressed: () {
                        //Navigator.of(context).pop();
                        Navigator.of(context).pop(tempSelectedSteps);
                      },
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 1,
              ),
              Container(
                  padding: const EdgeInsets.all(4.0),
                  child: const Center(
                      child: Text(goalTextTitle,
                        textAlign: TextAlign.center,
                      ))),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  child: CupertinoPicker(
                    //offAxisFraction: 0.18, // 0.45 is the Max
                    magnification: 2.35 / 2.1,
                    useMagnifier: true,
                    squeeze: 1.25,
                    onSelectedItemChanged: (value) {
                      debugPrint('value_index>> $value');
                      tempSelectedSteps = totalGoalsList[value].toString();
                    },
                    selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(),
                    backgroundColor: Colors.white,
                    itemExtent: 28,
                    // scrollController: FixedExtentScrollController(initialItem: int.parse(tempSelectedSteps)),
                    scrollController: FixedExtentScrollController(initialItem:totalGoalsList.indexOf(tempSelectedSteps)),
                    //itemExtent: 10,
                    children: totalGoalsList.map((e) => Text(e)).toList(),
                    //children: totalGoalsList,totalGoalsList
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selectedSteps != null && selectedSteps != tempSelectedSteps) {
      return selectedSteps;
    } else {
      return tempSelectedSteps;
    }
  }

  // Find the first date of the week which contains the provided date.
  static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  // Find last date of the week which contains provided date.
  static DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  // Find the first date of the month which contains the provided date.
  static DateTime findFirstDateOfTheMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1);
  }

  // Find last date of the month which contains provided date.
  static DateTime findLastDateOfTheMonth(DateTime dateTime) {
    return dateTime.month < 12
        ? DateTime(dateTime.year, dateTime.month + 1, 0)
        : DateTime(dateTime.year + 1, 1, 0);
  }

  // operations for the calender shifts
  static DateTime getOneDayBackward(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day - 1);
  }

  static DateTime getOneDayForward(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day + 1);
  }

  static DateTime getLastDayOfCurrentMonth(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    return lastDayOfMonth;
  }

  static Future<List<DateTime>> findNextSevenWeekDatesListByTime(DateTime currentDateTime) async {
    List<DateTime> sevenWeekDays = [];
    //sevenWeekDays.add(DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day));
    int i = 0;
    while (i < 7) {
      sevenWeekDays.add(DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day).add(Duration(days: i)));
      i++;
    }
    debugPrint('$sevenWeekDays');
    return sevenWeekDays;
  }

  static Future<List<DateTime>> getWeekDatesListByTime(DateTime dateTime) async {
    //  debugPrint('inside>> $dateTime');
    // pass the current date time or past week time
    DateTime firstDate = findFirstDateOfTheWeek(dateTime);
    // debugPrint('firstDate>> $firstDate');
    DateTime lastDate = findLastDateOfTheWeek(dateTime);
    //  debugPrint('lastDate>> $lastDate');
    List<DateTime> weekDays = [];
    if (firstDate.day > lastDate.day) {
      //27 > 3
      int i = 0;
      while (i < 7) {
        weekDays.add(DateTime(firstDate.year, firstDate.month, firstDate.day + i));
        i++;
      }
    } else {
      for (int i = firstDate.day; i <= lastDate.day; i++) {
        weekDays.add(DateTime(firstDate.year, firstDate.month, i));
      }
    }

    debugPrint('$weekDays');
    return weekDays;
  }

  static Future<List<DateTime>> getMonthyDatesListByTime(DateTime dateTime) async {
    // below code is used for the current month

    // pass the current date time or past week time
    // debugPrint('inside>> $dateTime');
    // pass the current date time or past week time
    DateTime firstDate = findFirstDateOfTheMonth(dateTime);
    // debugPrint('firstDate>> $firstDate');
    DateTime lastDate = findLastDateOfTheMonth(dateTime);
    // debugPrint('lastDate>> $lastDate');

    List<DateTime> monthDays = [];

    for (int i = firstDate.day; i <= lastDate.day; i++) {
      monthDays.add(DateTime(firstDate.year, firstDate.month, i));
    }
    return monthDays;
  }

  /*static List<String> getCurrentDayWeekDates() {
    // var dateFormatTemp = DateFormat("dd-MM-yyyy");
    //DateFormat("dd-MM-yyyy").format(DateTime.now());
    DateTime today = DateTime.now();
    DateTime firstDate = findFirstDateOfTheWeek(today);
    DateTime lastDate = findLastDateOfTheWeek(today);
    // or
    //String date = dateToday.toString().substring(0,10);

    debugPrint('first date : >> ${firstDate.day}');
    debugPrint('last date : >> ${lastDate.day}');

    List<String> weekDays = [];

    //var currentDate = DateTime(firstDate.year, 2 );
    for (int i = firstDate.day; i <= lastDate.day; i++) {
      weekDays.add(DateTime(firstDate.year, firstDate.month, i)
          .toString()
          .substring(0, 10)
          .trim());
    }

    debugPrint('$weekDays');

    List<String> weekDays12 = [];

    DateTime pastNext = DateTime(firstDate.year, firstDate.month, firstDate.day - 1);

    DateTime firstDate12 = findFirstDateOfTheWeek(pastNext);
    DateTime lastDate12 = findLastDateOfTheWeek(pastNext);

    for (int i = firstDate12.day; i <= lastDate12.day; i++) {
      weekDays12.add(DateTime(firstDate12.year, firstDate12.month, i)
          .toString()
          .substring(0, 10)
          .trim());
    }

    debugPrint('$weekDays12');

    List<String> weekDays23 = [];

    DateTime pastNext12 = DateTime(firstDate12.year, firstDate12.month, firstDate12.day - 1);

    DateTime firstDate23 = findFirstDateOfTheWeek(pastNext12);
    DateTime lastDate23 = findLastDateOfTheWeek(pastNext12);

    for (int i = firstDate23.day; i <= lastDate23.day; i++) {
      weekDays23.add(DateTime(firstDate23.year, firstDate23.month, i)
          .toString()
          .substring(0, 10)
          .trim());
    }

    debugPrint('$weekDays23');

    return weekDays;
  }*/

  /// Find first date of previous week using a date in current week.
  /// [dateTime] A date in current week.
  DateTime findFirstDateOfPreviousWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfLastWeek = dateTime.subtract(const Duration(days: 7));
    return findFirstDateOfTheWeek(sameWeekDayOfLastWeek);
  }

  /// Find last date of previous week using a date in current week.
  /// [dateTime] A date in current week.
  DateTime findLastDateOfPreviousWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfLastWeek = dateTime.subtract(const Duration(days: 7));
    return findLastDateOfTheWeek(sameWeekDayOfLastWeek);
  }

  /// Find first date of next week using a date in current week.
  /// [dateTime] A date in current week.
  DateTime findFirstDateOfNextWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfNextWeek = dateTime.add(const Duration(days: 7));
    return findFirstDateOfTheWeek(sameWeekDayOfNextWeek);
  }

  /// Find last date of next week using a date in current week.
  /// [dateTime] A date in current week.
  DateTime findLastDateOfNextWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfNextWeek = dateTime.add(const Duration(days: 7));
    return findLastDateOfTheWeek(sameWeekDayOfNextWeek);
  }

  // returns string in calender format "20220115"
  static String convertBandReadableCalender(DateTime dateTime) {
    String calenderDate = DateFormat('yyyyMMdd').format(dateTime);
    return calenderDate;
  }

  static String formatNumber(int number) {
    var f = NumberFormat("#,###", "en_US");
    return f.format(number);
  }

  static Future<List<String>> getDatesListByLastDateTime(DateTime lastDateTime) async {
    DateTime todayDateTime  = DateTime.now();
    List<String> listOfCalenderDays = [];
    for (int i = lastDateTime.day; i <= todayDateTime.day; i++) {
      listOfCalenderDays.add(convertBandReadableCalender(DateTime(lastDateTime.year, lastDateTime.month, i)));
    }
    //debugPrint('listOfCalenderDays>> $listOfCalenderDays');
    return listOfCalenderDays;
  }


  /*static Future<Position> fetchDeviceCurrentLocation(BuildContext context) async {
    Position currentLocation = await locateUser(context);
    if (currentLocation == null) {
      return null;
    }
    return currentLocation;
  }

  static Future<Position> locateUser(BuildContext context) async {
    if (await Permissions.locationPermissionsGranted()) {
      try {
        return await Geolocator.getCurrentPosition();
      } catch (e) {
        Toast.show(e.toString(), context, duration: 3);
        GlobalMethods.navigatePopBack();
      }
    }
    return null;
  }

  static Future<Placemark> getLocationAddress(double lat, double long) async {
    List<Placemark> placeMarkList = await placemarkFromCoordinates(lat,long);
    if (placeMarkList !=null && placeMarkList.isNotEmpty) {
      debugPrint('placemarkList.length>> ${placeMarkList.length}');
      return placeMarkList.first;
    } else{
      return null;
    }
   // debugPrint('placemarkList>> ${placeMarkList}');
    *//*placeMarkList.forEach((element) {
      debugPrint('element>> $element');
    });*//*
  }*/

  static void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  // primary: Color(0xFF6200EE),
                  // primary: Colors.teal,
                  foregroundColor: Colors.teal,
                ),
                // textColor: Color(0xFF6200EE),
                onPressed: () {
                  //Navigator.of(context).pop();
                  GlobalMethods.navigatePopBack();
                },
                child: const Text(okText),
              )
            ],
          );
        });
  }

  static void showAlertDialogWithFunction(BuildContext context, String title, String message, String buttonText, Function() onPressed) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  // primary: Color(0xFF6200EE),
                  foregroundColor: Colors.teal,
                ),
                onPressed:onPressed,
                // textColor: Color(0xFF6200EE),
                // onPressed: () {
                //   Navigator.of(context).pop();
                // },
                child: Text(buttonText),
              )
            ],
          );
        });
  }

  static Future<DateTime> selectCalenderDate(BuildContext context, DateTime tempPickedDate) async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButtonWidget(
                      title: cancelText,
                      onPressed: () {
                        //Navigator.of(context).pop();
                        GlobalMethods.navigatePopBack();
                      },
                    ),
                    CupertinoButtonWidget(
                      title: doneText,
                      onPressed: () {
                        //Navigator.of(context).pop();
                        Navigator.of(context).pop(tempPickedDate);
                      },
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: CupertinoDatePicker(
                    initialDateTime: tempPickedDate,
                    maximumDate: DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime dateTime) {
                      tempPickedDate = dateTime;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (pickedDate != null && pickedDate != tempPickedDate) {
      return pickedDate;
    } else {
      return tempPickedDate;
    }
  }

  static String getTimeByIntegerMin(int minutes) {
    int hour = minutes ~/ 60;
    int min = minutes % 60;
    //return String.format(Locale.getDefault(), "%02d:%02d", hour, min);
    return '${hour.toString().padLeft(2, "0")}:${min.toString().padLeft(2, "0")}';
  }

  static Future<String> getWeekTitleLabel(BuildContext context, List<DateTime> weekList) async {
    String weekTitleLabel ='';
    try{
      String firstDay = weekList[0].day.toString();
      String lastDay = weekList[weekList.length - 1].day.toString();
      //String month = tempCalenderMonth[weekList[0].month - 1];
      String nextMonth = '';
      String prevMonth = '';
      int firstMonth =  weekList[0].month;
      int lastMonth =  weekList[weekList.length - 1].month;
      if (firstMonth == lastMonth) {
        prevMonth = '';
        nextMonth = calMonths[lastMonth - 1];
      }else{
        prevMonth = calMonths[firstMonth - 1];
        nextMonth = calMonths[lastMonth - 1];
      }
      weekTitleLabel = '$firstDay $prevMonth ~ $lastDay $nextMonth';
    }catch(e){
      debugPrint('getWeekTitleLabelExp: $e');
    }
    return weekTitleLabel;
  }

/* static String getTimeByIntegerMin(int minutes) {
    double hour = minutes / 60;
    int min = minutes % 60;
    return String.format(Locale.getDefault(), "%02d:%02d", hour, min);
  }*/

/* "2012-02-27 13:27:00"
  "2012-02-27 13:27:00.123456789z"
  "2012-02-27 13:27:00,123456789z"
  "20120227 13:27:00"
  "20120227T132700"
  "20120227"
  "+20120227"
  "2012-02-27T14Z"
  "2012-02-27T14+00:00"
  "-123450101 00:00:00 Z": in the year -12345.
  "2002-02-27T14:00:00-0500": Same as "2002-02-27T19:00:00Z"*/

/*static Future<String> prepareDirectory(String folderName) async {
    String localPath = (await findLocalPath()) + Platform.pathSeparator + folderName;
    final savedDir = Directory(localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    return localPath;
  }

  static Future<String> findLocalPath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final savedDir = Directory(directory.path + Platform.pathSeparator + Settings.docty_folder);
    bool dirExists = await savedDir.exists();
    if (!dirExists) {
      savedDir.create();
    }
    return savedDir.path;
  }*/

}
