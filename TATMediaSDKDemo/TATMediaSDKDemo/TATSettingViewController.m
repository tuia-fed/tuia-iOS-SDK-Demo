//
//  TATSettingViewController.m
//  TATMediaSDKDemo
//
//  Created by wuleslie on 2019/12/23.
//  Copyright © 2019 wuleslie. All rights reserved.
//

#import "TATSettingViewController.h"
#import "TATUserManager.h"
#import <TATMediaSDK/TATMediaSDK.h>
#import "TATMediaManager.h"

@interface TATSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *floatView;

@end

@implementation TATSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:119.0/255 green:211.0/255 blue:220.0/255 alpha:1.0]; // 61 162 132
    self.dataArray = @[@"设置用户ID", @"设置device ID"];
    CGRect frame = CGRectMake(0, 88, self.view.bounds.size.width, self.view.bounds.size.height - 88);
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showFloatAd];
}

- (void)showUserIdInputField {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置用户ID" message:@"~" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //响应事件，这里只有一个，也只简单处理第一个
        NSString *text = alert.textFields.firstObject.text;
        [self setUserId:text];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        //响应事件
        NSLog(@"action = %@", alert.textFields);
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"用户ID";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setUserId: (NSString *)userId {
    if (!userId) {
        return;
    }
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    userId = [(NSString *)userId stringByTrimmingCharactersInSet:charSet];
    if (userId.length <= 0) {
        return;
    }
    [TATUserManager sharedInstance].userId = userId;
    [self.tableView reloadData];
}

- (void)showInputDeviceIdField {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置device ID" message:@"请输device_id" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //响应事件，这里只有一个，也只简单处理第一个
        NSString *text = alert.textFields.firstObject.text;
        [self setDeviceId:text];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        //响应事件
        NSLog(@"action = %@", alert.textFields);
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"device ID";
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setDeviceId: (NSString *)deviceId {
    if (!deviceId) {
        return;
    }
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    deviceId = [(NSString *)deviceId stringByTrimmingCharactersInSet:charSet];
    if (deviceId.length <= 0) {
        return;
    }
    [TATUserManager sharedInstance].deviceId = deviceId;
    [self.tableView reloadData];
}

- (void)showFloatAd {
    __block TATBaseAdView *adView = [TATMediaCenter initSimpleAdWithSlotId:[TATMediaManager slotIdForType:TATSimpleAdTypeFloat] resultBlock:^(BOOL result, NSError *error) {
        if (result) {
            CGRect frame = adView.frame;
            CGFloat originX = ([UIScreen mainScreen].bounds.size.width - frame.size.width) - 16;
            frame.origin.x = originX;
            frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height - 116;
            adView.frame = frame;
        } else {
            
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
    
    [self.floatView removeFromSuperview];
    self.floatView = nil;
    [self.view addSubview:adView];
    self.floatView = adView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.text = self.dataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = [TATUserManager sharedInstance].userId;
    } else if (indexPath.row == 1) {
        cell.detailTextLabel.text = [TATUserManager sharedInstance].deviceId;
    } else {
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self showUserIdInputField];
            break;
        case 1:
            [self showInputDeviceIdField];
            break;
        default:
            break;
    }
}

@end
