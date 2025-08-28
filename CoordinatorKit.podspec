# CoordinatorKit.podspec
Pod::Spec.new do |s|
  s.name             = 'CoordinatorKit'
  s.version          = '1.0.0'
  s.summary          = 'Reusable coordinator & router for UIKit projects.'
  s.description      = <<-DESC
A tiny, production-ready coordinator/router for UIKit.
Push/present helpers, back/dismiss callbacks, and alert builder.
  DESC

  s.homepage         = 'https://github.com/97longphan/CoordinatorKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LONGPHAN' => 'your-email@example.com' }

  # Public repo + tag phải tồn tại
  s.source           = { :git => 'https://github.com/yourname/CoordinatorKit.git', :tag => s.version.to_s }

  s.platform         = :ios, '13.0'
  s.swift_versions   = ['5.8', '5.9', '5.10']
  s.requires_arc     = true
  s.static_framework = true

  s.source_files     = 'Sources/CoordinatorKit/**/*.{swift}'
  s.frameworks       = 'UIKit'

  # Nếu có resource:
  # s.resource_bundles = {
  #   'CoordinatorKitResources' => ['Sources/CoordinatorKit/Resources/**/*']
  # }

  # Nếu có test spec:
  # s.test_spec 'Tests' do |test|
  #   test.source_files = 'Tests/CoordinatorKitTests/**/*.{swift}'
  # end
end
