# TMF POC (iOS) Release Notes

## 更新模版

### 基线：x.x.x

- Demo信息

  | 信息             | 值    | 说明               |
  | ---------------- | ----- | ------------------ |
  | Demo版本         | x.x.x | 版本号与基线号相同 |
  | Demo BuildNumber | x     | xxx                |

- 变更信息

  - 变更信息1
  - 变更信息2

- SDK变更信息

  | SDK  | 变更前版本 | 变更后版本 |
  | ---- | ---------- | ---------- |
  | XXX  | x.x.x      | x.x.x      |



## 发布记录

### 基线：1.8.1

- Demo信息

   | 信息             | 值    | 说明 |
   | ---------------- | ----- | ---- |
   | Demo版本         | 1.8.1 |      |
   | Demo BuildNumber | 2     |      |

- 变更信息

   - 增加  Release Notes
   - 固定SDK版本信息
   - 升级 Demo 版本至 1.8.1，与基线版本保持同步 

- SDK信息

  | SDK                     | 版本      |
  | ----------------------- | --------- |
  | AFNetworking            | \（本地） |
  | IQKeyboardManager       | \（本地） |
  | Masonry                 | \（本地） |
  | SDWebImage              | \（本地） |
  | AMap                    | 6.8.1.195 |
  | APOpenSDK               | 1.1.0     |
  | DTShareKit              | 3.0.0     |
  | LCActionSheet           | 3.5.5.240 |
  | Mars                    | 1.2.3     |
  | MQQComponents           | 1.3.4     |
  | ncnn                    | 1.0       |
  | QAPM                    | 3.3.21    |
  | QMap                    | 4.4.7     |
  | QMUIKit                 | 4.2.2     |
  | SSZipArchive            | 2.2.2     |
  | TencentOpenAPI          | 3.5.1     |
  | TMFAnalyse              | 1.0.1     |
  | TMFBase                 | 1.0.4     |
  | TMFChrist               | 2.0.1     |
  | TMFCodeDetector         | 1.6.0     |
  | TMFDataPush             | 1.0.0     |
  | TMFDistribution         | 1.1.2     |
  | TMFHelper               | 1.0.2     |
  | TMFInstruction          | 1.2.3     |
  | TMFJSAPIs               | 1.3.7     |
  | TMFJSBridge             | 1.2.3     |
  | TMFLiveDetection        | 1.1.1     |
  | TMFLocation             | 1.1.1     |
  | TMFOCRSDK               | 1.1.1     |
  | TMFProfile              | 1.4.2     |
  | TMFPush                 | 1.2.2     |
  | TMFQWebView             | 1.2.4     |
  | TMFSafeKeyboard         | 1.1.2     |
  | TMFShare                | 1.2.3     |
  | TMFShark                | 3.8.4     |
  | TMFStorage              | 1.0.1     |
  | TMFUploader             | 1.1.2     |
  | TMFWebOffline           | 1.6.2     |
  | TMFXLog                 | 1.1.1     |
  | TZImagePickerController | 3.8.1.324 |
  | WCDB                    | 1.0.7.5   |
  | WechatOpenSDK           | 1.8.7.1   |
  | WeiboSDK                | 3.3.0     |

- 仓库地址 https://e.coding.net/tmf-work/tmf/tmf-repo.git

- Podfile

  ```ruby
  ##TMF Release Pods Repo
  source 'https://e.coding.net/tmf-work/tmf/tmf-repo.git'
  
  # Uncomment the next line to define a global platform for your project
  platform :ios, '9.0'
  target 'TMFDemo' do
  
      # ―――  Components  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
      pod 'TMFBase', '1.0.4'
      pod 'TMFBaseCore', '1.0.1'
      pod 'MQQTcc', '1.1.3'
      pod 'TMFSSL', '1.2.1'
      pod 'Tars', '1.6.0'
      pod 'CocoaAsyncSocket', '7.6.3'
      pod 'MQQComponents', '1.3.3'
      pod 'TMFRouter', '1.0.0'
      
      # ―――  Data  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――--- #
      pod 'SSZipArchive', '2.2.2‘
      pod 'WCDB', '1.0.7.5'
      
      # ―――  Shark  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
      pod 'TMFShark', '3.8.4'
      
      # ―――  Shark Services  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
      pod 'TMFInstruction', '1.2.3'
      pod 'TMFUploader', '1.1.2'
      
      # ―――  Web  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
      pod 'TMFJSBridge', '1.2.3'
      pod 'TMFJSAPIs', '1.3.7'
      pod 'TMFQWebView', '1.2.4'
      pod 'TMFWebOffline', '1.6.2'
      
      # ―――  Push  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
      pod 'TMFPush', '1.2.2'
      pod 'TMFPushGo', '1.0.2'
      pod 'TMFDataPush', '1.0.0'
      
      # ―――  Distribution ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
      pod 'TMFDistribution', '1.1.2'
      
      # ―――  UI  -―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
      pod 'QMUIKit', '4.2.1'
      
      # ―――  Share  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
      pod 'WechatOpenSDK', '1.8.7.1'
      pod 'TencentOpenAPI', '3.5.1'
      pod 'APOpenSDK', '1.1.0'
      pod 'WeiboSDK', '3.3.0'
      pod 'DTShareKit', '3.0.0'
      pod 'TMFShare', '1.2.3'
      pod 'TMFShare/Core’
      pod 'TMFShare/TMFShare_DDing'
      pod 'TMFShare/TMFShare_Alipay'
      pod 'TMFShare/TMFShare_QQ'
      pod 'TMFShare/TMFShare_WeChat'
      pod 'TMFShare/TMFShare_Weibo'
  
  
      # ―――  Detector  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
      pod 'TMFCodeDetector', '1.6.0'
      pod 'TMFOCRSDK', '1.1.1'
      pod 'TMFLiveDetection', '1.1.1'
      
      # ―――  Reporter  -―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
      pod 'TMFProfile', '1.4.2'
      pod 'Mars', '1.2.3'
      pod 'TMFXLog', '1.1.1'
      
      # ―――  Patch  -―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――———— #
      pod 'TMFChrist', '2.0.1'
      
      # ――― Map -----――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――——— #
      pod 'QMap', '4.2.3.1'
      pod 'AMap', '6.8.1.195'
      pod 'TMFLocation', '1.0.3'
      
      
      # ――― safe Keyboard -----――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
      pod 'TMFSafeKeyboard', '1.1.2'
      
      # ――― QAPM -----――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
      pod 'QAPM', '3.3.21'
      # ――― ICDP -----――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
      pod 'TMFICDP', '2.0.0'
      
      # ――― demo -----――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
      pod 'IQKeyboardManager',      :path => "Frameworks/IQKeyboardManager"
      pod 'Masonry',                :path => "Frameworks/Masonry",              :inhibit_warnings => true
      pod 'AFNetworking',           :path => "Frameworks/AFNetworking",         :inhibit_warnings => true
      pod 'SDWebImage',             :path => "Frameworks/SDWebImage",           :inhibit_warnings => true
      
  end
  ```
