#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_aliplayer.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_aliplayer'
  s.version          = '5.5.6'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AliPlayerSDK_iOS', '6.18.0'
  
  #s.dependency 'AliPlayerSDK_iOS_ARTC', '5.5.6.0'
  #s.dependency 'RtsSDK', '2.5.0'
  s.dependency 'MJExtension'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
