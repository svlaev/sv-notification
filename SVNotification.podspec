Pod::Spec.new do |s|

  s.name         = "SVNotification"
  s.version      = "1.0.5"
  s.summary      = "Nav bar notifications lib, built with Swift"
  s.description  = <<-DESC
  Use this lib to show notifications over nav bar
                   DESC

  s.homepage     = "https://github.com/svlaev/sv-notification"
  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Stanislav Vlaev" => "stanislav.vlaev@gmail.com" }
  s.social_media_url   = "https://twitter.com/svlaev"

  # s.platform     = :ios
  # s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/svlaev/sv-notification.git", :tag => "1.0.5 }
  s.source_files  = "Source/*.swift"

end
