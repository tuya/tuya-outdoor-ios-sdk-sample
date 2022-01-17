//
//  TuyaSmartSchemaModel+ValueProtocol.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <TuyaSmartDeviceCoreKit/TuyaSmartDeviceCoreKit.h>
#import "TYODValueProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSmartSchemaModel (ValueProtocol) <TYODNumberValueProtocol, TYODStringValueProtocol, TYODBoolValueProtocol, TYODEnumValueProtocol, TYODFaultValueProtocol, TYODRawValueProtocol>

@end

NS_ASSUME_NONNULL_END
