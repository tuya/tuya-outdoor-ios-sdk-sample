//
//  TYODDeviceStatusBehaveCell.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYODDeviceStatusBehaveCell : UITableViewCell

@property (strong, nonatomic) NSMutableArray *controls;
@property (assign, nonatomic) bool isReadOnly;
- (void)disableControls;
- (void)enableControls;

@end

NS_ASSUME_NONNULL_END
