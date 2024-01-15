//
//  ThingSmartDeviceModel+ODDpSchema.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <ThingSmartDeviceCoreKit/ThingSmartDeviceCoreKit.h>
#import "TYODValueProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef ThingSmartSchemaModel<TYODNumberValueProtocol> TYODNumDp;
typedef ThingSmartSchemaModel<TYODBoolValueProtocol> TYODBoolDp;
typedef ThingSmartSchemaModel<TYODEnumValueProtocol> TYODEnumDp;
typedef ThingSmartSchemaModel<TYODStringValueProtocol> TYODStrDp;
typedef ThingSmartSchemaModel<TYODRawValueProtocol> TYODRawDp;
typedef ThingSmartSchemaModel<TYODFaultValueProtocol> TYODFaultDp;

@interface ThingSmartDeviceModel (ODDpSchema)

- (TYODNumDp *)tyso_gps_signal;

- (TYODNumDp *)tyso_gsm_signal;

- (ThingSmartSchemaModel<TYODEnumValueProtocol> *)tyso_4g_signal_strength;
- (TYODNumDp *)tyso_endurance_mileage;
- (TYODNumDp *)tyso_mileage_total;
- (TYODNumDp *)tyso_battery_percentage;
- (TYODNumDp *)tyso_battery_percentage2;
- (TYODNumDp *)tyod_speed_limit;
- (TYODNumDp *)tyso_current_speed;
- (TYODNumDp *)tyso_average_speed;
- (TYODNumDp *)tyso_once_mileage;
- (TYODNumDp *)tyso_once_ridetime;
- (TYODBoolDp *)tyso_start_status;
- (BOOL)isHiddenEndAndOnceAndTotalMile;

@end

NS_ASSUME_NONNULL_END
