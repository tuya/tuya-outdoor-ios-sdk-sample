//
//  TYODDPLanguageManager.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYODDPLanguageManager.h"
#import <ThingSmartLangsPackKit/ThingSmartLangsPackKit.h>

static NSString * const KDpLocalDeviceLangsKey = @"KLocalDeviceLangsKey";

@interface TYODDPLanguageManager()

@property (nonatomic, strong) NSMutableDictionary *dpLanguageDictionary; /// all products are dp multilingual
@property (nonatomic, strong) NSMutableDictionary *dpTempLanguageDic; //Temporary product DP multilanguage storage to avoid multiple requests for multilanguage after application startup

@end

@implementation TYODDPLanguageManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static TYODDPLanguageManager * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TYODDPLanguageManager alloc] init];
    });
    return sharedInstance;
}

///Update DP multilanguage
- (void)updateDpLanguageWithDeviceModelAry:(NSArray<TuyaSmartDeviceModel *> *)deviceModelAry
                                completion:(void(^)(void))completion {
    if (deviceModelAry.count < 1) {
        if (completion) {
            completion();
        }
        return;
    }
    __block NSMutableArray<TuyaSmartDeviceModel *> *mArr = [NSMutableArray array];
    __block NSMutableArray<NSString *> *mPIDArr = [NSMutableArray array];
    //Language pack download - Shared Device + My device
    [deviceModelAry enumerateObjectsUsingBlock:^(TuyaSmartDeviceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.productId.length > 0 && ![mPIDArr containsObject:obj.productId]) {
            [mArr addObject:obj];
            [mPIDArr addObject:obj.productId];
        }
    }];
    NSMutableSet *set1 = [NSMutableSet setWithArray:mPIDArr];
    NSMutableSet *set2 = [NSMutableSet setWithArray:self.dpTempLanguageDic.allKeys];
    [set1 minusSet:set2];
    if (set1.count <= 0) {
        if (completion) {
            completion();
        }
        return;
    }
    ty_weakify(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSString *langu = TY_SystemLanguage();
        for (TuyaSmartDeviceModel *deviceModel in mArr) {
            [[ThingSmartLangsPackDownloader downloader] downloadLangsPackWithProductID:deviceModel.productId i18nTime:deviceModel.i18nTime callbackQueue:dispatch_get_global_queue(0, 0) completeBlock:^(NSDictionary<NSString *,NSDictionary<NSString *,NSString *> *> * _Nullable langsPack, NSError * _Nullable error) {
                ty_strongify(self);
                NSDictionary<NSString *,NSString *> *la = [langsPack ty_dictionaryForKey:@"en"];
                if ([[langsPack allKeys] containsObject:langu]) {
                    la = langsPack[langu];
                }
                if (la) { //fix
                    [self setLang:la PID:deviceModel.productId];
                }
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        if (completion) {
            completion();
        }
    });
}

///Gets multiple languages for the current device
- (NSMutableDictionary *)getDeviceDPLanguageWithPID:(NSString *)PID; {
    return [self.dpLanguageDictionary ty_safeObjectForKey:PID];
}

///Save the multilingual copy of the obtained product in memory
- (void)setLang:(NSDictionary *)lang PID:(NSString *)PID {
    [self.dpLanguageDictionary ty_safeSetObject:lang forKey:PID];///memory
    [self.dpTempLanguageDic ty_safeSetObject:lang forKey:PID];///temporary
    [self synchronousDPLangs:self.dpLanguageDictionary]; ///Save to a local directory
}

///Save multilingual copy locally
- (void)synchronousDPLangs:(NSDictionary *)langs {
    [[NSUserDefaults standardUserDefaults] setObject:langs forKey:KDpLocalDeviceLangsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///Get locally saved multilingual copy
- (NSDictionary *)localDPLangs {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:KDpLocalDeviceLangsKey];
    return dic;
}

- (NSMutableDictionary *)dpLanguageDictionary {
    if (!_dpLanguageDictionary) {
        NSDictionary *localLangs = [self localDPLangs];
        if (localLangs && localLangs.allKeys > 0) {
            _dpLanguageDictionary = [NSMutableDictionary dictionaryWithDictionary:localLangs];
        }else{
            _dpLanguageDictionary = [NSMutableDictionary dictionary];
        }
    }
    return _dpLanguageDictionary;
}

- (NSMutableDictionary *)dpTempLanguageDic {
    if (!_dpTempLanguageDic) {
        _dpTempLanguageDic = [NSMutableDictionary dictionary];
    }
    return _dpTempLanguageDic;
}

@end


@implementation NSString (TYSmartOutdoor)

- (NSString *)tyod_dp_localized {
    TuyaSmartDeviceModel *deviceModel = [TuyaSmartDevice deviceWithDeviceId:TYODDataManager.currentDeviceID].deviceModel;
    NSDictionary *dic = [[TYODDPLanguageManager sharedInstance] getDeviceDPLanguageWithPID:deviceModel.productId];
    NSString *str = [dic ty_safeObjectForKey:self];
    return str;
}

- (NSString *)tyod_dp_localizedWithPID:(NSString *)PID {
    NSDictionary *dic = [[TYODDPLanguageManager sharedInstance] getDeviceDPLanguageWithPID:PID];
    NSString *str = [dic ty_safeObjectForKey:self];
    return str;
}

- (NSString *)tyod_dp_localizedWithDefault:(NSString *)defaultString {
    TuyaSmartDeviceModel *deviceModel = [TuyaSmartDevice deviceWithDeviceId:TYODDataManager.currentDeviceID].deviceModel;
    NSDictionary *dic = [[TYODDPLanguageManager sharedInstance] getDeviceDPLanguageWithPID:deviceModel.productId];
    NSString *str = [dic ty_safeObjectForKey:self];
    if (!str) {
        str = defaultString;
    }
    return str;
}

@end
