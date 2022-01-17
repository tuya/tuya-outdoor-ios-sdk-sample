//
//  TYODSliderTableViewCell.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYODDeviceStatusBehaveCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYODSliderTableViewCell : TYODDeviceStatusBehaveCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (strong, nonatomic) void(^sliderAction)(UISlider *slider);

@end

NS_ASSUME_NONNULL_END
