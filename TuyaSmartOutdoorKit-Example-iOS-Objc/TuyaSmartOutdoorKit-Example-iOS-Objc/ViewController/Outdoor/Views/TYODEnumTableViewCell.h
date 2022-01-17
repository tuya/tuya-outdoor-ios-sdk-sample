//
//  TYODEnumTableViewCell.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYODDeviceStatusBehaveCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYODEnumTableViewCell : TYODDeviceStatusBehaveCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (strong, nonatomic) NSMutableArray *optionArray;
@property (strong, nonatomic) NSString *currentOption;
@property (strong, nonatomic) void(^selectAction)(NSString *option);

@end

NS_ASSUME_NONNULL_END
