//
//  TYODAPIViewController.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYODAPIViewController.h"

@interface TYODAPIViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSMutableArray *listAry;

@property (nonatomic, strong) TuyaSmartOutdoorDeviceListService *deviceListService;
@property (nonatomic, strong) TuyaSmartOutdoorCyclingService *cyclingService;
@property (nonatomic, strong) TuyaSmartOutdoorStoreService *storeService;

@end

@implementation TYODAPIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MAX(self.listAry.count, 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TYODAPI"
                                                            forIndexPath:indexPath];
    cell.textLabel.text = [self.listAry ty_safeObjectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *devId = [TYODDataManager currentDeviceID];
    if (!devId) {
        return;
    }
    ty_weakify(self)
    switch (indexPath.row) {
        case 0:
        {
            NSSet<NSString *> *set = [NSSet setWithArray:@[devId]];
            [self.deviceListService requestProductIconWithDeviceIDList:set
                                                               success:^(NSDictionary<NSString *,TuyaSmartOutdoorProductIconModel *> * _Nonnull productIconMap)
            {
                ty_strongify(self)
                self.textView.text = [productIconMap yy_modelToJSONString];
                [TYODProgressHUD showSuccessWithStatus:self.textView.text];
            } failure:^(NSError * _Nonnull error) {
                ty_strongify(self)
                self.textView.text = error.localizedDescription;
                [TYODProgressHUD showErrorWithStatus:self.textView.text];
            }];
        }
            break;
        case 1:
        {
            [self.deviceListService requestHardwareWithDeviceID:devId success:^(TuyaSmartOutdoorDeviceHardwareModel * _Nonnull hardwareModel) {
                ty_strongify(self)
                self.textView.text = [hardwareModel yy_modelToJSONString];
                [TYODProgressHUD showSuccessWithStatus:self.textView.text];
            } failure:^(NSError * _Nonnull error) {
                ty_strongify(self)
                self.textView.text = error.localizedDescription;
                [TYODProgressHUD showErrorWithStatus:self.textView.text];
            }];
        }
            break;
        case 2:
        {
            [self.cyclingService requestTripTrackWithDeviceId:devId size:10 completion:^(NSArray<TuyaSmartOutdoorCycleRecordModel *> * _Nonnull records, NSError * _Nonnull error) {
                ty_strongify(self)
                if (error) {
                    self.textView.text = error.localizedDescription;
                    [TYODProgressHUD showErrorWithStatus:self.textView.text];
                }else{
                    self.textView.text = [records yy_modelToJSONString];
                    [TYODProgressHUD showSuccessWithStatus:self.textView.text];
                }
            }];
        }
            break;
        case 3:
        {
            UInt64 startTime = (UInt64)([[NSDate date] timeIntervalSince1970] * 1000);
            UInt64 endTime = (UInt64)([[NSDate date] timeIntervalSince1970] * 1000);
            [self.cyclingService requestTripTrackStatisticWithDeviceId:devId
                                                             startTime:startTime
                                                               endTime:endTime
                                                            completion:^(TuyaSmartOutdoorCycleRecordModel * _Nonnull record, NSError * _Nonnull error)
            {
                ty_strongify(self)
                if (error) {
                    self.textView.text = error.localizedDescription;
                    [TYODProgressHUD showErrorWithStatus:self.textView.text];
                }else{
                    self.textView.text = [record yy_modelToJSONString];
                    [TYODProgressHUD showSuccessWithStatus:self.textView.text];
                }
            }];
        }
            break;
        case 4:
        {
            TuyaSmartOutdoorLocationUploadModel *model = [[TuyaSmartOutdoorLocationUploadModel alloc] init];
            model.coord = CLLocationCoordinate2DMake(31.157840043548337, 121.15179116499475);
            model.speed = 14;
            model.mileage = 14;
            model.started = YES;
            model.batteryValue = 99;
            NSString *productId = [TuyaSmartDevice deviceWithDeviceId:devId].deviceModel.productId;
            [self.cyclingService uploadLocatonWithDeviceId:devId
                                                 productId:productId
                                               uploadModel:model
                                                completion:^(BOOL success, NSError * _Nonnull error)
            {
                ty_strongify(self)
                if (error) {
                    self.textView.text = error.localizedDescription;
                    [TYODProgressHUD showErrorWithStatus:self.textView.text];
                }else{
                    self.textView.text = [NSString stringWithFormat:@"upload:%d",success];
                    [TYODProgressHUD showSuccessWithStatus:self.textView.text];
                }
            }];
        }
            break;
        case 5:
        {
            TuyaSmartOutdoorStoreRequestModel *model = [[TuyaSmartOutdoorStoreRequestModel alloc] init];
            model.radius = 20;
            model.longitude = 31.157840043548337;
            model.latitude = 121.15179116499475;
            model.coordType = @"WGS84-google";
            model.max = 10;
            [self.storeService requestStoreWithParams:model
                                           completion:^(NSArray<TuyaSmartOutdoorStoreModel *> * _Nonnull storeList, NSError * _Nonnull error)
            {
                ty_strongify(self)
                if (error) {
                    self.textView.text = error.localizedDescription;
                    [TYODProgressHUD showErrorWithStatus:self.textView.text];
                }else{
                    self.textView.text = [storeList yy_modelToJSONString];
                    [TYODProgressHUD showSuccessWithStatus:self.textView.text];
                }
            }];
        }
            break;
        case 6:
        {
            TuyaSmartOutdoorStorePageRequestModel *model = [[TuyaSmartOutdoorStorePageRequestModel alloc] init];
            model.longitude = 31.157840043548337;
            model.latitude = 121.15179116499475;
            model.coordType = @"WGS84-google";
            model.keyword = @"door";//Search content
            model.pageIndex = 0;
            model.pageSize = 10;
            [self.storeService requestStorePagesWithParams:model
                                                completion:^(NSArray<TuyaSmartOutdoorStoreModel *> * _Nonnull storeList, NSError * _Nonnull error)
            {
                ty_strongify(self)
                if (error) {
                    self.textView.text = error.localizedDescription;
                    [TYODProgressHUD showErrorWithStatus:self.textView.text];
                }else{
                    self.textView.text = [storeList yy_modelToJSONString];
                    [TYODProgressHUD showSuccessWithStatus:self.textView.text];
                }
            }];
        }
            break;
        default:
            break;
    }
    
}

- (NSMutableArray *)listAry {
    if (!_listAry) {
        _listAry = [NSMutableArray arrayWithObjects:@"request product icon",@"request hardware info",@"request track record list",@"request track statistic",@"update cycling info for track record",@"request store with radius",@"request store with keyword", nil];
    }
    return _listAry;
}

- (TuyaSmartOutdoorDeviceListService*)deviceListService {
    if (!_deviceListService) {
        _deviceListService = [[TuyaSmartOutdoorDeviceListService alloc] init];
    }
    return _deviceListService;
}

- (TuyaSmartOutdoorCyclingService *)cyclingService {
    if (!_cyclingService) {
        _cyclingService = [[TuyaSmartOutdoorCyclingService alloc] init];
    }
    return _cyclingService;
}

- (TuyaSmartOutdoorStoreService *)storeService {
    if (!_storeService) {
        _storeService = [[TuyaSmartOutdoorStoreService alloc] init];
    }
    return _storeService;
}

@end
