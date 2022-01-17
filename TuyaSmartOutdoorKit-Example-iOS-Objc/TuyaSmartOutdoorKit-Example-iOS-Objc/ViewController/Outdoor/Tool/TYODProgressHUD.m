//
//  TYODProgressHUD.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYODProgressHUD.h"
#import <SVProgressHUD/SVProgressHUD.h>

NSTimeInterval const HUDMinDismissTimeInterval = 1.0;
NSTimeInterval const HUDMaxDismissTimeInterval = 5.0;

@implementation TYODProgressHUD

+ (void)load {
    [self customHUD];
}

+ (void)showInfoWithStatus:(NSString *)status {
    [self showInfoWithStatus:status maskType:TYProgressHUDMaskTypeClear];
}

+ (void)showInfoWithStatus:(NSString *)status maskType:(TYProgressHUDMaskType)maskType {
    [self showInfoWithStatus:status maskType:maskType completion:^{
        
    }];
}

+ (void)showInfoWithStatus:(NSString *)status maskType:(TYProgressHUDMaskType)maskType completion:(void (^)(void))completion {
    [self resetHUDBehavior];
    SVProgressHUDMaskType type = maskType == TYProgressHUDMaskTypeClear ? SVProgressHUDMaskTypeClear : SVProgressHUDMaskTypeNone;
    [SVProgressHUD setDefaultMaskType:type];
    [SVProgressHUD showInfoWithStatus:status];
    NSTimeInterval delay = [self displayDurationForString:status];
    [SVProgressHUD dismissWithDelay:delay completion:completion];
}

+ (void)showSuccessWithStatus:(NSString *)status {
    [self resetHUDBehavior];
    [SVProgressHUD showSuccessWithStatus:status];
}

+ (void)showErrorWithStatus:(NSString*)status {
    [self resetHUDBehavior];
    [SVProgressHUD showErrorWithStatus:status];
}

+ (void)show {
    [self showWithMaskType:TYProgressHUDMaskTypeClear];
}

+ (void)showWithMaskType:(TYProgressHUDMaskType)maskType {
    [self resetHUDBehavior];
    SVProgressHUDMaskType type = maskType == TYProgressHUDMaskTypeClear ? SVProgressHUDMaskTypeClear : SVProgressHUDMaskTypeNone;
    [SVProgressHUD setDefaultMaskType:type];
    [SVProgressHUD show];
}

+ (void)showWithStatus:(NSString *)status {
    [self showWithStatus:status maskType:TYProgressHUDMaskTypeClear];
}

+ (void)showWithStatus:(NSString *)status maskType:(TYProgressHUDMaskType)maskType {
    [self resetHUDBehavior];
    SVProgressHUDMaskType type = maskType == TYProgressHUDMaskTypeClear ? SVProgressHUDMaskTypeClear : SVProgressHUDMaskTypeNone;
    [SVProgressHUD setDefaultMaskType:type];
    [SVProgressHUD showWithStatus:status];
}

+ (void)dismiss {
    [self dismissWithDelay:0];
}

+ (void)dismissWithDelay:(NSTimeInterval)delay {
    [self dismissWithDelay:delay completion:^{
        
    }];
}

+ (void)dismissWithDelay:(NSTimeInterval)delay completion:(void (^)(void))completion {
    [SVProgressHUD dismissWithDelay:delay completion:completion];
}

+ (BOOL)isVisible {
    return [SVProgressHUD isVisible];
}

+ (void)customHUD {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:HUDMinDismissTimeInterval];
    [SVProgressHUD setMaximumDismissTimeInterval:HUDMaxDismissTimeInterval];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    [SVProgressHUD setInfoImage:nil];
#pragma clang diagnostic pop
}

+ (void)resetHUDBehavior {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

+ (NSTimeInterval)displayDurationForString:(NSString *)string {
    CGFloat minimum = MAX((CGFloat)string.length * 0.06 + 0.5, HUDMinDismissTimeInterval);
    return MIN(minimum, HUDMaxDismissTimeInterval);
}

@end
