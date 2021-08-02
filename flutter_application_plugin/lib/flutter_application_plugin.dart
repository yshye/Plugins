import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FlutterApplicationPlugin {
  static const MethodChannel _channel =
      MethodChannel('flutter_application_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// 获取安装的应用列表
  static Future<List<ApplicationModel>> getInstalledApps() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      var apps = await _channel.invokeMethod("getInstalledApps");
      if (apps != null && apps is List) {
        List<ApplicationModel> list = [];
        for (var app in apps) {
          if (app is Map) {
            list.add(ApplicationModel.fromMap(app));
          }
        }
        return list;
      }
    }
    return [];
  }
}

class ApplicationModel {
  String appName;
  String packageName;
  int versionCode;
  String versionName;

  ApplicationModel(
      {this.appName, this.packageName, this.versionCode, this.versionName});

  Map<String, dynamic> toMap() {
    return {
      'appName': appName,
      'packageName': packageName,
      'versionCode': versionCode,
      'versionName': versionName,
    };
  }

  factory ApplicationModel.fromMap(dynamic map) {
    return ApplicationModel(
      appName: map['appName']?.toString(),
      packageName: map['packageName']?.toString(),
      versionCode: map['versionCode'],
      versionName: map['versionName']?.toString(),
    );
  }
}
