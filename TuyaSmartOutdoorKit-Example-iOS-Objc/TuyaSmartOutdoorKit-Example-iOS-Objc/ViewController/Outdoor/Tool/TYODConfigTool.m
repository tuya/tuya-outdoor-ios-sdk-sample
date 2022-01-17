//
//  TYODConfigTool.m
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYODConfigTool.h"

inline NSArray * TYODCategoryCodeList(void) {
    return @[@"phc",@"ddc",@"ddzxc",@"ddly",@"znddc",@"tracker",@"hbc"];
}

inline UIWindow * TY_MainWindow(void) {
    id appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate && [appDelegate respondsToSelector:@selector(window)]) {
        return [appDelegate window];
    }
    NSArray *windows = [UIApplication sharedApplication].windows;
    if ([windows count] == 1) {
        return [windows firstObject];
    } else {
        for (UIWindow *window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                return window;
            }
        }
    }
    return nil;
}

inline UIViewController * TY_TopViewController(void) {
    UIViewController *topViewController = TY_MainWindow().rootViewController;
    UIViewController *temp = nil;
    while (YES) {
        temp = nil;
        if ([topViewController isKindOfClass:[UINavigationController class]]) {
            temp = ((UINavigationController *)topViewController).visibleViewController;
            
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            temp = ((UITabBarController *)topViewController).selectedViewController;
        }
        else if (topViewController.presentedViewController != nil) {
            temp = topViewController.presentedViewController;
        }
        
        if (temp != nil) {
            topViewController = temp;
        } else {
            break;
        }
    }
    
    return topViewController;
}

@implementation TYODConfigTool

@end

NSString * const dpod_blelock_switch        = @"blelock_switch";
NSString * const dpod_start                 = @"start";
NSString * const dpod_battery_percentage    = @"battery_percentage";
NSString * const dpod_battery_percentage_2  = @"battery_percentage_2";
NSString * const dpod_gps_position          = @"gps_position";
NSString * const dpod_speed                 = @"speed";
NSString * const dpod_ridetime_once         = @"ridetime_once";
NSString * const dpod_avgspeed_once         = @"avgspeed_once";
NSString * const dpod_headlight_switch      = @"headlight_switch";
NSString * const dpod_taillight_switch      = @"taillight_switch";
NSString * const dpod_speed_limit_enum      = @"speed_limit_enum";
NSString * const dpod_speed_limit_e         = @"speed_limit_e";
NSString * const dpod_unit_set              = @"unit_set";
NSString * const dpod_mileage_total         = @"mileage_total";
NSString * const dpod_endurance_mileage     = @"endurance_mileage";
NSString * const dpod_mileage_once          = @"mileage_once";
NSString * const dpod_cruise_switch         = @"cruise_switch";
NSString * const dpod_level                 = @"level";
NSString * const dpod_mode                  = @"mode";
NSString * const dpod_energy_recovery_level = @"energy_recovery_level";
NSString * const dpod_anti_thef_sensitivity = @"anti_thef_sensitivity";
NSString * const dpod_search                = @"search";
NSString * const dpod_bucket_lock           = @"bucket_lock";
NSString * const dpod_auto_lock             = @"auto_lock";
NSString * const dpod_auto_unlock_distance  = @"auto_unlock_distance";
NSString * const dpod_auto_unlock           = @"auto_unlock";
NSString * const dpod_signal_strength       = @"signal_strength";
NSString * const dpod_gps_signal_strength   = @"gps_signal_strength";
NSString * const dpod_4g_signal_strength    = @"4g_signal_strength";
NSString * const dpod_fault_detection       = @"fault_detection";
NSString * const dpod_status                = @"status";
NSString * const dpod_move_alarm            = @"move_alarm";
NSString * const dpod_power_system          = @"power_system";
NSString * const dpod_smart_system          = @"smart_system";
NSString * const dpod_electronic_system     = @"electronic_system";
NSString * const dpod_ithium_battery_system = @"ithium_battery_system";
NSString * const dpod_battery_status        = @"battery_status";
NSString * const dpod_battery_status_2      = @"battery_status_2";
NSString * const dpod_battery_cycle_times   = @"battery_cycle_times";
NSString * const dpod_battery_cycle_times_2 = @"battery_cycle_times_2";
NSString * const dpod_voltage_current       = @"voltage_current";
NSString * const dpod_voltage_current_2     = @"voltage_current_2";
NSString * const dpod_cur_current           = @"cur_current";
NSString * const dpod_cur_current_2         = @"cur_current_2";
NSString * const dpod_work_power            = @"work_power";
NSString * const dpod_battery_temp_current  = @"battery_temp_current";
NSString * const dpod_battery_temp_2        = @"battery_temp_2";
NSString * const dpod_battery_capacity      = @"battery_capacity";
NSString * const dpod_battery_capacity_2    = @"battery_capacity_2";
NSString * const dpod_central_battery_pct   = @"central_battery_pct";

NSString * const dpod_navigation_data       = @"navigation_data";
NSString * const dpod_geofence_switch       = @"geofence_switch";
NSString * const dpod_hid_bind              = @"hid_bind";
NSString * const dpod_tail_box_lock         = @"tail_box_lock";

NSString * const dpod_bms_chartime   = @"bms_chartime";
NSString * const dpod_bms_chartime_2 = @"bms_chartime_2";
NSString * const dpod_switch_led     = @"switch_led";
NSString * const dpod_bright_value   = @"bright_value";
NSString * const dpod_temp_value     = @"temp_value";
NSString * const dpod_scene          = @"scene";
NSString * const dpod_mcu_info       = @"mcu_info";
NSString * const dpod_bms_info       = @"bms_info";
NSString * const dpod_dashboard_info = @"dashboard_info";
NSString * const dpod_ecu_info       = @"ecu_info";
NSString * const dpod_remote_pair    = @"remote_pair";

NSString * const dpod_fortify_distance_record = @"fortify_distance_record";
NSString * const dpod_disarm_distance_record  = @"disarm_distance_record";
NSString * const dpod_auto_lock_distance    = @"auto_lock_distance";
NSString * const dpod_nfc_id_sync           = @"nfc_id_sync";
NSString * const dpod_nfc_id_input          = @"nfc_id_input";
NSString * const dpod_nfc_id_reset          = @"nfc_id_reset";
NSString * const dpod_nfc_id_delete         = @"nfc_id_delete";
NSString * const dpod_pass_change           = @"pass_change";
NSString * const dpod_password_sync         = @"password_sync";
NSString * const dpod_password_creat        = @"password_creat";
NSString * const dpod_password_delete       = @"password_delete";

NSString * const dpod_imei       = @"imei";
NSString * const dpod_iccid      = @"iccid";
NSString * const dpod_boost      = @"boost";
NSString * const dpod_zero_start = @"zero_start";
NSString * const dpod_start_mode = @"start_mode";
