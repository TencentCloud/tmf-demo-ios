
# TMF Demo For iOS

## 简介

腾讯移动开发平台（ Tencent Mobile Framework）整合了腾讯在移动产品中开发、测试、发布和运营的技术能力，为企业提供一站式、 覆盖全生命周期的移动端技术平台。TMF Demo For iOS演示了如何在iOS端接入TMF。

## 环境要求

|                | 版本           |
| -------------- | ------------- |
| Xcode          | 11.0及以上版本  |
| iOS            | 9.0及以上版本   |

## TMFDemo工程目录

- **Demo**:TMFDemo源码
  - **Frameworks**：TMFDemo用到的第三方库
  - **Podfile**:默认的podfile
- **Tools**：cocoapods安装脚本

## 使用TMFDemo

1. 打开`终端`，切换目录至`TMF.xcodeproj`同级目录

2. `$ pod install`倒入依赖库文件 注意：如果报 `Couldn't determine repo type for URL: 'https: //e.coding.net/tmf-work/tmf/tmf-repo.git':`错误，则需要在执`pod install`前执行`pod repo add specs https://e.coding.net/tmf-work/tmf/tmf-repo.git`

3. 在[TMF控制台](https://console.cloud.tencent.com/tmf)下载您的应用配置文件tmf-ios-configurations.json。注：应用包名需与demo一致，默认是com.tencent.tmf.demo

4. 运行`TMF.xcworkspace`

注：TMFDemo提供在程序运行时切换控制台环境，或切换到控制台不同的应用中。需要把configurations.json文件存储到我的iPhone->TMF-Demo->Environment中，然后在移动网关->Reset选择存储的配置文件进行重启即可生效

## 目录结构

- SDK信息

  | SDK                     |    说明     |
  | ----------------------- | ---------- |
  | QMUIKit                 | DemoUI库   |
  | TMFBase                 | 基础库依赖库 |
  | TMFPhaseReporter        | 基础库依赖库 |
  | TMFWebOffline           | 离线包      |
  | TMFPush                 | 消息推送    |
  | TMFDistribution         | 应用发布    |

执行`pod install`后`tmf-demo-ios/Delivery/Demo/Pods`目录下的其它库均为业务组件的依赖库


