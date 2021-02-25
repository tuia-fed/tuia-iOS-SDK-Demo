//
//  TATUserManager.swift
//  TATSwiftDemo
//
//  Created by zhen yang on 2021/2/1.
//

import UIKit
let kUserIdKey : String = "kUserIdKey"
let kDeviceIdKey : String = "kDeviceIdKey"

class TATUserManager: NSObject {

    var userId : String?
    var deviceId : String?
    
    static let sharedInstance = TATUserManager()
    override init() {
        userId = UserDefaults.standard.string(forKey: kUserIdKey)
        deviceId = UserDefaults.standard.string(forKey: kDeviceIdKey)
    }
    func setUserId(_ userId : String) -> Void {
        self.userId = userId
        let userDefaults = UserDefaults.standard
        userDefaults.set(userId, forKey: kUserIdKey)
        userDefaults.synchronize()
    }
    
    func setDeviceId(_ deviceId : String) -> Void {
        self.deviceId = deviceId
        let userDefaults = UserDefaults.standard
        userDefaults.set(deviceId, forKey: kDeviceIdKey)
        userDefaults.synchronize()
    }
}
