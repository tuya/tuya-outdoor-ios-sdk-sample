//
//  TYSOHomePresenter.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <Foundation/Foundation.h>
#import "TYSOHomeViewProtocol.h"
#import "TYSOHomePresenterDataProtocol.h"

@class ThingSmartHome,ThingSmartHomeManager,ThingSmartDevice;

NS_ASSUME_NONNULL_BEGIN

@interface TYSOHomePresenter : NSObject<TYSOHomePresenterDataProtocol,ThingSmartHomeDelegate>

@property (nonatomic, strong) ThingSmartHome *home;
@property (nonatomic, strong) ThingSmartHomeManager *homeManager;
@property (nonatomic, strong) ThingSmartDevice *__nullable device;
@property (nonatomic, strong) NSMutableDictionary *cyclingRecord;
@property (nonatomic, strong) NSMutableDictionary *deviceIconList; 

- (instancetype)initWithView:(id<TYSOHomeViewProtocol>)view;
- (void)changeDeviceBlock;
- (void)reloadHomeData;

@end

NS_ASSUME_NONNULL_END
