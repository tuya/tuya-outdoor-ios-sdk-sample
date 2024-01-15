//
//  TYODDPLanguageManager.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYODDPLanguageManager : NSObject

+ (instancetype)sharedInstance;

/// Update dp multilingual application startup/add device call
///deviceModelAry Device list
- (void)updateDpLanguageWithDeviceModelAry:(NSArray<ThingSmartDeviceModel *> *)deviceModelAry
                                completion:(void(^)(void))completion;


// Get the multi-language of the device according to PID
///PID Product productId of the current device
- (NSMutableDictionary *)getDeviceDPLanguageWithPID:(NSString *)PID;

@end

/// dp multilingual
@interface NSString (TYSmartOutdoor)

@property (nonatomic, readonly) NSString *tyod_dp_localized;// How does the dp multilingual copy of the current device not return nil

/// Get device multilanguage if nothing returns nil
///PID Product productId of the current device
- (NSString *)tyod_dp_localizedWithPID:(NSString *)PID;

/// Get the multilingual of the current device if default is not returned
/// defaultString Returns the default value if there is no corresponding DP multilanguage copy
- (NSString *)tyod_dp_localizedWithDefault:(NSString *)defaultString;

@end

NS_ASSUME_NONNULL_END
