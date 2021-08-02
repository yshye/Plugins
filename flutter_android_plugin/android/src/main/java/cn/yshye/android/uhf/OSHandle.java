package cn.yshye.android.uhf;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Service;
import android.media.AudioAttributes;
import android.media.AudioManager;
import android.media.SoundPool;
import android.os.Build;
import android.os.Vibrator;


import cn.yshye.android.plugin.R;

public class OSHandle {
    /**
     * 震动
     */
    private static Vibrator mVibrator = null;
    /**
     * msg.mp3播放器
     */
    static SoundPool soundPool = null;

    /**
     * 初始化
     */
    public static void init(Activity activity) {
        mVibrator = (Vibrator) activity.getSystemService(Service.VIBRATOR_SERVICE);

        if (Build.VERSION.SDK_INT >= 21) {
            SoundPool.Builder builder = new SoundPool.Builder();
            //传入最多播放音频数量,
            builder.setMaxStreams(1);
            //AudioAttributes是一个封装音频各种属性的方法
            AudioAttributes.Builder attrBuilder = new AudioAttributes.Builder();
            //设置音频流的合适的属性
            attrBuilder.setLegacyStreamType(AudioManager.STREAM_MUSIC);
            //加载一个AudioAttributes
            builder.setAudioAttributes(attrBuilder.build());
            soundPool = builder.build();
        } else {
            soundPool = new SoundPool(1, AudioManager.STREAM_MUSIC, 1);
        }
        soundPool.load(activity, R.raw.msg, 1);
    }

    /**
     * 开始震动
     */
    @SuppressLint("MissingPermission")
    public static void doVibrate() {
        if (mVibrator != null) {
            if (mVibrator.hasVibrator()) {
                long[] list = {100, 100, 100, 100};
                mVibrator.vibrate(list, -1);
            }
        }
    }

    /**
     * 播放提示音
     */
    public static void doSound() {
        soundPool.play(1, 1f, 1f, 0, 0, 1f);
    }
}
