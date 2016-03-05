Pod::Spec.new do |s|
  s.name             = 'JWAnimatedImage'
  s.version          = '0.1.1'
  s.summary          = 'A animated GIF engine for iOS in Swift'
  s.homepage         = 'https://github.com/wangjwchn/JWAnimatedImage'
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Jiawei Wang" => "wangjwchn@yahoo.com" }
  s.source           = { :git => "https://github.com/wangjwchn/JWAnimatedImage.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'JWAnimatedImage/**/*'
end
