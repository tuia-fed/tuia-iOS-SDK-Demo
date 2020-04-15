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
#import "TATDiscoverViewController.h"
#import "TATSettingViewController.h"
#import "TATUserManager.h"
#import "TATMediaManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [TATUserManager sharedInstance];
    [TATMediaCenter startWithAppKey:[TATMediaManager appKey] appSecret:[TATMediaManager appSecret]];
    #if defined(DEBUG)
    [TATMediaCenter setLogEnable:YES];
    #else
    [TATMediaCenter setLogEnable:NO];
    #endif
    // [TATMediaCenter showLaunchAdWithSlotId:[TATMediaManager slotIdForType:TATSimpleAdTypeLaunch] resultBlock:nil];
    TATLaunchAdConfiguration *config = [TATLaunchAdConfiguration defaultConfiguration];
    config.sourceType = TATLaunchSourceTypeScreen;
    config.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height - 180);
    [TATMediaCenter showLaunchAdWithSlotId:[TATMediaManager slotIdForType:TATSimpleAdTypeLaunch] configuration:config resultBlock:^(BOOL result, NSError *error) {
        
    }];
    [self initRootView];
    
    [TATMediaCenter sharedInstance].rewardHandler = ^(NSString * _Nullable rewardJson) {
        NSString *message = [NSString stringWithFormat:@"激励发奖回调:%@", rewardJson];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    };
    [TATMediaCenter sharedInstance].closeHandler = ^(NSString * _Nullable closeJson) {
        NSString *message = [NSString stringWithFormat:@"激励关闭回调:%@", closeJson];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];

    };
    
    [TATMediaCenter sharedInstance].closeH5Block = ^(NSString * _Nullable slotId){
        NSString *message = [NSString stringWithFormat:@"关闭活动页回调:%@", slotId];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    };
    return YES;
}

- (void)initRootView {
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    ViewController *homepageVC = [[ViewController alloc] init];
    UINavigationController *homeNavi = [[UINavigationController alloc] initWithRootViewController:homepageVC];
    homeNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"tabbar_hd"] tag:1];
    TATDiscoverViewController *discoverVC = [[TATDiscoverViewController alloc] init];
    UINavigationController *discoverNavi = [[UINavigationController alloc] initWithRootViewController:discoverVC];
    discoverNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"tabbar_dt"] tag:2];
    TATSettingViewController *settingVC = [[TATSettingViewController alloc] init];
    settingVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"tabbar_me"] tag:3];
    tabBarController.viewControllers = @[homeNavi, discoverNavi, settingVC];
    self.window.rootViewController = tabBarController;
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
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
    }];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate");
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"time"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
