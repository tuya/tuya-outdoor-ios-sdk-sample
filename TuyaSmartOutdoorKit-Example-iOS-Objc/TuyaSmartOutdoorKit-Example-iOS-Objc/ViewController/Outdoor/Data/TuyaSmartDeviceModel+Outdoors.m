//
//  TuyaSmartDeviceModel+Outdoors.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TuyaSmartDeviceModel+Outdoors.h"
#import <objc/runtime.h>

static void *kTYSmartOutdoorsCyclingRecord  = &kTYSmartOutdoorsCyclingRecord;
static void *KTYSmartOutdoorsDeviceIcon     = &KTYSmartOutdoorsDeviceIcon;

@interface TuyaSmartDeviceModel ()

@end

@implementation TuyaSmartDeviceModel (Outdoors)

- (void)setTyso_cyclingRecord:(NSDictionary *)tyso_cyclingRecord {
    objc_setAssociatedObject(self, kTYSmartOutdoorsCyclingRecord, tyso_cyclingRecord, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)tyso_cyclingRecord {
    return objc_getAssociatedObject(self, kTYSmartOutdoorsCyclingRecord);
}

- (void)setTyod_deviceIcon:(NSString *)tyod_deviceIcon {
    objc_setAssociatedObject(self, KTYSmartOutdoorsDeviceIcon, tyod_deviceIcon, OBJC_ASSOCIATION_COPY);
}

- (NSString *)tyod_deviceIcon {
    return objc_getAssociatedObject(self, KTYSmartOutdoorsDeviceIcon);
}


- (BOOL)tyso_have_gps {
    TuyaSmartSchemaModel *obj = [self tyod_schemaMWithCode:dpod_gps_signal_strength];
    return obj ? YES : NO;
}

- (BOOL)tyso_fault_detection {
    TuyaSmartSchemaModel *obj = [self tyod_schemaMWithCode:dpod_fault_detection];
    return obj ? YES : NO;
}

- (BOOL)tyso_battery_status {
    TuyaSmartSchemaModel *obj = [self tyod_schemaMWithCode:dpod_battery_status];
    return obj ? YES : NO;
}

- (BOOL)tyso_unlocked {
    TuyaSmartSchemaModel *obj = [self tyod_schemaMWithCode:dpod_blelock_switch];
    BOOL value = [obj.tyod_DPValue ty_bool];
    return value;
}

// [self capabilityIsSupport:10]
- (BOOL)isCat1Device {
    BOOL isCat1Device = [self capabilityIsSupport:20];
    return isCat1Device;
}

- (BOOL)isCat1Online {
    // Both 4G and Bluetooth are online, so they are considered online devices
    BOOL status = self.isOnline;
    return status;
}

- (BOOL)isBluetooth {
    BOOL isBluetooth = [self capabilityIsSupport:10];
    return isBluetooth;
}

- (BOOL)isBLEOnline {
    BOOL status = NO;
    if (self.onlineType & (TuyaSmartDeviceOnlineTypeBLE | TuyaSmartDeviceOnlineTypeMeshBLE)) {
        status = YES;
    }
    return status;
}

- (BOOL)isSingleBLEDevice {
    BOOL status = TuyaSmartDeviceModelTypeBle == self.deviceType;
    return status;
}

- (NSNumber *)tyso_dpTimeWithCode:(NSString *)codeString {
    if (!codeString || codeString.length == 0) {
        return nil;
    }
    
    TuyaSmartSchemaModel *schemeModel = [self tyod_schemaMWithCode:codeString];
    id value = [self.dpsTime ty_safeObjectForKey:schemeModel.dpId];
    if (value) {
        return @([value ty_double]);
    } else {
        return nil;
    }
}

- (NSString *)mileageUnit {
    return [self mileageUnit:[self tyso_once_mileage]];
}

- (NSString *)mileageUnit:(TuyaSmartSchemaModel *)schemaModel {
    NSString *unitStr = @"km";
    TuyaSmartSchemaModel *unitModel = [self tyod_schemaMWithCode:dpod_unit_set];
    if (unitModel) {
        unitStr = [unitModel.tyod_DPValue ty_string];
    } else if (schemaModel) {
        unitStr = schemaModel.property.unit;
    }
    return unitStr;
}

@end
