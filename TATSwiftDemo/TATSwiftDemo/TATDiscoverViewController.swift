//
//  TATDiscoverViewController.swift
//  TATSwiftDemo
//
//  Created by zhen yang on 2021/2/1.
//

import UIKit
import TATMediaSDK
import WebKit
class TATDiscoverViewController: UIViewController {
    var webView : WKWebView?
    var bannerView : UIView?
    var floatView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 119.0/255.0, green: 211.0/255.0, blue: 220.0/255.0, alpha: 1.0)
        navigationItem.title = "发现"
        configWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showBannerAd()
        showFloatAd()
        
    }
    
    func configWebView() -> Void {
        self.webView = WKWebView(frame: CGRect.zero)
        let webURL  = URL(string: "https://book.douban.com")
        let webRequest = URLRequest(url: webURL!)
        self.webView?.load(webRequest)
        self.view.addSubview(self.webView!)
    }
    
    func showBannerAd() -> Void {
        let adView = TATMediaCenter.initSimpleAd(withSlotId: TATMediaManager.slotIdForType(.banner)) { [weak self](result, error) in
            if result {
                if var frame = self?.bannerView?.frame {
                    let originX = (UIScreen.main.bounds.width - frame.width) * 0.5
                    frame.origin.x = originX
                    frame.origin.y = 88 + 16
                    self?.bannerView?.frame = frame
                    self?.relayoutWebView()
                }
                
            }
        }
        self.bannerView?.removeFromSuperview()
        self.bannerView = nil
        self.view.addSubview(adView!)
        self.bannerView = adView
    }
    
    func showFloatAd() -> Void {
        let adView = TATMediaCenter.initSimpleAd(withSlotId: TATMediaManager.slotIdForType(.banner)) { [weak self](result, error) in
            if result {
                if var frame = self?.floatView?.frame {
                    let originX = (UIScreen.main.bounds.width - frame.width) * 0.5
                    frame.origin.x = originX
                    frame.origin.y = 88 + 16
                    self?.floatView?.frame = frame
                    self?.relayoutWebView()
                }
                
            }
        }
        self.floatView?.removeFromSuperview()
        self.floatView = nil
        self.view.addSubview(adView!)
        self.floatView = adView
    }
    
    func relayoutWebView() -> Void {
        if let maxY = self.bannerView?.frame.maxY {
            let originY = maxY + 16
            let frame = CGRect(x: 0, y: originY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - originY)
            self.webView?.frame = frame
        }
    }
}
