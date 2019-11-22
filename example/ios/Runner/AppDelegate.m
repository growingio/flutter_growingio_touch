#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "Growing.h"
#import <GrowingTouchKit/GrowingTouchKit.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  
  [Growing startWithAccountId:@"97fd6815651f25fb"];
 
  [GrowingTouch start];
  [GrowingTouch setDebugEnable:YES];
  [GrowingTouch setEventPopupEnable:YES];
 


  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([Growing handleUrl:url])
    {
        return YES;
    }
    return NO;
}

//- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
//    [Growing handleUrl:userActivity.webpageURL];
//       return YES;
//}


@end
