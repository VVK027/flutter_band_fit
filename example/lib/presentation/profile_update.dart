import 'package:flutter/cupertino.dart';
import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:get/get.dart';

class ProfileUpdate extends StatefulWidget {
  final String userFullName, gender, height, weight, dob;
  final String waist, bloodGroup;
  final bool fromSettings;

  const ProfileUpdate(
      {Key? key,
        required this.userFullName,
        required this.gender,
        required this.height,
        required this.weight,
        required this.dob,
        required this.waist,
        required this.bloodGroup,
        required this.fromSettings}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // this class should be initialize whereever there is no data/ info about
    // like gender, birthday, height, weight.
    return ProfileUpdateState();
  }
}

class ProfileUpdateState extends State<ProfileUpdate> {
  late DateTime _selectedDate;
  late String _gender;
  late String _selectedHeight;
  late  String _selectedWeight;
  late String _selectedScreenOffSecs;
  late  String _myBMI;
  late String bmiStatus;
  late String _selectedSteps;

  late  String _selectedTemperatureUnits;
  late bool _selectedRaiseWakeUp;

  late String _tempTempUnits;

  List<String> defaultHeightList = [];
  List<String> defaultWeightList = [];

  final  _activityServiceProvider = Get.put(ActivityServiceProvider());

  @override
  void initState() {

    _selectedSteps = _activityServiceProvider.getTargetedSteps;
    _selectedDate = (widget.dob.isNotEmpty) ? DateTime.parse(widget.dob).toLocal() : DateTime.now();
    _gender = widget.gender;
    _selectedScreenOffSecs = _activityServiceProvider.getScreenOffTime ?? screenOffTimeMin.toString();
    _selectedTemperatureUnits = _activityServiceProvider.getIsCelsius ? tempInCelsius : tempInFahrenheit;
    _tempTempUnits = _selectedTemperatureUnits;
    _selectedRaiseWakeUp = _activityServiceProvider.getRaiseHandWakeUp;
    _selectedHeight = int.parse(widget.height.toString()) == 0 ? heightMin.toString() : widget.height.toString();
    _selectedWeight = int.parse(widget.weight.toString()) == 0 ? weightMin.toString() : widget.weight.toString();
    initializeHeight();
    initializeWeight();
    super.initState();
    calculateBMI();
  }

  void initializeHeight() async {
    for (int i = heightMin; i <= heightMax; i++) {
      defaultHeightList.add(i.toString());
    }
  }

  void initializeWeight() {
    for (int i = weightMin; i <= weightMax; i++) {
      defaultWeightList.add(i.toString());
    }
  }

  void calculateBMI() {
    int hFinalCM = int.parse(_selectedHeight);
    double cWeight = double.parse(_selectedWeight);
    double bmiValueNum = 10000 * cWeight / ((hFinalCM) * (hFinalCM));

    setState(() {
      _myBMI = bmiValueNum.roundToDouble().toString();
      if (bmiValueNum < 18.5) {
        bmiStatus = 'bmi_under_weight';
      } else if (bmiValueNum > 18.5 && bmiValueNum < 24.9) {
        bmiStatus = 'bmi_fit';
      } else if (bmiValueNum > 25.0 && bmiValueNum < 29.0) {
        bmiStatus = 'bmi_over_weight';
      } else if (bmiValueNum > 30.0) {
        bmiStatus = 'bmi_obese';
      }
    });
  }

  /*goBack() {
    final currentUserDetails = Provider.of<CurrentUserDetailsProvider>(context, listen: false).userDetailsValue;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileHomeMain(
                userName: currentUserDetails.firstName,
                userPictureURL: currentUserDetails.picture,
                userGender: currentUserDetails.gender)),
        (_) => false);
  }*/

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          //elevation: 1.0,
          centerTitle: true,
          title: const Text(textNeedProfileUpdate, //'Need a Profile Update',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
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
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text('$textDear ${widget.userFullName}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(2.0),
                      //child: Text('We need the below fields to be updated, to proceed further..!',
                      child: Text('$textUpdateInfoMsg..!',
                          //'Please update the following before you proceed..!',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w300)),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              GestureDetector(
                onTap: () async {
                  String? data = await selectGender(_gender);
                  if (data!.isNotEmpty) {
                    setState(() {
                      _gender = data;
                      // _textEditingController.text = pickedDate.toString();
                    });
                  }
                  debugPrint('_selectedGender>> $_gender');
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Expanded(child: Text(textGender, style: TextStyle(fontSize: 16))),
                      Text(_gender.toUpperCase(), style: const TextStyle(fontSize: 16, color: Colors.blueAccent)),
                    ],
                  ),
                ),
              ),
              const Divider(// thickness: 1.0,
              ),
              GestureDetector(
                onTap: () async {
                  // DateTime tempPickedDate =  DateTime.now();

                  DateTime? data = await selectDate(_selectedDate);
                  if (data != DateTime.now()) {
                    setState(() {
                      _selectedDate = data!;
                      // _textEditingController.text = pickedDate.toString();
                    });
                  }
                  debugPrint('_selectedDate>> $_selectedDate');

                  debugPrint('data>> $data');
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Expanded(
                        child: Text(textDateOfBirth, //'Date of Birth',
                            style: TextStyle(fontSize: 16)),
                      ),
                      Text(_selectedDate.toString().trim().split(' ')[0],
                          style: const TextStyle(
                              fontSize: 16, color: Colors.blueAccent)),
                    ],
                  ),
                ),
              ),
              const Divider(// thickness: 1.0,
              ),
              GestureDetector(
                onTap: () async {
                  String? data = await selectHeight(_selectedHeight);
                  if (data!.isNotEmpty) {
                    setState(() {
                      _selectedHeight = data;
                      calculateBMI();
                      // _textEditingController.text = pickedDate.toString();
                    });
                  }
                  debugPrint('_selectedHeight>> $_selectedHeight');
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 2.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Expanded(
                        child: Text(textHeight, //'Height',
                            style: TextStyle(fontSize: 16)),
                      ),
                      Text('$_selectedHeight cm',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.blueAccent)),
                    ],
                  ),
                ),
              ),
              const Divider(// thickness: 1.0,
              ),
              GestureDetector(
                onTap: () async {
                  String? data = await selectWeight(_selectedWeight);
                  if (data!.isNotEmpty) {
                    setState(() {
                      _selectedWeight = data;
                      calculateBMI();
                      // _textEditingController.text = pickedDate.toString();
                    });
                  }
                  debugPrint('_selectedWeight>> $_selectedWeight');
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 2.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Expanded(
                          child: Text(textWeight,
                              style: TextStyle(fontSize: 16))),
                      Text('$_selectedWeight kg',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.blueAccent)),
                    ],
                  ),
                ),
              ),
              const Divider(// thickness: 1.0,
              ),
              GestureDetector(
                onTap: () async {},
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 2.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Expanded(
                          child: Text(textBMI,
                              style: TextStyle(fontSize: 16))),
                      Container(
                        child: Row(
                          children: [
                            Text(_myBMI,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.blueAccent)),
                            const SizedBox(
                              width: 8,
                            ),
                            /*Text(Utils.tr(context, bmiStatus),
                                style: TextStyle(
                                    fontSize: 16, color: GlobalMethods.getColor(bmiStatus))),*/
                            /*SizedBox(
                              width: 4,
                            ),*/
                            Container(
                              decoration: BoxDecoration(
                                  color: GlobalMethods.getColor(bmiStatus),
                                  shape: BoxShape.circle),
                              height: 16,
                              width: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(// thickness: 1.0,
              ),
              GestureDetector(
                onTap: () async {
                  //String selectedGoal ='';
                  String data = await GlobalMethods.selectGoalSteps(
                      context, _selectedSteps);
                  if (data.isNotEmpty) {
                    setState(() {
                      _selectedSteps = data;
                      // _textEditingController.text = pickedDate.toString();
                    });
                  }
                  debugPrint('selectedGoal>> $_selectedSteps');
                  // DateTime tempPickedDate =  DateTime.now();
                  /*DateTime data = await selectDate(_selectedDate);
                  if (data != DateTime.now()) {
                    setState(() {
                      _selectedDate = data;
                      // _textEditingController.text = pickedDate.toString();
                    });
                  }
                  debugPrint('_selectedDate>> $_selectedDate');*/
                  //debugPrint('data>> $data');
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 2.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Expanded(
                        child: Text(textDailyStepsGoal, //'Daily Steps Goal',
                            style: TextStyle(fontSize: 16)),
                      ),
                      Text(_selectedSteps,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.blueAccent)),
                    ],
                  ),
                ),
              ),
              const Divider(
                // thickness: 1.0,
              ),
              GestureDetector(
                onTap: () async {
                  //String selectedGoal ='';
                  String? data = await selectRaiseUpSeconds(_selectedScreenOffSecs);
                  if (data!.isNotEmpty) {
                    setState(() {
                      _selectedScreenOffSecs = data;
                      // _textEditingController.text = pickedDate.toString();
                    });
                  }
                  debugPrint('_selectedRaiseUpSecs>> $_selectedScreenOffSecs');
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 2.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Expanded(
                        child: Text(textBandScreenOffTime, //'Band Screen Off Time',
                            style: TextStyle(fontSize: 16)),
                      ),
                      Text('$_selectedScreenOffSecs Secs',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.blueAccent)),
                    ],
                  ),
                ),
              ),
              const Divider(
                // thickness: 1.0,
              ),
              GestureDetector(
                onTap: () async {
                  //String selectedGoal ='';
                  String? data = await selectTemperatureUnits(_selectedTemperatureUnits);
                  if (data!.isNotEmpty) {
                    setState(() {
                      _selectedTemperatureUnits = data;
                      // _textEditingController.text = pickedDate.toString();
                    });
                  }
                  debugPrint('_selectedTemperatureUnits>> $_selectedTemperatureUnits');
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 2.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      const Expanded(
                        child: Text(textSetTemperatureUnit, //'Set Temperature Units',
                            style: TextStyle(fontSize: 16)),
                      ),
                      Text(_selectedTemperatureUnits, style: const TextStyle(fontSize: 16, color: Colors.blueAccent)),
                    ],
                  ),
                ),
              ),
              const Divider(
                // thickness: 1.0,
              ),
              GestureDetector(
                onTap: () {
                  /*showRoundedModalBottomSheet(
                    autoResize: true,
                    dismissOnTap: false,
                    context: context,
                    radius: 5.0,
                    color: Colors.white,
                    builder: (context) => StatefulBuilder(
                        builder: (BuildContext cont, StateSetter state) {
                      //actionState = state;
                      return showRaiseWakeUpInfo(context, state);
                    }),
                  );*/
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(textRaiseHandActivateLabel,
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        value: _selectedRaiseWakeUp,
                        onChanged: (bool value) {
                          setState(() {
                            _selectedRaiseWakeUp = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                // thickness: 1.0,
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
            debugPrint('H: $_selectedHeight, W: $_selectedWeight,DOB: $_selectedDate, G: $_gender');
            debugPrint('gender: ${widget.gender}, dob: ${widget.dob}');

            String submitDateOfBirth = '';
            try{
              if (widget.dob  != 'N/A'  &&  widget.dob.isNotEmpty){
                DateTime pastDOB = DateTime.parse(widget.dob).toLocal();
                DateTime currentDOB = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
                //debugPrint('pastDOB>> $pastDOB');
                //debugPrint('currentDOB>> $currentDOB');
                int duration = pastDOB.difference(currentDOB).inDays;
                debugPrint('duration>> $duration');
                if (duration < 0 ) {
                  submitDateOfBirth = currentDOB.toString();
                }else if (duration > 0 ) {
                  submitDateOfBirth = currentDOB.toString();
                }else{
                  // no dob update
                  submitDateOfBirth = '';
                }
              }else{
                submitDateOfBirth = _selectedDate.toString();
              }
              //print('submitDateOfBirth>> $submitDateOfBirth');
            }catch(exp){
              debugPrint('dateOfBirthExp>> $exp');
            }

            bool isConnected = await _activityServiceProvider.checkIsDeviceConnected();
            await _activityServiceProvider.updateTargetedSteps(_selectedSteps);
            await _activityServiceProvider.setScreenOffTime(_selectedScreenOffSecs);
            await _activityServiceProvider.setTemperatureUnits(_selectedTemperatureUnits.toString().trim());
            await _activityServiceProvider.setRaiseHandWakeUp(_selectedRaiseWakeUp);
            await _activityServiceProvider.updateBMIStatus(_myBMI, bmiStatus);

            String dob = submitDateOfBirth.isEmpty? _selectedDate.toString(): submitDateOfBirth;
            await _activityServiceProvider.updateWatchProfile(_selectedHeight, _selectedWeight, _gender.toLowerCase(), dob);

            // bool zeroValue = int.parse(widget.height.toString()) == 0 && int.parse(widget.weight.toString()) == 0;
            // bool changedValue = (int.parse(widget.height.toString()) != int.parse(_selectedHeight)) && (int.parse(widget.weight.toString()) != int.parse(_selectedWeight));

            bool changedHeight = int.parse(widget.height.toString()) != int.parse(_selectedHeight);
            bool changedWeight = int.parse(widget.weight.toString()) != int.parse(_selectedWeight);
            bool changedValue = false;
            if (changedHeight && changedWeight) {
              changedValue = true;
            } else if (changedHeight) {
              //individual
              changedValue = true;
            }else if(changedWeight){
              //individual
              changedValue = true;
            }

            if (widget.gender != _gender && submitDateOfBirth.isNotEmpty) {
              // update gender & dob
              //print('update gender & dob');
              await updateUserDOBGender(submitDateOfBirth, _gender);
            }else if(widget.gender != _gender ){
              // update only gender
              // print('update gender');
              await updateUserDOBGender('', _gender);
            }else if (submitDateOfBirth.isNotEmpty){
              await updateUserDOBGender(submitDateOfBirth, '');
            }//else if (submitDateOfBirth.isEmpty){
            // print('do nothing with api');
            //}

            if (isConnected) {
              if (_tempTempUnits.toString().trim() != _selectedTemperatureUnits.toString().trim()) {
                //await _activityServiceProvider.callWeatherForecast(_activityServiceProvider.getDeviceLatitude.toString(), _activityServiceProvider.getDeviceLongitude.toString(), false);
              }
              await _activityServiceProvider.updateUserParamsWatch(false);
            } else {

            }
            await sharedService.setProfileUpdate(true);
            debugPrint('profile_activityServiceProvider.getDeviceSWName>> ${_activityServiceProvider.getDeviceSWName}');
            if (_activityServiceProvider.getDeviceSWName == googleFitKey || _activityServiceProvider.getDeviceSWName == appleHealthKey) {
              // Navigator.pushAndRemoveUntil(context,
              //     MaterialPageRoute(
              //         builder: (context) => GFitVitalMain(fromLogin: false)),
              //     (_) => false);
            } else {
              if (widget.fromSettings) {
                // Navigator.of(context).pop();
                GlobalMethods.navigatePopBack();
              } else {
                // Navigator.push(context,
                //   MaterialPageRoute(
                //       builder: (context) => const VitalMain(
                //             fetchWeather: false,
                //             fromLogin: false,
                //           )),
                // );
              }
            }
          },
          tooltip: textSaveContinue,
          child: const Icon(Icons.done),
        ),
      ),
    );
  }


  Future<void> updateUserDOBGender(String dateOfBirth, String gender) async {

    String dobUpdate ='';
    String genderUpdate ='';
    if (dateOfBirth.isNotEmpty) {
      //print('dateOfBirth12>> $dateOfBirth');
      dobUpdate = DateTime.parse(dateOfBirth).toUtc().toIso8601String();
    }
    if (gender.isNotEmpty) {
      genderUpdate = gender.toUpperCase();
    }
    print('dateOfBirthUpdate>> $dobUpdate');
    print('gender>> $genderUpdate');
  }

  Future<DateTime?> selectDate(DateTime tempPickedDate) async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButtonWidget(
                      title:cancelText,
                      onPressed: () {
                        // Navigator.of(context).pop();
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

    if (pickedDate != _selectedDate) {
      return pickedDate;
    } else {
      return tempPickedDate;
    }
  }

  Future<String?> selectGender(String tempSelectedDate) async {
    String? selectedGender = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButtonWidget(
                      title:cancelText,
                      onPressed: () {
                        // Navigator.of(context).pop();
                        GlobalMethods.navigatePopBack();
                      },
                    ),
                    CupertinoButtonWidget(
                      title: doneText,
                      onPressed: () {
                        //Navigator.of(context).pop();
                        Navigator.of(context).pop(tempSelectedDate);
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
                  child: CupertinoPicker(
                    //offAxisFraction: 0.18, // 0.45 is the Max
                    magnification: 2.35 / 2.1,
                    useMagnifier: true,
                    squeeze: 1.25,
                    onSelectedItemChanged: (value) {
                      debugPrint('value>> $value');
                      //tempSelectedDate
                      if (value == 1) {
                        tempSelectedDate = 'female';
                      } else {
                        tempSelectedDate = 'male';
                      }
                    },
                    selectionOverlay:
                    const CupertinoPickerDefaultSelectionOverlay(),
                    backgroundColor: Colors.white,
                    itemExtent: 28,
                    scrollController: FixedExtentScrollController(
                        initialItem: tempSelectedDate == 'female' ? 1 : 0),
                    //itemExtent: 10,
                    children: [
                      Text('male'.toUpperCase()),
                      Text('female'.toUpperCase()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selectedGender != _gender) {
      return selectedGender;
    } else {
      return tempSelectedDate;
    }
  }

  Future<String?> selectHeight(String tempSelectedHeight) async {
    String? selectedHeight = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButtonWidget(
                      title:cancelText,
                      onPressed: () {
                        // Navigator.of(context).pop();
                        GlobalMethods.navigatePopBack();
                      },
                    ),
                    CupertinoButtonWidget(
                      title: doneText,
                      onPressed: () {
                        //Navigator.of(context).pop();
                        Navigator.of(context).pop(tempSelectedHeight);
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
                  child: CupertinoPicker(
                    //offAxisFraction: 0.18, // 0.45 is the Max
                    magnification: 2.35 / 2.1,
                    useMagnifier: true,
                    squeeze: 1.25,
                    onSelectedItemChanged: (value) {
                      debugPrint('value_index>> $value');
                      tempSelectedHeight = (value + heightMin).toString();
                    },
                    selectionOverlay:
                    const CupertinoPickerDefaultSelectionOverlay(),
                    backgroundColor: Colors.white,
                    itemExtent: 28,
                    scrollController: FixedExtentScrollController(
                        initialItem: int.parse(tempSelectedHeight) - heightMin),
                    //itemExtent: 10,
                    children: defaultHeightList.map((e) => Text(e)).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selectedHeight != _selectedHeight) {
      return selectedHeight;
    } else {
      return tempSelectedHeight;
    }
  }

  Future<String?> selectWeight(String tempSelectedWeight) async {
    String? selectedWeight = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButtonWidget(
                      title:cancelText,
                      onPressed: () {
                        //Navigator.of(context).pop();
                        GlobalMethods.navigatePopBack();
                      },
                    ),
                    CupertinoButtonWidget(
                      title: doneText,
                      onPressed: () {
                        //Navigator.of(context).pop();
                        Navigator.of(context).pop(tempSelectedWeight);
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
                  child: CupertinoPicker(
                    //offAxisFraction: 0.18, // 0.45 is the Max
                    magnification: 2.35 / 2.1,
                    useMagnifier: true,
                    squeeze: 1.25,
                    onSelectedItemChanged: (value) {
                      debugPrint('value_index>> $value');
                      tempSelectedWeight = (value + weightMin).toString();
                    },
                    selectionOverlay:
                    const CupertinoPickerDefaultSelectionOverlay(),
                    backgroundColor: Colors.white,
                    itemExtent: 28,
                    scrollController: FixedExtentScrollController(
                        initialItem: int.parse(tempSelectedWeight) - weightMin),
                    //itemExtent: 10,
                    children: defaultWeightList.map((e) => Text(e)).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selectedWeight != _selectedWeight) {
      return selectedWeight;
    } else {
      return tempSelectedWeight;
    }
  }

  Future<String?> selectRaiseUpSeconds(String tempScreenOffSecs) async {
    String? selectedSeconds = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButtonWidget(
                      title:cancelText,
                      onPressed: () {
                        //Navigator.of(context).pop();
                        GlobalMethods.navigatePopBack();
                      },
                    ),
                    CupertinoButtonWidget(
                      title: doneText,
                      onPressed: () {
                        //Navigator.of(context).pop();
                        Navigator.of(context).pop(tempScreenOffSecs);
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
                  child: CupertinoPicker(
                    //offAxisFraction: 0.18, // 0.45 is the Max
                    magnification: 2.35 / 2.1,
                    useMagnifier: true,
                    squeeze: 1.25,
                    onSelectedItemChanged: (value) {
                      debugPrint('value_index>> $value');
                      //tempScreenOffSecs = value.toString();
                      //tempScreenOffSecs = (value + screenOffTimeMin).toString();
                      tempScreenOffSecs =
                          screenOffSecondsList[value].toString();
                    },
                    selectionOverlay:
                    const CupertinoPickerDefaultSelectionOverlay(),
                    backgroundColor: Colors.white,
                    itemExtent: 28,
                    scrollController: FixedExtentScrollController(
                        initialItem:
                        screenOffSecondsList.indexOf(tempScreenOffSecs)),
                    //scrollController: FixedExtentScrollController(
                    //initialItem: int.parse(tempScreenOffSecs),
                    //  initialItem: int.parse(tempScreenOffSecs) - screenOffTimeMin

                    // ),
                    //itemExtent: 10,
                    children: screenOffSecondsList.map((e) => Text(e)).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selectedSeconds != _selectedScreenOffSecs) {
      return selectedSeconds;
    } else {
      return tempScreenOffSecs;
    }
  }

  Future<String?> selectTemperatureUnits(String tempUnits) async {
    String? selectedUnits = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButtonWidget(
                      title:cancelText,
                      onPressed: () {
                        //Navigator.of(context).pop();
                        GlobalMethods.navigatePopBack();
                      },
                    ),
                    CupertinoButtonWidget(
                      title: doneText,
                      onPressed: () {
                        //Navigator.of(context).pop();
                        Navigator.of(context).pop(tempUnits);
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
                  child: CupertinoPicker(
                    //offAxisFraction: 0.18, // 0.45 is the Max
                    magnification: 2.35 / 2.1,
                    useMagnifier: true,
                    squeeze: 1.25,
                    onSelectedItemChanged: (value) {
                      debugPrint('value_index>> $value');
                      //tempScreenOffSecs = value.toString();
                      //tempScreenOffSecs = (value + screenOffTimeMin).toString();
                      tempUnits = temperatureUnitsList[value].toString();
                    },
                    selectionOverlay:
                    const CupertinoPickerDefaultSelectionOverlay(),
                    backgroundColor: Colors.white,
                    itemExtent: 28,
                    scrollController: FixedExtentScrollController(
                        initialItem: temperatureUnitsList.indexOf(tempUnits)),
                    //scrollController: FixedExtentScrollController(
                    //initialItem: int.parse(tempUnits),
                    //  initialItem: int.parse(tempUnits) - screenOffTimeMin
                    // ),
                    //itemExtent: 10,
                    children: temperatureUnitsList.map((e) => Text(e)).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (selectedUnits != _selectedTemperatureUnits) {
      return selectedUnits;
    } else {
      return tempUnits;
    }
  }

  Widget showRaiseWakeUpInfo(BuildContext buildContext, StateSetter state) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text(textRaiseHandActivateMsg, //'Raise your hand to activate display',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(raiseHandWakeUpText,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
