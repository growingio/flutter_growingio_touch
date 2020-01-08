package com.growingio.plugin.flutter_growingio_touch_example;

import android.content.Context;
import android.content.SharedPreferences;

public class SpHelper {
    private static final String SP_NAME = "touch_demo_data";
    private static final String TOUCH_STATE = "touch_state";
    private static final String TOUCH_USER = "touch_user";
    private static final String TOUCH_HOST = "touch_host";
    private static final String IMAGE_OPEN_CNT = "image_open_cnt";

    private final SharedPreferences mSharedPreferences;

    public SpHelper(Context context) {
        mSharedPreferences = context.getSharedPreferences(SP_NAME, Context.MODE_PRIVATE);
    }

    public void saveGTouchEnableState(boolean enable) {
        mSharedPreferences.edit().putBoolean(TOUCH_STATE, enable).apply();
    }

    public boolean getGTouchEnableState() {
        return mSharedPreferences.getBoolean(TOUCH_STATE, false);
    }

    public void saveGTouchUser(String user) {
        mSharedPreferences.edit().putString(TOUCH_USER, user).apply();
    }

    public String getGTouchUser() {
        return mSharedPreferences.getString(TOUCH_USER, "");
    }


    public void saveGtouchHost(String host) {
        mSharedPreferences.edit().putString(TOUCH_HOST, host).commit();
    }

    public String getTouchHost() {
        return mSharedPreferences.getString(TOUCH_HOST, "https://messages.growingio.com");
    }

    public void saveImgOpenCnt(int cnt) {
        mSharedPreferences.edit().putInt(IMAGE_OPEN_CNT,cnt).commit();
    }

    public int getImgOpenCnt() {
        return mSharedPreferences.getInt(IMAGE_OPEN_CNT,1);
    }
}