import 'package:flutter/cupertino.dart';
import 'package:flutter_band_fit_app/core/constants/global_constants.dart';
import 'package:flutter_band_fit_app/core/services/activity_service_provider.dart';
import 'package:flutter_band_fit_app/features/profile/domain/usecases/calculate_bmi_usecase.dart';
import 'package:flutter_band_fit_app/features/profile/domain/usecases/get_profile_settings_usecase.dart';
import 'package:get/get.dart';

class ProfileUpdateController extends GetxController {
  ActivityServiceProvider get activityProvider =>
      Get.find<ActivityServiceProvider>();

  ProfileUpdateController({
    required this.userFullName,
    required this.gender,
    required this.height,
    required this.weight,
    required this.dob,
    required this.waist,
    required this.bloodGroup,
    required this.fromSettings,
  });

  final String userFullName;
  final String gender;
  final String height;
  final String weight;
  final String dob;
  final String waist;
  final String bloodGroup;
  final bool fromSettings;

  BuildContext get context => Get.context!;

  late DateTime selectedDate;
  late String selectedGender;
  late String selectedHeight;
  late String selectedWeight;
  late String selectedScreenOffSecs;
  late String myBMI;
  late String bmiStatus;
  late String selectedSteps;

  late String selectedTemperatureUnits;
  late bool selectedRaiseWakeUp;

  late String tempTempUnits;

  List<String> defaultHeightList = [];
  List<String> defaultWeightList = [];

  final GetProfileSettingsUseCase _getProfileSettingsUseCase =
      Get.find<GetProfileSettingsUseCase>();
  final CalculateBmiUseCase _calculateBmiUseCase = CalculateBmiUseCase();

  @override
  void onInit() {
    final profileSettings = _getProfileSettingsUseCase();

    selectedSteps = profileSettings.targetedSteps;
    selectedDate =
        (dob.isNotEmpty) ? DateTime.parse(dob).toLocal() : DateTime.now();
    selectedGender = gender;
    selectedScreenOffSecs = profileSettings.screenOffTime;
    selectedTemperatureUnits =
        profileSettings.isCelsius ? tempInCelsius : tempInFahrenheit;
    tempTempUnits = selectedTemperatureUnits;
    selectedRaiseWakeUp = profileSettings.raiseHandWakeUp;
    selectedHeight = int.parse(height.toString()) == 0
        ? heightMin.toString()
        : height.toString();
    selectedWeight = int.parse(weight.toString()) == 0
        ? weightMin.toString()
        : weight.toString();
    initializeHeight();
    initializeWeight();
    super.onInit();
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
    final result = _calculateBmiUseCase(
      heightInCm: int.parse(selectedHeight),
      weightInKg: double.parse(selectedWeight),
    );
    myBMI = result.value;
    bmiStatus = result.status;
    update();
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
}
