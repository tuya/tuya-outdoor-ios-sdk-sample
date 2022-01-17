//
//  TYODValueProtocol.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TYODNumberValueProtocol <NSObject>
- (NSNumber *)numberValue;
///Converts to the specified decimal character
- (NSString *)formatedDecimal:(int)count;
@end

@protocol TYODStringValueProtocol <NSObject>
- (NSString *)stringValue;
@end

@protocol TYODBoolValueProtocol <NSObject>
- (BOOL)boolValue;
@end

@protocol TYODEnumValueProtocol <NSObject>
- (NSUInteger)selectedIndex;
- (NSArray *)enumValues;
@end

@protocol TYODFaultValueProtocol <NSObject>
//\Binary values
- (NSString *)binaryValue;
@end

@protocol TYODRawValueProtocol <NSObject>
- (NSData *)rawValue;
@end

NS_ASSUME_NONNULL_END
