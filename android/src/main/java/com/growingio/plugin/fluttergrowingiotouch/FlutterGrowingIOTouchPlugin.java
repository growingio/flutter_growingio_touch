package com.growingio.plugin.fluttergrowingiotouch;

import android.util.Log;

import com.growingio.android.sdk.gtouch.GrowingTouch;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterGrowingIOTouchPlugin
 */
public class FlutterGrowingIOTouchPlugin implements MethodCallHandler {
    private static final String TAG = "FlutterGTouchPlugin";

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_growingio_touch");
        channel.setMethodCallHandler(new FlutterGrowingIOTouchPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if ("setEventPopupEnable".equals(call.method)) {
            if (call.arguments() != null && call.arguments() instanceof Boolean) {
                GrowingTouch.setEventPopupEnable((Boolean) call.arguments());
            } else {
                Log.e(TAG, "onMethodCall: setEventPopupEnable arguments is ERROR");
            }
            result.success(null);
        } else if ("isEventPopupEnabled".equals(call.method)) {
            result.success(GrowingTouch.isEventPopupEnabled());
        } else if ("enableEventPopupAndGenerateAppOpenEvent".equals(call.method)) {
            GrowingTouch.enableEventPopupAndGenerateAppOpenEvent();
            result.success(null);
        } else if ("isEventPopupShowing".equals(call.method)) {
            result.success(GrowingTouch.isEventPopupShowing());
        } else {
            result.notImplemented();
        }
    }
}
