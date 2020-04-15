//
//  TATUserManager.m
//  TATMediaSDKDemo
//
//  Created by wuleslie on 2019/12/24.
//  Copyright © 2019 wuleslie. All rights reserved.
//

#import "TATUserManager.h"
#import <TATMediaSDK/TATMediaSDK.h>

static NSString *const kUserIdKey = @"kUserIdKey";
static NSString *const kDeviceIdKey = @"kDeviceIdKey";

@implementation TATUserManager

+ (instancetype)sharedInstance {
    static dispatch_once_t predict;
    static TATUserManager *instance = nil;
    dispatch_once(&predict, ^{
        if (!instance) {
            instance = [[TATUserManager alloc] init];
        }
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserIdKey];
        if (userId) {
            self.userId = userId;
        } else {
            self.userId = @"190026";
        }
        NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceIdKey];
        if (deviceId) {
            self.deviceId = deviceId;
        }
    }
    return self;
}

- (void)setUserId:(NSString *)userId {
    _userId = userId;
    if (userId) {
        [[NSUserDefaults standardUserDefaults]  setObject:userId forKey:kUserIdKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [TATMediaCenter setUserId:userId];
}

- (void)setDeviceId:(NSString *)deviceId {
    _deviceId = deviceId;
    if (deviceId) {
        [[NSUserDefaults standardUserDefaults]  setObject:deviceId forKey:kDeviceIdKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [TATMediaCenter setDeviceId:deviceId];
}

@end
