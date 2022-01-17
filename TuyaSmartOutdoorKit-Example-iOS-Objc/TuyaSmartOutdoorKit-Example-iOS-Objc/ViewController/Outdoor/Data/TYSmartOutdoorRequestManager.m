//
//  TYSmartOutdoorRequestManager.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYSmartOutdoorRequestManager.h"

static id _instace = nil;

@implementation TYSmartOutdoorRequestManager

+ (instancetype)shareInstance {
    return [[self alloc] init];
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super init];
        if (_instace) {
        }
    });
    return _instace;
}

- (void)requestOutdoorsDevicesIconWithParams:(NSArray<NSString *> *)deviceIds
                                  completion:(void(^)(NSDictionary<NSString *,TuyaSmartOutdoorProductIconModel *> *result))completion {
    
    NSSet<NSString *> *set = [NSSet setWithArray:deviceIds];
    [self.service requestProductIconWithDeviceIDList:set success:^(NSDictionary<NSString *,TuyaSmartOutdoorProductIconModel *> * _Nonnull productIconMap) {
        if (completion) {
            completion(productIconMap);
        }
    } failure:^(NSError * _Nonnull error) {
        if (completion) {
            completion(nil);
        }
    }];
}

#pragma mark -
- (TuyaSmartOutdoorDeviceListService *)service {
    if (!_service) {
        _service = [[TuyaSmartOutdoorDeviceListService alloc] init];
    }
    return _service;
}

@end
