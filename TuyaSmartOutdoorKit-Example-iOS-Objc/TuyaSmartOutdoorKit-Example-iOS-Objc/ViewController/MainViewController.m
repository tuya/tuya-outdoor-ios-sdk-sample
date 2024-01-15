//
//  MainViewController.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "MainViewController.h"
#import <ThingSmartOutdoorKit/ThingSmartOutdoorKit.h>

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *version;
    NSDictionary *dic = [[ThingSmartSDK sharedInstance] valueForKey:@"sdkVerMark"];
    if (dic) {
        version = [dic objectForKey:@"outdoorSDK"];
    }
    if (version) {
        self.label.hidden = NO;
        self.label.text = [NSString stringWithFormat:@"version:%@",version];
    }else{
        self.label.hidden = YES;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
