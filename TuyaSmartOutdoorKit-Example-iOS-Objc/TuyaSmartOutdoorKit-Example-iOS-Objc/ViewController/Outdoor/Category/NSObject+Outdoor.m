//
//  NSObject+Outdoor.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "NSObject+Outdoor.h"

@implementation NSObject (Outdoor)

- (void)tyod_performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay {
    if ([NSThread isMainThread]) {
        [self performSelector:aSelector withObject:anArgument afterDelay:delay];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:aSelector withObject:anArgument afterDelay:delay];
        });
    }
}

- (void)tyod_cancelPreviousPerformRequestsWithTarget:(id)aTarget selector:(SEL)aSelector object:(nullable id)anArgument {
    if ([NSThread isMainThread]) {
        [NSObject cancelPreviousPerformRequestsWithTarget:aTarget selector:aSelector object:anArgument];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSObject cancelPreviousPerformRequestsWithTarget:aTarget selector:aSelector object:anArgument];
        });
    }
}

- (void)tyod_cancelPreviousPerformRequestsWithTarget:(id)aTarget {
    if ([NSThread isMainThread]) {
        [NSObject cancelPreviousPerformRequestsWithTarget:aTarget];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSObject cancelPreviousPerformRequestsWithTarget:aTarget];
        });
    }
}

@end
