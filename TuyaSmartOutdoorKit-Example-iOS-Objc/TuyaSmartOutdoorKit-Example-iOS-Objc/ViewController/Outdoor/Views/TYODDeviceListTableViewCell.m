//
//  TYODDeviceListTableViewCell.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYODDeviceListTableViewCell.h"
#import "TuyaSmartDeviceModel+ODDpSchema.h"

@interface TYODDeviceListTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@end

@implementation TYODDeviceListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDeviceModel:(TuyaSmartDeviceModel *)deviceModel {
    _deviceModel = deviceModel;
    NSDictionary *dic = [TYODDataManager localDeviceIconList];
    NSString *iconUrl;
    if (dic && dic.allKeys > 0) {
        iconUrl = [dic ty_stringForKey:_deviceModel.productId];
    }
    if (!iconUrl) {
        iconUrl = _deviceModel.iconUrl;
    }
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:iconUrl]];
    //info
    NSMutableString *info = [NSMutableString string];
    [info appendFormat:@"%@\n\n",_deviceModel.name];
    [info appendFormat:_deviceModel.isOnline ? @"Online" : @"Offline"];
    self.informationLabel.text = info;
}

@end
