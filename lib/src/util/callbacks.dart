part of '../../flutter_band_fit.dart';

// const _channel = MethodChannel(BandFitConstants.SMART_CALLBACK);
// typedef MultiUseCallback = void Function(dynamic msg);
// typedef CancelListening = void Function();
//
// Map<String, MultiUseCallback> _callbacksById = <String, void Function(dynamic)> {};

/*Future<void> _methodCallHandler(MethodCall call) async {
  debugPrintI('methodCallHandler method: ${call.method}');
  debugPrintI('methodCallHandler argument : ${jsonDecode(call.arguments)}');
  dynamic callMap = jsonDecode(call.arguments);
  //debugPrintI('methodCallHandler callMap : ${callMap}');
  switch (call.method) {
    case BandFitConstants.CALL_LISTENER:
      //_callbacksById[call.arguments["id"]](call.arguments["args"]);
      //dynamic callMap = jsonDecode(call.arguments);
      _callbacksById[callMap["id"]]!(callMap);
      break;
    default:
      debugPrintI('_methodCallHandlerExp: Ignoring invoke from native. This normally shouldn\'t happen.');
      break;
  }
}*/

/*
Future<CancelListening> startListening(MultiUseCallback callback, String callbackName) async {

  _channel.setMethodCallHandler(_methodCallHandler);

  _callbacksById[callbackName] = callback;

  await _channel.invokeMethod(BandFitConstants.START_LISTENING, callbackName);

  return () {
    _channel.invokeMethod(BandFitConstants.STOP_LISTENING, callbackName);
    _callbacksById.remove(callbackName);
  };
}

Future<void> stopListening(CancelListening callback ,String callbackName ) async{
  _channel.invokeMethod(BandFitConstants.STOP_LISTENING, callbackName);
  _callbacksById.remove(callbackName);
}*/
