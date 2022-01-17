//
//  TYODSwitchTableViewCell.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYODSwitchTableViewCell.h"

@implementation TYODSwitchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.switchButton) {
        [self.controls addObject:self.switchButton];
    }
}

- (IBAction)switchTapped:(UISwitch *)sender {
    self.userInteractionEnabled = NO;
    if (self.switchAction) {
        self.switchAction(sender);
    }
    ty_weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ty_strongify(self)
        self.userInteractionEnabled = YES;
    });
}

@end
