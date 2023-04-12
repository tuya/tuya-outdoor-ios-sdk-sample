//
//  TYODDPObserver.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TYODDPObserverSchemaMBlock)(ThingSmartSchemaModel *schemaM);

@class TYODDPObserver;
@protocol TYODDPObserverDelegate <NSObject>

- (void)observer:(TYODDPObserver *)observer deviceID:(NSString *)deviceID schemaM:(ThingSmartSchemaModel *)schemaM;

@end

@interface TYODDPObserver : NSObject

/// listen to the current device DP agent, will listen to all codes
/// @param delegate delegate object
+ (void)addDelegate:(id<TYODDPObserverDelegate>)delegate;

/// listen on the DP agent of the current device, only listen on the DP of codes
/// @param delegate delegate object
/// @param codes listen for codes
+ (void)addDelegate:(id<TYODDPObserverDelegate>)delegate codes:(NSArray<NSString *> *)codes;

+ (void)addObserverDelegate:(id<TYODDPObserverDelegate>)delegate deviceID:(NSString *)deviceID;
+ (void)removeObserverDelegate:(id<TYODDPObserverDelegate>)delegate deviceID:(NSString *)deviceID;

+ (void)addObserverDelegate:(id<TYODDPObserverDelegate>)delegate deviceID:(NSString *)deviceID codes:(NSArray<NSString *> *)codes;
+ (void)removeObserverDelegate:(id<TYODDPObserverDelegate>)delegate deviceID:(NSString *)deviceID codes:(NSArray<NSString *> *)codes;

/// listen for the current device callback
/// @param code The listening code
/// @param schemaMBlock Block callback
+ (TYODDPObserverSchemaMBlock)monitorDPWithCode:(NSString *)code schemaMBlock:(TYODDPObserverSchemaMBlock)schemaMBlock;

+ (TYODDPObserverSchemaMBlock)monitorDPWithDeviceID:(NSString *)deviceID code:(NSString *)code schemaMBlock:(TYODDPObserverSchemaMBlock)schemaMBlock;
@end

NS_ASSUME_NONNULL_END
