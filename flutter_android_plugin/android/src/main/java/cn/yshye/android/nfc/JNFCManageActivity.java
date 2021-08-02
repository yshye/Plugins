package cn.yshye.android.nfc;

//import android.app.Activity;
import android.content.Intent;
import android.nfc.NfcAdapter;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;

import java.math.BigInteger;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

public class JNFCManageActivity extends AppCompatActivity {
    private static int type = 0;
//    private static Activity activity = null;
    private static Handler nfcHandler = null;
    private static int nfcHandlerWhat = -1;
    private static boolean isReceiveNFC = false;

    public static void initNFCHandler(Handler handler, int what) {
        nfcHandler = handler;
        nfcHandlerWhat = what;
        isReceiveNFC = true;
    }


    public static void setType(int type){
        JNFCManageActivity.type = type;
    }

    public static void destroyNFCActivity(){
        nfcHandler = null;
        nfcHandlerWhat = -1;
        isReceiveNFC = false;
    }

    @Override
    protected void onDestroy() {
        if(JNFCManageActivity.type==1){
            super.onDestroy();
            return;
        }
        nfcHandler = null;
        nfcHandlerWhat = -1;
        isReceiveNFC = false;
        super.onDestroy();
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        activity = this;
        if (isReceiveNFC) {
            processAdapterAction(getIntent());
        } else {
            finish();
        }
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        if (isReceiveNFC) {
            processAdapterAction(intent);
        } else {
            finish();
        }
    }


    void processAdapterAction( Intent intent)  {
        // 当系统检测到tag中含有NDEF格式的数据时，且系统中有activity声明可以接受包含NDEF数据的Intent的时候，系统会优先发出这个action的intent。
        // 得到是否检测到ACTION_NDEF_DISCOVERED触发 序号1
        if (NfcAdapter.ACTION_NDEF_DISCOVERED.equals(intent.getAction())) {
//            println("ACTION_NDEF_DISCOVERED");
            // 处理该intent
            processIntent(intent);
            return;
        }
        // 当没有任何一个activity声明自己可以响应ACTION_NDEF_DISCOVERED时，系统会尝试发出TECH的intent.即便你的tag中所包含的数据是NDEF的，但是如果这个数据的MIME
        // type或URI不能和任何一个activity所声明的想吻合，系统也一样会尝试发出tech格式的intent，而不是NDEF.
        // 得到是否检测到ACTION_TECH_DISCOVERED触发 序号2
        if (NfcAdapter.ACTION_TECH_DISCOVERED.equals(intent.getAction())) {
//            println("ACTION_TECH_DISCOVERED")
            // 处理该intent
            processIntent(intent);
            return;
        }
        // 当系统发现前两个intent在系统中无人会接受的时候，就只好发这个默认的TAG类型的
        // 得到是否检测到ACTION_TAG_DISCOVERED触发 序号3
        if (NfcAdapter.ACTION_TAG_DISCOVERED.equals(intent.getAction())) {
//            println("ACTION_TAG_DISCOVERED")
            // 处理该intent
            processIntent(intent);
        }
    }

    private void processIntent(Intent intent) {
        byte[] myNFCID = intent.getByteArrayExtra(NfcAdapter.EXTRA_ID);// 这里就得到卡号
        String nfcId = binary(myNFCID, 16);
        if (nfcHandler != null && nfcHandlerWhat != -1) {
            Message msg = nfcHandler.obtainMessage();
            msg.what = nfcHandlerWhat;
            msg.obj = nfcId.toUpperCase();
            nfcHandler.handleMessage(msg);
            finish();
        }
    }

    /**
     * 将byte[]转为各种进制的字符串
     *
     * @param bytes
     * byte[]
     * @param radix
     * 基数可以转换进制的范围，从Character.MIN_RADIX到Character.MAX_RADIX，
     * 超出范围后变为10进制
     * @return 转换后的字符串
     */
    String binary(byte[] bytes, int radix) {
        return new BigInteger(1, bytes).toString(radix);// 这里的1代表正数
    }
}
