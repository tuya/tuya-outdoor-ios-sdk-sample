//
//  TYODStringTableViewCell.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYODDeviceStatusBehaveCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYODStringTableViewCell : TYODDeviceStatusBehaveCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) void(^buttonAction)(NSString *text);

@end

NS_ASSUME_NONNULL_END
