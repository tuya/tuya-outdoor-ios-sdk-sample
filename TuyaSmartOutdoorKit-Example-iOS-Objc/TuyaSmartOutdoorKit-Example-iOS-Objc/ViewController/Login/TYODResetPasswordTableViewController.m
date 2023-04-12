//
//  TYODResetPasswordTableViewController.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYODResetPasswordTableViewController.h"

@interface TYODResetPasswordTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *countryCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *verficationCodeTextField;

@end

@implementation TYODResetPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)sendVerficationCodeButtonAction:(id)sender {
    [[ThingSmartUser sharedInstance] sendVerifyCodeWithUserName:self.accountTextField.text
                                                        region:[[ThingSmartUser sharedInstance] getDefaultRegionWithCountryCode:self.countryCodeTextField.text]
                                                   countryCode:self.countryCodeTextField.text
                                                          type:3
                                                       success:^
    {
        [TYODProgressHUD showSuccessWithStatus:@"Verification Code Sent Successfully"];
    } failure:^(NSError *error) {
        [TYODProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (IBAction)resetButtonAction:(id)sender {
    if ([self.accountTextField.text containsString:@"@"]) {
        [[ThingSmartUser sharedInstance] resetPasswordByEmail:self.countryCodeTextField.text
                                                       email:self.accountTextField.text
                                                 newPassword:self.passwordTextField.text
                                                        code:self.verficationCodeTextField.text
                                                     success:^
        {
            [TYODProgressHUD showSuccessWithStatus:@"Password Reset Successfully"];
        } failure:^(NSError *error) {
            [TYODProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }else{
        [[ThingSmartUser sharedInstance] resetPasswordByPhone:self.countryCodeTextField.text
                                                 phoneNumber:self.accountTextField.text
                                                 newPassword:self.passwordTextField.text
                                                        code:self.verficationCodeTextField.text
                                                     success:^
        {
            [TYODProgressHUD showSuccessWithStatus:@"Password Reset Successfully"];
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
