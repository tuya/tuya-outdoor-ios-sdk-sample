//
//  TYODLabelTableViewCell.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYODDeviceStatusBehaveCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYODLabelTableViewCell : TYODDeviceStatusBehaveCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

NS_ASSUME_NONNULL_END
