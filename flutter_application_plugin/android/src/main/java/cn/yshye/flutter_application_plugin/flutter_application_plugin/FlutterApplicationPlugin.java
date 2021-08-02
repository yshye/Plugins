package cn.yshye.flutter_application_plugin.flutter_application_plugin;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FlutterApplicationPlugin */
public class FlutterApplicationPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_application_plugin");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }else if(call.method.equals("getInstalledApps")){
      result.success(getInstalledApps());
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  private List<Map<String, Object>> getInstalledApps() {
    PackageManager packageManager = context.getPackageManager();
    List<PackageInfo> apps = packageManager.getInstalledPackages(0);
    List<Map<String, Object>> installedApps = new ArrayList<>(apps.size());
    int systemAppMask = ApplicationInfo.FLAG_SYSTEM | ApplicationInfo.FLAG_UPDATED_SYSTEM_APP;
    for (PackageInfo pInfo : apps) {
      if ((pInfo.applicationInfo.flags & systemAppMask) != 0) {
        continue;
      }
      Map<String, Object> map = this.convertPackageInfoToJson(pInfo);
      installedApps.add(map);
    }

    return installedApps;
  }

  private Map<String, Object> convertPackageInfoToJson(PackageInfo info) {
    Map<String, Object> map = new HashMap<>();
    map.put("appName", info.applicationInfo.loadLabel(context.getPackageManager()).toString());
    map.put("packageName", info.packageName);
    map.put("versionCode", info.versionCode);
    map.put("versionName", info.versionName);
    return map;
  }
}
