//
//  TYODUnLockViewController.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Created by heye on 2023/3/20.
//

#import "TYODUnLockViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <ThingSmartBLEKit/ThingSmartBLEKit.h>
#import "TYODDataManager.h"
#import "ThingSmartDeviceModel+ODDpSchema.h"
#import "TYODProgressHUD.h"
#import "Alert.h"

@interface TYODUnLockViewController ()<CLLocationManagerDelegate, ThingSmartODInductiveUnlockDelegate, ThingODHidInductiveUnlockDelegate, ThingODBTInductiveUnlockDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign, getter=isPaired) BOOL paired;
@property (nonatomic, assign) InductiveUnlockType type;
@property (weak, nonatomic) IBOutlet UIView *unLockView;
@property (weak, nonatomic) IBOutlet UILabel *locationStatus;
@property (weak, nonatomic) IBOutlet UILabel *fullLocationStatus;
@property (weak, nonatomic) IBOutlet UIButton *authButton;
@property (weak, nonatomic) IBOutlet UILabel *unlockTypeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *unLockSwitch;
@property (weak, nonatomic) IBOutlet UILabel *hidBindStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *hidBindStatus;
@property (weak, nonatomic) IBOutlet UILabel *unLockDistanceLabel;
@property (weak, nonatomic) IBOutlet UISlider *stepSlider;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIButton *fortifyDistanceButton;
@property (weak, nonatomic) IBOutlet UIButton *disarmDistanceButton;

@end

@implementation TYODUnLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkAuth];
    [self changeDeviceAndRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeDeviceAndRefresh)
                                                 name:@"TYODChangeDeviceAndRefresh"
                                               object:nil];

    [ThingSmartODInductiveUnlock sharedInstance].delegate = self;
    [ThingODHidInductiveUnlock sharedInstance].delegate = self;
    [ThingODBTInductiveUnlock sharedInstance].delegate = self;
}

- (void)changeDeviceAndRefresh {
    if ([TYODDataManager currentDeviceID]) {
        self.unLockView.hidden = NO;
        [self checkUnlockType];
    } else {
        self.unLockView.hidden = YES;
    }
}

- (void)checkAuth {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

- (void)checkUnlockType {
    NSString *devId = [TYODDataManager currentDeviceID];
    self.unLockSwitch.enabled = NO;
    thing_weakify(self)
    // unlock type
    [[ThingSmartODInductiveUnlock sharedInstance] getInductiveUnlockType:devId completion:^(InductiveUnlockType type) {
        thing_strongify(self)
        self.type = type;
        if (type == InductiveUnlockTypeBLEHID) {
            self.unlockTypeLabel.text = @"BLE_HID";
            [self checkHIDBindStatus];
            [self.unLockSwitch setHidden:NO];
            [self hideHIDBindStatusView:NO];
            [self hideDistanceView:YES];
            [self hideRecordDistanceView:NO];
            BOOL unlockStatus = [[ThingODHidInductiveUnlock sharedInstance] getUnlockStatus:devId];
            [self.unLockSwitch setOn:unlockStatus];
            [self enabledRecordDistanceView:unlockStatus];
        } else if (type == InductiveUnlockTypeBT) {
            self.unlockTypeLabel.text = @"BT";
            [self.unLockSwitch setHidden:NO];
            [self hideHIDBindStatusView:YES];
            [self hideRecordDistanceView:YES];
            
            self.paired = [[ThingODBTInductiveUnlock sharedInstance] checkPairedStatus:devId];
            if (self.paired) {
                [self.unLockSwitch setOn:YES];
                [self hideDistanceView:NO];
                self.stepSlider.value = [[ThingODBTInductiveUnlock sharedInstance] getInductiveUnlockDistance:devId];
                long level = lroundf(self.stepSlider.value);
                self.levelLabel.text = [NSString stringWithFormat:@"level: %ld", level];
            } else {
                [self.unLockSwitch setOn:NO];
                [self hideDistanceView:YES];
            }
        } else {
            [self.unLockSwitch setHidden:YES];
            self.unlockTypeLabel.text = @"None";
            [self hideHIDBindStatusView:YES];
            [self hideDistanceView:YES];
            [self hideRecordDistanceView:YES];
        }
        self.unLockSwitch.enabled = YES;
    } error:^(NSError * _Nonnull error) {
        [TYODProgressHUD showInfoWithStatus:error.localizedDescription];
    }];
    
    [self.stepSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)checkHIDBindStatus {
    NSString *devId = [TYODDataManager currentDeviceID];
    BOOL bindStatus = [[ThingODHidInductiveUnlock sharedInstance] getHidBindStatus:devId];
    self.hidBindStatus.text = bindStatus ? @"BIND" : @"UNBIND";
}

#pragma mark - ThingSmartODInductiveUnlockDelegate

- (void)listenUnlockStatusCallback:(UnlockStatus)status {
    switch (status) {
        case UnlockStatusTurnOn:{
            [self.unLockSwitch setOn:YES];
            [self enabledRecordDistanceView:YES];
            break;
        }
        case UnlockStatusTurnOff:{
            [self.unLockSwitch setOn:NO];
            [self enabledRecordDistanceView:NO];
            break;
        }
        default:
            break;
    }
}

#pragma mark - ThingODHidInductiveUnlockDelegate

- (void)listenHidBindStatusCallback:(HidBindStatus)status {
    [self checkHIDBindStatus];
    self.unLockSwitch.enabled = YES;
}

#pragma mark - ThingODBTInductiveUnlockDelegate

- (void)listenBTUnlockStatusCallback:(BTUnlockPairStatus)status {
    switch (status) {
        case BTUnlockPairStatusCancelParing: {
            [TYODProgressHUD showInfoWithStatus:@"Cancel Pairing"];
            [self.unLockSwitch setOn:NO];
            break;
        }
        case BTUnlockPairStatusPublishBoardcast: {
            if (!self.paired) {
                [self getDeviceBtNameWithCompletion:^(NSString *btName) {
                    [Alert showBasicAlertOnVC:[UIApplication sharedApplication].keyWindow.rootViewController withTitle:@"Broadcast On" message:[NSString stringWithFormat:@"Go System Settings - Bluetooth - \"Other Devices\" to find %@ and start pairing. After completion, Bluetooth device will appear in \"My Devices\", which means the setup is successful", btName]];
                }];

            }
            break;
        }
        case BTUnlockPairStatusPairedSuccess: {
            self.paired = YES;
            break;
        }
        case BTUnlockPairBindStatusSuccess: {
            [self.unLockSwitch setOn:YES];
            [self hideDistanceView:NO];
            break;
        }
        case BTUnlockPairBindStatusFailed: {
            [TYODProgressHUD showInfoWithStatus:@"Bind Status Failed"];
            break;
        }
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    [self updateAuthView];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self updateAuthView];
}

- (BOOL)getAuthStatus {
    BOOL au = NO;
    CLAuthorizationStatus authS = kCLAuthorizationStatusNotDetermined;
    if (@available(iOS 14.0, *)) {
        authS = self.locationManager.authorizationStatus;
    } else {
        authS = [CLLocationManager authorizationStatus];
    }
    if (authS == kCLAuthorizationStatusAuthorizedAlways ||
        authS == kCLAuthorizationStatusAuthorizedWhenInUse) {
        au = YES;
    }
    else {
        au = NO;
    }
    self.locationStatus.text = au ? @"Enabled" : @"Disabled";

    BOOL enabled = au;
    BOOL fa = NO;
    if (@available(iOS 14.0, *)) {
        fa = (self.locationManager.accuracyAuthorization == CLAccuracyAuthorizationFullAccuracy);
        enabled = fa && au;
    }
    return enabled;
}

- (void)updateAuthView {
    BOOL enabled = [self getAuthStatus];
    self.fullLocationStatus.text = enabled ? @"Enabled" : @"Disabled";
    
    self.authButton.hidden = enabled;
    self.unLockSwitch.enabled = enabled;
}

#pragma mark Actions

- (IBAction)authAction:(id)sender {
    CLAuthorizationStatus authS = kCLAuthorizationStatusNotDetermined;
    if (@available(iOS 14.0, *)) {
        authS = self.locationManager.authorizationStatus;
    } else {
        authS = [CLLocationManager authorizationStatus];
    }
    if (authS == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
        if (@available(iOS 14.0, *)) {
            [self.locationManager requestTemporaryFullAccuracyAuthorizationWithPurposeKey:@"purposeKey" completion:^(NSError * _Nullable) {
                //...
            }];
        }
    }
    else {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }
}


- (IBAction)unLockSwitch:(UISwitch *)sender {
    if (![self getAuthStatus]) {
        [TYODProgressHUD showInfoWithStatus:@"You need to enable location access first"];
        [sender setOn:!sender.isOn];
        return;
    }
    NSString *devId = [TYODDataManager currentDeviceID];
    thing_weakify(self)
    if (self.type == InductiveUnlockTypeBLEHID) {
        if (sender.isOn) {
            [[ThingODHidInductiveUnlock sharedInstance] turnOnHidInductiveUnlock:devId finished:^{

            } error:^(NSError * _Nonnull error) {
                [TYODProgressHUD showInfoWithStatus:error.localizedDescription];
                [sender setOn:NO animated:YES];
            }];
        } else {
            [[ThingODHidInductiveUnlock sharedInstance] turnOffHidInductiveUnlock:devId finished:^{

            } error:^(NSError * _Nonnull error) {
                [TYODProgressHUD showInfoWithStatus:error.localizedDescription];
                [sender setOn:YES animated:YES];
            }];
        }
    } else if (self.type == InductiveUnlockTypeBT) {
        if (sender.isOn) {
            self.paired = [[ThingODBTInductiveUnlock sharedInstance] checkPairedStatus:devId];
            if (!self.paired) {
                [[ThingODBTInductiveUnlock sharedInstance] turnOnBTInductiveUnlock:devId finished:^{
                } error:^(NSError *error) {
                    [TYODProgressHUD showInfoWithStatus:error.localizedDescription];
                    [sender setOn:NO animated:YES];
                }];
            } else {
                [TYODProgressHUD showInfoWithStatus:@"BT inductiv unlocking is still on"];
                [self hideDistanceView:NO];
            }
        } else {
            [[ThingODBTInductiveUnlock sharedInstance] turnOffBTInductiveUnlock:devId finished:^{
                thing_strongify(self)
                [self hideDistanceView:YES];
                [Alert showBasicAlertOnVC:[UIApplication sharedApplication].keyWindow.rootViewController withTitle:@"Attention" message:@"To ensure you won't receive notifications of the removed device, tap Go or go to Settings > Bluetooth to check if the device is removed from your phone."];
            } error:^(NSError * _Nonnull error) {
                [TYODProgressHUD showInfoWithStatus:@"Unlock Failed"];
                [sender setOn:YES animated:YES];
            }];
        }
    }
}

- (IBAction)recordFortifyDistanceAction:(id)sender {
    NSString *devId = [TYODDataManager currentDeviceID];
    [[ThingODHidInductiveUnlock sharedInstance] recordFortifyDistance:devId finished:^{
        [TYODProgressHUD showInfoWithStatus:@"Record Success"];
    } error:^(NSError * _Nonnull error) {
        [TYODProgressHUD showInfoWithStatus:error.localizedDescription];
    }];
}

- (IBAction)recordDisarmDistanceAction:(id)sender {
    NSString *devId = [TYODDataManager currentDeviceID];
    [[ThingODHidInductiveUnlock sharedInstance] recordDisarmDistance:devId finished:^{
        [TYODProgressHUD showInfoWithStatus:@"Record Success"];
    } error:^(NSError * _Nonnull error) {
        [TYODProgressHUD showInfoWithStatus:error.localizedDescription];
    }];
}

- (void)sliderValueChanged:(UISlider *)sender {
    long distance = lroundf(sender.value);
    self.levelLabel.text = [NSString stringWithFormat:@"level: %ld", distance];
    NSString *devId = [TYODDataManager currentDeviceID];
    [[ThingODBTInductiveUnlock sharedInstance] setInductiveUnlockDistance:devId distance:distance finished:^{

    } error:^(NSError * _Nonnull error) {
        [TYODProgressHUD showInfoWithStatus:@"Bind Status Failed"];
    }];
}

#pragma mark - private methods

- (void)getDeviceBtNameWithCompletion:(void(^)(NSString * btName))completion {
    NSString *devId = [TYODDataManager currentDeviceID];

    thingsdk_dispatch_async_on_default_global_thread(^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        __block NSString *btName = nil;
        [[ThingSmartBLEManager sharedInstance] queryBLEDualModeBTInfoWithDeviceId:devId success:^(ThingBLEDualModeBTModel * _Nonnull btModel) {
            btName = btModel.deviceName;
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC));
        thingsdk_dispatch_async_on_main_thread(^{
            if (completion) {
                completion(btName);
            }
        });
    });
}

- (void)hideDistanceView:(BOOL)hidden {
    self.unLockDistanceLabel.hidden = hidden;
    self.stepSlider.hidden = hidden;
    self.levelLabel.hidden = hidden;
}

- (void)hideHIDBindStatusView:(BOOL)hidden {
    self.hidBindStatusLabel.hidden = hidden;
    self.hidBindStatus.hidden = hidden;
}

- (void)hideRecordDistanceView:(BOOL)hidden {
    self.fortifyDistanceButton.hidden = hidden;
    self.disarmDistanceButton.hidden = hidden;
}

- (void)enabledRecordDistanceView:(BOOL)enabled {
    self.fortifyDistanceButton.enabled = enabled;
    self.disarmDistanceButton.enabled = enabled;
}

@end
