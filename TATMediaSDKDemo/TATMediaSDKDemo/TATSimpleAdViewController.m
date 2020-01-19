//
//  TATSimpleAdViewController.m
//  TATMediaSDKDemo
//
//  Created by wuleslie on 2019/12/19.
//  Copyright © 2019 wuleslie. All rights reserved.
//

#import "TATSimpleAdViewController.h"
#import <TATMediaSDK/TATMediaSDK.h>

@interface TATSimpleAdViewController ()

@property (nonatomic, assign) TATSimpleAdType adType;
@property (nonatomic, copy) NSString *slotId;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UIView *adView;
@property (nonatomic, strong) UIImageView *imageView;

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
        default:
            break;
    }
}

- (void)figureOutSlotId {
    self.slotId = [TATSlotIDManager slotIdForType:self.adType];
}

- (void)loadGeneralAd {
    __weak __typeof(self)weakSelf = self;
    __block UIView *adView = [TATMediaCenter initSimpleAdWithSlotId:self.slotId resultBlock:^(BOOL result, NSError *error) {
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
            
        }
    }];
    [self.adView removeFromSuperview];
    self.adView = nil;
    [self.view addSubview:adView];
    self.adView = adView;
}

- (void)loadCustomAd {
    [TATMediaCenter fetchCustomAdWithSlotId:self.slotId completion:^(NSError *error, TATCustomAdModel *model) {
        if (!error && model) {
        }
    }];
}

- (void)loadAd {
//    if (self.adType == TATSimpleAdTypeCustom) {
//        [self loadCustomAd];
//    } else {
        [self loadGeneralAd];
//    }
}

// 自定义
- (void)tapAD {
    
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

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = [UIColor clearColor];
        [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAD)]];
    }
    return _imageView;
}

@end
