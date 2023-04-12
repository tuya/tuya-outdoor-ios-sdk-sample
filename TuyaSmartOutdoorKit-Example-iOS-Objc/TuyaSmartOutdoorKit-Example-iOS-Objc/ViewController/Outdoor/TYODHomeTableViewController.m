//
//  TYODHomeTableViewController.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYODHomeTableViewController.h"
#import "UIViewController+Outdoor.h"

#import "TYSOHomePresenter.h"
#import "TYSOHomePresenter+HomeData.h"
#import "TYODBluetoothStateManager.h"
#import "NSObject+Outdoor.h"
#import "ThingSmartDeviceModel+ODDpSchema.h"

#import "TYODSwitchTableViewCell.h"
#import "TYODSliderTableViewCell.h"
#import "TYODEnumTableViewCell.h"
#import "TYODStringTableViewCell.h"
#import "TYODLabelTableViewCell.h"
#import "DeviceDetailTableViewController.h"
#import "TYODDPObserver.h"

@interface TYODHomeTableViewController ()<TYSOHomeViewProtocol,TYODDPObserverDelegate>

@property (nonatomic, strong) TYSOHomePresenter *presenter;
@property (nonatomic, assign) BOOL hasFirstLoadData;

@end

@implementation TYODHomeTableViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.presenter = [[TYSOHomePresenter alloc] initWithView:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shareList:)
                                                 name:@"kNotificationSharedListUpdateWithUUID"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeDeviceAndRefresh)
                                                 name:@"TYODChangeDeviceAndRefresh"
                                               object:nil];
    
    [TYODBluetoothStateManager sharedInstance].bluetoothStateBlock = ^(TYODBluetoothPowerState state) {
        if (state == TYODBluetoothPowerStatePoweredOff) {
            [TYODProgressHUD showErrorWithStatus:@"bluetooth power state powered off"];
        }
    };
    ///Listen for changes in these DP points
    [self listenforChangesInTheseDpPoints];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshingActionAndReloadData)];
    self.tableView.mj_header = header;
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
}

- (void)refreshingActionAndReloadData {
    thing_weakify(self)
    [self.presenter reloadWithCompletion:^{
        thing_strongify(self)
        [self reloadViewData];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.hasFirstLoadData) {
        if ([self.presenter currentDevice].deviceModel == nil) {
            self.presenter = [[TYSOHomePresenter alloc] initWithView:self];
        }
        thing_weakify(self)
        [self.presenter reloadWithCompletion:^{
            thing_strongify(self)
            [self reloadViewData];
        }];
    }
    ///
    ThingSmartDeviceModel *deviceModel = [self.presenter currentDevice].deviceModel;
    bool isOnline = deviceModel.isOnline;
    if (!isOnline && deviceModel) {
        [TYODProgressHUD showErrorWithStatus:@"The device is offline. The control panel is unavailable."];
    }
}

- (void)changeDeviceAndRefresh {
    [self.presenter changeDeviceBlock];
}

///Account A deletes A shared device. Account B deletes the cache of the device
- (void)shareList:(NSNotification *)notification {
    NSString *UUID = [notification.object thing_string];
    if (!UUID) {
        return;
    }
    if ([[self.presenter currentDevice].deviceModel.uuid isEqualToString:UUID]) {
        [TYODDataManager clearCurrentDevice];
    }
    thing_weakify(self)
    [self.presenter reloadWithCompletion:^{
        thing_strongify(self)
        if ([[self.presenter currentDevice].deviceModel.uuid isEqualToString:UUID]) {
            [self.presenter clearCurrentDevice];
        }
        [self reloadViewData];
        self.hasFirstLoadData = NO;
    }];
    self.hasFirstLoadData = NO;
}

#pragma mark -
- (void)reloadViewData {
    self.hasFirstLoadData = YES;
    [self.tableView reloadData];
    ///Listen for changes in these DP points
    [self listenforChangesInTheseDpPoints];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.presenter currentDevice].deviceModel.schemaArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    ThingSmartSchemaModel *schema = [[self.presenter currentDevice].deviceModel.schemaArray thing_safeObjectAtIndex:indexPath.row];
    
    schema = [[self.presenter currentDevice].deviceModel tsod_schemaMWithCode:schema.code];
    if ([schema.code isEqualToString:dpod_gps_signal_strength]) {
        schema = [[self.presenter currentDevice].deviceModel tyso_gps_signal];
    }
    if ([schema.code isEqualToString:dpod_4g_signal_strength]) {
        schema = [[self.presenter currentDevice].deviceModel tyso_4g_signal_strength];
    }
    if ([schema.code isEqualToString:dpod_signal_strength]) {
        schema = [[self.presenter currentDevice].deviceModel tyso_gsm_signal];
    }
    if ([schema.code isEqualToString:dpod_endurance_mileage]) {
        schema = [[self.presenter currentDevice].deviceModel tyso_endurance_mileage];
    }
    if ([schema.code isEqualToString:dpod_mileage_total]) {
        schema = [[self.presenter currentDevice].deviceModel tyso_mileage_total];
    }
    if ([schema.code isEqualToString:dpod_speed_limit_enum]) {
        schema = [[self.presenter currentDevice].deviceModel tyod_speed_limit];
    }
    if ([schema.code isEqualToString:dpod_speed]) {
        schema = [[self.presenter currentDevice].deviceModel tyso_current_speed];
    }
    if ([schema.code isEqualToString:dpod_avgspeed_once]) {
        schema = [[self.presenter currentDevice].deviceModel tyso_average_speed];
    }
    if ([schema.code isEqualToString:dpod_mileage_once]) {
        schema = [[self.presenter currentDevice].deviceModel tyso_once_mileage];
    }
    bool isReadOnly = NO;
    NSString *cellIdentifier = [self.presenter cellIdentifierWithSchemaModel:schema];
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    isReadOnly = [@"ro" isEqualToString:schema.mode];
    thing_weakify(self)
    thing_weakify(cell)
    ///Dp multilingual
    NSString *key = [NSString stringWithFormat:@"dp_%@", schema.code];
    NSString *title = key.tyod_dp_localized ? : schema.name;
    switch ([self.presenter cellTypeWithSchemaModel:schema]) {
        case DeviceControlCellTypeSwitchCell:
        {
            ((TYODSwitchTableViewCell *)cell).label.text = title;
            [((TYODSwitchTableViewCell *)cell).switchButton setOn:[schema.tsod_DPValue thing_bool]];
            ((TYODSwitchTableViewCell *)cell).isReadOnly = isReadOnly;
            ((TYODSwitchTableViewCell *)cell).schema = schema;
            ((TYODSwitchTableViewCell *)cell).switchAction = ^(UISwitch *switchButton) {
                thing_strongify(self)
                thing_strongify(cell)
                [self publishMessageWithCode:schema.code idV:@(switchButton.isOn) cell:cell];
            };
            break;
        }
        case DeviceControlCellTypeSliderCell:
        {
            NSMutableString *detailStr = [NSMutableString string];
            [detailStr appendFormat:@"%@",[schema.tsod_DPValue thing_string]];
            if (schema.property.unit) {
                [detailStr appendString:schema.property.unit];
            }
            ((TYODSliderTableViewCell *)cell).label.text = title;
            ((TYODSliderTableViewCell *)cell).detailLabel.text = detailStr;
            ((TYODSliderTableViewCell *)cell).slider.minimumValue = schema.property.min;
            ((TYODSliderTableViewCell *)cell).slider.maximumValue = schema.property.max;
            [((TYODSliderTableViewCell *)cell).slider setContinuous:NO];
            ((TYODSliderTableViewCell *)cell).slider.value = [schema.tsod_DPValue thing_float];
            ((TYODSliderTableViewCell *)cell).isReadOnly = isReadOnly;
            ((TYODSliderTableViewCell *)cell).sliderAction = ^(UISlider * _Nonnull slider) {
                float step = schema.property.step;
                float roundedValue = round(slider.value / step) * step;
                thing_strongify(self)
                thing_strongify(cell)
                [self publishMessageWithCode:schema.code idV:@((int)roundedValue) cell:cell];
            };
            break;
        }
        case DeviceControlCellTypeEnumCell:
        {
            ((TYODEnumTableViewCell *)cell).label.text = title;
            ((TYODEnumTableViewCell *)cell).optionArray = [schema.property.range mutableCopy];
            ((TYODEnumTableViewCell *)cell).currentOption = [schema.tsod_DPValue thing_string];
            ((TYODEnumTableViewCell *)cell).detailLabel.text = [schema.tsod_DPValue thing_string];
            ((TYODEnumTableViewCell *)cell).isReadOnly = isReadOnly;
            ((TYODEnumTableViewCell *)cell).selectAction = ^(NSString * _Nonnull option) {
                thing_strongify(self)
                thing_strongify(cell)
                [self publishMessageWithCode:schema.code idV:option cell:cell];
            };
            break;
        }
        case DeviceControlCellTypeStringCell:
        {
            ((TYODStringTableViewCell *)cell).label.text = title;
            ((TYODStringTableViewCell *)cell).textField.text = [schema.tsod_DPValue thing_string];
            ((TYODStringTableViewCell *)cell).isReadOnly = isReadOnly;
            ((TYODStringTableViewCell *)cell).buttonAction = ^(NSString * _Nonnull text) {
                thing_strongify(self)
                thing_strongify(cell)
                NSString *str = ((TYODStringTableViewCell *)cell).textField.text;
                str = str ? str : [schema.tsod_DPValue thing_string];
                [self publishMessageWithCode:schema.code idV:str cell:cell];
            };
            break;
        }
        case DeviceControlCellTypeLabelCell:
        {
            ((TYODLabelTableViewCell *)cell).label.text = title;
            ((TYODLabelTableViewCell *)cell).detailLabel.text = [schema.tsod_DPValue thing_string];
            break;
        }
        default:
            break;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.presenter currentDevice].deviceModel.name;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"show-device-detail"]) {
        ((DeviceDetailTableViewController *)segue.destinationViewController).device = [self.presenter currentDevice];
    }
}

#pragma mark ---- HID -------

- (void)listenforChangesInTheseDpPoints {
    NSMutableArray *codeAry = [NSMutableArray array];
    for (ThingSmartSchemaModel *obj in [self.presenter currentDevice].deviceModel.schemaArray) {
        [codeAry addObject:obj.code];
    }
    if(codeAry.count){
        [TYODDPObserver addDelegate:self codes:codeAry];
    }
}

- (void)publishMessageWithCode:(NSString *)code idV:(id)idV cell:(UITableViewCell *)cell {
    thing_weakify(self)
    [self.presenter.device tsod_publishDPWithCode:code DPValue:idV success:^{
        thing_strongify(self)
        if ([self checkNeedHIDBindWithCode:code]) {
            [self tyod_performSelector:@selector(resetHIDBindStatusWithCode:) withObject:code afterDelay:15];
            [TYODProgressHUD show];
        }else{
            [TYODProgressHUD showSuccessWithStatus:@"success"];
        }
    } failure:^(NSError *error) {
        [TYODProgressHUD showErrorWithStatus:error.localizedDescription];
        if ([cell isKindOfClass:[TYODSwitchTableViewCell class]]) {
            [((TYODSwitchTableViewCell *)cell).switchButton setOn:![idV thing_bool] animated:NO];
        }
    }];
}

- (BOOL)checkNeedHIDBindWithCode:(NSString *)code {
    NSArray<NSString *> *HIDCodes = @[dpod_auto_lock, dpod_auto_unlock];
    BOOL needHIDBind = NO;
    if ([HIDCodes containsObject:code]) {
        ThingSmartSchemaModel *dict = [[self.presenter currentDevice].deviceModel tsod_schemaMWithCode:code];
        BOOL idV = [dict.tsod_DPValue thing_bool];
        ThingSmartSchemaModel *bindDict = [[self.presenter currentDevice].deviceModel tsod_schemaMWithCode:dpod_hid_bind];
        NSString *bindState = [bindDict.tsod_DPValue thing_string];
        BOOL hadBind = [bindState isEqualToString:@"bind"];
        if (!idV && !hadBind) {
            needHIDBind = YES;
        }
    }
    return needHIDBind;
}

- (void)resetHIDBindStatusWithCode:(NSString *)code {
    if (code.length <= 0) {
        [TYODProgressHUD dismiss];
        return;
    }
    thing_weakify(self)
    [self.presenter.device tsod_publishDPWithCode:code DPValue:@NO success:^{
        thing_strongify(self)
        [TYODProgressHUD dismiss];
        [self resertUIWithCode:code];
    } failure:^(NSError *error) {
        [TYODProgressHUD dismiss];
    }];
}

- (void)resertUIWithCode:(NSString *)code {
    NSMutableArray<TYODSwitchTableViewCell*> *ary = [NSMutableArray array];
    for (NSInteger i = 0; i < MAX([self.presenter currentDevice].deviceModel.schemaArray.count, 0); i++ ) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([cell isKindOfClass:[TYODSwitchTableViewCell class]]) {
            [ary addObject:(TYODSwitchTableViewCell*)cell];
        }
    }
    [ary enumerateObjectsUsingBlock:^(TYODSwitchTableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.schema.code isEqualToString:code]) {
            [obj.switchButton setOn:NO animated:NO];
            *stop = YES;
        }
    }];
}

- (void)observer:(TYODDPObserver *)observer deviceID:(NSString *)deviceID schemaM:(ThingSmartSchemaModel *)schemaM {
    if ([schemaM.code isEqualToString:dpod_hid_bind]) {
        NSString *bindState = [schemaM.tsod_DPValue thing_string];
        [self tyod_cancelPreviousPerformRequestsWithTarget:self];
        if ([bindState isEqualToString:@"bind"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [TYODProgressHUD dismiss];
            });
        }else{
            BOOL auto_lock_Value = [[[self.presenter currentDevice].deviceModel tsod_schemaMWithCode:dpod_auto_lock].tsod_DPValue thing_bool];
            if (auto_lock_Value) {
                [self resetHIDBindStatusWithCode:dpod_auto_lock];
            }
            BOOL auto_unlock_Value = [[[self.presenter currentDevice].deviceModel tsod_schemaMWithCode:dpod_auto_unlock].tsod_DPValue thing_bool];
            if (auto_unlock_Value) {
                [self resetHIDBindStatusWithCode:dpod_auto_unlock];
            }
            if (!auto_lock_Value && !auto_unlock_Value) {
                [TYODProgressHUD dismiss];
            }
        }
    }
    [self.tableView reloadData];
}

@end
