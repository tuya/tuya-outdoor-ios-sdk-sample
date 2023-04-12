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
                                  completion:(void(^)(NSDictionary<NSString *,ThingSmartOutdoorProductIconModel *> *result))completion {
    
    NSSet<NSString *> *set = [NSSet setWithArray:deviceIds];
    [self.service requestProductIconWithDeviceIDList:set success:^(NSDictionary<NSString *,ThingSmartOutdoorProductIconModel *> * _Nonnull productIconMap) {
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
- (ThingSmartOutdoorDeviceListService *)service {
    if (!_service) {
        _service = [[ThingSmartOutdoorDeviceListService alloc] init];
    }
    return _service;
}

@end
