//
//  Home.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "Home.h"

@implementation Home

+ (ThingSmartHomeModel *)getCurrentHome {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults valueForKey:@"CurrentHome"]) {
        return nil;
    }
    long long homeId = [[defaults valueForKey:@"CurrentHome"] longLongValue];
    if (![ThingSmartHome homeWithHomeId:homeId]) {
        return nil;
    }
    return [ThingSmartHome homeWithHomeId:homeId].homeModel;
}

+ (void)setCurrentHome:(ThingSmartHomeModel *)homeModel {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSString stringWithFormat:@"%lld", homeModel.homeId] forKey:@"CurrentHome"];
}

@end
