//
//  TYSOHomePresenter+Network.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYSOHomePresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYSOHomePresenter (Network)

- (void)requestViewDataWithCompletion:(dispatch_block_t)completion;
- (void)requestLangsPackWithCompletion:(dispatch_block_t)completion;
- (void)requestOutdoorsCurrentDeviceIconWithCompletion:(void(^)(void))completion;
- (void)requestOutdoorsDeviceIconListWithCompletion:(void(^)(void))completion;
- (void)requestTripTrackWithCompletion:(dispatch_block_t)completion;
- (void)requestDeviceListWithCompletion:(dispatch_block_t)completion;
- (void)fetchDeviceOTAInfoData;

@end

NS_ASSUME_NONNULL_END
