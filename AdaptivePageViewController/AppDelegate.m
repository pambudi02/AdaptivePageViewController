//
//  AppDelegate.m
//  AdaptivePageViewController
//
//  Created by Pambudi on 25/11/20.
//

#import "AppDelegate.h"
#import "PageViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    PageViewController *vc = [PageViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = nav;
    [window makeKeyAndVisible];
    self.window = window;
    
    for (UIScene* scene in UIApplication.sharedApplication.connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene* windowScene = (UIWindowScene*) scene;
            windowScene.sizeRestrictions.minimumSize = CGSizeMake(600, 400);
        }
    }
    
    return YES;
}

@end
