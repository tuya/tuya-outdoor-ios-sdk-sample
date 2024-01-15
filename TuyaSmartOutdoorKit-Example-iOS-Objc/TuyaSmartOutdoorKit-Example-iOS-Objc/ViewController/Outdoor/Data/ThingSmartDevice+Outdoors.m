//
//  ThingSmartDevice+Outdoors.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "ThingSmartDevice+Outdoors.h"
#import "ThingSmartDeviceModel+Outdoors.h"
#import <objc/runtime.h>

static void *kTYSmartOutdoorsBeginRideTime = &kTYSmartOutdoorsBeginRideTime;
static void *kTYSmartOutdoorsBeginNaviTime = &kTYSmartOutdoorsBeginNaviTime;

static NSMutableDictionary<NSString *, NSNumber*> *s_naviTimeDict;
static NSMutableDictionary<NSString *, NSNumber*> *s_rideTimeDict;

@interface ThingSmartDevice ()

@end

@implementation ThingSmartDevice (Outdoors)

- (void)setTyso_beginRideTime:(NSTimeInterval)tyso_beginRideTime {
    if (!s_rideTimeDict) {
        s_rideTimeDict = [NSMutableDictionary new];
    }
    [s_rideTimeDict thing_safeSetObject:@(tyso_beginRideTime) forKey:self.deviceModel.devId];
}

- (NSTimeInterval)tyso_beginRideTime {
    return [[s_rideTimeDict thing_safeObjectForKey:self.deviceModel.devId] doubleValue];
}

- (void)setTyso_beginNaviTime:(NSTimeInterval)tyso_beginNaviTime {
    if (!s_naviTimeDict) {
        s_naviTimeDict = [NSMutableDictionary new];
    }
    [s_naviTimeDict thing_safeSetObject:@(tyso_beginNaviTime) forKey:self.deviceModel.devId];
}

- (NSTimeInterval)tyso_beginNaviTime {
    return [[s_naviTimeDict thing_safeObjectForKey:self.deviceModel.devId] doubleValue];
}

- (void)tyod_publish_code:(NSString *)code
                  dpValue:(id)dpValue
                  success:(nullable ThingSuccessHandler)success
                  failure:(nullable ThingFailureError)failure {
    if (!self.deviceModel.isOnline) {
        failure([self tyod_deviceOfflineError]);
        return;
    }
    NSDictionary *extDict = [[NSObject thing_objectFromJson:[self.deviceModel tsod_schemaMWithCode:code].extContent] thing_dictionary];
    if ([extDict[@"route"] thingsdk_toInt] == 2 && !self.deviceModel.isBLEOnline) {
        [self tyod_showBLEOfflineAlert];
        if (failure) failure(nil);
        return;
    }
    // If the DP sending part needs to go through the Bluetooth channel, please check the Bluetooth permission and status.
    BOOL bleAuth = NO; // pre check ble status Unauthorized or PoweredOff
    if (bleAuth) {
        [TYODProgressHUD showErrorWithStatus:@"BLEUnauthorized || BLEPoweredOff"];
        if (failure) failure(nil);
        return;
    }
    BOOL bleOffline = NO; // pre check offline
    if (bleOffline) {
        [self tyod_showBLEOfflineAlert];
        if (failure) failure(nil);
        return;
    }

    [self tsod_publishDPWithCode:code DPValue:dpValue success:success failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

#pragma mark - private
- (void)tyod_showBLEOfflineAlert {
    [TYODProgressHUD showErrorWithStatus:@"Please connect the device before use"];
}

- (NSError *)tyod_deviceOfflineError {
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: @"equipment_offline".thing_localized,
        NSLocalizedFailureReasonErrorKey: @"device offline"
    };
    NSError *error = [NSError errorWithDomain:@"com.tuya.travel" code:THING_GW_OFFLINE userInfo:userInfo];
    return error;
}

@end
