#
# Be sure to run `pod lib lint EasyObserve.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EasyObserve'
  s.version          = '1.2.0'
  s.summary          = '简单、易用、轻量的 Swift 观察者模式'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.homepage         = 'https://github.com/AiweiChujian/EasyObserve'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AiweiChujian' => 'hellohezhili@gmail.com' }
  s.source           = { :git => 'https://github.com/AiweiChujian/EasyObserve.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '11.0'
  
  s.swift_versions = '5.0'
  
  s.subspec 'Foundation' do |ss|
      ss.source_files = 'EasyObserve/Classes/Foundation/**/*'
  end
  
  s.subspec 'UIKit' do |ss|
      ss.ios.deployment_target = '10.0'
      ss.source_files = 'EasyObserve/Classes/UIKit/**/*'
      ss.dependency 'EasyObserve/Foundation'
  end
end
