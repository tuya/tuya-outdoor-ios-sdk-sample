//
//  TYSOHomeDataProtocol.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ThingSmartDevice;
@protocol TYSOHomePresenterDataProtocol <NSObject>

- (void)reloadWithCompletion:(dispatch_block_t)completion;
- (ThingSmartDevice *)currentDevice;
- (void)clearCurrentDevice;

@end

typedef NS_ENUM(NSInteger, DeviceControlCellType) {
    DeviceControlCellTypeSwitchCell, //"device-switch-cell"
    DeviceControlCellTypeSliderCell, //"device-slider-cell"
    DeviceControlCellTypeEnumCell,   //"device-enum-cell"
    DeviceControlCellTypeStringCell, //"device-string-cell"
    DeviceControlCellTypeLabelCell   //"device-label-cell"
};

@protocol TYODHomePresenterViewProtocol <NSObject>

- (NSString *)cellIdentifierWithSchemaModel:(ThingSmartSchemaModel *)schema;
- (DeviceControlCellType)cellTypeWithSchemaModel:(ThingSmartSchemaModel *)schema;

@end

NS_ASSUME_NONNULL_END
