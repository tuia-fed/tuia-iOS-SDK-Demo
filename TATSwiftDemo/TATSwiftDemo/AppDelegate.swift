//
//  AppDelegate.swift
//  TATSwiftDemo
//
//  Created by zhen yang on 2021/1/26.
//

import UIKit
import TATMediaSDK
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        test()
        if nil == UserDefaults.standard.value(forKey: kEnvTypeKey) {
            TATMediaManager.setEnvType(.publish)
        }
        initRootView()
        let _ = TATUserManager.sharedInstance
        let appInfo = TATMediaManager.appKey()
        TATMediaCenter.start(withAppKey: appInfo.appkey, appSecret: appInfo.appSecret)
        let config = TATLaunchAdConfiguration()
        config.sourceType = .screen
        config.waitDuration = 0
        config.showDuration = -1
        config.frame = CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 180.0)
        TATMediaCenter.showLaunchAd(withSlotId: TATMediaManager .slotIdForType(.launch)!, configuration: config) { (result, error) in
            
        }
        return true
    }

    func test() -> Void {
        NSSetUncaughtExceptionHandler { (exception) in
            let callStackSymbols = exception.callStackSymbols
            guard let packageName = Bundle.main.infoDictionary?["CFBundleExecutable"] else {
                return
            }
            for symbol in callStackSymbols {
//                if symbol.contains(packageName as! String.Element) {
//                    
//                    break
//                }
            }
            let name = exception.name
            let reason = exception.reason
            print("Exception name:\(name)\nException reason:\(String(describing: reason))\nException stack:\(callStackSymbols)")

            
            
        }
    }
    
    func initRootView() -> Void {
        let tabBarController : UITabBarController = UITabBarController()
        let homePageVC : ViewController = ViewController()
        let homeNavi : UINavigationController = UINavigationController(rootViewController: homePageVC)
        homeNavi.tabBarItem = UITabBarItem(title: "首页", image: UIImage(named: "tabbar_hd"), tag: 1)
        let discoverVC : TATDiscoverViewController = TATDiscoverViewController()
        let discoverNavi : UINavigationController = UINavigationController(rootViewController: discoverVC)
        discoverNavi.tabBarItem = UITabBarItem(title: "发现", image: UIImage(named: "tabbar_dt"), tag: 2)
        let settingVC : TATSettingViewController = TATSettingViewController()
        let settingNavi : UINavigationController = UINavigationController(rootViewController: settingVC)
        settingNavi.tabBarItem = UITabBarItem(title: "设置", image: UIImage(named: "tabbar_me"), tag: 3)
        tabBarController.viewControllers = [homeNavi, discoverNavi, settingNavi]
        window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    
}

