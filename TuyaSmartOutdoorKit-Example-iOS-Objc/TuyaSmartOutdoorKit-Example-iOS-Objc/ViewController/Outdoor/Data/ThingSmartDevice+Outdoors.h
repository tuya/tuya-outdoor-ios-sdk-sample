//
//  ThingSmartDevice+Outdoors.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <ThingSmartDeviceCoreKit/ThingSmartDeviceCoreKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThingSmartDevice (Outdoors)

@property (nonatomic, assign) NSTimeInterval tyso_beginRideTime;
@property (nonatomic, assign) NSTimeInterval tyso_beginNaviTime;

/// The type of DP point communication will be checked when the DP entry is sent to the external line. Some DP only supports Bluetooth communication. If bluetooth is not enabled on the device, the permission box will prompt
/// @param code The sent DP Code will search for relevant DP ids according to the secondary Code to send DP. Therefore, multiple DP ids are not supported
/// @param dpValue DP value, string type RAW type interface implementation will do value conversion, the upper layer can not be converted
/// @param success Success callback
/// @param failure Failure callback
- (void)tyod_publish_code:(NSString *)code
                  dpValue:(id)dpValue
                  success:(nullable ThingSuccessHandler)success
                  failure:(nullable ThingFailureError)failure;
@end

NS_ASSUME_NONNULL_END
