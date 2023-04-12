//
//  TYODRegisterTableViewController.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYODRegisterTableViewController.h"

@interface TYODRegisterTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *countryCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;

@end

@implementation TYODRegisterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)sendVerificationCodeButtonAction:(id)sender {
    [[ThingSmartUser sharedInstance] sendVerifyCodeWithUserName:self.accountTextField.text
                                                        region:[[ThingSmartUser sharedInstance] getDefaultRegionWithCountryCode:self.countryCodeTextField.text]
                                                   countryCode:self.countryCodeTextField.text
                                                          type:1
                                                       success:^
    {
        [TYODProgressHUD showSuccessWithStatus:@"Verification Code Sent Successfully"];
    } failure:^(NSError *error) {
        [TYODProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (IBAction)registerButtonAction:(id)sender {
    if ([self.accountTextField.text containsString:@"@"]) {
        [[ThingSmartUser sharedInstance] registerByEmail:self.countryCodeTextField.text email:self.accountTextField.text password:self.passwordTextField.text code:self.verificationCodeTextField.text success:^{
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *nav = [mainStoryboard instantiateInitialViewController];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            [TYODProgressHUD showSuccessWithStatus:@"Registered Successfully"];
        } failure:^(NSError *error) {
            [TYODProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    } else {
        [[ThingSmartUser sharedInstance] registerByPhone:self.countryCodeTextField.text phoneNumber:self.accountTextField.text password:self.passwordTextField.text code:self.verificationCodeTextField.text success:^{
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *nav = [mainStoryboard instantiateInitialViewController];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            [TYODProgressHUD showSuccessWithStatus:@"Registered Successfully"];
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
