package cn.yshye.android.uhf;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.os.Handler;
import android.os.Message;

import androidx.annotation.NonNull;

import com.speedata.libuhf.IUHFService;
import com.speedata.libuhf.UHFManager;
import com.speedata.libuhf.bean.SpdInventoryData;
import com.speedata.libuhf.interfaces.OnSpdInventoryListener;

import cn.yshye.android.plugin.FlutterAndroidPlugin;

public class SBTUHFHandle {
    private static Activity activity;
    private static IUHFService iuhfService;
    static boolean uhfEnableWithSBT = false;

    public static void registerReceiver(Activity appCompatActivity) {
        activity = appCompatActivity;
    }

    @SuppressLint("HandlerLeak")
    private static Handler handler = new Handler() {
        @Override
        public void handleMessage(@NonNull Message msg) {
            super.handleMessage(msg);
            if (msg.what == 1) {
                //播放提示音
                OSHandle.doSound();
                OSHandle.doVibrate();
                SpdInventoryData var1 = (SpdInventoryData) msg.obj;
                String epc = var1.epc;
                iuhfService.inventoryStop();
                doUHFEnd(epc);
            }
        }
    };

    public static void doUHF() {
        if (!uhfEnableWithSBT) return;
        iuhfService.inventoryStart();
    }

    /**
     * 检查结果
     */
    private static void doUHFEnd(final String msg) {
        SBTUHFHandle.activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                FlutterAndroidPlugin.doNFCEnd(msg);
            }
        });
    }

    public static boolean initUHF() {
        if (iuhfService == null) {
            try {
                iuhfService = UHFManager.getUHFService(activity);
                if (iuhfService == null || iuhfService.openDev() != 0) {
                    uhfEnableWithSBT = false;
                    return false;
                }
                iuhfService.setOnInventoryListener(new OnSpdInventoryListener() {
                    @Override
                    public void getInventoryData(SpdInventoryData var1) {
                        handler.sendMessage(handler.obtainMessage(1, var1));
                    }

                    @Override
                    public void onInventoryStatus(int status) {

                    }
                });
                uhfEnableWithSBT = true;
            } catch (Exception e) {
                uhfEnableWithSBT = false;
                return false;
            }
        } else {
            uhfEnableWithSBT = true;
        }
        iuhfService.selectCard(1, "", false);
        return true;
    }

}
