package cn.yshye.android.plugin;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.nfc.NfcAdapter;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.preference.PreferenceManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import cn.yshye.android.nfc.JNFCManageActivity;
import cn.yshye.android.uhf.HDHEUHFHandle;
import cn.yshye.android.uhf.OSHandle;
import cn.yshye.android.uhf.SBTUHFHandle;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.ActivityLifecycleListener;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/**
 * FlutterAndroidPlugin
 */
public class FlutterAndroidPlugin implements FlutterPlugin, MethodCallHandler, PluginRegistry.ActivityResultListener, ActivityAware, Application.ActivityLifecycleCallbacks {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private static MethodChannel channel;
//    private Context application;
    private Activity activity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
//        application = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_android_plugin");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        String method = call.method;
        switch (method) {
            case "doNFC":
                Boolean auto = call.argument("auto");
                if (auto == null)
                    auto = false;
                result.success(doNFCWork(auto));
                break;
            case "stopNFC":
                stopNFC();
                break;
            case "initUHF_sbt":
                result.success(SBTUHFHandle.initUHF());
                break;
            case "doUHF_sbt":
                SBTUHFHandle.doUHF();
                result.success(true);
                break;
            case "initUHF_hdhr":
                result.success(HDHEUHFHandle.initUHF());
                break;
            case "doUHF_hdhr":
                HDHEUHFHandle.startFlagWithUHF = true;
                break;
            case "pauseUHF_hdhr":
                HDHEUHFHandle.startFlagWithUHF = false;
                break;
            case "doVibrate":
                OSHandle.doVibrate();
                break;
            case "doSound":
                OSHandle.doSound();
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        HDHEUHFHandle.registerReceiver(activity);
        SBTUHFHandle.registerReceiver(activity);
        OSHandle.init(activity);
    }


    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {

        return false;
    }


    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }


    @Override
    public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {

    }

    @Override
    public void onActivityStarted(@NonNull Activity activity) {

    }

    @Override
    public void onActivityResumed(@NonNull Activity activity) {

    }

    @Override
    public void onActivityPaused(@NonNull Activity activity) {

    }

    @Override
    public void onActivityStopped(@NonNull Activity activity) {

    }

    @Override
    public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {

    }

    @Override
    public void onActivityDestroyed(@NonNull Activity activity) {
        HDHEUHFHandle.unregisterReceiver(activity);
    }


    final int RFID_CODE = 0XEEEE;

    @SuppressLint("HandlerLeak")
    private Handler nfcHandler = new Handler() {
        @Override
        public void handleMessage(@NonNull Message msg) {
            if (msg.what == RFID_CODE) {
                OSHandle.doVibrate();
                doNFCEnd(msg.obj.toString());
            }
        }
    };

    /**
     * return 0-不支持NFC,1-系统设置中未启用NFC功能，2-可以正常使用
     */
    private int doNFCWork(boolean auto) {
        int flag = isEnableNFC();
        if (flag == 2) {
            JNFCManageActivity.initNFCHandler(nfcHandler, RFID_CODE);
            JNFCManageActivity.setType(auto ? 0 : 1);
            return 2;
        }
        return flag;
    }

    /**
     * 停止NFC识别
     */
    private void stopNFC() {
        JNFCManageActivity.destroyNFCActivity();
    }

    /**
     * 检查结果
     */
    public static void doNFCEnd(String msg) {
        channel.invokeMethod("doNFCEnd", msg);
    }

    /**
     * 是否可用NFC 0-不支持NFC,1-系统设置中未启用NFC功能，2-可以正常使用
     */
    private int isEnableNFC() {
        NfcAdapter nfcAdapter = NfcAdapter.getDefaultAdapter(activity);
        if (nfcAdapter == null) {
            // showToast("设备不支持NFC！")
            return 0;
        }
        if (!nfcAdapter.isEnabled()) {
            // showToast("请在系统设置中先启用NFC功能！")
            return 1;
        }
        return 2;
    }
}
