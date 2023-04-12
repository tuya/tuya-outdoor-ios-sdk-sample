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
    ThingSmartDeviceModel *deviceModel = [ThingSmartDevice deviceWithDeviceId:deviceID].deviceModel;
    NSString *dpID = [deviceModel tsod_schemaMWithCode:code].dpId;
    
    if (!dpID.thing_isStringAndNotEmpty) return nil;
    
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
    if (!TYODDP_CurrentDeviceID().thing_isStringAndNotEmpty) return;
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
    ThingAssertCond([delegate conformsToProtocol:@protocol(TYODDPObserverDelegate)]);
    ThingAssertCond(codes.thing_isArrayAndNotEmpty);
    ThingAssertCond(deviceID.thing_isStringAndNotEmpty);
    
    if (!TYODDP_CurrentDeviceID().thing_isStringAndNotEmpty) return;
    if (!delegate) return;
    if (!codes.thing_isArrayAndNotEmpty) return;
    if (!deviceID.thing_isStringAndNotEmpty) return;
    
    for (NSString *code in codes) {
        NSString *key = TYODDP_observerKey(deviceID, code);
        if (!key.thing_isStringAndNotEmpty) continue;
        
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
        if (!key.thing_isStringAndNotEmpty) continue;
        
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
    ThingAssertCond(code.thing_isStringAndNotEmpty);
    ThingAssertCond(schemaMBlock);
    ThingAssertCond(deviceID.thing_isStringAndNotEmpty);
    
    if (!code.thing_isStringAndNotEmpty) return nil;
    if (!TYODDP_CurrentDeviceID().thing_isStringAndNotEmpty) return nil;
    if (!deviceID.thing_isStringAndNotEmpty) return nil;
    
    NSString *key = TYODDP_observerKey(deviceID, code);
    
    if (!key.thing_isStringAndNotEmpty) return nil;
    
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
    NSString *devID = [notification.object thing_stringForKey:@"devId"];
    NSDictionary<NSString *, id> *dpsDict = [notification.object thing_dictionaryForKey:@"dps"];
    
    ThingSmartDeviceModel *deviceModel = [ThingSmartDevice deviceWithDeviceId:devID].deviceModel;
    for (NSString *dpID in dpsDict.allKeys) {
        NSString *key = [NSString stringWithFormat:@"%@_%@", devID, dpID];
        
        // ...block
        ThingSmartSchemaModel *schemaM = [deviceModel tsod_schemaMWithCode:[self.schemaAdaptorMap thing_stringForKey:key]];
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
    NSArray<ThingSmartSchemaModel *> *schemaArr = [ThingSmartDevice deviceWithDeviceId:deviceID].deviceModel.schemaArray;
    
    NSMutableArray<NSString *> *mCodes = [NSMutableArray arrayWithCapacity:schemaArr.count];
    for (ThingSmartSchemaModel *schemaM in schemaArr) {
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
