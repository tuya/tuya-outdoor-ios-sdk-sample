//
//  TYODDataManager.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYODDataManager.h"
#import <TYFoundationKit/TYFoundationKit.h>

NSString *TYSOCurrentSelectedDeviceWillChange = @"TYSOCurrentSelectedDeviceWillChange";
NSString *TYSOCurrentSelectedDeviceDidChange  = @"TYSOCurrentSelectedDeviceDidChange";

static id _instace = nil;
static NSString * _currentDeviceID = nil;
static NSString * const kCurrentDeviceKey = @"kCurrentDeviceKey";
static NSString * const KLocalDeviceIconListKey = @"KLocalDeviceIconListKey";
static NSString * const KLocalDeviceLangsKey = @"KLocalDeviceLangsKey";

@implementation TYODDataManager

#pragma mark -
+ (void)setCurrentDeviceID:(NSString *)currentDeviceID {
    TYAssertCond(currentDeviceID.length > 0);
    if (currentDeviceID == nil) return;
    if ([_currentDeviceID isEqualToString:currentDeviceID]) return;

    // Issue notification of change if DeviceId changes
    [[NSNotificationCenter defaultCenter] postNotificationName:TYSOCurrentSelectedDeviceWillChange object:nil userInfo:@{@"devID": _currentDeviceID}];
    
    _currentDeviceID = currentDeviceID;
    [[NSUserDefaults standardUserDefaults] setObject:_currentDeviceID forKey:kCurrentDeviceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Issue notification of change if DeviceId changes
    [[NSNotificationCenter defaultCenter] postNotificationName:TYSOCurrentSelectedDeviceDidChange object:nil userInfo:@{@"devID": _currentDeviceID}];
}

+ (NSString *)currentDeviceID {
    if (_currentDeviceID.length <= 0) {
        _currentDeviceID = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentDeviceKey];
    }
    if (_currentDeviceID.length <= 0) {
        NSArray <TuyaSmartDeviceModel *> *deviceArr = [TYODDataManager outdoorsDeviceList];
        if (deviceArr.count > 0) {
            _currentDeviceID = deviceArr.lastObject.devId;
        }
    }
    if (_currentDeviceID.length <= 0) {
        NSArray<TuyaSmartDeviceModel *> *sharedDevArr = [TYODDataManager outdoorsSharedDeviceList];
        if (sharedDevArr.count > 0) {
            _currentDeviceID =  sharedDevArr.lastObject.devId;
        }
    }
    return _currentDeviceID;
}

#pragma mark - init
+ (NSArray<TuyaSmartDeviceModel *> *)outdoorsDeviceList {
    TuyaSmartHomeModel *homeModel = [Home getCurrentHome];
    TuyaSmartHome *home = [TuyaSmartHome homeWithHomeId:homeModel.homeId];
    NSMutableArray<TuyaSmartDeviceModel *> *oriDeviceArr = home.deviceList.mutableCopy;
    NSMutableArray<TuyaSmartDeviceModel *> *deviceArr = [NSMutableArray array];
    NSArray<NSString *> *filterCodes = TYODCategoryCodeList();
    [oriDeviceArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(TuyaSmartDeviceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([filterCodes containsObject:obj.category]) {
            [deviceArr addObject:obj];
        }
    }];
    ///The latest display is on the back
    [deviceArr sortUsingComparator:^NSComparisonResult(TuyaSmartDeviceModel *obj1, TuyaSmartDeviceModel *obj2) {
        return [obj1 homeDisplayOrder] < [obj2 homeDisplayOrder] ? NSOrderedAscending :NSOrderedDescending;
    }];
    return deviceArr.copy;
}

+ (NSArray<TuyaSmartDeviceModel *> *)outdoorsSharedDeviceList {
    TuyaSmartHomeModel *homeModel = [Home getCurrentHome];
    TuyaSmartHome *home = [TuyaSmartHome homeWithHomeId:homeModel.homeId];
    NSMutableArray<TuyaSmartDeviceModel *> *oriDeviceArr = home.sharedDeviceList.mutableCopy;
    NSMutableArray<TuyaSmartDeviceModel *> *deviceArr = [NSMutableArray array];
    NSArray<NSString *> *filterCodes = TYODCategoryCodeList();
    [oriDeviceArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(TuyaSmartDeviceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([filterCodes containsObject:obj.category]) {
            [deviceArr addObject:obj];
        }
    }];
    [deviceArr sortUsingComparator:^NSComparisonResult(TuyaSmartDeviceModel *  _Nonnull obj1, TuyaSmartDeviceModel *  _Nonnull obj2) {
        return obj1.activeTime > obj2.activeTime ? NSOrderedAscending :NSOrderedDescending;
    }];
    return deviceArr.copy;
}

+ (BOOL)isSharedOutdoorsDeviceWithDeviceID:(NSString *)deviceID {
    __block BOOL shared = NO;
    [[self.class outdoorsSharedDeviceList] enumerateObjectsUsingBlock:^(TuyaSmartDeviceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.devId isEqualToString:deviceID]) {
            shared = YES;
            *stop = YES;
        }
    }];
    return shared;
}


#pragma mark --- Total outdoor equipment ---
+ (NSInteger)outdoorsDeviceListAllCount {
    TuyaSmartHomeModel *homeModel = [Home getCurrentHome];
    TuyaSmartHome *home = [TuyaSmartHome homeWithHomeId:homeModel.homeId];
    NSMutableArray<TuyaSmartDeviceModel *> *oriDeviceArr = [NSMutableArray arrayWithArray:home.sharedDeviceList];
    [oriDeviceArr addObjectsFromArray:home.deviceList];
    NSArray<NSString *> *filterCodes = TYODCategoryCodeList();
    __block NSMutableArray<TuyaSmartDeviceModel *> *deviceArr = [NSMutableArray array];
    [oriDeviceArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(TuyaSmartDeviceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([filterCodes containsObject:obj.category]) {
            [deviceArr addObject:obj];
        }
    }];
    return deviceArr.count;
}

+ (void)clearCurrentDevice {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentDeviceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _currentDeviceID = nil;
}

+ (void)saveLocalDeviceIconList:(NSDictionary *)dic {
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:KLocalDeviceIconListKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)localDeviceIconList {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:KLocalDeviceIconListKey];;
    return dic;
}

@end
