import 'package:flutter/cupertino.dart';
import 'package:flutter_band_fit_app/features/profile/presentation/controllers/profile_update_controller.dart';
import 'package:flutter_band_fit_app/features/profile/presentation/widgets/profile_update_body.dart';
import 'package:get/get.dart';

class ProfileUpdate extends StatelessWidget {
  const ProfileUpdate({
    super.key,
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileUpdateController>(
      init: ProfileUpdateController(
        userFullName: userFullName,
        gender: gender,
        height: height,
        weight: weight,
        dob: dob,
        waist: waist,
        bloodGroup: bloodGroup,
        fromSettings: fromSettings,
      ),
      autoRemove: true,
      builder: (c) => ProfileUpdateBody(controller: c),
    );
  }
}
