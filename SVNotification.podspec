#
# Be sure to run `pod lib lint SVNotification.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SVNotification'
  s.version          = '1.0.3'
  s.summary          = 'Nav bar notifications lib, built with Swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Use this lib to show notifications over nav bar
                       DESC

  s.homepage         = 'https://github.com/svlaev/sv-notification.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Stanislav Vlaev' => 'stanislav.vlaev@gmail.com' }
  s.source           = { :git => 'https://github.com/svlaev/sv-notification.git', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SVNotification/Classes/**/*'

end
