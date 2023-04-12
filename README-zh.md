# 涂鸦智慧出行 App SDK iOS 版示例

[中文版](README-zh.md) | [English](README.md)

---

涂鸦智慧出行 App SDK基于'ThingSmartDeviceCoreKit'构建，并扩展与户外相关的功能，以加快您的开发过程。主要包括了以下功能：

- 获取设备DP模型信息
- 获取设备高清图片
- 设备硬件信息
- 获取轨迹列表
- 获取轨迹统计信息
- 蓝牙车上报轨迹的接口封装
- 获取一定半径内门店

## 运行环境

- Xcode 12.0 及以上版本
- iOS 12.0 及以上版本

## 运行示例

1. 涂鸦智慧出行 App SDK iOS 版示例通过 [CocoaPods](http://cocoapods.org/) 进行集成。您需要安装 CocoaPods 才能运行本示例。如果你没有安装 CocoaPods，可以通过以下命令安装 CocoaPods:

    ```bash
    sudo gem install cocoapods
    pod setup
    ```

2. Clone 或者下载本示例源码，打开终端并进入 **Podfile** 所在的文件夹路径下，然后在终端执行以下命令:

    ```bash
    pod install
    ```

3. 运行本示例需要 **AppKey**、**SecretKey** 和 **安全图片**。您可以前往 [涂鸦开发者 IoT 平台](https://developer.tuya.com/cn/) 注册成为开发者，并通过以下步骤获取：

   1. 登录 [涂鸦 IoT 开发平台](https://iot.tuya.com/)，在左侧导航栏面板分别选择： **App** -> **SDK 开发**。

   2. 点击 **创建 App** 按钮，开始创建 **智能生活 App SDK** 应用。

   3. 填写必要的应用信息，包括 应用名称、Bundle ID 等。

   4. 点击创建好的应用，在 **获取密钥** 页签，可以获取 SDK 的 **AppKey**、**AppSecret**、安全图片 等信息。

4. 打开本示例工程 `TuyaSmartOutdoorKit-Example-iOS-Objc.xcworkspace`。

5. 在 **AppDelegate.m** 中将 `AppKey`、`SecretKey`替换为你的 **AppKey** 和 **AppSecret**。

    ```objective-c
    #define APP_KEY @"<#AppKey#>"
    #define APP_SECRET_KEY @"<#SecretKey#>"
    ```

6. 下载 **安全图片** 并重命名为 `t_s.bmp`，将安全图片拖拽到 `Info.plist` 所在的文件夹下。
7. 如果您想在搭载 M1 芯片的 MacBook 提供的模拟器上调试，前往 `Pods` > `PROJECT`，加入下图所示内容。

![M1EngineeringConfiguration](https://github.com/tuya/tuya-outdoor-ios-sdk-sample/blob/develop/M1EngineeringConfiguration.png)

**注意**：**Bundle ID**、**AppKey**、**AppSecret** 和 安全图片 必须与您在 [涂鸦 IoT 开发平台](https://iot.tuya.com/) 创建的应用配置保持一致。否则，本示例工程无法正常运行。

## 开发文档

关于涂鸦智慧出行 App SDK iOS 版示例的更多信息，请参考：[App SDK](https://developer.tuya.com/en/docs/app-development)。
