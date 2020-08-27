//
//  TATDiscoverViewController.m
//  TATMediaSDKDemo
//
//  Created by wuleslie on 2019/12/19.
//  Copyright © 2019 wuleslie. All rights reserved.
//

#import "TATDiscoverViewController.h"
#import <TATMediaSDK/TATMediaSDK.h>
#import "TATUserManager.h"
#import "TATMediaManager.h"
@import WebKit;

@interface TATDiscoverViewController ()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *bannerView;
@property (nonatomic, strong) UIView *floatView;

@end

@implementation TATDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:119.0/255 green:211.0/255 blue:220.0/255 alpha:1.0]; // 61 162 132
    self.navigationItem.title = @"发现";
    [self configWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showBannerAd];
    [self showFloatAd];
}

- (void)showBannerAd {
    [self.bannerView removeFromSuperview];
    __weak typeof(self)weakself = self;
    self.bannerView = [TATMediaCenter initSimpleAdWithSlotId:[TATMediaManager slotIdForType:TATSimpleAdTypeBanner] resultBlock:^(BOOL result, NSError *error) {
        if (result) {
            __strong typeof(weakself)self = weakself;
            CGRect frame = self.bannerView.frame;
            CGFloat originX = ([UIScreen mainScreen].bounds.size.width - frame.size.width) / 2;
            frame.origin.x = originX;
            frame.origin.y = 88 + 16;
            self.bannerView.frame = frame;
            [self relayoutWebView];
        } else {
            
        }
    }];
    [self.view addSubview:self.bannerView];
}

- (void)configWebView {
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    // self.webView.navigationDelegate = self;
    NSURL *webURL = [NSURL URLWithString: @"https://book.douban.com"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:webURL]];
    [self.view addSubview:self.webView];
}

- (void)relayoutWebView {
    CGFloat originY = CGRectGetMaxY(self.bannerView.frame) + 16;
    CGRect frame = CGRectMake(0, originY, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - originY);
    self.webView.frame = frame;
}

- (void)showFloatAd {
    [self.floatView removeFromSuperview];

    self.floatView = [TATMediaCenter initSimpleAdWithSlotId:[TATMediaManager slotIdForType:TATSimpleAdTypeFloat] resultBlock:^(BOOL result, NSError *error) {
        if (result) {
            CGRect frame = self.floatView.frame;
            CGFloat originX = ([UIScreen mainScreen].bounds.size.width - frame.size.width) - 16;
            frame.origin.x = originX;
            frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height - 116;
            self.floatView.frame = frame;
        } else {
            
        }
    }];
    [self.view addSubview:self.floatView];
}


@end
