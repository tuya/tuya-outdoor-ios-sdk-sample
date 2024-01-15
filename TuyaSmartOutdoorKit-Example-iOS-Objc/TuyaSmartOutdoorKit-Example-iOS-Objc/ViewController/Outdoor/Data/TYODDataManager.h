//
//  TYODDataManager.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// It's going to change and you can add some preprocessing here so currentDeviceId is going to change
UIKIT_EXTERN NSString *TYSOCurrentSelectedDeviceWillChange;
// You can add some preprocessing here while currentDeviceId has changed
UIKIT_EXTERN NSString *TYSOCurrentSelectedDeviceDidChange;

@class ThingSmartDeviceModel;

@interface TYODDataManager : NSObject

@property (class, nonatomic, copy, nullable) NSString *currentDeviceID;

+ (NSArray<ThingSmartDeviceModel *> *)outdoorsDeviceList;

+ (NSArray<ThingSmartDeviceModel *> *)outdoorsSharedDeviceList;

+ (BOOL)isSharedOutdoorsDeviceWithDeviceID:(NSString *)deviceID;

///Total outdoor equipment
+ (NSInteger)outdoorsDeviceListAllCount;

+ (void)clearCurrentDevice;
///Save device icon
+ (void)saveLocalDeviceIconList:(NSDictionary *)dic;
+ (NSDictionary *)localDeviceIconList;

@end

NS_ASSUME_NONNULL_END
