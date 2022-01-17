//
//  UIViewController+Outdoor.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "UIViewController+Outdoor.h"

@implementation UIViewController (Outdoor)

- (BOOL)isTy_visible {
    return (self.isViewLoaded && self.view.window);
}

- (void)ty_goBackToPreviousPage:(BOOL)animated {
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:animated];
    } else if (self.navigationController.presentingViewController && self.navigationController.presentingViewController.presentedViewController == self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:animated completion:nil];
    } else if (self.presentingViewController && self.presentingViewController.presentedViewController == self) {
        [self dismissViewControllerAnimated:animated completion:nil];
    }
}

- (void)ty_goBackToFirstPage:(BOOL)animated {
    if (self.presentedViewController) {
        [self.presentedViewController ty_goBackToFirstPage:animated];
    } else if (self.presentingViewController) {
        UIViewController *vc = self.presentingViewController;
        [vc.presentedViewController dismissViewControllerAnimated:animated completion:^{
            [vc ty_goBackToFirstPage:animated];
        }];
    } else if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:animated];
    } else if ([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navi = (UINavigationController *)self;
        [navi popToRootViewControllerAnimated:animated];
    } else if ([self isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)self;
        [tab.selectedViewController ty_goBackToFirstPage:animated];
    }
}

@end
