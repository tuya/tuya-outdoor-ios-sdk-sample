//
//  TYODLoginViewController.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYODLoginViewController.h"

@interface TYODLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *countryCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;

@end

@implementation TYODLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark --- action ---
- (IBAction)loginAction:(id)sender {
    if ([self.accountTextField.text containsString:@"@"]) { 
        [[TuyaSmartUser sharedInstance] loginByEmail:self.countryCodeTextField.text
                                               email:self.accountTextField.text
                                            password:self.passwordTextField.text
                                             success:^
        {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"TYSmartOutdoorMain" bundle:nil];
            UINavigationController *nav = [mainStoryboard instantiateInitialViewController];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        } failure:^(NSError *error) {
            [TYODProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }else{
        [[TuyaSmartUser sharedInstance] loginByPhone:self.countryCodeTextField.text
                                         phoneNumber:self.accountTextField.text
                                            password:self.passwordTextField.text
                                             success:^
        {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"TYSmartOutdoorMain" bundle:nil];
            UINavigationController *nav = [mainStoryboard instantiateInitialViewController];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        } failure:^(NSError *error) {
            [TYODProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
}

- (IBAction)tapGestureRecognizerAction:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
}


@end
