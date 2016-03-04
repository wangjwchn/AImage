#
# Be sure to run `pod lib lint JWAnimatedImage.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JWAnimatedImage"
  s.version          = "0.1.0"
  s.summary          = "A animated GIF engine for iOS in Swift "
  s.homepage         = "https://github.com/wangjwchn/JWAnimatedImage"
  s.license          = 'MIT'
  s.author           = { "Jiawei Wang" => "wangjwchn@yahoo.com" }
  s.source           = { :git => "https://github.com/wangjwchn/JWAnimatedImage.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
end
