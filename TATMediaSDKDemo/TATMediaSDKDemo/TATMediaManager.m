//
//  TATMediaManager.m
//  TATMediaSDKDemo
//
//  Created by wuleslie on 2019/12/31.
//  Copyright © 2019 wuleslie. All rights reserved.
//

#import "TATMediaManager.h"

NSString *const kEnvTypeKey = @"kEnvTypeKey";
NSString *const kEnvNameKey = @"kTATEnvNameKey";
NSString *const kSlotNameListKey = @"kSlotNameListKey";
NSString *const kSlotTypeListKey = @"kSlotTypeListKey";

@implementation TATMediaManager

+ (NSString *)slotIdForType:(TATSimpleAdType)type {
    return [[TATMediaManager slotIdInfo] objectForKey:@(type)];
}

+ (NSDictionary *)slotIdInfo {
    return @{@(TATSimpleAdTypeThinBanner): @"323777", @(TATSimpleAdTypeBanner): @"323778", @(TATSimpleAdTypeFloat): @"323779", @(TATSimpleAdTypeCustom): @"331868", @(TATSimpleAdTypeLaunch): @"323775", @(TATSimpleAdTypeInterstitial): @"323776", @(TATSimpleAdTypeDownload): @"326629",
        @(TATSimpleAdTypeNative): @"325021",
        @(TATSimpleAdTypeNative): @"331981",
        @(TATSimpleAdTypeNative): @"325613",
        @(TATSimpleAdTypeInfoFlow): @"331035"};
}

+ (NSDictionary *)slotDataDictionary {
    NSDictionary *slotIdInfo = [TATMediaManager slotIdInfo];
    if (!slotIdInfo) {
        return nil;
    }
    NSMutableArray *nameList = [NSMutableArray array];
    NSMutableArray *typeList = [NSMutableArray array];
    for (NSNumber *key in slotIdInfo.allKeys) {
        NSString *title = nil;
        switch ([key integerValue]) {
            case TATSimpleAdTypeBanner:
                title = @"Banner";
                break;
            case TATSimpleAdTypeThinBanner:
                title = @"横幅";
                break;
            case TATSimpleAdTypeFloat:
                title = @"浮标";
                break;
            case TATSimpleAdTypeLaunch:
                title = @"开屏";
                break;
            case TATSimpleAdTypeCustom:
                title = @"自定义";
                break;
            case TATSimpleAdTypeInterstitial:
                title = @"插屏";
                break;
            case TATSimpleAdTypeDownload:
                title = @"下载";
                break;
            case TATSimpleAdTypeNative:
                title = @"原生插屏";
                break;
            case TATSimpleAdTypeInfoFlow:
                title = @"信息流";
                break;
            default:
                break;
        }
        if (title) {
            title = [NSString stringWithFormat:@"%@:%@",title, slotIdInfo[key]];
            [nameList addObject:title];
            [typeList addObject:key];
        }
    }
    if (nameList && typeList) {
        return @{kSlotNameListKey: nameList, kSlotTypeListKey: typeList};
    } else {
        return nil;
    }
}


+ (TATEnvType)envType {
    id env = [[NSUserDefaults standardUserDefaults] objectForKey:kEnvTypeKey];
    return [env integerValue];
}

+ (NSString *)appKey {
    switch ([TATMediaManager envType]) {
        case TATEnvTypePublish:
            return @"4UycwwZv41rwzne1ZXgtQBgDSnPH";
        case TATEnvTypePre:
            return @"3qKwty87tP6VxztdZB3CWnT5aNty";
        case TATEnvTypeTest:
            return @"427wTcUcwxkttDmGcqYMTU7NJo3k";
        case TATEnvTypeDev:
            return @"ctPo3s2hpcHx4HtGhBwqcdLvDnj";
        default:
            return nil;
    }
}

+ (NSString *)appSecret {
    switch ([TATMediaManager envType]) {
        case TATEnvTypePublish:
            return @"3WpyTLfifQyGhvgivxtUjvzXxtkzdceETBU2n5g";
        case TATEnvTypePre:
            return @"3WimkJ3GDAPKrD2o8xBGczJTdtDA9qLs2R4qAhQ";
        case TATEnvTypeTest:
            return @"3Wfp5DiA5jqVaUZ8CMkJemWopxefsBxtwm6mk67";
        case TATEnvTypeDev:
            return @"JwNQpF9wyRvskgj8ARk6H4rKDq4ZA159VSVJj";

        default:
            return nil;
    }
}


@end
