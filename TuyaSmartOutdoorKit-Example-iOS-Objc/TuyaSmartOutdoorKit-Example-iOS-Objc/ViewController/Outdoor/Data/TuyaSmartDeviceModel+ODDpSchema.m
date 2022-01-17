//
//  TuyaSmartDeviceModel+ODDpSchema.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TuyaSmartDeviceModel+ODDpSchema.h"
#import "TuyaSmartDeviceModel+Outdoors.h"
#import <objc/runtime.h>
#import "TuyaSmartSchemaModel+ValueProtocol.h"
#import "TYSmartOutdoorUtils.h"

@implementation TuyaSmartDeviceModel (ODDpSchema)
#pragma mark -

// Unit conversion
- (TuyaSmartSchemaModel *)mileageDPConvertFromSchemaM:(TuyaSmartSchemaModel *)schemaM {
    NSString *mileageUnitType = [[self tyod_schemaMWithCode:@"unit_set"].tyod_DPValue ty_string];
    if ([mileageUnitType.lowercaseString isEqualToString:@"mile"]) {
        double value = [TYSmartOutdoorUtils mileConvertFromKM:[schemaM.tyod_DPValue ty_double]];
        schemaM.tyod_DPValue = @(value);
    }

    if (mileageUnitType) {
        schemaM.property.unit = mileageUnitType;
    }
    else if (schemaM.property.unit.length <= 0) {
        schemaM.property.unit = @"Km";
    }
    return schemaM;
}

- (TuyaSmartSchemaModel *)tyso_gps_signal {
    TuyaSmartSchemaModel *obj = [self tyod_schemaMWithCode:dpod_gps_signal_strength];
    if (obj) {
        double max = obj.property.max;
        double min = obj.property.min;
        double cSignal = [obj.tyod_DPValue ty_double];

        double num1 = cSignal - min;
        double num2 = max - min;
        double tnum = num1/num2;
        double num = tnum/0.2;

        obj.tyod_DPValue = @(ceil(num));
    }
    return obj;
}

- (TuyaSmartSchemaModel *)tyso_4g_signal_strength {
    TuyaSmartSchemaModel *model = [self tyod_schemaMWithCode:dpod_4g_signal_strength];
    if (model) {
        NSArray<NSString *> *rangs = model.property.range;
        NSString *cSignal = [model.tyod_DPValue ty_string];
        NSArray<NSString *> *sigArr = rangs.count == 5 ? rangs : @[@"cut", @"bad",@"general",@"good",@"great"];
        NSInteger num = [sigArr indexOfObject:cSignal];
        model.property.selectedValue = num;
    }
    return model;
}

- (TuyaSmartSchemaModel *)tyso_gsm_signal {
    TuyaSmartSchemaModel *model = [self tyod_schemaMWithCode:dpod_signal_strength];
    if (model) {
        NSInteger max = model.property.max;
        NSInteger min = model.property.min;
        NSInteger cSignal = [model.tyod_DPValue ty_int];

        NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld", (cSignal - min)]];
        NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld", (max - min)]];
        NSDecimalNumber *tnum = [num1 decimalNumberByDividingBy:num2];
        NSDecimalNumber *num = [tnum decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"0.2"]];
        model.tyod_DPValue = @(ceil(num.floatValue));
    }

    return model;
}

- (TuyaSmartSchemaModel *)tyso_endurance_mileage {
    TuyaSmartSchemaModel *schemaM = [self tyod_schemaMWithCode:dpod_endurance_mileage];
    return [self mileageDPConvertFromSchemaM:schemaM];
}

- (TuyaSmartSchemaModel *)tyso_mileage_total {
    TuyaSmartSchemaModel *schemaM = [self tyod_schemaMWithCode:dpod_mileage_total];
    return [self mileageDPConvertFromSchemaM:schemaM];
}

- (TuyaSmartSchemaModel *)tyso_battery_percentage {
    TuyaSmartSchemaModel *schemaM = [self tyod_schemaMWithCode:dpod_battery_percentage];
    return schemaM;
}

- (TuyaSmartSchemaModel *)tyso_battery_percentage2 {
    TuyaSmartSchemaModel *schemaM = [self tyod_schemaMWithCode:dpod_battery_percentage_2];
    return schemaM;
}

- (TuyaSmartSchemaModel *)tyod_speed_limit {
    TuyaSmartSchemaModel *schema = [self tyod_schemaMWithCode:dpod_speed_limit_enum];
    if (!schema) {
        schema = [self tyod_schemaMWithCode:dpod_speed_limit_e];
    }
    if (!schema) {
        return nil;
    }
    schema = [self mileageDPConvertFromSchemaM:schema];
    return schema;
}

- (TuyaSmartSchemaModel *)tyso_current_speed {
    TuyaSmartSchemaModel *schema = [self tyod_schemaMWithCode:dpod_speed];
    if (!schema) return nil;
    schema = [self mileageDPConvertFromSchemaM:schema];
    return schema;
}

- (TuyaSmartSchemaModel<TYODNumberValueProtocol> *)tyso_average_speed {
    TuyaSmartSchemaModel *schema = [self tyod_schemaMWithCode:dpod_avgspeed_once];
    if (!schema) return nil;
    schema = [self mileageDPConvertFromSchemaM:schema];
    return schema;
}

- (TuyaSmartSchemaModel *)tyso_once_mileage {
    TuyaSmartSchemaModel *schema = [self tyod_schemaMWithCode:dpod_mileage_once];
    if (!schema) return nil;
    schema = [self mileageDPConvertFromSchemaM:schema];
    return schema;
}

- (TuyaSmartSchemaModel *)tyso_once_ridetime {
    TuyaSmartSchemaModel *schema = [self tyod_schemaMWithCode:dpod_ridetime_once];
    return schema;
}

- (TuyaSmartSchemaModel *)tyso_start_status {
    TuyaSmartSchemaModel *schema = [self tyod_schemaMWithCode:dpod_start];
    if (!schema) return nil;
    return schema;
}

- (BOOL)isHiddenEndAndOnceAndTotalMile {
    TuyaSmartSchemaModel<TYODNumberValueProtocol> *endMile = [self tyso_endurance_mileage];
    TuyaSmartSchemaModel<TYODNumberValueProtocol> *totalMile = [self tyso_mileage_total];
    TuyaSmartSchemaModel<TYODNumberValueProtocol> *onceMile = [self tyso_once_mileage];
    return (endMile.numberValue == nil) && (onceMile.numberValue == nil) && (totalMile.numberValue == nil);
}

@end
