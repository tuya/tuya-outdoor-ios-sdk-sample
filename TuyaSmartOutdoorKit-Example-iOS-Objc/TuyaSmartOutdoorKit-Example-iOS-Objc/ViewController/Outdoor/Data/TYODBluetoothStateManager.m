//
//  TYODBluetoothStateManager.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYODBluetoothStateManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface TYODBluetoothStateManager()<CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;

@end

@implementation TYODBluetoothStateManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static TYODBluetoothStateManager * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TYODBluetoothStateManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    }
    return self;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (self.bluetoothStateBlock) {
        self.bluetoothStateBlock((TYODBluetoothPowerState)central.state);
    }
}

@end
