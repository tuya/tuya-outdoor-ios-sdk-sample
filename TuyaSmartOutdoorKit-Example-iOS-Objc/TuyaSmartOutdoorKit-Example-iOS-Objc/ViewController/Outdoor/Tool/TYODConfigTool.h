//
//  TYODConfigTool.h
//  TuyaSmartOutdoorKit-Example-iOS-Objc
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSArray * TYODCategoryCodeList(void);

UIKIT_EXTERN UIWindow *TY_MainWindow(void);
UIKIT_EXTERN UIViewController *TY_TopViewController(void);

@interface TYODConfigTool : NSObject

@end

FOUNDATION_EXTERN NSString * const dpod_blelock_switch;
FOUNDATION_EXTERN NSString * const dpod_start;
FOUNDATION_EXTERN NSString * const dpod_battery_percentage;
FOUNDATION_EXTERN NSString * const dpod_battery_percentage_2;
FOUNDATION_EXTERN NSString * const dpod_gps_position;
FOUNDATION_EXTERN NSString * const dpod_speed;
FOUNDATION_EXTERN NSString * const dpod_ridetime_once;
FOUNDATION_EXTERN NSString * const dpod_avgspeed_once;
FOUNDATION_EXTERN NSString * const dpod_headlight_switch;
FOUNDATION_EXTERN NSString * const dpod_taillight_switch;
FOUNDATION_EXTERN NSString * const dpod_speed_limit_enum;
FOUNDATION_EXTERN NSString * const dpod_speed_limit_e;
FOUNDATION_EXTERN NSString * const dpod_unit_set;
FOUNDATION_EXTERN NSString * const dpod_mileage_total;
FOUNDATION_EXTERN NSString * const dpod_endurance_mileage;
FOUNDATION_EXTERN NSString * const dpod_mileage_once;
FOUNDATION_EXTERN NSString * const dpod_cruise_switch;
FOUNDATION_EXTERN NSString * const dpod_level;
FOUNDATION_EXTERN NSString * const dpod_mode;
FOUNDATION_EXTERN NSString * const dpod_energy_recovery_level;
FOUNDATION_EXTERN NSString * const dpod_anti_thef_sensitivity;
FOUNDATION_EXTERN NSString * const dpod_search;
FOUNDATION_EXTERN NSString * const dpod_bucket_lock;
FOUNDATION_EXTERN NSString * const dpod_auto_unlock_distance;
FOUNDATION_EXTERN NSString * const dpod_signal_strength;
FOUNDATION_EXTERN NSString * const dpod_gps_signal_strength;
FOUNDATION_EXTERN NSString * const dpod_4g_signal_strength;
FOUNDATION_EXTERN NSString * const dpod_fault_detection;
FOUNDATION_EXTERN NSString * const dpod_status;
FOUNDATION_EXTERN NSString * const dpod_move_alarm;
FOUNDATION_EXTERN NSString * const dpod_power_system;
FOUNDATION_EXTERN NSString * const dpod_smart_system;
FOUNDATION_EXTERN NSString * const dpod_electronic_system;
FOUNDATION_EXTERN NSString * const dpod_ithium_battery_system;
FOUNDATION_EXTERN NSString * const dpod_battery_status;
FOUNDATION_EXTERN NSString * const dpod_battery_status_2;
FOUNDATION_EXTERN NSString * const dpod_battery_cycle_times;
FOUNDATION_EXTERN NSString * const dpod_battery_cycle_times_2;
FOUNDATION_EXTERN NSString * const dpod_voltage_current;
FOUNDATION_EXTERN NSString * const dpod_voltage_current_2;
FOUNDATION_EXTERN NSString * const dpod_cur_current;
FOUNDATION_EXTERN NSString * const dpod_cur_current_2;
FOUNDATION_EXTERN NSString * const dpod_work_power;
FOUNDATION_EXTERN NSString * const dpod_battery_temp_current;
FOUNDATION_EXTERN NSString * const dpod_battery_temp_2;
FOUNDATION_EXTERN NSString * const dpod_battery_capacity;
FOUNDATION_EXTERN NSString * const dpod_battery_capacity_2;
FOUNDATION_EXTERN NSString * const dpod_central_battery_pct;
FOUNDATION_EXTERN NSString * const dpod_navigation_data;
FOUNDATION_EXTERN NSString * const dpod_geofence_switch;
FOUNDATION_EXTERN NSString * const dpod_tail_box_lock;
FOUNDATION_EXTERN NSString * const dpod_bms_chartime;
FOUNDATION_EXTERN NSString * const dpod_bms_chartime_2;
FOUNDATION_EXTERN NSString * const dpod_switch_led;
FOUNDATION_EXTERN NSString * const dpod_bright_value;
FOUNDATION_EXTERN NSString * const dpod_temp_value;
FOUNDATION_EXTERN NSString * const dpod_scene;
FOUNDATION_EXTERN NSString * const dpod_mcu_info;
FOUNDATION_EXTERN NSString * const dpod_bms_info;
FOUNDATION_EXTERN NSString * const dpod_dashboard_info;
FOUNDATION_EXTERN NSString * const dpod_ecu_info;
FOUNDATION_EXTERN NSString * const dpod_remote_pair;
FOUNDATION_EXTERN NSString * const dpod_auto_lock_distance;
FOUNDATION_EXTERN NSString * const dpod_nfc_id_input;
FOUNDATION_EXTERN NSString * const dpod_nfc_id_reset;
FOUNDATION_EXTERN NSString * const dpod_nfc_id_sync;
FOUNDATION_EXTERN NSString * const dpod_nfc_id_delete;
FOUNDATION_EXTERN NSString * const dpod_password_sync;
FOUNDATION_EXTERN NSString * const dpod_pass_change;
FOUNDATION_EXPORT NSString * const dpod_password_creat;
FOUNDATION_EXPORT NSString * const dpod_password_delete;
FOUNDATION_EXPORT NSString * const dpod_imei;
FOUNDATION_EXPORT NSString * const dpod_iccid;
FOUNDATION_EXPORT NSString * const dpod_boost;
FOUNDATION_EXPORT NSString * const dpod_zero_start;
FOUNDATION_EXPORT NSString * const dpod_start_mode;

NS_ASSUME_NONNULL_END
