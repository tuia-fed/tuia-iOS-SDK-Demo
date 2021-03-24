//
//  TATSimpleAdViewController.m
//  TATMediaSDKDemo
//
//  Created by wuleslie on 2019/12/19.
//  Copyright © 2019 wuleslie. All rights reserved.
//

#import "TATSimpleAdViewController.h"
#import <TATMediaSDK/TATMediaSDK.h>
#import "TATUserManager.h"

@interface TATSimpleAdViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) TATSimpleAdType adType;
@property (nonatomic, copy) NSString *slotId;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, assign, getter=isUseCustomSize) BOOL useCustomSize;
@property (nonatomic, assign) CGFloat customWidth;
@property (nonatomic, assign) CGFloat customHeight;
@property (nonatomic, strong)UIView *localView;
@property (nonatomic, strong)UIButton *localOpenButton;
@property (nonatomic, strong)UIButton *localCloseButton;
@property (nonatomic, strong)UIImageView *localImageView;
@property (nonatomic, strong) UIButton *localImageButton;
@property (nonatomic, strong) UITextField *localImageURLTextField;
@property (nonatomic, strong)NSString *customSlotId;
@property (nonatomic, strong) UIView *adView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) TATAdConfiguration *adConfig;
@property (nonatomic, strong) TATCustomAdModel *customModel;
@property (nonatomic, assign) UIEdgeInsets inset;

@end

@implementation TATSimpleAdViewController

- (id)initWithAdType:(TATSimpleAdType)type {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.adType = type;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle];
    self.view.backgroundColor = [UIColor colorWithRed:119.0/255 green:211.0/255 blue:220.0/255 alpha:1.0]; // 61 162 132
    [self figureOutSlotId];
    [self loadAd];
    [self.view addSubview:self.refreshButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"配置" style:UIBarButtonItemStylePlain target:self action:@selector(showInputParamsField)];
    [self setupLocalUI];
}

- (void)setupLocalUI {
    if (self.adType == TATSimpleAdTypeBanner || self.adType == TATSimpleAdTypeFloat || self.adType == TATSimpleAdTypeThinBanner || self.adType == TATSimpleAdTypeLaunch || self.adType == TATSimpleAdTypeInterstitial || self.adType == TATSimpleAdTypeDownload) {
        [self.localView addSubview:self.localImageView];
        [self.localView addSubview:self.localImageButton];
        [self.localView addSubview:self.localImageURLTextField];
        [self.localView addSubview:self.localCloseButton];
        self.localView.frame = CGRectMake(0, 360, [UIScreen mainScreen].bounds.size.width, 305);
        [self.view addSubview:self.localView];
        self.localOpenButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 150) * .5, 360, 150, 50);
        [self.view addSubview:self.localOpenButton];
        [self localCloseButtonDidOnClick];
    }
}

- (void)setupAdConfiguration {
    self.adConfig = [[TATAdConfiguration alloc] init];
    self.adConfig.appKey = [TATMediaManager appKey];
    self.adConfig.appSecret = [TATMediaManager appSecret];
}

- (void)setNavigationTitle {
    switch (self.adType) {
        case TATSimpleAdTypeThinBanner:
            self.title = @"横幅广告";
            break;
        case TATSimpleAdTypeFloat:
            self.title = @"浮标广告";
            break;
        case TATSimpleAdTypeBanner:
            self.title = @"Banner广告";
            break;
        case TATSimpleAdTypeCustom:
            self.title = @"自定义广告";
            break;
        case TATSimpleAdTypeLaunch:
            self.title = @"开屏广告";
            break;
        case TATSimpleAdTypeInterstitial:
            self.title = @"插屏广告";
            break;
        case TATSimpleAdTypeNative:
            self.title = @"原生插屏";
            break;
        case TATSimpleAdTypeInfoFlow:
            self.title = @"信息流";
            break;
        default:
            break;
    }
}

- (void)figureOutSlotId {
    self.slotId = [TATMediaManager slotIdForType:self.adType];
}

#pragma mark - 加载广告

- (void)loadAd {
    switch (self.adType) {
        case TATSimpleAdTypeBanner:
        case TATSimpleAdTypeThinBanner:
        case TATSimpleAdTypeFloat:
        case TATSimpleAdTypeDownload:
            [self loadGeneralAd];
            break;
        case TATSimpleAdTypeCustom:
            [self fetchCustomAd];
            break;
        case TATSimpleAdTypeInterstitial:
            [self showInterstitialAd];
            break;
        case TATSimpleAdTypeLaunch:
            [self showLaunchAd];
            break;
        case TATSimpleAdTypeNative:
            [self showNativeAd];
            break;
        case TATSimpleAdTypeInfoFlow:
            [self loadInfoFlowView];
            break;
        case TATSimpleAdTypeTextLink:
            [self loadTextLinkAd];
            break;
        case TATSimpleAdTypeFloatUpgrade:
            [self showFloatUpgrade];
            break;
        default:
            break;
    }
}

- (void)loadGeneralAd {
    [self.adView removeFromSuperview];
    __weak __typeof(self)weakSelf = self;
    if (!self.localView.isHidden) {
        self.adConfig.localImage = self.localImageView.image;
        self.adConfig.localImageURL = self.localImageURLTextField.text;
    } else {
        self.adConfig.localImage = nil;
        self.adConfig.localImageURL = nil;
    }
    self.adView = [TATMediaCenter initSimpleAdWithSlotId:self.slotId configuration:self.adConfig resultBlock:^(BOOL result, NSError *error) {
        __strong __typeof(weakSelf)self = weakSelf;
        if (result) {
            CGRect frame = self.adView.frame;
            if (self.isUseCustomSize) {
                frame.size = CGSizeMake(self.customWidth, self.customHeight);
            }
            CGFloat originX = ([UIScreen mainScreen].bounds.size.width - frame.size.width) / 2;
            frame.origin.x = originX;
            frame.origin.y = 126;
            self.adView.frame = frame;
            CGRect buttonFrame = self.refreshButton.frame;
            buttonFrame.origin.y = frame.origin.y + frame.size.height + 30;
            self.refreshButton.frame = buttonFrame;
        } else {
            if (error) {
                [self showErrorAlert:error];
            }
        }
    }];
    TATBaseAdView *adView = (TATBaseAdView *)self.adView;
    adView.clickAdBlock = ^(NSString * _Nullable slotId) {
        NSLog(@"点击广告位回调:%@", slotId);
    };
    [self.view addSubview:adView];
}

- (void)showInterstitialAd {
    if (!self.localView.isHidden) {
        self.adConfig.localImage = self.localImageView.image;
        self.adConfig.localImageURL = self.localImageURLTextField.text;
    } else {
        self.adConfig.localImage = nil;
        self.adConfig.localImageURL = nil;
    }
    __weak __typeof(self)weakSelf = self;
    TATBaseAdView *adView = [TATMediaCenter showInterstitialWithSlotId:self.slotId configuration:self.adConfig resultBlock:^(BOOL result, NSError *error) {
        __strong __typeof(weakSelf)self = weakSelf;
        if (error) {
            [self showErrorAlert:error];
        }

    }];
    
    adView.clickAdBlock = ^(NSString * _Nullable slotId) {
        NSString *message = [NSString stringWithFormat:@"点击广告位回调:%@", slotId];
        NSLog(@"%@", message);
    };
}

- (void)showLaunchAd {
    TATLaunchAdConfiguration *launchConfig = [TATLaunchAdConfiguration defaultConfiguration];
    launchConfig.appKey = self.adConfig.appKey;
    launchConfig.appSecret = self.adConfig.appSecret;
    if (!self.localView.isHidden) {
        launchConfig.localImage = self.localImageView.image;
        launchConfig.localImageURL = self.localImageURLTextField.text;
    } else {
        self.adConfig.localImage = nil;
        self.adConfig.localImageURL = nil;
    }
    if (self.isUseCustomSize) {
        launchConfig.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - self.customWidth) * .5, 0, self.customWidth, self.customHeight);
    }
    __weak __typeof(self)weakSelf = self;
    TATBaseAdView *adView = [TATMediaCenter showLaunchAdWithSlotId:self.slotId configuration:launchConfig resultBlock:^(BOOL result, NSError *error) {
        __strong __typeof(weakSelf)self = weakSelf;
        if (error) {
            [self showErrorAlert:error];
        }
    }];
    
    adView.clickAdBlock = ^(NSString * _Nullable slotId) {
        NSString *message = [NSString stringWithFormat:@"点击广告位回调:%@", slotId];
        NSLog(@"%@", message);
    };
}

- (void)fetchCustomAd {
    __weak __typeof(self)weakSelf = self;
    [TATMediaCenter fetchCustomAdWithSlotId:self.slotId configuration:self.adConfig completion:^(NSError *error, TATCustomAdModel *model) {
        __strong __typeof(weakSelf)self = weakSelf;
        if (error) {
            [self showErrorAlert:error];
        } else {
            self.customModel = model;
            // 展示自己的广告入口素材
            [self displayCustomAd];
        }
    }];
}

- (void)displayCustomAd {
    // 加载自定义素材图标，并上报曝光事件
    UIImage *adImage = [UIImage imageNamed:@"custom_ad_placeholder"];
    UIImageView *adImageView = [[UIImageView alloc] initWithImage:adImage];
    adImageView.userInteractionEnabled = YES;
    [adImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customAdClickAction)]];
    [self.view addSubview:adImageView];
    
    CGRect frame = adImageView.frame;
    CGFloat originX = ([UIScreen mainScreen].bounds.size.width - frame.size.width) / 2;
    frame.origin.x = originX;
    frame.origin.y = 126;
    adImageView.frame = frame;
    
    CGRect buttonFrame = self.refreshButton.frame;
    buttonFrame.origin.y = frame.origin.y + frame.size.height + 30;
    self.refreshButton.frame = buttonFrame;
    
    [self.adView removeFromSuperview];
    self.adView = nil;
    self.adView = adImageView;
    
    // 上报曝光事件
    [TATMediaCenter reportExposureWithURL:self.customModel.exposureUrl];
}

- (void)customAdClickAction {
    // 上报用户点击事件
    [TATMediaCenter reportClickWithURL:self.customModel.clickUrl];
    // 拼接userId，也可以调用setUserId:接口，让SDK内部处理
    NSString *activityUrl = [self.customModel.activityUrl stringByAppendingString:@"&userId=129600"];
    // 推荐使用SDK提供的接口来加载活动
    [TATMediaCenter loadActivityURL:activityUrl slotId:self.slotId title:self.customModel.extTitle];
}

- (void)showNativeAd {
    __weak __typeof(self)weakSelf = self;
    [TATMediaCenter showFullModeAdWithSlotId:self.slotId configuration:self.adConfig resultBlock:^(BOOL result, NSError * _Nonnull error) {
        __strong __typeof(weakSelf)self = weakSelf;
        if (error) {
            [self showErrorAlert:error];
        }
    }];
}

- (void)loadInfoFlowView {
    TATInfoFlowAdConfiguration *infoFlowConfig = [TATInfoFlowAdConfiguration defaultConfiguration];
    infoFlowConfig.appKey = self.adConfig.appKey;
    infoFlowConfig.appSecret = self.adConfig.appSecret;
    [self.adView removeFromSuperview];
    __weak __typeof(self)weakSelf = self;
    self.adView = [TATMediaCenter initInfoFlowAdWithSlotId:self.slotId configuration:infoFlowConfig resultBlock:^(BOOL result, NSError *error) {
        __strong __typeof(weakSelf)self = weakSelf;
        if (result) {
            CGRect frame = self.adView.frame;
            CGFloat originX = ([UIScreen mainScreen].bounds.size.width - frame.size.width) / 2;
            frame.origin.x = originX;
            frame.origin.y = 126;
            self.adView.frame = frame;
            
            CGRect buttonFrame = self.refreshButton.frame;
            buttonFrame.origin.y = frame.origin.y + frame.size.height + 30;
            self.refreshButton.frame = buttonFrame;
        } else {
            if (error) {
                [self showErrorAlert:error];
            }

        }
    }];
        

    [self.view addSubview:self.adView];

}

- (void)loadTextLinkAd {
    [self.adView removeFromSuperview];
    __weak __typeof(self)weakSelf = self;
    self.adView = [TATMediaCenter initTextLinkAdWithSlotId:self.slotId resultBlock:^(BOOL result, NSError *error) {
        __strong __typeof(weakSelf)self = weakSelf;
        if (result) {
            CGRect frame = self.adView.frame;
            CGFloat originX = ([UIScreen mainScreen].bounds.size.width - frame.size.width) / 2;
            frame.origin.x = originX;
            frame.origin.y = 126;
            self.adView.frame = frame;
            
            CGRect buttonFrame = self.refreshButton.frame;
            buttonFrame.origin.y = frame.origin.y + frame.size.height + 30;
            self.refreshButton.frame = buttonFrame;
        } else {
            if (error) {
                [self showErrorAlert:error];
            }

        }
    }];
    [self.view addSubview:self.adView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.refreshButton && [keyPath isEqualToString:@"frame"]
        && self.localView.superview != nil) {
        id rectValue = change[NSKeyValueChangeNewKey];
        self.localView.frame = CGRectMake(0, CGRectGetMaxY([rectValue CGRectValue]) + 5, self.localView.frame.size.width, self.localView.frame.size.height);
        self.localOpenButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - self.localOpenButton.frame.size.width) * .5, CGRectGetMaxY([rectValue CGRectValue]) + 10, self.localOpenButton.frame.size.width, self.localOpenButton.frame.size.height);

    }
}

- (void)dealloc {
    [self.refreshButton removeObserver:self forKeyPath:@"frame"];
}

- (void)showFloatUpgrade {
    TATFloatUpgradeAdConfiguration *upgradeConfig = [TATFloatUpgradeAdConfiguration new];
    upgradeConfig.appKey = self.adConfig.appKey;
    upgradeConfig.appSecret = self.adConfig.appSecret;
    upgradeConfig.displayPosition = self.inset;
    upgradeConfig.parentViewController = self;
    
    [TATMediaCenter showFloatAdWithSlotId:self.slotId configuration:upgradeConfig resultBlock:^(BOOL result, NSError *error) {
        
    }];
}

- (void)showErrorAlert:(NSError *)error {
    NSString *message = error.userInfo[NSLocalizedDescriptionKey];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)chooseLocalImage {
    UIImagePickerController *photoVc = [[UIImagePickerController alloc] init];
    photoVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoVc.delegate = self;
    [self presentViewController:photoVc animated:YES completion:nil];
}

- (void)localCloseButtonDidOnClick {
    self.localView.hidden = YES;
    self.localOpenButton.hidden = NO;
    [self figureOutSlotId];
}

- (void)localOpenButtonDidOnClick {
    self.localView.hidden = NO;
    self.localOpenButton.hidden = YES;
    self.slotId = self.customSlotId;
}

#pragma mark    -   UIImagePickerControllerDelegate相册/相机处理逻辑
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *updateImage = info[UIImagePickerControllerOriginalImage];

    if (@available(iOS 11.0, *)) {
        NSString *imageURL = info[UIImagePickerControllerImageURL];
        NSData *data = [NSData dataWithContentsOfFile:imageURL];
        
        if (data) {
            CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
            
            size_t count = CGImageSourceGetCount(source);
            
            UIImage *animatedImage;
            
            if (count <= 1) {
                animatedImage = [[UIImage alloc] initWithData:data scale:[UIScreen mainScreen].scale];
            }
            else {
                NSMutableArray *images = [NSMutableArray array];
                
                NSTimeInterval duration = 0.0f;
                
                for (size_t i = 0; i < count; i++) {
                    CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
                    if (!image) {
                        continue;
                    }
                    
                    float frameDuration = 0.1f;
                    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, i, nil);
                    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
                    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
                    
                    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
                    if (delayTimeUnclampedProp) {
                        frameDuration = [delayTimeUnclampedProp floatValue];
                    }
                    else {
                        
                        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
                        if (delayTimeProp) {
                            frameDuration = [delayTimeProp floatValue];
                        }
                    }
                    
                    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
                    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
                    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
                    // for more information.
                    
                    if (frameDuration < 0.011f) {
                        frameDuration = 0.100f;
                    }
                    
                    CFRelease(cfFrameProperties);
                    
                    duration += frameDuration;
                    
                    [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
                    
                    CGImageRelease(image);
                }
                
                if (!duration) {
                    duration = (1.0f / 10.0f) * count;
                }
                
                animatedImage = [UIImage animatedImageWithImages:images duration:duration];
                updateImage = animatedImage;

            }
            
            CFRelease(source);
        }
    } else {
        // Fallback on earlier versions
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    CGSize originalSize = updateImage.size;
    CGFloat showWidth = 150.0f / originalSize.height * originalSize.width;
    self.localImageView.image = updateImage;
    self.localImageView.frame = CGRectMake(.5 * ([UIScreen mainScreen].bounds.size.width - showWidth), CGRectGetMaxY(self.localImageURLTextField.frame) + 5, showWidth, 150.0f);
}
- (void)showInputParamsField {
    BOOL needCustomAddConfig = self.adType == TATSimpleAdTypeBanner || self.adType == TATSimpleAdTypeFloat || self.adType == TATSimpleAdTypeThinBanner || self.adType == TATSimpleAdTypeLaunch;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"动态设置请求参数" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSString *slotId = alert.textFields.firstObject.text;
        NSString *appKey = alert.textFields[1].text;
        NSString *appSecret = alert.textFields[2].text;
        if (needCustomAddConfig) {
            NSString *width = alert.textFields[3].text;
            NSString *height = alert.textFields[4].text;
            if ([width length] && [height length]) {
                self.customWidth = [width floatValue];
                self.customHeight = [height floatValue];
                self.useCustomSize = YES;
            } else {
                self.useCustomSize = NO;
            }
        }
        if (slotId.length > 0) {
            self.slotId = slotId;
            self.customSlotId = slotId;
        }
        if (appKey.length > 0 && appSecret.length > 0) {
            self.adConfig = [[TATAdConfiguration alloc] init];
            self.adConfig.appKey = appKey;
            self.adConfig.appSecret = appSecret;
        } else {
            [self setupAdConfiguration];
        }
        if (self.adType == TATSimpleAdTypeCustom) {
            NSString *imageUsageOption = alert.textFields.lastObject.text;
            if ([imageUsageOption isEqualToString:@"0"]) {
                self.adConfig.needImageURL = NO;
            } else {
                self.adConfig.needImageURL = YES;
            }
        } else if (self.adType == TATSimpleAdTypeFloatUpgrade) {
            UIEdgeInsets inset = self.inset;
            inset.top = alert.textFields[3].text.length > 0 ? [alert.textFields[3].text floatValue] : TAT_FlOAT_UNDEFINED;
            inset.left = alert.textFields[4].text.length > 0 ? [alert.textFields[4].text floatValue] : TAT_FlOAT_UNDEFINED;
            inset.bottom = alert.textFields[5].text.length > 0 ? [alert.textFields[5].text floatValue] : TAT_FlOAT_UNDEFINED;
            inset.right = alert.textFields[6].text.length > 0 ? [alert.textFields[6].text floatValue] : TAT_FlOAT_UNDEFINED;
            self.inset = inset;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadAd];
        });
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        //响应事件
        NSLog(@"action = %@", alert.textFields);
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"广告位ID";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"AppKey";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"AppSecret";
    }];
    if (needCustomAddConfig) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.placeholder = @"广告位宽度(此处为物理尺寸)";
            if (self.isUseCustomSize) {
                textField.text = [NSString stringWithFormat:@"%.0f", self.customWidth];
            }
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.placeholder = @"广告位高度(此处为物理尺寸)";
            if (self.isUseCustomSize) {
                textField.text = [NSString stringWithFormat:@"%.0f", self.customHeight];
            }
        }];
    }
    
    if (self.adType == TATSimpleAdTypeCustom) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"是否使用素材：0或1";
        }];
    } else if (self.adType == TATSimpleAdTypeFloatUpgrade) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"top";
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"left";
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"bottom";
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"right";
        }];
    }
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Getters
- (UIView *)localView {
    if (!_localView) {
        _localView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 305)];
    }
    return _localView;
}

- (UIButton *)localOpenButton {
    if (!_localOpenButton) {
        _localOpenButton = [[UIButton alloc] init];
        _localOpenButton.backgroundColor = [UIColor orangeColor];
        _localOpenButton.layer.cornerRadius = 25.0;
        [_localOpenButton setTitle:@"开启本地上传" forState:UIControlStateNormal];
        [_localOpenButton addTarget:self action:@selector(localOpenButtonDidOnClick) forControlEvents:(UIControlEventTouchUpInside)];

    }
    return _localOpenButton;
}

- (UIButton *)localCloseButton {
    if (!_localCloseButton) {
        _localCloseButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 65, 10, 50, 30)];
        _localCloseButton.backgroundColor = [UIColor darkGrayColor];
        [_localCloseButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_localCloseButton addTarget:self action:@selector(localCloseButtonDidOnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _localCloseButton;
}

- (UIImageView *)localImageView {
    if (!_localImageView) {
        _localImageView = [[UIImageView alloc] init];

    }
    return _localImageView;
}

- (UITextField *)localImageURLTextField {
    if (!_localImageURLTextField) {
        _localImageURLTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.localImageButton.frame) + 5, [UIScreen mainScreen].bounds.size.width - 30, 35)];
        _localImageURLTextField.borderStyle = UITextBorderStyleRoundedRect;
        _localImageURLTextField.allowsEditingTextAttributes = YES;
        _localImageURLTextField.placeholder = @"请输入原创图片服务器地址";
    }
    return _localImageURLTextField;
}

- (UIButton *)localImageButton {
    if (!_localImageButton) {
        CGFloat originX = ([UIScreen mainScreen].bounds.size.width - 180) / 2;
        _localImageButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, 180, 40)];
        _localImageButton.backgroundColor = [UIColor orangeColor];
        _localImageButton.layer.cornerRadius = 20.0;
        [_localImageButton setTitle:@"选择本地图片" forState:UIControlStateNormal];
        [_localImageButton addTarget:self action:@selector(chooseLocalImage) forControlEvents:UIControlEventTouchUpInside];

    }
    return _localImageButton;
}

- (UIButton *)refreshButton {
    if (!_refreshButton) {
        CGFloat originX = ([UIScreen mainScreen].bounds.size.width - 100) / 2;
        _refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, 300, 100, 50)];
        _refreshButton.backgroundColor = [UIColor orangeColor];
        _refreshButton.tag = TATSimpleAdTypeFloat;
        _refreshButton.layer.cornerRadius = 25.0;
        [_refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
        [_refreshButton addTarget:self action:@selector(loadAd) forControlEvents:UIControlEventTouchUpInside];
        [_refreshButton addObserver:self forKeyPath:@"frame" options:(NSKeyValueObservingOptionNew) context:nil];

    }
    return _refreshButton;
}

@end
