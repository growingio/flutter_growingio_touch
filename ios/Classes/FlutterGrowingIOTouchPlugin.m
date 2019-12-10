#import "FlutterGrowingIOTouchPlugin.h"
#import <GrowingTouchCoreKit/GrowingTouchCoreKit.h>
#import <WebKit/WebKit.h>

static NSString *const GIO_FLUTTER_TOUCH_METHOD_CHANNEL = @"flutter_growingio_touch_method_channel";
static NSString *const GIO_FLUTTER_TOUCH_EVENT_CHANNEL = @"flutter_growingio_touch_event_channel";

static NSString *const GIO_TOUCH_SET_EVENTPOPUP_ENABLE = @"setEventPopupEnable";
static NSString *const GIO_TOUCH_IS_EVENTPOPUP_ENABLED = @"isEventPopupEnabled";
static NSString *const GIO_TOUCH_ENABLE_EVENTPOPUP_GENERATE_APPOPEN = @"enableEventPopupAndGenerateAppOpenEvent";
static NSString *const GIO_TOUCH_IS_EVENTPOPUP_SHOWING = @"isEventPopupShowing";
static NSString *const GIO_TOUCH_SET_EVENTPOPUP_LISTENER = @"setEventPopupListener";

static NSString *const GIO_TOUCH_METHOD_SUCCESS = @"onLoadSuccess";
static NSString *const GIO_TOUCH_METHOD_FAILED = @"onLoadFailed";
static NSString *const GIO_TOUCH_METHOD_CLICK = @"onClicked";
static NSString *const GIO_TOUCH_METHOD_CANCEL = @"onCancel";
static NSString *const GIO_TOUCH_METHOD_TIMEOUT = @"onTimeout";

static NSString *const GIO_TOUCH_METHOD = @"method";
static NSString *const GIO_TOUCH_EVENTID = @"eventId";
static NSString *const GIO_TOUCH_EVENTTYPE = @"eventType";
static NSString *const GIO_TOUCH_ERRORCODE = @"errorCode";
static NSString *const GIO_TOUCH_DESCRIPTION = @"description";
static NSString *const GIO_TOUCH_OPENURL = @"openUrl";

@interface FlutterGrowingIOTouchPlugin () <GrowingTouchEventPopupDelegate, FlutterStreamHandler, WKNavigationDelegate>

@property (nonatomic, copy) FlutterEventSink eventSink;

@end

@implementation FlutterGrowingIOTouchPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

  FlutterGrowingIOTouchPlugin* instance = [[FlutterGrowingIOTouchPlugin alloc] init];

  //    methodChannel
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:GIO_FLUTTER_TOUCH_METHOD_CHANNEL
            binaryMessenger:[registrar messenger]];
  [registrar addMethodCallDelegate:instance channel:channel];
  //    eventChannel
  FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:GIO_FLUTTER_TOUCH_EVENT_CHANNEL binaryMessenger:[registrar messenger]];
  [eventChannel setStreamHandler:instance];
       
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

  if ([GIO_TOUCH_SET_EVENTPOPUP_ENABLE isEqualToString:call.method]) {
      if (![call.arguments isKindOfClass:NSNumber.class] && ![call.arguments isKindOfClass:NSString.class]) {
          return;
      }
     [GrowingTouch setEventPopupEnable:[call.arguments boolValue]];
    
  } else if ([GIO_TOUCH_IS_EVENTPOPUP_ENABLED isEqualToString:call.method]) {

      result([NSNumber numberWithBool:[GrowingTouch isEventPopupEnabled]]);
    
   } else if ([GIO_TOUCH_ENABLE_EVENTPOPUP_GENERATE_APPOPEN isEqualToString:call.method]) {

        [GrowingTouch enableEventPopupAndGenerateAppOpenEvent];
       
    } else if ([GIO_TOUCH_IS_EVENTPOPUP_SHOWING isEqualToString:call.method]) {

        result([NSNumber numberWithBool: [GrowingTouch isEventPopupShowing]]);
    } else if ([GIO_TOUCH_SET_EVENTPOPUP_LISTENER isEqualToString:call.method]) {
        //  监听弹窗事件
        [GrowingTouch setEventPopupDelegate:self];
        
    } else {

        result(FlutterMethodNotImplemented);
    }

}

#pragma mark - <FlutterStreamHandler>
// // 这个onListen是Flutter端开始监听这个channel时的回调，第二个参数 EventSink是用来传数据的载体。
- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    
    if (events) {
        self.eventSink = events;
    }
    return nil;
}

/// flutter不再接收
- (FlutterError*)onCancelWithArguments:(id)arguments {
  
    self.eventSink = nil;
    return nil;
}

#pragma mark - GrowingTouchEventPopupDelegate
- (void)onEventPopupLoadSuccess:(NSString *)trackEventId eventType:(NSString *)eventType {
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:GIO_TOUCH_METHOD_SUCCESS forKey:GIO_TOUCH_METHOD];
    [dataDic setValue:trackEventId forKey:GIO_TOUCH_EVENTID];
    [dataDic setValue:eventType forKey:GIO_TOUCH_EVENTTYPE];
    if (self.eventSink) {
        self.eventSink(dataDic);
    }
    
}

- (void)onEventPopupLoadFailed:(NSString *)trackEventId eventType:(NSString *)eventType withError:(NSError *)error {
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:GIO_TOUCH_METHOD_FAILED forKey:GIO_TOUCH_METHOD];
    [dataDic setValue:trackEventId forKey:GIO_TOUCH_EVENTID];
    [dataDic setValue:eventType forKey:GIO_TOUCH_EVENTTYPE];
    [dataDic setValue:error.localizedDescription forKey:GIO_TOUCH_DESCRIPTION];
    [dataDic setValue:[NSNumber numberWithInteger:error.code] forKey:GIO_TOUCH_ERRORCODE];
    if (self.eventSink) {
        self.eventSink(dataDic);
    }
    
}

- (BOOL)onClickedEventPopup:(NSString *)trackEventId eventType:(NSString *)eventType openUrl:(NSString *)openUrl {
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:GIO_TOUCH_METHOD_CLICK forKey:GIO_TOUCH_METHOD];
    [dataDic setValue:trackEventId forKey:GIO_TOUCH_EVENTID];
    [dataDic setValue:eventType forKey:GIO_TOUCH_EVENTTYPE];
    [dataDic setValue:openUrl forKey:GIO_TOUCH_OPENURL];
    if (self.eventSink) {
        self.eventSink(dataDic);
        return YES;
    } else {
        return NO;
    }
}

- (void)onCancelEventPopup:(NSString *)trackEventId eventType:(NSString *)eventType {
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:GIO_TOUCH_METHOD_CANCEL forKey:GIO_TOUCH_METHOD];
    [dataDic setValue:trackEventId forKey:GIO_TOUCH_EVENTID];
    [dataDic setValue:eventType forKey:GIO_TOUCH_EVENTTYPE];
    if (self.eventSink) {
        self.eventSink(dataDic);
    }
}

- (void)onTrackEventTimeout:(NSString *)trackEventId eventType:(NSString *)eventType {
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:GIO_TOUCH_METHOD_TIMEOUT forKey:GIO_TOUCH_METHOD];
    [dataDic setValue:trackEventId forKey:GIO_TOUCH_EVENTID];
    [dataDic setValue:eventType forKey:GIO_TOUCH_EVENTTYPE];
    if (self.eventSink) {
        self.eventSink(dataDic);
    }
}



@end
