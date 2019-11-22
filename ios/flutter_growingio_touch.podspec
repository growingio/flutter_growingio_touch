#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_growingio_touch'
  s.version          = '0.0.1'
  s.summary          = 'The Flutter plugin for GrowingIO Touch.'
  s.description      = <<-DESC
The Flutter plugin for GrowingIO Touch.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.static_framework = true
  s.ios.deployment_target = '8.0'
  s.dependency 'GrowingTouchKit'

end

