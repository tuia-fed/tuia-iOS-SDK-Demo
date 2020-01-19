//
//  AppDelegate.m
//  TATMediaSDKDemo
//
//  Created by wuleslie on 2019/11/28.
//  Copyright © 2019 wuleslie. All rights reserved.
//

#import "AppDelegate.h"
#import <TATMediaSDK/TATMediaSDK.h>
#import "ViewController.h"
#import "TATSlotIDManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [TATMediaCenter setUserId:@"2020126"];
    [TATMediaCenter startWithAppKey:@"RFH45U9e2mEpKxq2BHg6VqQm6HA" appSecret:@"3WoqJ6MwUZCMEtSgUojW8E4X2KCirUv4EgLhTLQ"];
    #if defined(DEBUG)
    [TATMediaCenter setLogEnable:YES];
    #else
    [TATMediaCenter setLogEnable:NO];
    #endif
    
    [TATMediaCenter showLaunchAdWithSlotId:[TATSlotIDManager slotIdForType:TATSimpleAdTypeLaunch] resultBlock:^(BOOL result, NSError *error) {
        
    } closeBlock:^(BOOL isClosedByUser) {
        
    }];
    [self initRootView];
    return YES;
}

- (void)initRootView {
    ViewController *homepageVC = [[ViewController alloc] init];
    UINavigationController *homeNavi = [[UINavigationController alloc] initWithRootViewController:homepageVC];
    self.window.rootViewController = homeNavi;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
