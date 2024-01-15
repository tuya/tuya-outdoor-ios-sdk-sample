//
//  ThingSmartDeviceModel+ODDpSchema.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "ThingSmartDeviceModel+ODDpSchema.h"
#import "ThingSmartDeviceModel+Outdoors.h"
#import <objc/runtime.h>
#import "ThingSmartSchemaModel+ValueProtocol.h"
#import "TYSmartOutdoorUtils.h"

@implementation ThingSmartDeviceModel (ODDpSchema)
#pragma mark -

// Unit conversion
- (ThingSmartSchemaModel *)mileageDPConvertFromSchemaM:(ThingSmartSchemaModel *)schemaM {
    NSString *mileageUnitType = [[self tsod_schemaMWithCode:@"unit_set"].tsod_DPValue thing_string];
    if ([mileageUnitType.lowercaseString isEqualToString:@"mile"]) {
        double value = [TYSmartOutdoorUtils mileConvertFromKM:[schemaM.tsod_DPValue thing_double]];
        schemaM.tsod_DPValue = @(value);
    }

    if (mileageUnitType) {
        schemaM.property.unit = mileageUnitType;
    }
    else if (schemaM.property.unit.length <= 0) {
        schemaM.property.unit = @"Km";
    }
    return schemaM;
}

- (ThingSmartSchemaModel *)tyso_gps_signal {
    ThingSmartSchemaModel *obj = [self tsod_schemaMWithCode:dpod_gps_signal_strength];
    if (obj) {
        double max = obj.property.max;
        double min = obj.property.min;
        double cSignal = [obj.tsod_DPValue thing_double];

        double num1 = cSignal - min;
        double num2 = max - min;
        double tnum = num1/num2;
        double num = tnum/0.2;

        obj.tsod_DPValue = @(ceil(num));
    }
    return obj;
}

- (ThingSmartSchemaModel *)tyso_4g_signal_strength {
    ThingSmartSchemaModel *model = [self tsod_schemaMWithCode:dpod_4g_signal_strength];
    if (model) {
        NSArray<NSString *> *rangs = model.property.range;
        NSString *cSignal = [model.tsod_DPValue thing_string];
        NSArray<NSString *> *sigArr = rangs.count == 5 ? rangs : @[@"cut", @"bad",@"general",@"good",@"great"];
        NSInteger num = [sigArr indexOfObject:cSignal];
        model.property.selectedValue = num;
    }
    return model;
}

- (ThingSmartSchemaModel *)tyso_gsm_signal {
    ThingSmartSchemaModel *model = [self tsod_schemaMWithCode:dpod_signal_strength];
    if (model) {
        NSInteger max = model.property.max;
        NSInteger min = model.property.min;
        NSInteger cSignal = [model.tsod_DPValue thing_int];

        NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld", (cSignal - min)]];
        NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld", (max - min)]];
        NSDecimalNumber *tnum = [num1 decimalNumberByDividingBy:num2];
        NSDecimalNumber *num = [tnum decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"0.2"]];
        model.tsod_DPValue = @(ceil(num.floatValue));
    }

    return model;
}

- (ThingSmartSchemaModel *)tyso_endurance_mileage {
    ThingSmartSchemaModel *schemaM = [self tsod_schemaMWithCode:dpod_endurance_mileage];
    return [self mileageDPConvertFromSchemaM:schemaM];
}

- (ThingSmartSchemaModel *)tyso_mileage_total {
    ThingSmartSchemaModel *schemaM = [self tsod_schemaMWithCode:dpod_mileage_total];
    return [self mileageDPConvertFromSchemaM:schemaM];
}

- (ThingSmartSchemaModel *)tyso_battery_percentage {
    ThingSmartSchemaModel *schemaM = [self tsod_schemaMWithCode:dpod_battery_percentage];
    return schemaM;
}

- (ThingSmartSchemaModel *)tyso_battery_percentage2 {
    ThingSmartSchemaModel *schemaM = [self tsod_schemaMWithCode:dpod_battery_percentage_2];
    return schemaM;
}

- (ThingSmartSchemaModel *)tyod_speed_limit {
    ThingSmartSchemaModel *schema = [self tsod_schemaMWithCode:dpod_speed_limit_enum];
    if (!schema) {
        schema = [self tsod_schemaMWithCode:dpod_speed_limit_e];
    }
    if (!schema) {
        return nil;
    }
    schema = [self mileageDPConvertFromSchemaM:schema];
    return schema;
}

- (ThingSmartSchemaModel *)tyso_current_speed {
    ThingSmartSchemaModel *schema = [self tsod_schemaMWithCode:dpod_speed];
    if (!schema) return nil;
    schema = [self mileageDPConvertFromSchemaM:schema];
    return schema;
}

- (ThingSmartSchemaModel<TYODNumberValueProtocol> *)tyso_average_speed {
    ThingSmartSchemaModel *schema = [self tsod_schemaMWithCode:dpod_avgspeed_once];
    if (!schema) return nil;
    schema = [self mileageDPConvertFromSchemaM:schema];
    return schema;
}

- (ThingSmartSchemaModel *)tyso_once_mileage {
    ThingSmartSchemaModel *schema = [self tsod_schemaMWithCode:dpod_mileage_once];
    if (!schema) return nil;
    schema = [self mileageDPConvertFromSchemaM:schema];
    return schema;
}

- (ThingSmartSchemaModel *)tyso_once_ridetime {
    ThingSmartSchemaModel *schema = [self tsod_schemaMWithCode:dpod_ridetime_once];
    return schema;
}

- (ThingSmartSchemaModel *)tyso_start_status {
    ThingSmartSchemaModel *schema = [self tsod_schemaMWithCode:dpod_start];
    if (!schema) return nil;
    return schema;
}

- (BOOL)isHiddenEndAndOnceAndTotalMile {
    ThingSmartSchemaModel<TYODNumberValueProtocol> *endMile = [self tyso_endurance_mileage];
    ThingSmartSchemaModel<TYODNumberValueProtocol> *totalMile = [self tyso_mileage_total];
    ThingSmartSchemaModel<TYODNumberValueProtocol> *onceMile = [self tyso_once_mileage];
    return (endMile.numberValue == nil) && (onceMile.numberValue == nil) && (totalMile.numberValue == nil);
}

@end
