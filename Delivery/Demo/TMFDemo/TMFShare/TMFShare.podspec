Pod::Spec.new do |s|
  
  s.name         = "TMFShare"
  s.version      = "1.1.6"
  s.summary      = "TMF 分享组件"
  s.description  = <<-DESC
                    TMFShare - TMF 分享组件 支持 QQ 微信 微博 支付宝等渠道
                    DESC
  s.homepage     = "https://git.code.oa.com/groot-components/TMFShare"
  s.license      = { :type => "", :file => "LICENSE" }
  s.authors      = { "kloudzliang" => "kloudzliang@tencent.com" }
  
  s.ios.deployment_target = "8.0"
  
  s.source       = { :git => "", :tag => s.version.to_s }
  
  s.requires_arc = true
  s.frameworks   = "Foundation", "UIKit"
  
  s.subspec "Core" do |ss|
    ss.source_files  = "Headers/*.h"
    ss.public_header_files  = "Headers/*.h"
    ss.vendored_libraries = "Libraries/libTMFShare_Core.a"
  end
  s.subspec "TMFShare_Alipay" do |ss|
    ss.vendored_libraries = "Libraries/libTMFShare_Alipay.a"
    ss.dependency "APOpenSDK", "~> 1.1.0"
  end
  s.subspec "TMFShare_DDing" do |ss|
    ss.vendored_libraries = "Libraries/libTMFShare_DDing.a"
    ss.dependency "DTShareKit", "~> 3.0.0"
  end
  s.subspec "TMFShare_QQ" do |ss|
    ss.vendored_libraries = "Libraries/libTMFShare_QQ.a"
    ss.dependency "TencentOpenAPI", "~> 3.5.1"
  end
  s.subspec "TMFShare_WeChat" do |ss|
    ss.vendored_libraries = "Libraries/libTMFShare_WeChat.a"
    ss.dependency "WechatOpenSDK", "~> 1.8.7.1"
  end
  s.subspec "TMFShare_Weibo" do |ss|
    ss.vendored_libraries = "Libraries/libTMFShare_Weibo.a"
    ss.dependency "WeiboSDK", "~> 3.3.0"
  end

end
