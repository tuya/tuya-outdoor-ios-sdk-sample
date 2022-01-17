//
//  TYODBluetoothStateManager.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TYODBluetoothPowerState) {
    TYODBluetoothPowerStateUnknown = 0,
    TYODBluetoothPowerStateResetting,
    TYODBluetoothPowerStateUnsupported,
    TYODBluetoothPowerStateUnauthorized,
    TYODBluetoothPowerStatePoweredOff,
    TYODBluetoothPowerStatePoweredOn,
};

typedef void(^TYODBluetoothStateBlock)(TYODBluetoothPowerState state);

@interface TYODBluetoothStateManager : NSObject

@property (nonatomic, copy) TYODBluetoothStateBlock bluetoothStateBlock;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
