//
//  TATSimpleAdViewController.swift
//  TATSwiftDemo
//
//  Created by zhen yang on 2021/2/1.
//

import UIKit
import TATMediaSDK

class TATSimpleAdViewController: UIViewController {
    
    /// 广告位类型
    var adtype : TATSimpleAdType!
    
    /// 广告位ID
    var slotId : String!
    /// 自定义的广告位ID
    var customSlotId : String!
    /// 悬浮升级时使用的属性，用于设置悬浮升级点击按钮距离屏幕某一角的距离
    var inset : UIEdgeInsets = UIEdgeInsets(top: CGFloat(NSNotFound), left: CGFloat(NSNotFound), bottom: CGFloat(NSNotFound), right: CGFloat(NSNotFound))
    /// 调用推啊SDK的配置对象，动态设置AppKey和AppSecret也在TATAdConfiguration中设置新的AppKey和AppSecret
    var adConfig : TATAdConfiguration?
    /// 广告位视图
    var adView : UIView?
    /// 是否自定义大小
    var useCustomSize : Bool = false
    /// 自定义大小的宽度
    var customWidth : CGFloat = 0
    /// 自定义大小的高度
    var customHeight : CGFloat = 0
    
    /// 自定义广告请求推啊接口后返回的自定义数据模型
    var customModel : TATCustomAdModel?
    
    func figureOutSlotId() -> Void {
        slotId = TATMediaManager.slotIdForType(adtype)
    }
    
    func showErrorAlert(error : Error) -> Void {
        let alert = UIAlertController(title: "提示", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle()
        self.view.backgroundColor = UIColor.init(red: 119.0/255.0, green: 211.0/255.0, blue: 220.0/255.0, alpha: 1.0)
        figureOutSlotId()
        self.inset = UIEdgeInsets(top: 50, left: CGFloat(NSNotFound), bottom: CGFloat(NSNotFound), right: 32)
        loadAd()
        self.view.addSubview(self.refreshButton)
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "配置", style: .plain, target: self, action: #selector(showInputParamsField))
        setupLocalUI()
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    required init(WithAdtype adtype : TATSimpleAdType) {
        super.init(nibName: nil, bundle: nil)
        self.adtype = adtype
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as! NSObject == refreshButton && keyPath == "frame" && localView.superview != nil {
            if let rectValue = change?[NSKeyValueChangeKey.newKey] as? CGRect {
                localView.frame = CGRect(x: 0, y: rectValue.maxY + 5, width: localView.frame.width, height: localView.frame.height)
                localOpenButton.frame = CGRect(x: (UIScreen.main.bounds.width - localOpenButton.frame.width) * 0.5, y: rectValue.maxY + 10, width: localOpenButton.frame.width, height: localOpenButton.frame.height)

            }
        }
    }
    // MARK:    -   点击事件
    @objc func tapAd() -> Void {
        
    }
    
    @objc func localOpenButtonDidOnClick() -> Void {
        localView.isHidden = false
        localOpenButton.isHidden = true
        slotId = customSlotId
    }
    
    @objc func localCloseButtonDidOnClick() -> Void {
        localView.isHidden = true
        localOpenButton.isHidden = false
        figureOutSlotId()
    }
    deinit {
        refreshButton.removeObserver(self, forKeyPath: "frame")
        print("控制器死了")
    }
    @objc func chooseLocalImage() -> Void {
        let photoVc = UIImagePickerController()
        photoVc.sourceType = .photoLibrary
        photoVc.delegate = self
        self.present(photoVc, animated: true, completion: nil)
    }
    
    @objc func loadAd() -> Void {
        switch self.adtype {
        case .banner:
            fallthrough
        case .thinBanner:
            fallthrough
        case .download:
            loadGenralAd()
        case .float:
            loadIconAd()
        case .custom:
            fetchCustomAd()
        case .interstitial:
            showInterstitialAd()
        case .launch:
            showLaunchAd()
        case .native:
            showNativeAd()
        case .infoFlow:
            loadInfoFlowView()
        case .textLink:
            loadTextLinkAd()
        case .floatUpgrade:
            showFloatUpgrade()
        default:
            return
        }
    }
    
    /// 展示弹窗
    @objc func showInputParamsField() -> Void {
        let needCustomAddConfig : Bool = (adtype == .banner || adtype == .float || adtype == .thinBanner || adtype == .launch || adtype == .interstitial)
        let alert = UIAlertController(title: "动态设置请求参数", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let slotId = alert.textFields?.first?.text {
                if slotId.count > 0 {
                    self.slotId = slotId
                    self.customSlotId = slotId
                }
                
            }
            if let appKey = alert.textFields?[1].text, let appSecret = alert.textFields?[2].text {
                if appKey.count > 0 && appSecret.count > 0 {
                    self.adConfig = TATAdConfiguration()
                    self.adConfig?.appKey = appKey
                    self.adConfig?.appSecret = appSecret
                } else {
                    self.setupAdConfiguration()
                }
            } else {
                self.setupAdConfiguration()
            }
            if needCustomAddConfig {
                if let width = alert.textFields?[3].text, let height = alert.textFields?[4].text {
                    self.customWidth = CGFloat(Float(width) ?? 0.0)
                    self.customHeight = CGFloat(Float(height) ?? 0.0)
                    self.useCustomSize = self.customHeight != 0.0 && self.customWidth != 0.0
                }
            }
            if self.adtype == .custom {
                if let imageUsageOption = alert.textFields?.last?.text {
                    if imageUsageOption == "0" {
                        self.adConfig?.needImageURL = false
                    } else {
                        self.adConfig?.needImageURL = true
                    }
                    
                } else {
                    self.adConfig?.needImageURL = false
                }
            } else if self.adtype == .floatUpgrade {
                var innerInset = self.inset
                if let top = alert.textFields?[3].text {
                    innerInset.top = CGFloat(Float(top) ?? 0.0)
                } else {
                    innerInset.top = CGFloat(NSNotFound);
                }
                if let left = alert.textFields?[4].text {
                    innerInset.left = CGFloat(Float(left) ?? 0.0)
                } else {
                    innerInset.left = CGFloat(NSNotFound);
                }
                if let bottom = alert.textFields?[5].text {
                    innerInset.bottom = CGFloat(Float(bottom) ?? 0.0)
                } else {
                    innerInset.bottom = CGFloat(NSNotFound);
                }
                if let right = alert.textFields?[6].text {
                    innerInset.right = CGFloat(Float(right) ?? 0.0)
                } else {
                    innerInset.right = CGFloat(NSNotFound);
                }
                self.inset = innerInset
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.loadAd()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addTextField { (textField) in
            textField.placeholder = "广告位ID"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "AppKey"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "AppSecret"
        }
        if needCustomAddConfig {
            alert.addTextField { (textField) in
                textField.keyboardType = .numberPad
                textField.placeholder = "广告位宽度(此处为物理尺寸)"
                if self.useCustomSize {
                    textField.text = "\(self.customWidth)"
                }
            }
            alert.addTextField { (textField) in
                textField.keyboardType = .numberPad
                textField.placeholder = "广告位高度(此处为物理尺寸)"
                if self.useCustomSize {
                    textField.text = "\(self.customHeight)"
                }
            }
        }
        if self.adtype == .custom {
            alert.addTextField { (textField) in
                textField.placeholder = "是否使用素材：0或1"
                textField.keyboardType = .numberPad
            }
        } else if self.adtype == .floatUpgrade {
            alert.addTextField { (textField) in
                textField.placeholder = "top"
                textField.keyboardType = .numberPad
            }
            alert.addTextField { (textField) in
                textField.placeholder = "left"
                textField.keyboardType = .numberPad
            }
            alert.addTextField { (textField) in
                textField.placeholder = "bottom"
                textField.keyboardType = .numberPad
            }
            alert.addTextField { (textField) in
                textField.placeholder = "right"
                textField.keyboardType = .numberPad
            }
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK:    -   懒加载
    lazy var imageView : UIImageView = {
        let imageView : UIImageView = UIImageView(frame: .zero)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAd))
        return imageView
    }()
    
    lazy var localView : UIView = {
        UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 306))
    }()
    
    /// 是否开启本地上传的按钮
    lazy var localOpenButton : UIButton = {
        let localOpenButton : UIButton = UIButton()
        localOpenButton.backgroundColor = UIColor.orange
        localOpenButton.layer.cornerRadius = 25.0
        localOpenButton.setTitle("开启本地上传", for: .normal)
        localOpenButton.addTarget(self, action: #selector(localOpenButtonDidOnClick), for: .touchUpInside)
        return localOpenButton
    }()
    
    /// 关闭本地上传的按钮
    lazy var localCloseButton : UIButton = {
        let localCloseButton : UIButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width - 65.0, y: 10.0, width: 50.0, height: 30.0))
        localCloseButton.backgroundColor = .darkGray
        localCloseButton.setTitle("关闭", for: .normal)
        localCloseButton.addTarget(self, action: #selector(localCloseButtonDidOnClick), for: .touchUpInside)
        return localCloseButton
    }()
    
    lazy var localImageView : UIImageView = {
        UIImageView()
    }()
    
    lazy var localImageButton : UIButton = {
        let originX : CGFloat = (UIScreen.main.bounds.size.width - 180.0) * 0.5
        let localImageButton = UIButton(frame: CGRect(x: originX, y: 0.0, width: 180.0, height: 40))
        localImageButton.backgroundColor = UIColor.orange
        localImageButton.layer.cornerRadius = 20.0
        localImageButton.setTitle("选择本地图片", for: .normal)
        localImageButton.addTarget(self, action: #selector(chooseLocalImage), for: .touchUpInside)
        return localImageButton
    }()

    lazy var localImageURLTextField : UITextField = {
        let localImageURLTextField  = UITextField(frame: CGRect(x: 15.0, y: localImageButton.frame.maxY + 5, width: UIScreen.main.bounds.width - 30, height: 35.0))
        localImageURLTextField.borderStyle = .roundedRect
        localImageURLTextField.allowsEditingTextAttributes = true
        localImageURLTextField.placeholder = "请输入原创图片服务器地址"
        return localImageURLTextField
    }()
    
    lazy var refreshButton : UIButton = {
        let originX = ( UIScreen.main.bounds.width - 100) * 0.5
        let refreshButton = UIButton(frame: CGRect(x: originX, y: 300, width: 100, height: 50))
        refreshButton.backgroundColor = UIColor.orange
        refreshButton.layer.cornerRadius = 25.0
        refreshButton.setTitle("刷新", for: .normal)
        refreshButton.addTarget(self, action: #selector(loadAd), for: .touchUpInside)
        refreshButton.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        return refreshButton
    }()
}

extension TATSimpleAdViewController {
    func setNavigationTitle() -> Void {
        switch adtype {
        case .thinBanner:
            title = "横幅广告"
        case .float:
            title = "icon广告"
        case .banner:
            title = "Banner广告"
        case .custom:
            title = "自定义广告"
        case .launch:
            title = "开屏广告"
        case .interstitial:
            title = "插屏广告"
        case .native:
            title = "原生插屏"
        case .textLink:
            title = "文字链"
        default:
            title = "未知"
        }
    }
    func setupLocalUI() -> Void {
        if adtype == .banner || adtype == .float || adtype == .thinBanner || adtype == .launch || adtype == .interstitial || adtype == .download {
            localView.addSubview(localImageView)
            localView.addSubview(localImageButton)
            localView.addSubview(localImageURLTextField)
            localView.addSubview(localCloseButton)
            localView.frame = CGRect(x: 0, y: 360, width: UIScreen.main.bounds.width, height: 305)
            view.addSubview(self.localView)
            localOpenButton.frame = CGRect(x: (UIScreen.main.bounds.width - 150) * 0.5, y: 360, width: 150, height: 50)
            view.addSubview(localOpenButton)
            localCloseButtonDidOnClick()
            
            // TODO: 明天需要完成的工作
        }
    }
    func setupAdConfiguration() -> Void {
        self.adConfig = TATAdConfiguration()
        self.adConfig?.appKey = TATMediaManager.appKey().appkey
        self.adConfig?.appSecret = TATMediaManager.appKey().appSecret
    }
}

// MARK:    使用TATMediaSDK的具体方法调用例子封装
extension TATSimpleAdViewController {
    
    /// 加载Banner 类型的广告示例代码
    func loadGenralAd() -> Void {
        if !localView.isHidden {
            adConfig?.localImage = localImageView.image
            adConfig?.localImageURL = localImageURLTextField.text
        } else {
            adConfig?.localImage = nil
            adConfig?.localImageURL = nil
        }
        let adView : TATBaseAdView = TATMediaCenter.initSimpleAd(withSlotId: self.slotId, configuration: adConfig) {[weak self] result,error in
            if result {
                guard let tmpSelf = self else {
                    return
                }
                guard let innerAdView = tmpSelf.adView else {
                    return
                }
                var frame = innerAdView.frame
                if let isUseCustomSize = self?.useCustomSize {
                    if isUseCustomSize {
                        frame.size = CGSize(width: tmpSelf.customWidth, height: tmpSelf.customHeight)
                    }
                }
                let originX = (UIScreen.main.bounds.width - frame.width) * 0.5
                frame.origin.x = originX
                frame.origin.y = 180
                innerAdView.frame = frame
                var buttonFrame = tmpSelf.refreshButton.frame
                buttonFrame.origin.y = frame.maxY + 30
                tmpSelf.refreshButton.frame = buttonFrame
            } else {
                if let realError = error {
                    self?.showErrorAlert(error: realError)
                }
            }
            
        }
        if let preAdView = self.adView {
            preAdView.removeFromSuperview()
        }
        self.view.addSubview(adView)
        self.adView = adView
    }
    
    
    /// 加载icon 类型的广告示例代码
    func loadIconAd() -> Void {
        if !localView.isHidden {
            adConfig?.localImage = localImageView.image
            adConfig?.localImageURL = localImageURLTextField.text
        } else {
            adConfig?.localImage = nil
            adConfig?.localImageURL = nil
        }
        let adView : TATBaseAdView = TATMediaCenter.initIconAd(withSlotId: self.slotId, configuration: adConfig) {[weak self] result,error in
            if result {
                guard let tmpSelf = self else {
                    return
                }
                guard let innerAdView = tmpSelf.adView else {
                    return
                }
                var frame = innerAdView.frame
                if let isUseCustomSize = self?.useCustomSize {
                    if isUseCustomSize {
                        frame.size = CGSize(width: tmpSelf.customWidth, height: tmpSelf.customHeight)
                    }
                }
                let originX = (UIScreen.main.bounds.width - frame.width) * 0.5
                frame.origin.x = originX
                frame.origin.y = 180
                innerAdView.frame = frame
                var buttonFrame = tmpSelf.refreshButton.frame
                buttonFrame.origin.y = frame.maxY + 30
                tmpSelf.refreshButton.frame = buttonFrame
            } else {
                if let realError = error {
                    self?.showErrorAlert(error: realError)
                }
            }
            
        }
        if let preAdView = self.adView {
            preAdView.removeFromSuperview()
        }
        self.view.addSubview(adView)
        self.adView = adView
    }
    
    /// 获取展示自定义广告
    func fetchCustomAd() -> Void {
        TATMediaCenter.fetchCustomAd(withSlotId: slotId, configuration: adConfig) {   [weak self] error, model in
            if let realError = error {
                self?.showErrorAlert(error: realError)
            } else {
                self?.customModel = model
                self?.displayCustomAd()
            }
        }
    }
    
    func displayCustomAd() -> Void {
        let adImage = UIImage(named: "custom_ad_placeholder")
        let adImageView = UIImageView(image: adImage)
        adImageView.isUserInteractionEnabled = true
        adImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(customAdClickAction)))
        view.addSubview(adImageView)
        
        var frame = adImageView.frame
        let originX = (UIScreen.main.bounds.width - frame.width) * 0.5
        frame.origin.x = originX
        frame.origin.y = 126
        adImageView.frame = frame
        
        var buttonFrame = self.refreshButton.frame
        buttonFrame.origin.y = frame.origin.y + frame.height + 30
        refreshButton.frame = buttonFrame
        
        if let preAdView = adView {
            preAdView.removeFromSuperview()
        }
        self.adView = adImageView
        
    }
    @objc func customAdClickAction() -> Void {
        
    }
    
    func showInterstitialAd() -> Void {
        if !localView.isHidden {
            adConfig?.localImage = localImageView.image
            adConfig?.localImageURL = localImageURLTextField.text
        } else {
            adConfig?.localImage = nil
            adConfig?.localImageURL = nil
        }
        let adView : TATBaseAdView = TATMediaCenter.showInterstitial(withSlotId: self.slotId, configuration: adConfig) { [weak self](result, error) in
            if let realError = error {
                self?.showErrorAlert(error: realError)
            }
        }
        adView.clickAdBlock = { (slotId : String?) -> Void in
            guard let hasSlotId = slotId else {
                return
            }
            let message = "点击广告位回调" + hasSlotId
            print(message)
        }
    }
    func showLaunchAd() -> Void {
        let launchConfig : TATLaunchAdConfiguration = TATLaunchAdConfiguration.default()
        if let adConfig = self.adConfig {
            launchConfig.appKey = adConfig.appKey
            launchConfig.appSecret = adConfig.appSecret
        }
        if !localView.isHidden {
            launchConfig.localImage = localImageView.image
            launchConfig.localImageURL = localImageURLTextField.text
        } else {
            launchConfig.localImage = nil
            launchConfig.localImageURL = nil
        }
        if useCustomSize {
            launchConfig.frame = CGRect(x: (UIScreen.main.bounds.width - customWidth) * 0.5, y: 0.0, width: customWidth, height: customHeight)
        }
        let adView = TATMediaCenter.showLaunchAd(withSlotId: slotId, configuration: launchConfig) { [weak self](result, error) in
            if let realError = error {
                self?.showErrorAlert(error: realError)
            }
        }
        adView?.clickAdBlock = {(slotId : String?) -> Void in
            guard let hasSlotId = slotId else {
                return
            }
            let message = "点击广告位回调" + hasSlotId
            print(message)
        }
    }
    
    func showNativeAd() -> Void {
        TATMediaCenter.showFullModeAd(withSlotId: self.slotId, configuration: self.adConfig) { [weak self](result, error) in
            if let realError = error {
                self?.showErrorAlert(error: realError)
            }
        }
    }
    
    func loadInfoFlowView() -> Void {
        let adView : TATBaseAdView = TATMediaCenter.initInfoFlowAd(withSlotId: self.slotId, configuration: self.adConfig as? TATInfoFlowAdConfiguration) { [weak self](result, error) in
            if result {
                guard let tmpSelf = self else {
                    return
                }
                guard let innerAdView = tmpSelf.adView else {
                    return
                }
                var frame = innerAdView.frame
                if let isUseCustomSize = self?.useCustomSize {
                    if isUseCustomSize {
                        frame.size = CGSize(width: tmpSelf.customWidth, height: tmpSelf.customHeight)
                    }
                }
                let originX = (UIScreen.main.bounds.width - frame.width) * 0.5
                frame.origin.x = originX
                frame.origin.y = 180
                innerAdView.frame = frame
                var buttonFrame = tmpSelf.refreshButton.frame
                buttonFrame.origin.y = frame.maxY + 30
                tmpSelf.refreshButton.frame = buttonFrame
            } else {
                if let realError = error {
                    self?.showErrorAlert(error: realError)
                }
            }
        }
        if let preAdView = self.adView {
            preAdView.removeFromSuperview()
        }
        self.view.addSubview(adView)
        self.adView = adView
    }
    
    func loadTextLinkAd() -> Void {
        let adView : TATBaseAdView = TATMediaCenter.initTextLinkAd(withSlotId: self.slotId) { [weak self](result, error) in
            if result {
                guard let tmpSelf = self else {
                    return
                }
                guard let innerAdView = tmpSelf.adView else {
                    return
                }
                var frame = innerAdView.frame
                if let isUseCustomSize = self?.useCustomSize {
                    if isUseCustomSize {
                        frame.size = CGSize(width: tmpSelf.customWidth, height: tmpSelf.customHeight)
                    }
                }
                let originX = (UIScreen.main.bounds.width - frame.width) * 0.5
                frame.origin.x = originX
                frame.origin.y = 180
                innerAdView.frame = frame
                var buttonFrame = tmpSelf.refreshButton.frame
                buttonFrame.origin.y = frame.maxY + 30
                tmpSelf.refreshButton.frame = buttonFrame
            } else {
                if let realError = error {
                    self?.showErrorAlert(error: realError)
                }
            }
        }
        if let preAdView = self.adView {
            preAdView.removeFromSuperview()
        }
        self.view.addSubview(adView)
        self.adView = adView
    }
    
    
    /// 悬浮升级接入
    func showFloatUpgrade() -> Void {
        let upgradeConfig : TATFloatUpgradeAdConfiguration = TATFloatUpgradeAdConfiguration()
        if let adConfig = self.adConfig {
            // 当需要动态切换AppKey和AppSecret时只需要在config中配置新的AppKey和AppSecret
            upgradeConfig.appKey = adConfig.appKey
            upgradeConfig.appSecret = adConfig.appSecret
        }
        // 设置悬浮升级按钮图标的布局，在Swift中请使用CGFloat(NSNotFound)替换OC中的TAT_FlOAT_UNDEFINED宏定义去设置那些不需要设置的边距，需要设置的边距请使用具体值去设置，可以使用，左上、左下，右上、右下的方式去设置悬浮按钮相对于屏幕所在的位置
        // 示例 UIEdgeInsets(top: 50, left: CGFloat(NSNotFound), bottom: CGFloat(NSNotFound), right: 32)  这个inset的意思是距离屏幕上面为50，距离屏幕右侧为32
        upgradeConfig.displayPosition = self.inset
        // 悬浮升级与控制器相关，整屏显示，需要传入当前显示悬浮升级所在的控制器。悬浮升级除了可点击的区域不影响页面其他手势
        upgradeConfig.parentViewController = self
        TATMediaCenter.showFloatAd(withSlotId: self.slotId, configuration: upgradeConfig) {[weak self] (result, error) in
            if let realError = error {
                self?.showErrorAlert(error: realError)
            }
        }
    }
}

extension TATSimpleAdViewController:UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var updateImage = info[UIImagePickerController.InfoKey.originalImage]
        if #available(iOS 11.0, *) {
            if let imageURL = info[UIImagePickerController.InfoKey.imageURL] {
                if let data = NSData(contentsOf: imageURL as! URL) {
                    var source = CGImageSourceCreateWithData(data as CFData, nil)
                    let count = CGImageSourceGetCount(source!)
                    var animatedImage : UIImage? = nil
                    if count <= 1 {
                        animatedImage = UIImage(data: data as Data, scale: UIScreen.main.scale)
                    } else {
                        var images : [UIImage] = []
                        var duration : Float = 0.0
                        for i in 0...count {
                            if let image = CGImageSourceCreateImageAtIndex(source!, i, nil) {
                                var frameDuration : Float = 0.1
                                let cfFrameProperties : CFDictionary? = CGImageSourceCopyPropertiesAtIndex(source!, i, nil)
                                let frameProperties = cfFrameProperties as! NSDictionary
                                let gifProperties : NSDictionary = frameProperties[kCGImagePropertyGIFDictionary as! NSString] as! NSDictionary
                                let delayTimeUnclampedProp = gifProperties[kCGImagePropertyGIFUnclampedDelayTime as! NSString]
                                if let tmp = delayTimeUnclampedProp as? NSNumber {
                                    frameDuration
                                     = tmp.floatValue
                                } else {
                                    if let delayTimeProp = gifProperties[kCGImagePropertyGIFDelayTime as! NSString] as? NSNumber {
                                        frameDuration = delayTimeProp.floatValue
                                    }
                                }
                                if frameDuration < 0.011 {
                                    frameDuration = 0.100
                                }
                                duration += frameDuration
                                images.append(UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: UIImage.Orientation.up))
                            }
                            if duration != 0.0 {
                                duration = 1.0 / 10.0 * Float(count)
                            }
                            let animatedImage = UIImage.animatedImage(with: images, duration: TimeInterval(duration))
                            updateImage = animatedImage
                        }
                    }
                    
                }
            }
        } else {
            
        }
        picker.dismiss(animated: true, completion: nil)
        if let image = updateImage as? UIImage {
            let originalSize = image.size
            let showWidth = 150.0 / originalSize.height * originalSize.width
            self.localImageView.image = image
            self.localImageView.frame = CGRect(x: 0.5 * (UIScreen.main.bounds.width - showWidth), y: self.localImageURLTextField.frame.maxY + 5, width: CGFloat(showWidth), height: 150.0)
        }
    }
}
