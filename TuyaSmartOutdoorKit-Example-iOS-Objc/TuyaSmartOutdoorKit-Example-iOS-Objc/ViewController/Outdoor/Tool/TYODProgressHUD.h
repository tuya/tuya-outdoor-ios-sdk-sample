//
//  TYODProgressHUD.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TYProgressHUDMaskType) {
    TYProgressHUDMaskTypeClear = 0,       // don't allow user interactions
    TYProgressHUDMaskTypeInteraction,     // allow user interactions
};

@interface TYODProgressHUD : NSObject

// show only message
+ (void)showInfoWithStatus:(NSString *)status;
+ (void)showInfoWithStatus:(NSString *)status maskType:(TYProgressHUDMaskType)maskType;
+ (void)showInfoWithStatus:(NSString *)status maskType:(TYProgressHUDMaskType)maskType completion:(void (^)(void))completion;
+ (void)showSuccessWithStatus:(NSString *)status;
+ (void)showErrorWithStatus:(NSString*)status;

// show indicator/message
+ (void)show;
+ (void)showWithMaskType:(TYProgressHUDMaskType)maskType;
+ (void)showWithStatus:(NSString *)status;
+ (void)showWithStatus:(NSString *)status maskType:(TYProgressHUDMaskType)maskType;

// dismiss hud
+ (void)dismiss;
+ (void)dismissWithDelay:(NSTimeInterval)delay;
+ (void)dismissWithDelay:(NSTimeInterval)delay completion:(void (^)(void))completion;

+ (BOOL)isVisible;

@end

NS_ASSUME_NONNULL_END

