import 'package:flutter/services.dart';

class WatchUtil{
  WatchUtil._();

  static void setUserProfileData(var data) async{
    //SpiroSdk spiroSdk = SpiroSdk({});
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      // platformVersion = await MobileSmartWatch.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    //print('platformVersion>> $platformVersion');
  }
}