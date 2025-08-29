# CoordinatorKit.podspec
Pod::Spec.new do |s|
  s.name             = 'CoordinatorKit'
  s.version          = '1.0.0'
  s.summary          = 'Reusable coordinator & router for UIKit projects.'
  s.homepage         = 'https://github.com/97longphan/CoordinatorKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LONGPHAN' => 'your-email@example.com' }
  s.source           = { :git => 'https://github.com/yourname/CoordinatorKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '12.0'
  s.swift_versions = ['5']
  s.source_files     = 'Sources/CoordinatorKit/**/*.{swift}'
  s.frameworks       = 'UIKit'
end
