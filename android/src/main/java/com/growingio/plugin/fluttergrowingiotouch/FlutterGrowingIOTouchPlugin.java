package com.growingio.plugin.fluttergrowingiotouch;

import android.util.Log;

import com.growingio.android.sdk.common.log.Logger;
import com.growingio.android.sdk.gtouch.GTouchManager;
import com.growingio.android.sdk.gtouch.GrowingTouch;
import com.growingio.android.sdk.gtouch.listener.EventPopupListener;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterGrowingIOTouchPlugin
 */
public class FlutterGrowingIOTouchPlugin implements MethodCallHandler, EventChannel.StreamHandler {
    private static final String TAG = "FlutterGTouchPlugin";
    private static final String METHOD_CHANNEL = "flutter_growingio_touch_method_channel";
    private static final String EVENT_CHANNEL = "flutter_growingio_touch_event_channel";

    private EventChannel.EventSink mEventSink;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        FlutterGrowingIOTouchPlugin touchPlugin = new FlutterGrowingIOTouchPlugin();

        final MethodChannel channel = new MethodChannel(registrar.messenger(), METHOD_CHANNEL);
        channel.setMethodCallHandler(touchPlugin);

        final EventChannel eventChannel = new EventChannel(registrar.messenger(), EVENT_CHANNEL);
        eventChannel.setStreamHandler(touchPlugin);
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
        } else if ("setEventPopupListener".equals(call.method)) {
            GTouchManager.getInstance().getTouchConfig().setEventPopupListener(new FlutterEventPopupListener());
            result.success(null);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        Logger.d(TAG, "register eventSink");
        mEventSink = eventSink;
    }

    @Override
    public void onCancel(Object o) {

    }

    private final class FlutterEventPopupListener implements EventPopupListener {
        @Override
        public void onLoadSuccess(String eventId, String eventType) {
            Logger.e(TAG, "onLoadSuccess: eventId = " + eventId + ", eventType = " + eventType);
            if (mEventSink != null) {
                HashMap<String, String> data = new HashMap<>();
                data.put("method", "onLoadSuccess");
                data.put("eventId", eventId);
                data.put("eventType", eventType);
                mEventSink.success(data);
            }
        }

        @Override
        public void onLoadFailed(String eventId, String eventType, int errorCode, String description) {
            Logger.e(TAG, "onLoadFailed: eventId = " + eventId + ", eventType = " + eventType);
            if (mEventSink != null) {
                HashMap<String, Object> data = new HashMap<>();
                data.put("method", "onLoadFailed");
                data.put("eventId", eventId);
                data.put("eventType", eventType);
                data.put("errorCode", errorCode);
                data.put("description", description);
                mEventSink.success(data);
            }

        }

        @Override
        public boolean onClicked(String eventId, String eventType, String openUrl) {
            Logger.e(TAG, "onClicked: eventId = " + eventId + ", eventType = " + eventType + ", openUrl = " + openUrl);
            if (mEventSink != null) {
                HashMap<String, String> data = new HashMap<>();
                data.put("method", "onClicked");
                data.put("eventId", eventId);
                data.put("eventType", eventType);
                data.put("openUrl", openUrl);
                mEventSink.success(data);
                return true;
            }
            return false;
        }

        @Override
        public void onCancel(String eventId, String eventType) {
            Logger.e(TAG, "onCancel: eventId = " + eventId + ", eventType = " + eventType);
            if (mEventSink != null) {
                HashMap<String, String> data = new HashMap<>();
                data.put("method", "onCancel");
                data.put("eventId", eventId);
                data.put("eventType", eventType);
                mEventSink.success(data);
            }
        }

        @Override
        public void onTimeout(String eventId, String eventType) {
            Logger.e(TAG, "onTimeout: eventId = " + eventId + ", eventType = " + eventType);
            if (mEventSink != null) {
                HashMap<String, String> data = new HashMap<>();
                data.put("method", "onTimeout");
                data.put("eventId", eventId);
                data.put("eventType", eventType);
                mEventSink.success(data);
            }
        }
    }
}
