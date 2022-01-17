//
//  UIViewController+Outdoor.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Outdoor)

@property (nonatomic, assign, readonly, getter=isTy_visible) BOOL ty_visible;


//go back to previous page，including present page
- (void)ty_goBackToPreviousPage:(BOOL)animated;
- (void)ty_goBackToFirstPage:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
