import 'dart:async';

import 'package:flutter/services.dart';

class GrowingTouch {
  //flutter_growingio_touch
  static const MethodChannel _methodChannel = const MethodChannel('flutter_growingio_touch_method_channel');
  static const EventChannel _eventChannel = const EventChannel('flutter_growingio_touch_event_channel');

  // ignore: cancel_subscriptions
  static StreamSubscription _subscription;
  static EventPopupListener _eventPopupListener;

  static set eventPopupEnable(bool enable) {
    _methodChannel.invokeMethod('setEventPopupEnable', enable);
  }

  static Future<bool> get eventPopupEnable async {
    return await _methodChannel.invokeMethod('isEventPopupEnabled');
  }

  static Future<void> enableEventPopupAndGenerateAppOpenEvent() async {
    await _methodChannel.invokeMethod('enableEventPopupAndGenerateAppOpenEvent');
  }

  static Future<bool> get isEventPopupShowing async {
    return await _methodChannel.invokeMethod('isEventPopupShowing');
  }

  static set eventPopupListener(EventPopupListener listener) {
    _eventPopupListener = listener;
    if (_subscription == null) {
      _subscription = _eventChannel.receiveBroadcastStream().listen(_onEvent);
      _methodChannel.invokeMethod('setEventPopupListener');
    }
  }

  static void _onEvent(Object event) {
    if (_eventPopupListener == null) {
      return;
    }
    if (event is Map) {
      Map data = event;
      String method = data['method'];
      if (method == null) {
        return;
      }

      String eventId = data['eventId'];
      String eventType = data['eventType'];
      switch (method) {
        case 'onLoadSuccess':
          if (_eventPopupListener.onLoadSuccess != null) {
            _eventPopupListener.onLoadSuccess(eventId, eventType);
          }
          break;
        case 'onLoadFailed':
          if (_eventPopupListener.onLoadFailed != null) {
            int errorCode = data['errorCode'];
            String description = data['description'];
            _eventPopupListener.onLoadFailed(eventId, eventType, errorCode, description);
          }
          break;
        case 'onClicked':
          if (_eventPopupListener.onClicked != null) {
            String openUrl = data['openUrl'];
            _eventPopupListener.onClicked(eventId, eventType, openUrl);
          }
          break;
        case 'onCancel':
          if (_eventPopupListener.onCancel != null) {
            _eventPopupListener.onCancel(eventId, eventType);
          }
          break;
        case 'onTimeout':
          if (_eventPopupListener.onTimeout != null) {
            _eventPopupListener.onTimeout(eventId, eventType);
          }
          break;
      }
    }
  }
}

typedef OnLoadSuccess = void Function(String eventId, String eventType);
typedef OnLoadFailed = void Function(String eventId, String eventType, int errorCode, String description);
typedef OnClicked = void Function(String eventId, String eventType, String openUrl);
typedef OnCancel = void Function(String eventId, String eventType);
typedef OnTimeout = void Function(String eventId, String eventType);

class EventPopupListener {
  OnLoadSuccess onLoadSuccess;
  OnLoadFailed onLoadFailed;
  OnClicked onClicked;
  OnCancel onCancel;
  OnTimeout onTimeout;

  EventPopupListener({this.onLoadSuccess, this.onLoadFailed, this.onClicked, this.onCancel, this.onTimeout});
}
