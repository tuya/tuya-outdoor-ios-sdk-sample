//
//  NSObject+Outdoor.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Outdoor)

- (void)tyod_performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay;

- (void)tyod_cancelPreviousPerformRequestsWithTarget:(id)aTarget selector:(SEL)aSelector object:(nullable id)anArgument;

- (void)tyod_cancelPreviousPerformRequestsWithTarget:(id)aTarget;

@end

NS_ASSUME_NONNULL_END
