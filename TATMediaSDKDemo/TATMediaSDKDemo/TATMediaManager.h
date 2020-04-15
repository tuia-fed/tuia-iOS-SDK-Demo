//
//  TATMediaManager.h
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
    TATSimpleAdTypeInterstitial, // 插屏s
    TATSimpleAdTypeDownload, // 下载类横幅
    TATSimpleAdTypeNative, // 原生插屏
    TATSimpleAdTypeInfoFlow, // 信息流
};

typedef NS_ENUM(NSUInteger, TATEnvType){
    TATEnvTypePublish = 1, // 发布
    TATEnvTypePre, // 预发
    TATEnvTypeTest, // 测试
    TATEnvTypeDev, // 开发
};

extern NSString *const kEnvTypeKey;
extern NSString *const kEnvNameKey;

extern NSString *const kSlotNameListKey;
extern NSString *const kSlotTypeListKey;

@interface TATMediaManager : NSObject

+ (NSString *)appKey;
+ (NSString *)appSecret;

+ (NSString *)slotIdForType:(TATSimpleAdType)type;
+ (NSDictionary *)slotDataDictionary;

@end

NS_ASSUME_NONNULL_END
