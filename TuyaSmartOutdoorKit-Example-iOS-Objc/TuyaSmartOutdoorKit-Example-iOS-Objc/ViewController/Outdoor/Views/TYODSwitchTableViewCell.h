//
//  TYODSwitchTableViewCell.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYODDeviceStatusBehaveCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYODSwitchTableViewCell : TYODDeviceStatusBehaveCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (strong, nonatomic) void(^switchAction)(UISwitch *switchButton);
@property (strong, nonatomic) ThingSmartSchemaModel *schema;

@end

NS_ASSUME_NONNULL_END
