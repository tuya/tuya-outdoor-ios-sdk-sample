//
//  TuyaSmartDevice+Outdoors.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TuyaSmartDevice+Outdoors.h"
#import "TuyaSmartDeviceModel+Outdoors.h"
#import <objc/runtime.h>

static void *kTYSmartOutdoorsBeginRideTime = &kTYSmartOutdoorsBeginRideTime;
static void *kTYSmartOutdoorsBeginNaviTime = &kTYSmartOutdoorsBeginNaviTime;

static NSMutableDictionary<NSString *, NSNumber*> *s_naviTimeDict;
static NSMutableDictionary<NSString *, NSNumber*> *s_rideTimeDict;

@interface TuyaSmartDevice ()

@end

@implementation TuyaSmartDevice (Outdoors)

- (void)setTyso_beginRideTime:(NSTimeInterval)tyso_beginRideTime {
    if (!s_rideTimeDict) {
        s_rideTimeDict = [NSMutableDictionary new];
    }
    [s_rideTimeDict ty_safeSetObject:@(tyso_beginRideTime) forKey:self.deviceModel.devId];
}

- (NSTimeInterval)tyso_beginRideTime {
    return [[s_rideTimeDict ty_safeObjectForKey:self.deviceModel.devId] doubleValue];
}

- (void)setTyso_beginNaviTime:(NSTimeInterval)tyso_beginNaviTime {
    if (!s_naviTimeDict) {
        s_naviTimeDict = [NSMutableDictionary new];
    }
    [s_naviTimeDict ty_safeSetObject:@(tyso_beginNaviTime) forKey:self.deviceModel.devId];
}

- (NSTimeInterval)tyso_beginNaviTime {
    return [[s_naviTimeDict ty_safeObjectForKey:self.deviceModel.devId] doubleValue];
}

- (void)tyod_publish_code:(NSString *)code
                  dpValue:(id)dpValue
                  success:(nullable TYSuccessHandler)success
                  failure:(nullable TYFailureError)failure {
    if (!self.deviceModel.isOnline) {
        failure([self tyod_deviceOfflineError]);
        return;
    }
    NSDictionary *extDict = [[NSObject ty_objectFromJson:[self.deviceModel tyod_schemaMWithCode:code].extContent] ty_dictionary];
    if ([extDict[@"route"] tysdk_toInt] == 2 && !self.deviceModel.isBLEOnline) {
        [self tyod_showBLEOfflineAlert];
        if (failure) failure(nil);
        return;
    }
    [self tyod_publishDPWithCode:code DPValue:dpValue success:success failure:^(NSError *error) {
        if (error.code == TuyaSmartOutdoorErrorCodeBLEUnauthorized || error.code == TuyaSmartOutdoorErrorCodeBLEPoweredOff) {
            [TYODProgressHUD showErrorWithStatus:@"BLEUnauthorized || BLEPoweredOff"];
            if (failure) failure(nil);
        }
        else if (error.code == TuyaSmartOutdoorErrorCodeBLEOffline) {
            [self tyod_showBLEOfflineAlert];
            if (failure) failure(nil);
        }
        else {
            if (failure) failure(error);
        }
    }];
}

#pragma mark - private
- (void)tyod_showBLEOfflineAlert {
    [TYODProgressHUD showErrorWithStatus:@"Please connect the device before use"];
}

- (NSError *)tyod_deviceOfflineError {
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: @"equipment_offline".ty_localized,
        NSLocalizedFailureReasonErrorKey: @"device offline"
    };
    NSError *error = [NSError errorWithDomain:@"com.tuya.travel" code:TUYA_GW_OFFLINE userInfo:userInfo];
    return error;
}

@end
