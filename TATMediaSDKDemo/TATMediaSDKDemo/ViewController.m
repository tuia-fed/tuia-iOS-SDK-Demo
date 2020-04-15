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
#import "TATUserManager.h"
#import "TATMediaManager.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UINavigationController *navi;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *adTypeArray;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad]; // 120 210 218
    self.view.backgroundColor = [UIColor colorWithRed:119.0/255 green:211.0/255 blue:220.0/255 alpha:1.0]; // 61 162 132
    self.navigationItem.title = @"入口";
    [self setupTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchNativeAdResource];
}

- (void)setupTableView {
    NSDictionary *slotInfo = [TATMediaManager slotDataDictionary];
    self.titleArray = slotInfo[kSlotNameListKey];
    self.adTypeArray = slotInfo[kSlotTypeListKey];
    CGRect frame = CGRectMake(0, 88, self.view.bounds.size.width, self.view.bounds.size.height - 88);
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:119.0/255 green:211.0/255 blue:220.0/255 alpha:1.0]; // 61 162 132
    [self.view addSubview:self.tableView];
}

- (void)showInterstitialAd {
    TATBaseAdView *adView = [TATMediaCenter showInterstitialWithSlotId:[TATMediaManager slotIdForType:TATSimpleAdTypeInterstitial] resultBlock:^(BOOL result, NSError *error) {
        
    } closeBlock:^{
        NSString *message = @"插屏已关闭";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
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
}

- (void)showLaunchAd {
    TATBaseAdView *adView = [TATMediaCenter showLaunchAdWithSlotId:[TATMediaManager slotIdForType:TATSimpleAdTypeLaunch] resultBlock:^(BOOL result, NSError *error) {
           
    } closeBlock:^(BOOL isClosedByUser) {
        NSString *message = nil;
        if (isClosedByUser) {
            message = @"用户点击关闭";
        } else {
            message = @"开屏倒计时结束";
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
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
}

- (void)fetchCustomAd {
    [TATMediaCenter fetchCustomAdWithSlotId:[TATMediaManager slotIdForType:TATSimpleAdTypeCustom] completion:^(NSError *error, TATCustomAdModel *model) {
        
    }];
}

- (void)fetchNativeAdResource {
    [TATMediaCenter fetchNativeAdResourceBySlotId:[TATMediaManager slotIdForType:TATSimpleAdTypeNative] resultBlock:^(UIImage *image, NSError *error) {
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imageView removeFromSuperview];
                self.imageView = nil;
                self.imageView = [[UIImageView alloc] initWithImage:image];
                CGRect frame = self.imageView.frame;
                CGFloat originX = ([UIScreen mainScreen].bounds.size.width - frame.size.width) - 16;
                frame.origin.x = originX;
                frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height - 116;
                self.imageView.frame = frame;
                self.imageView.userInteractionEnabled = YES;
                [self.imageView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNativeAD)]];
                [self.view addSubview:self.imageView];
            });
        }
    }];
}

- (void)showNativeAd {
    [TATMediaCenter showFullModeAdWithSlotId:[TATMediaManager slotIdForType:TATSimpleAdTypeNative] loadingOption:YES resultBlock:^(BOOL result, NSError * _Nonnull error) {
        if (!result) {
            NSString *message = error.userInfo[NSLocalizedDescriptionKey];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)gotoAdVCWithType:(TATSimpleAdType)type {
    TATSimpleAdViewController *vc = [[TATSimpleAdViewController alloc] initWithAdType:type];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)presentAdVCWithType:(UIButton *)button {
    TATSimpleAdViewController *vc = [[TATSimpleAdViewController alloc] initWithAdType:button.tag];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.text = self.titleArray[indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithWhite:0xCC/0xFF alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TATSimpleAdType adType = [self.adTypeArray[indexPath.row] integerValue];
    [self gotoAdVCWithType:adType];
}


#pragma mark - Getters

- (UINavigationController *)navi {
    if (!_navi) {
        _navi = [[UINavigationController alloc] init];
        _navi.viewControllers = @[self];
    }
    return _navi;
}

@end
