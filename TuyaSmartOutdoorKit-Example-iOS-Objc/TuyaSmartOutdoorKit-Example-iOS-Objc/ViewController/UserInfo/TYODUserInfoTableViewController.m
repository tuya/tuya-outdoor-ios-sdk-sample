//
//  TYODUserInfoTableViewController.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYODUserInfoTableViewController.h"

@interface TYODUserInfoTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *currentHomeLabel;

@end

@implementation TYODUserInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentHomeLabel.text = [Home getCurrentHome].name;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([Home getCurrentHome]) {
        self.currentHomeLabel.text = [Home getCurrentHome].name;
    }
}

- (IBAction)logOutButtonAction:(id)sender {
    [[ThingSmartUser sharedInstance] loginOut:^{
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *nav = [mainStoryboard instantiateInitialViewController];
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    } failure:^(NSError *error) {
        [TYODProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


@end
