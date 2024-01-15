//
//  ThingSmartDeviceModel+Outdoors.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <ThingSmartDeviceCoreKit/ThingSmartDeviceCoreKit.h>
#import "ThingSmartDeviceModel+ODDpSchema.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThingSmartDeviceModel (Outdoors)

@property (nonatomic, copy, nullable) NSDictionary *tyso_cyclingRecord; // Cycle track
@property (nonatomic, copy, nullable) NSString *tyod_deviceIcon; //Device icon

///Report time of DP point
- (NSNumber *)tyso_dpTimeWithCode:(NSString *)codeString;
- (BOOL)tyso_have_gps;
- (BOOL)tyso_fault_detection;
- (BOOL)tyso_battery_status;
- (BOOL)tyso_unlocked;

- (BOOL)isBluetooth;

- (BOOL)isBLEOnline;

- (BOOL)isCat1Device;

- (BOOL)isCat1Online;

- (BOOL)isSingleBLEDevice;

- (NSString *)mileageUnit;
- (NSString *)mileageUnit:(ThingSmartSchemaModel *)schemaModel;

@end

NS_ASSUME_NONNULL_END
