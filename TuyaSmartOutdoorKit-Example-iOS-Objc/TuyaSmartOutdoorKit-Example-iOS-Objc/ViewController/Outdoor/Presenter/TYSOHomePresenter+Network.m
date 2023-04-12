//
//  TYSOHomePresenter+Network.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYSOHomePresenter+Network.h"
#import "TYSmartOutdoorRequestManager.h"
#import <TuyaSmartBLECoreKit/TuyaSmartBLEManager.h>

@implementation TYSOHomePresenter (Network)

- (void)requestViewDataWithCompletion:(dispatch_block_t)completion {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.tuya.outdoors.presenter", DISPATCH_QUEUE_CONCURRENT);
    [self requestDeviceListWithCompletion:^{
        [[TuyaSmartBLEManager sharedInstance] startListeningWithType:TYBLEScanTypeNoraml cacheStatu:NO];
        [self reloadHomeData];
        ty_weakify(self);
        dispatch_group_async(group, queue, ^{
            ty_strongify(self);
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [self requestLangsPackWithCompletion:^{
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
        dispatch_group_async(group, queue, ^{
            ty_strongify(self);
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [self requestTripTrackWithCompletion:^{
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
        dispatch_group_async(group, queue, ^{
            ty_strongify(self);
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [self requestOutdoorsCurrentDeviceIconWithCompletion:^{
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
        
        dispatch_group_notify(group, queue, ^{
            ty_strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion();
                }
            });
            [self requestOutdoorsDeviceIconListWithCompletion:^{
                
            }];
        });
    }];
}

- (void)requestLangsPackWithCompletion:(void(^)(void))completion {
    NSMutableArray<TuyaSmartDeviceModel *> *listAry = [NSMutableArray arrayWithArray:TYODDataManager.outdoorsDeviceList];
    [listAry addObjectsFromArray:TYODDataManager.outdoorsSharedDeviceList];
    [[TYODDPLanguageManager sharedInstance] updateDpLanguageWithDeviceModelAry:listAry completion:completion];
}

#pragma mark --- Request a list of hd pictures of the device ---
- (void)requestOutdoorsCurrentDeviceIconWithCompletion:(void(^)(void))completion {
    ty_weakify(self);
    NSString *deviceID = TYODDataManager.currentDeviceID;
    if (!deviceID.ty_isStringAndNotEmpty) {
        if (completion) {
            completion();
        }
        return;
    }
    [[TYSmartOutdoorRequestManager shareInstance] requestOutdoorsDevicesIconWithParams:@[deviceID] completion:^(NSDictionary<NSString *,TuyaSmartOutdoorProductIconModel *> * _Nonnull result) {
        ty_strongify(self);
        if (result) {
            NSMutableDictionary<NSString *, NSString *> *devIconMap = [NSMutableDictionary dictionary];
            [result enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, TuyaSmartOutdoorProductIconModel * _Nonnull obj, BOOL * _Nonnull stop) {
                [devIconMap ty_safeSetObject:obj.icon forKey:key];
            }];
            
            [self.deviceIconList addEntriesFromDictionary:devIconMap];
            [TYODDataManager saveLocalDeviceIconList:self.deviceIconList];
        }
        if (completion) {
            completion();
        }
    }];
}

- (void)requestOutdoorsDeviceIconListWithCompletion:(void(^)(void))completion {
    NSMutableArray<TuyaSmartDeviceModel *> *listAry = [NSMutableArray arrayWithArray:TYODDataManager.outdoorsDeviceList];
    [listAry addObjectsFromArray:TYODDataManager.outdoorsSharedDeviceList];
    
    if (listAry.count < 1) {
        if (completion) {
            completion();
        }
        return;
    }
    
    __block NSMutableArray<NSString *> *deviceIdArray = [NSMutableArray array];
    [listAry enumerateObjectsUsingBlock:^(TuyaSmartDeviceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.devId.length > 0 && ![deviceIdArray containsObject:obj.devId]) {
            [deviceIdArray addObject:obj.devId];
        }
    }];
    ty_weakify(self);
    [[TYSmartOutdoorRequestManager shareInstance] requestOutdoorsDevicesIconWithParams:deviceIdArray.copy completion:^(NSDictionary<NSString *,TuyaSmartOutdoorProductIconModel *> * _Nonnull result) {
        ty_strongify(self);
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary<NSString *, NSString *> *devIconMap = [NSMutableDictionary dictionary];
            [result enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, TuyaSmartOutdoorProductIconModel * _Nonnull obj, BOOL * _Nonnull stop) {
                [devIconMap ty_safeSetObject:obj.icon forKey:key];
            }];
            [self.deviceIconList addEntriesFromDictionary:devIconMap];
            [TYODDataManager saveLocalDeviceIconList:self.deviceIconList];
        }
        if (completion) {
            completion();
        }
    }];
}

#pragma mark --- Request riding records ----
- (void)requestTripTrackWithCompletion:(dispatch_block_t)completion {
    if (completion) {
        completion();
    }
    ///TuyaSmartOutdoorCyclingService  requestTripTrackWithDeviceId
}

- (void)requestDeviceListWithCompletion:(dispatch_block_t)completion {
    TuyaSmartHomeModel *homeModel = [Home getCurrentHome];
    TuyaSmartHome *home = [TuyaSmartHome homeWithHomeId:homeModel.homeId];
    NSLog(@"--homeId:%@--home[%@] exist: ", @(homeModel.homeId), home);
    if (home) {
        self.home = home;
        self.home.delegate = self;
        [self.home getHomeDataWithSuccess:^(TuyaSmartHomeModel *homeModel) {
            NSLog(@"getHomeDetailWithSuccess: %@", homeModel.name);
            if (completion) completion();
        } failure:^(NSError *error) {
            if (completion) completion();
        }];
    } else {
        if (completion) completion();
    }
}

#pragma mark --- After the home details are returned, the device OTA update status is changed.
- (void)fetchDeviceOTAInfoData {
    [self.home getDeviceOTAStatusWithHomeId:self.home.homeModel.homeId success:^(NSArray<TuyaSmartDeviceOTAModel *> *result) {
        
    } failure:^(NSError *error) {
        
    }];
}

@end
