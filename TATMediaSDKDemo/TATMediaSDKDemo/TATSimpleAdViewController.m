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

@interface TATSimpleAdViewController ()

@property (nonatomic, assign) TATSimpleAdType adType;
@property (nonatomic, copy) NSString *slotId;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UIView *adView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) TATAdConfiguration *adConfig;

@end

@implementation TATSimpleAdViewController

- (id)initWithAdType:(TATSimpleAdType)type {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.adType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle];
    self.view.backgroundColor = [UIColor colorWithRed:119.0/255 green:211.0/255 blue:220.0/255 alpha:1.0]; // 61 162 132
    [self figureOutSlotId];
    [self loadAd];
    [self.view addSubview:self.refreshButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"配置" style:UIBarButtonItemStylePlain target:self action:@selector(showInputParamsField)];
    
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
        default:
            break;
    }
}

- (void)figureOutSlotId {
    self.slotId = [TATMediaManager slotIdForType:self.adType];
}

- (void)loadGeneralAd {
    __weak __typeof(self)weakSelf = self;
    __block TATBaseAdView *adView = [TATMediaCenter initSimpleAdWithSlotId:self.slotId configuration:self.adConfig resultBlock:^(BOOL result, NSError *error) {
        if (result) {
            __strong __typeof(weakSelf)self = weakSelf;
            CGRect frame = adView.frame;
            CGFloat originX = ([UIScreen mainScreen].bounds.size.width - frame.size.width) / 2;
            frame.origin.x = originX;
            frame.origin.y = 126;
            adView.frame = frame;
            
            CGRect buttonFrame = self.refreshButton.frame;
            buttonFrame.origin.y = frame.origin.y + frame.size.height + 30;
            self.refreshButton.frame = buttonFrame;
        } else {
            if (error) {
                [self showErrorAlert:error];
            }

        }
    }];
    
    adView.clickAdBlock = ^(NSString * _Nullable slotId) {
        NSString *message = [NSString stringWithFormat:@"点击广告位回调:%@", slotId];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
        });
    };
    
    [self.adView removeFromSuperview];
    self.adView = nil;
    [self.view addSubview:adView];
    self.adView = adView;
}

- (void)loadNativeAd {
    __weak __typeof(self)weakSelf = self;
    __block TATBaseAdView *adView = [TATMediaCenter initEmbedAdWithSlotId:self.slotId loadingOption:NO resultBlock:^(BOOL result, NSError * _Nonnull error) {
        __strong __typeof(weakSelf)self = weakSelf;
        if (result) {
            CGRect frame = adView.frame;
            CGFloat originX = ([UIScreen mainScreen].bounds.size.width - frame.size.width) / 2;
            frame.origin.x = originX;
            frame.origin.y = 126;
            adView.frame = frame;
            
            CGRect buttonFrame = self.refreshButton.frame;
            buttonFrame.origin.y = frame.origin.y + frame.size.height + 30;
            self.refreshButton.frame = buttonFrame;
        } else {
            
        }
    }];
    [self.adView removeFromSuperview];
    self.adView = nil;
    [self.view addSubview:adView];
    self.adView = adView;
}

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
        default:
            break;
    }
}

- (void)showInterstitialAd {
    TATBaseAdView *adView = [TATMediaCenter showInterstitialWithSlotId:self.slotId configuration:self.adConfig resultBlock:^(BOOL result, NSError *error) {
        if (error) {
            [self showErrorAlert:error];
        }

    }];
    
    adView.clickAdBlock = ^(NSString * _Nullable slotId) {
        NSString *message = [NSString stringWithFormat:@"点击广告位回调:%@", slotId];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[self presentViewController:alert animated:YES completion:nil];
        });
    };
}

- (void)showLaunchAd {
    TATLaunchAdConfiguration *launchConfig = [TATLaunchAdConfiguration defaultConfiguration];
    launchConfig.appKey = self.adConfig.appKey;
    launchConfig.appSecret = self.adConfig.appSecret;
    TATBaseAdView *adView = [TATMediaCenter showLaunchAdWithSlotId:self.slotId configuration:launchConfig resultBlock:^(BOOL result, NSError *error) {
        if (error) {
            [self showErrorAlert:error];
        }
    }];
    
    adView.clickAdBlock = ^(NSString * _Nullable slotId) {
        NSString *message = [NSString stringWithFormat:@"点击广告位回调:%@", slotId];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[self presentViewController:alert animated:YES completion:nil];
        });
    };
}

- (void)fetchCustomAd {
    [TATMediaCenter fetchCustomAdWithSlotId:self.slotId configuration:self.adConfig completion:^(NSError *error, TATCustomAdModel *model) {
        if (error) {
            [self showErrorAlert:error];
        } else {
            NSString *activityUrl = [model.activityUrl stringByAppendingString:@"&userId=129600"];
            [TATMediaCenter loadActivityURL:activityUrl slotId:self.slotId title:model.extTitle];
            
            NSString *message = [NSString stringWithFormat:@"activityUrl=%@ & imageUrl=%@ & extTitle=%@ & extDesc=%@", model.activityUrl, model.imageUrl, model.extTitle, model.extDesc];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"自定义广告返回" message:message preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];

        }
    }];
}

- (void)showNativeAd {
    self.adConfig.needLoading = NO;

    [TATMediaCenter showFullModeAdWithSlotId:self.slotId configuration:self.adConfig resultBlock:^(BOOL result, NSError * _Nonnull error) {
        if (error) {
            [self showErrorAlert:error];
        }
    }];
}

- (void)loadInfoFlowView {
    __weak __typeof(self)weakSelf = self;
    __block TATBaseAdView *adView = [TATMediaCenter initInfoFlowAdWithSlotId:self.slotId configuration:self.adConfig resultBlock:^(BOOL result, NSError *error) {
        if (result) {
            __strong __typeof(weakSelf)self = weakSelf;
            CGRect frame = adView.frame;
            CGFloat originX = ([UIScreen mainScreen].bounds.size.width - frame.size.width) / 2;
            frame.origin.x = originX;
            frame.origin.y = 126;
            adView.frame = frame;
            
            CGRect buttonFrame = self.refreshButton.frame;
            buttonFrame.origin.y = frame.origin.y + frame.size.height + 30;
            self.refreshButton.frame = buttonFrame;
        } else {
            if (error) {
                [self showErrorAlert:error];
            }

        }
    }];
        
    [self.adView removeFromSuperview];
    self.adView = nil;
    [self.view addSubview:adView];
    self.adView = adView;

}

- (void)showErrorAlert:(NSError *)error {
    NSString *message = error.userInfo[NSLocalizedDescriptionKey];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showInputParamsField {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"动态设置请求参数" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSString *slotId = alert.textFields.firstObject.text;
        NSString *appKey = alert.textFields[1].text;
        NSString *appSecret = alert.textFields[2].text;
        if (slotId.length > 0) {
            self.slotId = slotId;
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
    if (self.adType == TATSimpleAdTypeCustom) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"是否使用素材：0或1";
        }];
    }
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
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
    }
    return _refreshButton;
}

@end
