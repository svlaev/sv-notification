Pod::Spec.new do |s|
  s.name             = 'SVNotification'
  s.version          = '1.2'
  s.summary          = 'Nav bar notifications lib, built with Swift'

  s.description      = <<-DESC
  Use this lib to show notifications over nav bar
                       DESC

  s.homepage         = "https://github.com/svlaev/sv-notification"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Stanislav Vlaev' => 'stanislav.vlaev@gmail.com' }
  s.source           = { :git => "https://github.com/svlaev/sv-notification.git", :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/svlaev"

  s.platform     = :ios, "8.3"

  s.source_files = 'SVNotification/Classes/**/*.swift'
  s.swift_version = '4.1'
end
