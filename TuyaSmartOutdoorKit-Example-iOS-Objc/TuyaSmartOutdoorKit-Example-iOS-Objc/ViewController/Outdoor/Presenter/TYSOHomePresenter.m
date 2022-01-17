//
//  TYSOHomePresenter.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYSOHomePresenter.h"
#import <TuyaSmartBaseKit/TuyaSmartBaseKit.h>
#import "TuyaSmartDeviceModel+Outdoors.h"
#import "TuyaSmartDevice+Outdoors.h"
#import "TYSmartOutdoorUtils.h"
#import "TYSOHomePresenter+Network.h"
#import "UIViewController+Outdoor.h"

@interface TYSOHomePresenter ()
<TuyaSmartDeviceDelegate,TuyaSmartHomeManagerDelegate>

@property (nonatomic, assign) NSInteger outdoorsDevCount;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, weak) id<TYSOHomeViewProtocol> view;

@end

@implementation TYSOHomePresenter

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithView:(id<TYSOHomeViewProtocol>)view {
    if (self = [super init]) {
        _view = view;
        self.isFirst = YES;
        self.device = nil;
        
        _homeManager = [[TuyaSmartHomeManager alloc] init];
        _homeManager.delegate = self;
        [self loadSOHomeData];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeIdDidChanged:) name:@"kTYTPNotificationHomeIdDidChanged" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDpsUpdate:) name:@"kNotificationDeviceDpsUpdate" object:nil];
    }
    return self;
}

- (void)loadSOHomeData {
    if (![TYODDataManager outdoorsDeviceListAllCount]) {
        [TYODProgressHUD show];
    }else {
        self.outdoorsDevCount = [TYODDataManager outdoorsDeviceList].count;
    }
    ty_weakify(self)
    [self.homeManager getHomeListWithSuccess:^(NSArray<TuyaSmartHomeModel *> *homes) {
        ty_strongify(self)
        if (homes.count == 0) {
            [TYODProgressHUD dismiss];
            [self.homeManager addHomeWithName:@"home"
                                      geoName:@"city"
                                        rooms:@[@""]
                                     latitude:0
                                    longitude:0
                                      success:^(long long result)
            {
                if ([TuyaSmartHome homeWithHomeId:result]) {
                    [Home setCurrentHome:[TuyaSmartHome homeWithHomeId:result].homeModel];
                }
            } failure:^(NSError *error) {
                
            }];
            return;
        }
        if (homes && homes.count > 0) {
            [Home setCurrentHome:homes.firstObject];
        }
        [self.view reloadViewData];
        [self requestViewDataAndResultDispose];
        [self fetchDeviceOTAInfoData];
    } failure:^(NSError *error) {
        ty_strongify(self)
        self.isFirst = NO;
        [TYODProgressHUD dismiss];
    }];
}

- (void)requestViewDataAndResultDispose {
    ty_weakify(self);
    [self requestViewDataWithCompletion:^{
        ty_strongify(self)
        self.outdoorsDevCount = [TYODDataManager outdoorsDeviceList].count;
        [self.view reloadViewData];
        [TYODProgressHUD dismiss];
        self.isFirst = NO;
    }];
}

- (void)reloadWithCompletion:(dispatch_block_t)completion {
    if (!self.isFirst) {
        ty_weakify(self)
        [self requestViewDataWithCompletion:^{
            ty_strongify(self)
            self.outdoorsDevCount = [TYODDataManager outdoorsDeviceList].count;
            if (completion) {
                completion();
            }
        }];
    }else{
        if (completion) {
            completion();
        }
    }
}

- (void)reloadHomeData {
    [self.view reloadViewData];
}

- (TuyaSmartDevice *)currentDevice {
    TuyaSmartDevice * device = self.device;
    if (device) {
        device.deviceModel.tyso_cyclingRecord = self.cyclingRecord[device.deviceModel.devId];
        device.deviceModel.tyod_deviceIcon = [self.deviceIconList ty_stringForKey:device.deviceModel.productId];
    }
    return device;
}

- (void)clearCurrentDevice {
    self.device = nil;
    [TYODDataManager clearCurrentDevice];
}

#pragma mark --- notification ---
- (void)homeIdDidChanged:(NSNotification *)notification {
    NSLog(@"%s", __FUNCTION__);
    self.device = nil;
    [TYODDataManager clearCurrentDevice];
    [self.view reloadViewData];
}

- (void)deviceDpsUpdate:(NSNotification *)notification {
    NSString *devId = [notification.object objectForKey:@"devId"];
    if ([self.device.deviceModel.devId isEqualToString:devId]) {
        NSLog(@"%s", __FUNCTION__);
        [self.view reloadViewData];
    }
}

- (BOOL)isOutdoorsHomeAndVisible {
    TYAssertCond([self.view isKindOfClass:UIViewController.class]);
    UIViewController *topVC = TY_TopViewController();
    BOOL isHome = NO;
    if ([topVC.childViewControllers containsObject:(UIViewController *)self.view] || [topVC isEqual:self.view]) {
        isHome = YES;
    }
    return isHome && topVC.isTy_visible;
}

#pragma mark --- TuyaSmartHomeDelegate ----
- (void)home:(TuyaSmartHome *)home didAddDeivice:(TuyaSmartDeviceModel *)device {
    NSArray<TuyaSmartDeviceModel *> *devList = [TYODDataManager outdoorsDeviceList];
    NSLog(@"add device name: %@ devID: %@", device.name, device.devId);
    if (self.outdoorsDevCount == devList.count) {
        return;
    }
    self.outdoorsDevCount = devList.count;
    self.device = nil;
    [TYODDataManager clearCurrentDevice];
    [self.view reloadViewData];
    [self fetchDeviceOTAInfoData];
}

#pragma mark --- TuyaSmartDeviceDelegate ---
- (void)deviceInfoUpdate:(TuyaSmartDevice *)device {
    [self.view reloadViewData];
    NSLog(@"%s", __FUNCTION__);
}

- (void)deviceOnlineUpdate:(TuyaSmartDevice *)device {
    [self.view reloadViewData];
}

- (void)deviceRemoved:(TuyaSmartDevice *)device {
    NSLog(@"%s: %@", __FUNCTION__, device.deviceModel.devId);
    self.device = nil;
    [TYODDataManager clearCurrentDevice];
    self.outdoorsDevCount = [TYODDataManager outdoorsDeviceList].count;
    [self.view reloadViewData];
}

#pragma mark --- TuyaSmartHomeManagerDelegate ---
- (void)homeManager:(TuyaSmartHomeManager *)manager didRemoveHome:(long long)homeId {

}

- (void)homeManager:(TuyaSmartHomeManager *)manager didAddHome:(TuyaSmartHomeModel *)home {
    [self loadSOHomeData];
}

- (void)changeDeviceBlock {
    self.device = nil;
    [self requestViewDataWithCompletion:^{
        [self.view reloadViewData];
    }];
}

#pragma mark -- get ---
- (TuyaSmartDevice *)device {
    if (_device && _device.deviceModel == nil) {
        [TYODDataManager clearCurrentDevice];
        _device = nil;
    }
    if (!_device) {
        NSString *deviceID = TYODDataManager.currentDeviceID;
        _device = [TuyaSmartDevice deviceWithDeviceId:deviceID];
        if (_device) {
            _device.delegate = self;
        }
    }
    return _device;
}

- (NSMutableDictionary *)cyclingRecord {
    if (!_cyclingRecord) {
        _cyclingRecord = [NSMutableDictionary dictionary];
    }
    return _cyclingRecord;
}

- (NSMutableDictionary *)deviceIconList {
    if (!_deviceIconList) {
        NSDictionary *dic = [TYODDataManager localDeviceIconList];
        if (dic && dic.allKeys > 0) {
            _deviceIconList = [NSMutableDictionary dictionaryWithDictionary:dic];
        }else{
            _deviceIconList = [NSMutableDictionary dictionary];
        }
    }
    return _deviceIconList;
}

@end
