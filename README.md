# Tuya Smart Travel App SDK Sample in Objective-C for iOS


[English](./README.md) | [中文版](./README-zh.md)

---

## Overview

Tuya Smart Travel App SDK for iOS is built based on `ThingSmartDeviceCoreKit` and integrates with features for smart travel scenarios to speed up your app development process. The following features are supported:

* Get information about the device data point (DP) model
* Get high-definition images of devices
* Manage device information
* Get a list of routes
* Get statistics of routes
* Encapsulate API methods for Bluetooth vehicles to report routes
* Get stores within a certain radius

## Prerequisites

- Xcode 12.0 and later
- iOS 12 and later

## Use the sample

1. Tuya Smart Travel App SDK is distributed based on [CocoaPods](http://cocoapods.org/) and other dependencies in this sample. Make sure that you have installed CocoaPods. If not, run the following command to install CocoaPods first:

    ```bash
    sudo gem install cocoapods
    pod setup
    ```

2. Clone or download this sample, change the directory to the one that includes **Podfile**, and then run the following command:

    ```bash
    pod install
    ```

3. This sample requires you to get a pair of keys and a security image from [Tuya Developer Platform](https://developer.tuya.com/), and register a developer account on this platform if you do not have one. Then, perform the following steps:

   1. Log in to the [Tuya IoT Development Platform](https://iot.tuya.com/). In the left-side navigation pane, choose **App** > **SDK Development**.

   2. Click **Create** to create a **Smart Life App SDK**  app.

   3. Fill in the required information. Make sure that you enter the valid Bundle ID. It cannot be changed afterward.

   4. You can find the AppKey, AppSecret, and security image on the **Get Key** tab.

4. Open the sample project `TuyaSmartOutdoorKit-Example-iOS-Objc.xcworkspace`.

5. Fill in the AppKey and AppSecret in the **AppDelegate.m** file.

    ```objective-c
    #define APP_KEY @"<#AppKey#>"
    #define APP_SECRET_KEY @"<#SecretKey#>"
    ```

6. Download the security image, rename it `t_s.bmp`, and then drag it to the workspace at the same level as `Info.plist`.

7. To debug it by using a simulator on a MacBook with the M1 chip, add the following content to the Pods project.

![M1EngineeringConfiguration](https://github.com/tuya/tuya-outdoor-ios-sdk-sample/blob/develop/M1EngineeringConfiguration.png)

**Note**: The bundle ID, AppKey, AppSecret, and security image must be the same as those used for your app on the [Tuya IoT Development Platform](https://iot.tuya.com). Otherwise, API requests in this sample will fail.

## References
For more information about Tuya Smart Travel App SDK, see [App SDK](https://developer.tuya.com/en/docs/app-development).
