//
//  ThingSmartSchemaModel+ValueProtocol.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <ThingSmartDeviceCoreKit/ThingSmartDeviceCoreKit.h>
#import "TYODValueProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThingSmartSchemaModel (ValueProtocol) <TYODNumberValueProtocol, TYODStringValueProtocol, TYODBoolValueProtocol, TYODEnumValueProtocol, TYODFaultValueProtocol, TYODRawValueProtocol>

@end

NS_ASSUME_NONNULL_END
