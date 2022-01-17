//
//  TYSOHomePresenter.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <Foundation/Foundation.h>
#import "TYSOHomeViewProtocol.h"
#import "TYSOHomePresenterDataProtocol.h"

@class TuyaSmartHome,TuyaSmartHomeManager,TuyaSmartDevice;

NS_ASSUME_NONNULL_BEGIN

@interface TYSOHomePresenter : NSObject<TYSOHomePresenterDataProtocol,TuyaSmartHomeDelegate>

@property (nonatomic, strong) TuyaSmartHome *home;
@property (nonatomic, strong) TuyaSmartHomeManager *homeManager;
@property (nonatomic, strong) TuyaSmartDevice *__nullable device;
@property (nonatomic, strong) NSMutableDictionary *cyclingRecord;
@property (nonatomic, strong) NSMutableDictionary *deviceIconList; 

- (instancetype)initWithView:(id<TYSOHomeViewProtocol>)view;
- (void)changeDeviceBlock;
- (void)reloadHomeData;

@end

NS_ASSUME_NONNULL_END
