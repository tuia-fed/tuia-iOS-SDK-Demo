//
//  TATMediaManager.swift
//  TATSwiftDemo
//
//  Created by zhen yang on 2021/1/29.
//

import UIKit

/// 环境
enum TATEnvType : String {
    case publish = "publish"
    case pre = "pre"
    case test = "test"
    case dev = "dev"
}

/// 广告位类型
enum TATSimpleAdType : String {
    /// 广告位banner类型
    case banner = "banner"
    /// 广告位float类型
    case float = "float"
    case thinBanner = "thinBanner"
    case custom = "custom"
    case launch = "launch"
    case interstitial = "interstitial"
    case download = "download"
    case native = "native"
    case infoFlow = "infoFlow"
    case textLink = "textLink"
    case floatUpgrade = "floatUpgrade"
}

let kEnvTypeKey = "kEnvTypeKey"
let kEnvNameKey = "kTATEnvNameKey"


class TATMediaManager: NSObject {
    
    class func slotIdForType(_ type : TATSimpleAdType) -> String? {
        guard let info = self.slotIdInfo() else {
            return nil
        }
        return info[type]
    }
    
    class func slotIdInfo() -> [TATSimpleAdType : String]? {
        return [
            .thinBanner : "323777",
            .banner : "323778",
            .float : "323779",
            .custom : "331868",
            .launch :  "323775",
            .interstitial : "323776",
            .download : "326629",
            .native : "325021",
            .infoFlow : "331035",
            .floatUpgrade : "364648",
            .textLink : "347174"
        ]
//        switch self.envType() {
//        case .publish:
//            return [
//                .thinBanner : "323777",
//                .banner : "323778",
//                .float : "323779",
//                .custom : "331868",
//                .launch :  "323775",
//                .interstitial : "323776",
//                .download : "326629",
//                .native : "325021",
//                .infoFlow : "331035",
//                .floatUpgrade : "364648",
//                .textLink : "347174"
//            ]
//        case .pre:
//            return [
//                .thinBanner : "323777",
//                .banner : "323778",
//                .float : "323779",
//                .custom : "331868",
//                .launch :  "323775",
//                .interstitial : "323776",
//                .download : "326629",
//                .native : "325021",
//                .infoFlow : "331035",
//                .floatUpgrade : "364648"
//            ]
//        case .test:
//            return [
//                .thinBanner : "283553",
//                .banner : "283554",
//                .float : "284164",
//                .custom : "283557",
//                .launch :  "283556",
//                .interstitial : "283552",
//                .native : "283691",
//                .infoFlow : "283693",
//                .floatUpgrade : "284086",
//                .textLink : "283894"
//            ]
//        case .dev:
//            return [
//                .thinBanner : "292980",
//                .banner : "292980",
//                .float : "292980",
//                .custom : "292980",
//                .launch :  "292980",
//                .interstitial : "292980"
//            ]
//        default:
//            return [
//                .thinBanner : "323777",
//                .banner : "323778",
//                .float : "323779",
//                .custom : "331868",
//                .launch :  "323775",
//                .interstitial : "323776",
//                .download : "326629",
//                .native : "325021",
//                .infoFlow : "331035",
//                .floatUpgrade : "364648"
//            ]
//        }
    }
    
    class func slotDataDictionary() -> [(name : String, slotID : String)]? {
        guard let slotIdInfo = self.slotIdInfo() else {
            return nil
        }
        var list = [(name : String, slotID : String)]()
        for key in slotIdInfo.keys {
            var title : String?
            switch key
            
            {
            case .banner:
                title = "Banner"
            case .thinBanner:
                title = "横幅"
            case .float:
                title = "icon"
            case .launch:
                title = "开屏"
            case .custom:
                title = "自定义"
            case .interstitial:
                title = "插屏"
            case .download:
                title = "下载"
            case .native:
                title = "原生插屏"
            case .infoFlow:
                title = "信息流"
            case .textLink:
                title = "文字链"
            case .floatUpgrade:
                title = "悬浮升级"
            default:
                title = nil
            }
            if let realTitle = title {
                list.append((name: realTitle + ":" + (slotIdInfo[key] ?? ""), slotID: key.rawValue))
            }
        }
        return list
        
    }
    
    class func envType() -> TATEnvType? {
        return TATEnvType(rawValue: UserDefaults.standard.string(forKey: kEnvTypeKey)!)
    }
    
    /// 获取默认的AppKey和AppSecret
    /// - Returns: 包含AppKey和AppSecret的元组
    class func appKey() -> (appkey : String,appSecret : String) {
        return ("4UycwwZv41rwzne1ZXgtQBgDSnPH", "3WpyTLfifQyGhvgivxtUjvzXxtkzdceETBU2n5g")

    }
    
    class func setEnvType(_ type : TATEnvType) -> Void {
        UserDefaults.standard.set(type.rawValue, forKey: kEnvTypeKey)
        UserDefaults.standard.synchronize()
    }
    

    
    
    
}
