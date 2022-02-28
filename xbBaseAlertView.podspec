Pod::Spec.new do |spec|


  spec.name         = "xbBaseAlertView"
  spec.version      = "0.0.2"
  spec.summary      = "xbBaseAlertView."
  spec.description  = "自定义弹窗，xbBaseAlertView"

  spec.license      = "MIT"
  spec.swift_version = "5.0"

  spec.platform     = :ios
  spec.platform     = :ios, "9.0"
  # spec.ios.deployment_target = "5.0"

  spec.author             = { "FXiaobin" => "527256662@qq.com" }
  spec.homepage     = "https://github.com/FXiaobin/xbBaseAlertView"
  spec.source       = { :git => "https://github.com/FXiaobin/xbBaseAlertView.git", :tag => "#{spec.version}" }

  spec.source_files  = "xbBaseAlertView", "xbBaseAlertView/*.{swift}"

  spec.requires_arc = true
  spec.dependency "xbTextView"

end