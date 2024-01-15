//
//  TYSOHomePresenter.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYSOHomePresenter.h"
#import <ThingSmartBaseKit/ThingSmartBaseKit.h>
#import "ThingSmartDeviceModel+Outdoors.h"
#import "ThingSmartDevice+Outdoors.h"
#import "TYSmartOutdoorUtils.h"
#import "TYSOHomePresenter+Network.h"
#import "UIViewController+Outdoor.h"

@interface TYSOHomePresenter ()
<ThingSmartDeviceDelegate,ThingSmartHomeManagerDelegate>

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
        
        _homeManager = [[ThingSmartHomeManager alloc] init];
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
    thing_weakify(self)
    [self.homeManager getHomeListWithSuccess:^(NSArray<ThingSmartHomeModel *> *homes) {
        thing_strongify(self)
        if (homes.count == 0) {
            [TYODProgressHUD dismiss];
            [self.homeManager addHomeWithName:@"home"
                                      geoName:@"city"
                                        rooms:@[@""]
                                     latitude:0
                                    longitude:0
                                      success:^(long long result)
            {
                if ([ThingSmartHome homeWithHomeId:result]) {
                    [Home setCurrentHome:[ThingSmartHome homeWithHomeId:result].homeModel];
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
        thing_strongify(self)
        self.isFirst = NO;
        [TYODProgressHUD dismiss];
    }];
}

- (void)requestViewDataAndResultDispose {
    thing_weakify(self);
    [self requestViewDataWithCompletion:^{
        thing_strongify(self)
        self.outdoorsDevCount = [TYODDataManager outdoorsDeviceList].count;
        [self.view reloadViewData];
        [TYODProgressHUD dismiss];
        self.isFirst = NO;
    }];
}

- (void)reloadWithCompletion:(dispatch_block_t)completion {
    if (!self.isFirst) {
        thing_weakify(self)
        [self requestViewDataWithCompletion:^{
            thing_strongify(self)
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

- (ThingSmartDevice *)currentDevice {
    ThingSmartDevice * device = self.device;
    if (device) {
        device.deviceModel.tyso_cyclingRecord = self.cyclingRecord[device.deviceModel.devId];
        device.deviceModel.tyod_deviceIcon = [self.deviceIconList thing_stringForKey:device.deviceModel.productId];
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
    ThingAssertCond([self.view isKindOfClass:UIViewController.class]);
    UIViewController *topVC = TY_TopViewController();
    BOOL isHome = NO;
    if ([topVC.childViewControllers containsObject:(UIViewController *)self.view] || [topVC isEqual:self.view]) {
        isHome = YES;
    }
    return isHome && topVC.isTy_visible;
}

#pragma mark --- ThingSmartHomeDelegate ----
- (void)home:(ThingSmartHome *)home didAddDeivice:(ThingSmartDeviceModel *)device {
    NSArray<ThingSmartDeviceModel *> *devList = [TYODDataManager outdoorsDeviceList];
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

#pragma mark --- ThingSmartDeviceDelegate ---
- (void)deviceInfoUpdate:(ThingSmartDevice *)device {
    [self.view reloadViewData];
    NSLog(@"%s", __FUNCTION__);
}

- (void)deviceOnlineUpdate:(ThingSmartDevice *)device {
    [self.view reloadViewData];
}

- (void)deviceRemoved:(ThingSmartDevice *)device {
    NSLog(@"%s: %@", __FUNCTION__, device.deviceModel.devId);
    self.device = nil;
    [TYODDataManager clearCurrentDevice];
    self.outdoorsDevCount = [TYODDataManager outdoorsDeviceList].count;
    [self.view reloadViewData];
}

#pragma mark --- ThingSmartHomeManagerDelegate ---
- (void)homeManager:(ThingSmartHomeManager *)manager didRemoveHome:(long long)homeId {

}

- (void)homeManager:(ThingSmartHomeManager *)manager didAddHome:(ThingSmartHomeModel *)home {
    [self loadSOHomeData];
}

- (void)changeDeviceBlock {
    self.device = nil;
    [self requestViewDataWithCompletion:^{
        [self.view reloadViewData];
    }];
}

#pragma mark -- get ---
- (ThingSmartDevice *)device {
    if (_device && _device.deviceModel == nil) {
        [TYODDataManager clearCurrentDevice];
        _device = nil;
    }
    if (!_device) {
        NSString *deviceID = TYODDataManager.currentDeviceID;
        _device = [ThingSmartDevice deviceWithDeviceId:deviceID];
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
