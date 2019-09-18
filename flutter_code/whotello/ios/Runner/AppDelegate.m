#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  // Add the following line, with your API key
  [GMSServices provideAPIKey: @"AIzaSyAQWx1eRnf-RtNX7e26lBskWycowfD-p-Q"];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
