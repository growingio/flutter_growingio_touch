package com.growingio.plugin.flutter_growingio_touch_example;

import com.growingio.android.sdk.collection.Configuration;
import com.growingio.android.sdk.collection.GrowingIO;
import com.growingio.android.sdk.gtouch.GrowingTouch;
import com.growingio.android.sdk.gtouch.config.GTouchConfig;

import io.flutter.app.FlutterApplication;

public class MyFlutterApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();

        GrowingIO.startWithConfiguration(this, new Configuration()
                .setTestMode(false)
                .setDebugMode(false));

        GrowingTouch.startWithConfig(this, new GTouchConfig()
                .setEventPopupShowTimeout(5000)
                .setEventPopupEnable(false)
                .setUploadExceptionEnable(false)
                .setDebugEnable(BuildConfig.DEBUG));
    }
}
