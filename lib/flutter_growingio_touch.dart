import 'dart:async';

import 'package:flutter/services.dart';

class GrowingTouch {
  static const MethodChannel _channel = const MethodChannel('flutter_growingio_touch');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static set eventPopupEnable(bool enable) {
    _channel.invokeMethod('setEventPopupEnable', enable);
  }

  static Future<bool> get eventPopupEnable async {
    return await _channel.invokeMethod('isEventPopupEnabled');
  }

  static Future<Null> enableEventPopupAndGenerateAppOpenEvent() async {
    await _channel.invokeMethod('enableEventPopupAndGenerateAppOpenEvent');
  }

  static Future<bool> get isEventPopupShowing async {
    return await _channel.invokeMethod('isEventPopupShowing');
  }
}
