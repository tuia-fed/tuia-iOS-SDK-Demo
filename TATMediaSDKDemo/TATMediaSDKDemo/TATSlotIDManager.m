//
//  TATSlotIDManager.m
//  TATMediaSDKDemo
//
//  Created by wuleslie on 2019/12/31.
//  Copyright © 2019 wuleslie. All rights reserved.
//

#import "TATSlotIDManager.h"

static inline NSDictionary *TATSlotIdInfo() {
    return @{@(TATSimpleAdTypeThinBanner): @"321995", @(TATSimpleAdTypeBanner): @"321997", @(TATSimpleAdTypeFloat): @"321998", @(TATSimpleAdTypeCustom): @"322001", @(TATSimpleAdTypeLaunch): @"322000", @(TATSimpleAdTypeInterstitial): @"321994"};
}

@implementation TATSlotIDManager

+ (NSString *)slotIdForType:(TATSimpleAdType)type {
    return [TATSlotIdInfo() objectForKey:@(type)];
}

@end
