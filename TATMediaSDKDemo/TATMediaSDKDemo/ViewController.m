//
//  ViewController.m
//  TATMediaSDKDemo
//
//  Created by wuleslie on 2019/11/28.
//  Copyright © 2019 wuleslie. All rights reserved.
//

#import "ViewController.h"
#import <TATMediaSDK/TATMediaSDK.h>
#import "TATSimpleAdViewController.h"
#import "TATSlotIDManager.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *interstitialButton;
@property (nonatomic, strong) UIButton *customButton;
@property (nonatomic, strong) UIButton *bannerButton;
@property (nonatomic, strong) UIButton *thinBannerButton;
@property (nonatomic, strong) UIButton *floatButton;
@property (nonatomic, strong) UIButton *launchButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:119.0/255 green:211.0/255 blue:220.0/255 alpha:1.0]; // 61 162 132
    self.navigationItem.title = @"入口";
    [self.view addSubview:self.thinBannerButton];
    [self.view addSubview:self.floatButton];
    [self.view addSubview:self.bannerButton];
    [self.view addSubview:self.interstitialButton];
    [self.view addSubview:self.customButton];
    [self.view addSubview:self.launchButton];
    [self layoutButtons];
}

- (void)layoutButtons {
    NSArray *buttons = @[self.thinBannerButton, self.floatButton, self.bannerButton, self.interstitialButton, self.customButton, self.launchButton];
    CGFloat buttonWidth = 126;
    CGFloat buttonHeight = 50;
    CGFloat screenWith = self.view.bounds.size.width;
    CGFloat gapX = screenWith > 375 ? 60 : 40;
    CGFloat gapY = 32;
    CGFloat startX = (screenWith - 2 * buttonWidth - gapX) / 2;
    CGFloat startY = 120;
    for (int i = 0; i < buttons.count; i++) {
        int row = i / 2;
        int column = i % 2;
        CGFloat originX = startX + (buttonWidth + gapX) * column;
        CGFloat originY = startY + (buttonHeight + gapY) *row;
        UIButton *button = buttons[i];
        button.frame = CGRectMake(originX, originY, buttonWidth, buttonHeight);
    }
}

- (void)showInterstitialAd {
    [TATMediaCenter showInterstitialWithSlotId:[TATSlotIDManager slotIdForType:TATSimpleAdTypeInterstitial] resultBlock:^(BOOL result, NSError *error) {
        
    } closeBlock:^{
        
    }];
}

- (void)showLaunchAd {
    [TATMediaCenter showLaunchAdWithSlotId:[TATSlotIDManager slotIdForType:TATSimpleAdTypeLaunch] resultBlock:^(BOOL result, NSError *error) {
           
       }];
}

- (void)fetchCustomAd {
    [TATMediaCenter fetchCustomAdWithSlotId:[TATSlotIDManager slotIdForType:TATSimpleAdTypeCustom] completion:^(NSError *error, TATCustomAdModel *model) {
        
    }];
}

- (void)gotoAdVCWithType:(UIButton *)button {
    TATSimpleAdViewController *vc = [[TATSimpleAdViewController alloc] initWithAdType:button.tag];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)presentAdVCWithType:(UIButton *)button {
    TATSimpleAdViewController *vc = [[TATSimpleAdViewController alloc] initWithAdType:button.tag];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Getters

- (UIButton *)thinBannerButton {
    if (!_thinBannerButton) {
        _thinBannerButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 126, 50)];
        _thinBannerButton.backgroundColor = [UIColor orangeColor];
        _thinBannerButton.tag = TATSimpleAdTypeThinBanner;
        _thinBannerButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_thinBannerButton setTitle:@"横幅:323777" forState:UIControlStateNormal];
        [_thinBannerButton addTarget:self action:@selector(gotoAdVCWithType:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _thinBannerButton;
}

- (UIButton *)bannerButton {
    if (!_bannerButton) {
        _bannerButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 126, 50)];
        _bannerButton.backgroundColor = [UIColor orangeColor];
        _bannerButton.tag = TATSimpleAdTypeBanner;
        _bannerButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_bannerButton setTitle:@"Banner:323778" forState:UIControlStateNormal];
        [_bannerButton addTarget:self action:@selector(gotoAdVCWithType:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bannerButton;
}

- (UIButton *)floatButton {
    if (!_floatButton) {
        _floatButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 300, 126, 50)];
        _floatButton.backgroundColor = [UIColor orangeColor];
        _floatButton.tag = TATSimpleAdTypeFloat;
        _floatButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_floatButton setTitle:@"浮标:323779" forState:UIControlStateNormal];
        [_floatButton addTarget:self action:@selector(gotoAdVCWithType:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _floatButton;
}

- (UIButton *)interstitialButton {
    if (!_interstitialButton) {
        _interstitialButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 400, 126, 50)];
        _interstitialButton.backgroundColor = [UIColor orangeColor];
        _interstitialButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _interstitialButton.exclusiveTouch = YES;
        [_interstitialButton setTitle:@"插屏:323776" forState:UIControlStateNormal];
        [_interstitialButton addTarget:self action:@selector(showInterstitialAd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _interstitialButton;
}

- (UIButton *)customButton {
    if (!_customButton) {
        _customButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 500, 126, 50)];
        _customButton.backgroundColor = [UIColor orangeColor];
        _customButton.tag = TATSimpleAdTypeCustom;
        _customButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_customButton setTitle:@"自定义:323807" forState:UIControlStateNormal];
        [_customButton addTarget:self action:@selector(gotoAdVCWithType:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customButton;
}

- (UIButton *)launchButton {
    if (!_launchButton) {
        _launchButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 500, 126, 50)];
        _launchButton.backgroundColor = [UIColor orangeColor];
        _launchButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_launchButton setTitle:@"开屏:323775" forState:UIControlStateNormal];
        [_launchButton addTarget:self action:@selector(showLaunchAd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _launchButton;
}

@end
