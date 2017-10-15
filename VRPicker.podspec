Pod::Spec.new do |s|
  s.name             = 'VRPicker'
  s.version          = '4.0.0'
  s.summary          = 'A configurable picker for iOS apps written in Swift'

  s.description      = <<-DESC
VRPicker is a configurable and simple horizontal picker for iOS apps written entirely in Swift.
                       DESC

  s.homepage         = 'https://github.com/vrutberg/VRPicker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Viktor Rutberg' => 'wishie@gmail.com' }
  s.source           = { :git => 'https://github.com/vrutberg/VRPicker.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'VRPicker/Classes/**/*'
  s.frameworks = 'UIKit'
end
