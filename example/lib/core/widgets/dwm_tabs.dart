import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/core/constants/global_constants.dart';

List<Tab> buildDWMTabs() {
  return const <Tab>[
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text(textDay),
      ),
    ),
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text(textWeek),
      ),
    ),
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text(textMonth),
      ),
    ),
  ];
}
