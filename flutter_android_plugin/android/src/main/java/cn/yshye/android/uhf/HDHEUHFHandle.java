package cn.yshye.android.uhf;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;

import androidx.appcompat.app.AppCompatActivity;

import com.android.hdhe.uhf.reader.UhfReader;
import com.android.hdhe.uhf.readerInterface.TagModel;

import java.util.ArrayList;
import java.util.List;

import cn.pda.serialport.Tools;
import cn.yshye.android.plugin.FlutterAndroidPlugin;

public class HDHEUHFHandle {
    private static boolean runFlagWithUHF = true;

    // 度盘
    public static boolean startFlagWithUHF = false;
    // 汉德霍尔 UHF识别
    private static UhfReader uhfManagerWithHandheld = null;

    private static KeyReceiver keyReceiver = null;

    private static Activity activity = null;

    static class KeyReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            int keyCode = intent.getIntExtra("keyCode", 0);
            if (keyCode == 0) {
                keyCode = intent.getIntExtra("keycode", 0);
            }
            boolean keyDown = intent.getBooleanExtra("keydown", false);
//            if (keyDown) {
//                new ArrayList<Integer>(){
//                    KeyEvent.KEYCODE_F1, KeyEvent.KEYCODE_F2, KeyEvent.KEYCODE_F3, KeyEvent.KEYCODE_F4, KeyEvent.KEYCODE_F5}.contains()
//                when (keyCode) {
//                     -> Log.d("UHF", "KeyReceiver:keyCode = down$keyCode")
//                }
//            }
        }
    }

    static class InventoryThread extends Thread {
        private List<TagModel> tagList = new ArrayList<>();

        @Override
        public void run() {
            super.run();
            while (runFlagWithUHF) {
                if (startFlagWithUHF) {
                    try {
                        tagList = uhfManagerWithHandheld.inventoryRealTime();
                    } catch (Exception e) {
                        continue;
                    }
                    if (tagList != null && tagList.size() > 0) {
                        startFlagWithUHF = false;
                        OSHandle.doSound();
                        OSHandle.doVibrate();
                        String epcStr = Tools.Bytes2HexString(
                                tagList.get(0).getmEpcBytes(),
                                tagList.get(0).getmEpcBytes().length);
                        doUHFEnd(epcStr);
                    }
                    tagList = new ArrayList<>();
                    try {
                        Thread.sleep(20);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        }

    }


    /**
     * 初始化
     */
    public static boolean initUHF() {
        if (uhfManagerWithHandheld == null) {
            try {
                uhfManagerWithHandheld = UhfReader.getInstance();
                if (uhfManagerWithHandheld == null) {
//                    Log.i("UHF", "设备不具备识别超高频芯片的功能！")
                    return false;
                }
                Thread.sleep(20);
            } catch (InterruptedException e) {
                return false;
            } catch (Exception e) {
//                Log.i("UHF", "不存在汉德霍尔UHF识别模块！")
                return false;
//                e.printStackTrace()
            }
            runFlagWithUHF = true;
            InventoryThread thread = new InventoryThread();
            thread.start();
        }
        return true;
    }

    // 注册
    public static void registerReceiver(Activity activity) {
        HDHEUHFHandle.activity = activity;
        if (keyReceiver == null) {
            keyReceiver = new KeyReceiver();
            IntentFilter filter = new IntentFilter();
            filter.addAction("android.rfid.FUN_KEY");
            filter.addAction("android.intent.action.FUN_KEY");
            activity.registerReceiver(keyReceiver, filter);
        }
    }

    // 取消注册
    public static void unregisterReceiver(Activity activity) {
        if (keyReceiver != null)
            activity.unregisterReceiver(keyReceiver);
        keyReceiver = null;
    }

    /**
     * 检查结果
     */
    private static void doUHFEnd(final String msg) {
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                FlutterAndroidPlugin.doNFCEnd(msg);
            }
        });

    }
}
