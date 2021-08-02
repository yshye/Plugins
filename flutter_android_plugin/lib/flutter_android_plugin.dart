import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlutterAndroidPlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_android_plugin');

  static Future<int> doNFCWork(
      {required ValueChanged changed, bool auto = true}) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return -1;
    }
    try {
      int flag = await _channel.invokeMethod('doNFC', {'auto': auto});
      if (flag == 2) {
        _channel.setMethodCallHandler((call) async {
          // print(call?.arguments);
          switch (call.method) {
            case "doNFCEnd":
              changed(call.arguments);
              return;
            default:
              return;
          }
        });
      }
      return flag;
    } on PlatformException catch (e) {
      print(e.message);
      return -2;
    }
  }

  static void stopNFC() {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return;
    }
    try {
      _channel.invokeMethod('stopNFC');
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  /// 初始化超高频
  /// -1 不支持，1-汉德霍尔，2-思必拓
  static Future<bool> initUHF([int type = -1]) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }
    try {
      if (type == 1) {
        return await _channel.invokeMethod('initUHF_hdhr');
      } else if (type == 2) {
        return await _channel.invokeMethod('initUHF_sbt');
      }
    } on PlatformException {
      return false;
    }
    return false;
  }

  static void doUHF({required ValueChanged changed, int uhfType = -1}) {
    if (defaultTargetPlatform != TargetPlatform.android ||
        ![1, 2].contains(uhfType)) {
      return;
    }

    try {
      if (uhfType == 2) {
        _channel.invokeMethod('doUHF_sbt');
      } else if (uhfType == 1) {
        _channel.invokeMethod('doUHF_hdhr');
      }
    } on PlatformException catch (e) {
      print(e.message);
    }
    _channel.setMethodCallHandler((call) async {
      print(call.arguments);
      switch (call.method) {
        case "doUHFEnd":
          changed(call.arguments);
          return;
        default:
          return;
      }
    });
  }

  static void pauseUHF({int uhfType = -1}) {
    if (uhfType == -1) return;
    try {
      if (uhfType == 1) {
        _channel.invokeMethod('pauseUHF');
      }
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  static void doVibrate() {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return;
    }
    try {
      _channel.invokeMethod('doVibrate');
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
}
