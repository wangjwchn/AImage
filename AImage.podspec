Pod::Spec.new do |s|
  s.name             = 'AImage'
  s.version          =  '0.2.1'
  s.summary          = 'A animated GIF engine for iOS in Swift'
  s.homepage         = 'https://github.com/wangjwchn/AImage'
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Jiawei Wang" => "wangjwchn@yahoo.com" }
  s.source           = { :git => "https://github.com/wangjwchn/AImage.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'AImage/**/*'
end
