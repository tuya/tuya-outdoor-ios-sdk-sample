//
//  BLEModelViewController.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "BLEModelViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface BLEModelViewController ()<ThingSmartBLEManagerDelegate>

@property (nonatomic, assign) BOOL isSuccess;

@end

@implementation BLEModelViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopScan];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)stopScan{
    ThingSmartBLEManager.sharedInstance.delegate = nil;
    [ThingSmartBLEManager.sharedInstance stopListening:YES];
    if (!self.isSuccess) {
        [SVProgressHUD dismiss];
    }
}

- (IBAction)searchClicked:(id)sender {
    ThingSmartBLEManager.sharedInstance.delegate = self;
    [ThingSmartBLEManager.sharedInstance startListening:YES];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Searching", @"")];
}

#pragma --mark ThingSmartBLEManagerDelegate
- (void)didDiscoveryDeviceWithDeviceInfo:(ThingBLEAdvModel *)deviceInfo{
    long long homeId = [Home getCurrentHome].homeId;
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Configuring", @"")];
    [ThingSmartBLEManager.sharedInstance activeBLE:deviceInfo homeId:homeId success:^(ThingSmartDeviceModel * _Nonnull deviceModel) {
        self.isSuccess = YES;
        NSString *name = deviceModel.name?deviceModel.name:NSLocalizedString(@"Unknown Name", @"Unknown name device.");
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@ %@" ,NSLocalizedString(@"Successfully Added", @"") ,name]];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Failed to configuration", "")];
    }];
}

@end
