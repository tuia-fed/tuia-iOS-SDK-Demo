//
//  TATSlotIDManager.h
//  TATMediaSDKDemo
//
//  Created by wuleslie on 2019/12/31.
//  Copyright © 2019 wuleslie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TATSimpleAdType){
    TATSimpleAdTypeBanner, // Banner
    TATSimpleAdTypeFloat, // 浮窗广告
    TATSimpleAdTypeThinBanner, // 横幅
    TATSimpleAdTypeCustom, // 自定义
    TATSimpleAdTypeLaunch, // 启动页
    TATSimpleAdTypeInterstitial, // 插屏
};

@interface TATSlotIDManager : NSObject

+ (NSString *)slotIdForType:(TATSimpleAdType)type;

@end

NS_ASSUME_NONNULL_END
