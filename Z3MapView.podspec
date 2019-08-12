#
# Be sure to run `pod lib lint Z3MapView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Z3MapView'
  s.version          = '0.1.2'
  s.summary          = 'Z3MapView for zzht to build mapView'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/TonyTong1993/Z3MapView'
 
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tony Tony' => 'tongwanhua1993@163.com' }
  s.source           = { :git => 'https://github.com/TonyTong1993/Z3MapView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'Z3MapView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Z3MapView' => ['Z3MapView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
  s.vendored_frameworks = 'ArcGIS.framework'
  #s.dependency 'ArcGIS-Runtime-SDK-iOS', '~> 100.4'
  s.dependency 'Z3Login','~> 0.1.1'
  s.dependency 'Z3Network', '~>0.0.1'
  s.dependency 'Z3CommonLib', '~>0.1.1'
end
