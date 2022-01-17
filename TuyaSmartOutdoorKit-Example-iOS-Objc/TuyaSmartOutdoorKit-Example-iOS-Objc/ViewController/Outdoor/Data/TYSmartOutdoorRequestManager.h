//
//  TYSmartOutdoorRequestManager.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYSmartOutdoorRequestManager : NSObject

@property (nonatomic, strong) TuyaSmartOutdoorDeviceListService *service;

+ (instancetype)shareInstance;

//Request device HD picture according to device ID
- (void)requestOutdoorsDevicesIconWithParams:(NSArray<NSString *> *)deviceIds
                                  completion:(void(^)(NSDictionary<NSString *,TuyaSmartOutdoorProductIconModel *> *result))completion;

@end

NS_ASSUME_NONNULL_END
