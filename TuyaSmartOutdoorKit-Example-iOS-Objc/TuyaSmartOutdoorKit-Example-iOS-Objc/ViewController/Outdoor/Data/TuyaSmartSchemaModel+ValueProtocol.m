//
//  TuyaSmartSchemaModel+ValueProtocol.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TuyaSmartSchemaModel+ValueProtocol.h"

@implementation TuyaSmartSchemaModel (ValueProtocol)

// TYODNumberValueProtocol
- (NSNumber *)numberValue {
    NSInteger scale = self.property.scale;
    double value = [self.tyod_DPValue ty_double] / pow(10, scale);
    return @(value);
}

- (NSString *)formatedDecimal:(int)count {
    double value = self.numberValue.doubleValue;
    // Integers do not display decimal points
    double decimalValue  = (NSInteger)value - value;
    BOOL isInteger = decimalValue < 0.005 && decimalValue > -0.005;
    if (isInteger || count == 0) {
        return [NSString stringWithFormat:@"%0.0f", value];
    }
    if (count == 1) {
        return [NSString stringWithFormat:@"%0.1f", value];
    }
    if (count == 2) {
        return [NSString stringWithFormat:@"%0.2f", value];
    }
    if (count == 3) {
        return [NSString stringWithFormat:@"%0.3f", value];
    }
    return [NSString stringWithFormat:@"%0.4f", value];
}

// TYODStringValueProtocol
- (NSString *)stringValue {
    return [self.tyod_DPValue ty_string];
}

// TYODBoolValueProtocol
- (BOOL)boolValue{
    return [self.tyod_DPValue ty_bool];
}

// TYODEnumValueProtocol
- (NSInteger)selectedIndex{
    return self.property.selectedValue;
}
- (NSArray *)enumValues{
    return self.property.range;
}

// TYODFaultValueProtocol
- (NSString *)binaryValue{
    return [self.tyod_DPValue ty_string];
}

// TYODRawValueProtocol
- (NSData *)rawValue {
    return [NSData new];
}

@end
