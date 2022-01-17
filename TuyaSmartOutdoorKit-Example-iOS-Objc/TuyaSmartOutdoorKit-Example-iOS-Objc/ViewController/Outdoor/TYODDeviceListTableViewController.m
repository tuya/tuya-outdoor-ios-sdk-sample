//
//  TYODDeviceListTableViewController.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYODDeviceListTableViewController.h"
#import "TYODDeviceListTableViewCell.h"
#import "TYSOHomePresenter.h"

@interface TYODDeviceListTableViewController ()

@property (nonatomic, strong) NSMutableArray<TuyaSmartDeviceModel *> *deviceList;
@property (nonatomic, strong) NSMutableArray<TuyaSmartDeviceModel *> *sharedDeviceList;

@end

@implementation TYODDeviceListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.deviceList.count;
    }else{
        return self.sharedDeviceList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYODDeviceListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TYODDeviceListTableViewCell"
                                                                        forIndexPath:indexPath];
    TuyaSmartDeviceModel *deviceModel;
    if (indexPath.section == 0) {
        deviceModel = [self.deviceList ty_safeObjectAtIndex:indexPath.row];
    }else{
        deviceModel = [self.sharedDeviceList ty_safeObjectAtIndex:indexPath.row];
    }
    cell.deviceModel = deviceModel;
    if ([deviceModel.devId isEqualToString:[TYODDataManager currentDeviceID]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TuyaSmartDeviceModel *deviceModel;
    if (indexPath.section == 0) {
        deviceModel = [self.deviceList ty_safeObjectAtIndex:indexPath.row];
    }else{
        deviceModel = [self.sharedDeviceList ty_safeObjectAtIndex:indexPath.row];
    }
    [TYODDataManager clearCurrentDevice];
    TYODDataManager.currentDeviceID = deviceModel.devId;
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TYODChangeDeviceAndRefresh" object:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"My Device";
    } else {
        return @"Shared Device";
    }
}

- (NSMutableArray<TuyaSmartDeviceModel *> *)deviceList {
    if (!_deviceList) {
        _deviceList = [NSMutableArray array];
        [_deviceList addObjectsFromArray:[TYODDataManager outdoorsDeviceList]];
    }
    return _deviceList;
}

- (NSMutableArray<TuyaSmartDeviceModel *> *)sharedDeviceList {
    if (!_sharedDeviceList) {
        _sharedDeviceList = [NSMutableArray array];
        [_sharedDeviceList addObjectsFromArray:[TYODDataManager outdoorsSharedDeviceList]];
    }
    return _sharedDeviceList;
}

@end
