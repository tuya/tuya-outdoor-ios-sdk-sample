//
//  TYSmartOutdoorUtils.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYSmartOutdoorUtils.h"


@implementation TYSmartOutdoorUtils

+ (NSString *)getMMSSFromSS:(long)totalTime {
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",totalTime / 3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(totalTime % 3600) / 60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",totalTime % 60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour, str_minute, str_second];
    return format_time;
}

+ (double)mileConvertFromKM:(double)km {
    return km * 0.621371;
}

+ (NSString *)stringFromDistance:(double)distance {
    NSString *distanceStr;
    if (distance < 1000) {
        distanceStr = [NSString stringWithFormat:@"%dm", (int)(distance)];
    } else {
        distanceStr = [NSString stringWithFormat:@"%0.2fkm", distance / 1000.0];
    }
    return distanceStr;
}

+ (NSNumber *)filterDigitWtihStr:(NSString *)str {
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    float number;
    number = 0;
    [scanner scanFloat:&number];
    if (number <= 0.099) {
        return nil;
    }
    return @(number);
}

+ (NSString *)convertSpeedLimit:(NSString *)km_h toUnit:(NSString *)unit{
    NSNumber *filtered = [self filterDigitWtihStr:km_h];
    if (!filtered) {
        return nil;
    }
    double value_id = [filtered doubleValue];
    if ([unit isEqualToString:@"km"]) {
        NSString *str = [NSString stringWithFormat:@"%.1f", value_id];
        NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:str];
        NSString *mileNumStr = [NSString stringWithFormat:@"%@km/h",num.stringValue];
        return mileNumStr;
    } else {
        value_id = [TYSmartOutdoorUtils mileConvertFromKM:value_id];
        NSString *str = [NSString stringWithFormat:@"%.1f", value_id];
        NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:str];
        NSString *mileNumStr = [NSString stringWithFormat:@"%@mile/h",num.stringValue];
        return mileNumStr;
    }
}

@end
