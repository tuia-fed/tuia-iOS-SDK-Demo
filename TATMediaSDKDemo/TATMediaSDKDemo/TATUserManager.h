//
//  TATUserManager.h
//  TATMediaSDKDemo
//
//  Created by wuleslie on 2019/12/24.
//  Copyright © 2019 wuleslie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TATUserManager : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *deviceId;

+ (instancetype)sharedInstance;

@end

