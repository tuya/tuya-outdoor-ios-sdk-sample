//
//  TYODDPObserver.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYODDPObserver.h"
#import "TYODDataManager.h"

static id _instace = nil;

static NSString * TYODDP_CurrentDeviceID(void) {
    return TYODDataManager.currentDeviceID;
}

static NSString * TYODDP_observerKey(NSString *deviceID, NSString *code) {
    TuyaSmartDeviceModel *deviceModel = [TuyaSmartDevice deviceWithDeviceId:deviceID].deviceModel;
    NSString *dpID = [deviceModel tyod_schemaMWithCode:code].dpId;
    
    if (!dpID.ty_isStringAndNotEmpty) return nil;
    
    NSString *key = [NSString stringWithFormat:@"%@_%@", deviceModel.devId, dpID];
    return key;
}

@interface TYODDPObserver ()

@property (nonatomic, strong) NSMapTable<NSString *, NSHashTable<id<TYODDPObserverDelegate>> *> *codeDelegatesMap;
@property (nonatomic, strong) NSMapTable<NSString *, NSHashTable<TYODDPObserverSchemaMBlock> *> *codeBlocksMap;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *schemaAdaptorMap; /* DEVICEID_DPID 与 DP Code */

@end

@implementation TYODDPObserver
+ (void)addDelegate:(id<TYODDPObserverDelegate>)delegate {
    if (!TYODDP_CurrentDeviceID().ty_isStringAndNotEmpty) return;
    [self addObserverDelegate:delegate deviceID:TYODDP_CurrentDeviceID()];
}

+ (void)addDelegate:(id<TYODDPObserverDelegate>)delegate codes:(NSArray<NSString *> *)codes {
    [self addObserverDelegate:delegate deviceID:TYODDP_CurrentDeviceID() codes:codes];
}

+ (void)addObserverDelegate:(id<TYODDPObserverDelegate>)delegate deviceID:(NSString *)deviceID {
    NSArray<NSString *> *codes = [self assembleCodesFromDeviceID:deviceID];
    [self addObserverDelegate:delegate deviceID:deviceID codes:codes];
}

+ (void)removeObserverDelegate:(id<TYODDPObserverDelegate>)delegate deviceID:(NSString *)deviceID {
    NSArray<NSString *> *codes = [self assembleCodesFromDeviceID:deviceID];
    [self removeObserverDelegate:delegate deviceID:deviceID codes:codes];
}

+ (void)addObserverDelegate:(id<TYODDPObserverDelegate>)delegate deviceID:(NSString *)deviceID codes:(NSArray<NSString *> *)codes {
    TYAssertCond([delegate conformsToProtocol:@protocol(TYODDPObserverDelegate)]);
    TYAssertCond(codes.ty_isArrayAndNotEmpty);
    TYAssertCond(deviceID.ty_isStringAndNotEmpty);
    
    if (!TYODDP_CurrentDeviceID().ty_isStringAndNotEmpty) return;
    if (!delegate) return;
    if (!codes.ty_isArrayAndNotEmpty) return;
    if (!deviceID.ty_isStringAndNotEmpty) return;
    
    for (NSString *code in codes) {
        NSString *key = TYODDP_observerKey(deviceID, code);
        if (!key.ty_isStringAndNotEmpty) continue;
        
        NSHashTable<id<TYODDPObserverDelegate>> *hashTable = [[TYODDPObserver observer].codeDelegatesMap objectForKey:key];
        if (!hashTable) {
            hashTable =  [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:0];
        }
        [hashTable addObject:delegate];
        
        [[TYODDPObserver observer].schemaAdaptorMap setObject:code forKey:key];
        [[TYODDPObserver observer].codeDelegatesMap setObject:hashTable forKey:key];
    }
}

+ (void)removeObserverDelegate:(id<TYODDPObserverDelegate>)delegate deviceID:(NSString *)deviceID codes:(NSArray<NSString *> *)codes {
    for (NSString *code in codes) {
        NSString *key = TYODDP_observerKey(deviceID, code);
        if (!key.ty_isStringAndNotEmpty) continue;
        
        NSHashTable<id<TYODDPObserverDelegate>> *hashTable = [[TYODDPObserver observer].codeDelegatesMap objectForKey:key];
        if (hashTable) {
            [hashTable removeObject:delegate];
        }
    }
}

#pragma mark - Block
+ (TYODDPObserverSchemaMBlock)monitorDPWithCode:(NSString *)code schemaMBlock:(TYODDPObserverSchemaMBlock)schemaMBlock {
    return [self monitorDPWithDeviceID:TYODDP_CurrentDeviceID() code:code schemaMBlock:schemaMBlock];
}

+ (TYODDPObserverSchemaMBlock)monitorDPWithDeviceID:(NSString *)deviceID code:(NSString *)code schemaMBlock:(TYODDPObserverSchemaMBlock)schemaMBlock {
    TYAssertCond(code.ty_isStringAndNotEmpty);
    TYAssertCond(schemaMBlock);
    TYAssertCond(deviceID.ty_isStringAndNotEmpty);
    
    if (!code.ty_isStringAndNotEmpty) return nil;
    if (!TYODDP_CurrentDeviceID().ty_isStringAndNotEmpty) return nil;
    if (!deviceID.ty_isStringAndNotEmpty) return nil;
    
    NSString *key = TYODDP_observerKey(deviceID, code);
    
    if (!key.ty_isStringAndNotEmpty) return nil;
    
    NSHashTable<TYODDPObserverSchemaMBlock> *hashTable = [[TYODDPObserver observer].codeBlocksMap objectForKey:key];
    if (!hashTable) {
        hashTable =  [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:0];
    }
    [hashTable addObject:schemaMBlock];
    
    [[TYODDPObserver observer].schemaAdaptorMap setObject:code forKey:key];
    [[TYODDPObserver observer].codeBlocksMap setObject:hashTable forKey:key];
    return schemaMBlock;
}

#pragma mark - logic
- (void)deviceDPsUpdate:(NSNotification *)notification {
    NSString *devID = [notification.object ty_stringForKey:@"devId"];
    NSDictionary<NSString *, id> *dpsDict = [notification.object ty_dictionaryForKey:@"dps"];
    
    TuyaSmartDeviceModel *deviceModel = [TuyaSmartDevice deviceWithDeviceId:devID].deviceModel;
    for (NSString *dpID in dpsDict.allKeys) {
        NSString *key = [NSString stringWithFormat:@"%@_%@", devID, dpID];
        
        // ...block
        TuyaSmartSchemaModel *schemaM = [deviceModel tyod_schemaMWithCode:[self.schemaAdaptorMap ty_stringForKey:key]];
        NSHashTable<TYODDPObserverSchemaMBlock> *hashTableBlocks = [[TYODDPObserver observer].codeBlocksMap objectForKey:key];
        NSEnumerator <TYODDPObserverSchemaMBlock> *blocks = hashTableBlocks.objectEnumerator;
        TYODDPObserverSchemaMBlock schemaMBlock = blocks.nextObject;
        while (schemaMBlock != nil) {
            schemaMBlock(schemaM);
            schemaMBlock = blocks.nextObject;
        }
        
        // ...delegate
        NSHashTable<id<TYODDPObserverDelegate>> *hashTableDelegates = [[TYODDPObserver observer].codeDelegatesMap objectForKey:key];
        NSEnumerator<id<TYODDPObserverDelegate>> *delegates = hashTableDelegates.objectEnumerator;
        id<TYODDPObserverDelegate> delegate = delegates.nextObject;
        while (delegate != nil) {
            if ([delegate respondsToSelector:@selector(observer:deviceID:schemaM:)]) {
                [delegate observer:self deviceID:devID schemaM:schemaM];
            }
            delegate = delegates.nextObject;
        }
    }
}

#pragma mark - Private
+ (NSArray<NSString *> *)assembleCodesFromDeviceID:(NSString *)deviceID {
    NSArray<TuyaSmartSchemaModel *> *schemaArr = [TuyaSmartDevice deviceWithDeviceId:deviceID].deviceModel.schemaArray;
    
    NSMutableArray<NSString *> *mCodes = [NSMutableArray arrayWithCapacity:schemaArr.count];
    for (TuyaSmartSchemaModel *schemaM in schemaArr) {
        [mCodes addObject:schemaM.code];
    }
    return mCodes.copy;
}

#pragma mark - init
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)observer {
    return [[self alloc] init];
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super init];
        if (_instace) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDPsUpdate:) name:@"kNotificationDeviceDpsUpdate" object:nil];
            self.codeBlocksMap = [NSMapTable strongToStrongObjectsMapTable];
            self.codeDelegatesMap = [NSMapTable strongToStrongObjectsMapTable];
            self.schemaAdaptorMap = [NSMutableDictionary dictionary];
        }
    });
    return _instace;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!_instace) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instace = [super allocWithZone:zone];
        });
    }
    return _instace;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return _instace;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return _instace;
}

@end
