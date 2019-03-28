# Uncomment the next line to define a global platform for your project

platform :ios, '8.0'
inhibit_all_warnings!

target 'BaseProject' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for BaseProject

  ########################### 基础功能 ###########################
  #字典和模型之间互相转换
  pod 'MJExtension'
  #JSON解析
  pod 'JSONKit'
  #数据容错处理
  pod 'JKDataHelper'
  #检测网络状态
  pod 'Reachability'
  #网络请求
  pod 'AFNetworking'
  #网络图片加载
  pod 'SDWebImage'
  
  ########################### 第三方集成 ###########################
  #微信登陆
  pod 'WechatOpenSDK'
  #QQ登陆
  pod 'TencentOpenApiSDK'
  
  ########################### UI相关 ###########################
  #自动布局
  pod 'Masonry'
  #解决键盘遮挡输入框
  pod 'IQKeyboardManager'
  #下拉刷新
  pod 'MJRefresh'
  #导航控制器
  pod 'RTRootNavigationController'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 8.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
      end
    end
  end
end
