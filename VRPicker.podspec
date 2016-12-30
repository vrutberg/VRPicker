#
# Be sure to run `pod lib lint VRPicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VRPicker'
  s.version          = '0.1.0'
  s.summary          = 'A configurable slider for iOS apps written in Swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
VRPicker is a configurable and simple horizontal picker for iOS apps written entirely in Swift.
                       DESC

  s.homepage         = 'https://github.com/vrutberg/VRPicker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Viktor Rutberg' => 'wishie@gmail.com' }
  s.source           = { :git => 'https://github.com/vrutberg/VRPicker.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.3'

  s.source_files = 'VRPicker/Classes/**/*'
  
  # s.resource_bundles = {
  #   'VRSlider' => ['VRPicker/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
