//
//  TYSmartOutdoorUtils.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYSmartOutdoorUtils : NSObject

/// "HH:MM:SS"
+ (NSString *)getMMSSFromSS:(long)totalTime;

/// km mile
+ (double)mileConvertFromKM:(double)km;

/// Distance display character, more than 1 km, display km
+ (NSString *)stringFromDistance:(double)distance;

/// Speed convert km to mile
+ (NSString *)convertSpeedLimit:(NSString *)km_h toUnit:(NSString *)unit;

@end


NS_ASSUME_NONNULL_END
