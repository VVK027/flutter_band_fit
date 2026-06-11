import 'package:flutter/cupertino.dart';
import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:flutter_band_fit_app/core/utils/shared_service.dart';
import 'package:flutter_band_fit_app/core/widgets/cupertino_button_widget.dart';
import 'package:flutter_band_fit_app/core/widgets/theme_toggle_button.dart';
import 'package:flutter_band_fit_app/core/widgets/themed_picker_bottom_sheet.dart';
import 'package:flutter_band_fit_app/features/profile/presentation/controllers/profile_update_controller.dart';

class ProfileUpdateBody extends StatelessWidget {
  const ProfileUpdateBody({super.key, required this.controller});

  final ProfileUpdateController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(textNeedProfileUpdate),
          actions: const [
            ThemeToggleButton(
              key: Key(WidgetKeys.themeToggleButton),
            )
          ],
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
                        child: Text(
                          '$textDear ${controller.userFullName}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(2.0),
                      //child: Text('We need the below fields to be updated, to proceed further..!',
                      child: Text(textUpdateInfoMsg,
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
                  String? data = await selectGender(controller.selectedGender);
                  if (data!.isNotEmpty) {
                    controller.selectedGender = data;
                    // _textEditingController.text = pickedDate.toString();

                    controller.update();
                  }
                  debugPrintI('_selectedGender>> $controller.selectedGender');
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 2.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Expanded(
                          child:
                              Text(textGender, style: TextStyle(fontSize: 16))),
                      Text(controller.selectedGender.toUpperCase(),
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
                  // DateTime tempPickedDate =  DateTime.now();

                  DateTime? data = await selectDate(controller.selectedDate);
                  if (data != DateTime.now()) {
                    controller.selectedDate = data!;
                    // _textEditingController.text = pickedDate.toString();

                    controller.update();
                  }
                  debugPrintI(
                      'controller.selectedDate>> $controller.selectedDate');

                  debugPrintI('data>> $data');
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 2.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Expanded(
                        child: Text(textDateOfBirth, //'Date of Birth',
                            style: TextStyle(fontSize: 16)),
                      ),
                      Text(
                          controller.selectedDate
                              .toString()
                              .trim()
                              .split(' ')[0],
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
                  String? data = await selectHeight(controller.selectedHeight);
                  if (data!.isNotEmpty) {
                    controller.selectedHeight = data;
                    controller.calculateBMI();
                    // _textEditingController.text = pickedDate.toString();

                    controller.update();
                  }
                  debugPrintI(
                      'controller.selectedHeight>> $controller.selectedHeight');
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
                      Text('${controller.selectedHeight} cm',
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
                  String? data = await selectWeight(controller.selectedWeight);
                  if (data!.isNotEmpty) {
                    controller.selectedWeight = data;
                    controller.calculateBMI();
                    // _textEditingController.text = pickedDate.toString();

                    controller.update();
                  }
                  debugPrintI(
                      'controller.selectedWeight>> $controller.selectedWeight');
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 2.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Expanded(
                          child:
                              Text(textWeight, style: TextStyle(fontSize: 16))),
                      Text('${controller.selectedWeight} kg',
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
                          child: Text(textBMI, style: TextStyle(fontSize: 16))),
                      Row(
                        children: [
                          Text(controller.myBMI,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.blueAccent)),
                          const SizedBox(
                            width: 8,
                          ),
                          /*Text(Utils.tr(context, controller.bmiStatus),
                                style: TextStyle(
                                    fontSize: 16, color: GlobalMethods.getColor(controller.bmiStatus))),*/
                          /*SizedBox(
                              width: 4,
                            ),*/
                          Container(
                            decoration: BoxDecoration(
                                color: GlobalMethods.getColor(
                                    controller.bmiStatus),
                                shape: BoxShape.circle),
                            height: 16,
                            width: 16,
                          ),
                        ],
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
                      context, controller.selectedSteps);
                  if (data.isNotEmpty) {
                    controller.selectedSteps = data;
                    // _textEditingController.text = pickedDate.toString();

                    controller.update();
                  }
                  debugPrintI('selectedGoal>> $controller.selectedSteps');
                  // DateTime tempPickedDate =  DateTime.now();
                  /*DateTime data = await selectDate(controller.selectedDate);
                  if (data != DateTime.now()) {
                    
                      controller.selectedDate = data;
                      // _textEditingController.text = pickedDate.toString();
                    
                    controller.update();                  }
                  debugPrintI('controller.selectedDate>> $controller.selectedDate');*/
                  //debugPrintI('data>> $data');
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
                      Text(controller.selectedSteps,
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
                  String? data = await selectRaiseUpSeconds(
                      controller.selectedScreenOffSecs);
                  if (data!.isNotEmpty) {
                    controller.selectedScreenOffSecs = data;
                    // _textEditingController.text = pickedDate.toString();

                    controller.update();
                  }
                  debugPrintI(
                      '_selectedRaiseUpSecs>> $controller.selectedScreenOffSecs');
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 2.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Expanded(
                        child: Text(
                            textBandScreenOffTime, //'Band Screen Off Time',
                            style: TextStyle(fontSize: 16)),
                      ),
                      Text(
                          '${controller.selectedScreenOffSecs} $textSecondsShort',
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
                  String? data = await selectTemperatureUnits(
                      controller.selectedTemperatureUnits);
                  if (data!.isNotEmpty) {
                    controller.selectedTemperatureUnits = data;
                    // _textEditingController.text = pickedDate.toString();

                    controller.update();
                  }
                  debugPrintI(
                      'controller.selectedTemperatureUnits>> $controller.selectedTemperatureUnits');
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
                        child: Text(
                            textSetTemperatureUnit, //'Set Temperature Units',
                            style: TextStyle(fontSize: 16)),
                      ),
                      Text(controller.selectedTemperatureUnits,
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
                onTap: () {
                  /*showRoundedModalBottomSheet(
                    autoResize: true,
                    dismissOnTap: false,
                    context: Get.context!,
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
                        value: controller.selectedRaiseWakeUp,
                        onChanged: (bool value) {
                          controller.selectedRaiseWakeUp = value;

                          controller.update();
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
            debugPrintI(
                'H: $controller.selectedHeight, W: $controller.selectedWeight,DOB: $controller.selectedDate, G: $controller.selectedGender');
            debugPrintI('gender: ${controller.gender}, dob: ${controller.dob}');

            String submitDateOfBirth = '';
            try {
              if (controller.dob != 'N/A' && controller.dob.isNotEmpty) {
                DateTime pastDOB = DateTime.parse(controller.dob).toLocal();
                DateTime currentDOB = DateTime(controller.selectedDate.year,
                    controller.selectedDate.month, controller.selectedDate.day);
                //debugPrintI('pastDOB>> $pastDOB');
                //debugPrintI('currentDOB>> $currentDOB');
                int duration = pastDOB.difference(currentDOB).inDays;
                debugPrintI('duration>> $duration');
                if (duration < 0) {
                  submitDateOfBirth = currentDOB.toString();
                } else if (duration > 0) {
                  submitDateOfBirth = currentDOB.toString();
                } else {
                  // no dob update
                  submitDateOfBirth = '';
                }
              } else {
                submitDateOfBirth = controller.selectedDate.toString();
              }
              //debugPrintI('submitDateOfBirth>> $submitDateOfBirth');
            } catch (exp) {
              debugPrintI('dateOfBirthExp>> $exp');
            }

            bool isConnected =
                await controller.activityProvider.checkIsDeviceConnected();
            await controller.activityProvider
                .updateTargetedSteps(controller.selectedSteps);
            await controller.activityProvider
                .setScreenOffTime(controller.selectedScreenOffSecs);
            await controller.activityProvider.setTemperatureUnits(
                controller.selectedTemperatureUnits.toString().trim());
            await controller.activityProvider
                .setRaiseHandWakeUp(controller.selectedRaiseWakeUp);
            await controller.activityProvider
                .updateBMIStatus(controller.myBMI, controller.bmiStatus);

            String dob = submitDateOfBirth.isEmpty
                ? controller.selectedDate.toString()
                : submitDateOfBirth;
            await controller.activityProvider.updateWatchProfile(
                controller.selectedHeight,
                controller.selectedWeight,
                controller.selectedGender.toLowerCase(),
                dob);

            if (controller.gender != controller.selectedGender &&
                submitDateOfBirth.isNotEmpty) {
              await updateUserDOBGender(
                submitDateOfBirth,
                controller.selectedGender,
              );
            } else if (controller.gender != controller.selectedGender) {
              await updateUserDOBGender('', controller.selectedGender);
            } else if (submitDateOfBirth.isNotEmpty) {
              await updateUserDOBGender(submitDateOfBirth, '');
            }

            if (isConnected) {
              await controller.activityProvider.updateUserParamsWatch(false);
            }
            await sharedService.setProfileUpdate(true);
            debugPrintI(
                'profilecontroller.activityProvider.getDeviceSWName>> ${controller.activityProvider.getDeviceSWName}');
            if (controller.activityProvider.getDeviceSWName != googleFitKey &&
                controller.activityProvider.getDeviceSWName != appleHealthKey &&
                controller.fromSettings) {
              GlobalMethods.navigatePopBack();
            }
          },
          tooltip: textSaveContinue,
          child: const Icon(Icons.done),
        ),
      ),
    );
  }

  Future<void> updateUserDOBGender(String dateOfBirth, String gender) async {
    String dobUpdate = '';
    String genderUpdate = '';
    if (dateOfBirth.isNotEmpty) {
      //debugPrintI('dateOfBirth12>> $dateOfBirth');
      dobUpdate = DateTime.parse(dateOfBirth).toUtc().toIso8601String();
    }
    if (gender.isNotEmpty) {
      genderUpdate = gender.toUpperCase();
    }
    debugPrintI('dateOfBirthUpdate>> $dobUpdate');
    debugPrintI('gender>> $genderUpdate');
  }

  Future<DateTime?> selectDate(DateTime tempPickedDate) async {
    DateTime? pickedDate = await showThemedPickerBottomSheet<DateTime>(
      context: Get.context!,
      builder: (context) {
        return Column(
          children: <Widget>[
            Row(
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
                    Navigator.of(context).pop(tempPickedDate);
                  },
                ),
              ],
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
        );
      },
    );

    if (pickedDate != controller.selectedDate) {
      return pickedDate;
    } else {
      return tempPickedDate;
    }
  }

  Future<String?> selectGender(String tempSelectedDate) async {
    String? selectedGender = await showThemedPickerBottomSheet<String>(
      context: Get.context!,
      builder: (context) {
        return Column(
          children: <Widget>[
            Row(
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
                    Navigator.of(context).pop(tempSelectedDate);
                  },
                ),
              ],
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
                    debugPrintI('value>> $value');
                    //tempSelectedDate
                    if (value == 1) {
                      tempSelectedDate = 'female';
                    } else {
                      tempSelectedDate = 'male';
                    }
                  },
                  selectionOverlay:
                      const CupertinoPickerDefaultSelectionOverlay(),
                  backgroundColor: themedPickerBackground(context),
                  itemExtent: 28,
                  scrollController: FixedExtentScrollController(
                      initialItem: tempSelectedDate == 'female' ? 1 : 0),
                  //itemExtent: 10,
                  children: [
                    Text(textMale.toUpperCase(),
                        style: themedPickerItemStyle(context)),
                    Text(textFemale.toUpperCase(),
                        style: themedPickerItemStyle(context)),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );

    if (selectedGender != controller.selectedGender) {
      return selectedGender;
    } else {
      return tempSelectedDate;
    }
  }

  Future<String?> selectHeight(String tempSelectedHeight) async {
    String? selectedHeight = await showThemedPickerBottomSheet<String>(
      context: Get.context!,
      builder: (context) {
        return Column(
          children: <Widget>[
            Row(
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
                    Navigator.of(context).pop(tempSelectedHeight);
                  },
                ),
              ],
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
                    debugPrintI('value_index>> $value');
                    tempSelectedHeight = (value + heightMin).toString();
                  },
                  selectionOverlay:
                      const CupertinoPickerDefaultSelectionOverlay(),
                  backgroundColor: themedPickerBackground(context),
                  itemExtent: 28,
                  scrollController: FixedExtentScrollController(
                      initialItem: int.parse(tempSelectedHeight) - heightMin),
                  //itemExtent: 10,
                  children: controller.defaultHeightList
                      .map(
                          (e) => Text(e, style: themedPickerItemStyle(context)))
                      .toList(),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (selectedHeight != controller.selectedHeight) {
      return selectedHeight;
    } else {
      return tempSelectedHeight;
    }
  }

  Future<String?> selectWeight(String tempSelectedWeight) async {
    String? selectedWeight = await showThemedPickerBottomSheet<String>(
      context: Get.context!,
      builder: (context) {
        return Column(
          children: <Widget>[
            Row(
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
                    Navigator.of(context).pop(tempSelectedWeight);
                  },
                ),
              ],
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
                    debugPrintI('value_index>> $value');
                    tempSelectedWeight = (value + weightMin).toString();
                  },
                  selectionOverlay:
                      const CupertinoPickerDefaultSelectionOverlay(),
                  backgroundColor: themedPickerBackground(context),
                  itemExtent: 28,
                  scrollController: FixedExtentScrollController(
                      initialItem: int.parse(tempSelectedWeight) - weightMin),
                  //itemExtent: 10,
                  children: controller.defaultWeightList
                      .map(
                          (e) => Text(e, style: themedPickerItemStyle(context)))
                      .toList(),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (selectedWeight != controller.selectedWeight) {
      return selectedWeight;
    } else {
      return tempSelectedWeight;
    }
  }

  Future<String?> selectRaiseUpSeconds(String tempScreenOffSecs) async {
    String? selectedSeconds = await showThemedPickerBottomSheet<String>(
      context: Get.context!,
      builder: (context) {
        return Column(
          children: <Widget>[
            Row(
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
                    Navigator.of(context).pop(tempScreenOffSecs);
                  },
                ),
              ],
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
                    debugPrintI('value_index>> $value');
                    //tempScreenOffSecs = value.toString();
                    //tempScreenOffSecs = (value + screenOffTimeMin).toString();
                    tempScreenOffSecs = screenOffSecondsList[value].toString();
                  },
                  selectionOverlay:
                      const CupertinoPickerDefaultSelectionOverlay(),
                  backgroundColor: themedPickerBackground(context),
                  itemExtent: 28,
                  scrollController: FixedExtentScrollController(
                      initialItem:
                          screenOffSecondsList.indexOf(tempScreenOffSecs)),
                  //scrollController: FixedExtentScrollController(
                  //initialItem: int.parse(tempScreenOffSecs),
                  //  initialItem: int.parse(tempScreenOffSecs) - screenOffTimeMin

                  // ),
                  //itemExtent: 10,
                  children: screenOffSecondsList
                      .map(
                          (e) => Text(e, style: themedPickerItemStyle(context)))
                      .toList(),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (selectedSeconds != controller.selectedScreenOffSecs) {
      return selectedSeconds;
    } else {
      return tempScreenOffSecs;
    }
  }

  Future<String?> selectTemperatureUnits(String tempUnits) async {
    String? selectedUnits = await showThemedPickerBottomSheet<String>(
      context: Get.context!,
      builder: (context) {
        return Column(
          children: <Widget>[
            Row(
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
                    Navigator.of(context).pop(tempUnits);
                  },
                ),
              ],
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
                    debugPrintI('value_index>> $value');
                    //tempScreenOffSecs = value.toString();
                    //tempScreenOffSecs = (value + screenOffTimeMin).toString();
                    tempUnits = temperatureUnitsList[value].toString();
                  },
                  selectionOverlay:
                      const CupertinoPickerDefaultSelectionOverlay(),
                  backgroundColor: themedPickerBackground(context),
                  itemExtent: 28,
                  scrollController: FixedExtentScrollController(
                      initialItem: temperatureUnitsList.indexOf(tempUnits)),
                  //scrollController: FixedExtentScrollController(
                  //initialItem: int.parse(tempUnits),
                  //  initialItem: int.parse(tempUnits) - screenOffTimeMin
                  // ),
                  //itemExtent: 10,
                  children: temperatureUnitsList
                      .map(
                          (e) => Text(e, style: themedPickerItemStyle(context)))
                      .toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
    if (selectedUnits != controller.selectedTemperatureUnits) {
      return selectedUnits;
    } else {
      return tempUnits;
    }
  }

  Widget showRaiseWakeUpInfo(BuildContext buildContext, StateSetter state) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text(
                textRaiseHandActivateMsg, //'Raise your hand to activate display',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                raiseHandWakeUpText,
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
