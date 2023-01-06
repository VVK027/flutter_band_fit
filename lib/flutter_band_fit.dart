library flutter_band_fit;


import 'package:flutter_band_fit/flutter_band_fit_platform_interface.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:core';
//import 'dart:io';
//import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

part 'src/flutter_band_fit.dart';
part 'src/util/band_fit_constants.dart';
part 'src/util/callbacks.dart';
part 'src/models/band_device_model.dart';
part 'src/models/band_sleep_model.dart';
part 'src/models/band_hr_model.dart';
part 'src/models/band_bp_model.dart';
part 'src/models/band_temperature_model.dart';
part 'src/models/band_oxygen_model.dart';
part 'src/models/band_steps_model.dart';
part 'src/models/band_steps_data_model.dart';

/*
class FlutterBandFit {

  Future<String?> getPlatformVersion() {
    return FlutterBandFitPlatform.instance.getPlatformVersion();
  }
}
*/
