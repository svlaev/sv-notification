Pod::Spec.new do |s|
  s.name         = "SVNotification"
  s.version      = "0.2"
  s.summary      = "iOS App notification lib built with Swift"
  s.description  = 'A small lib designed to make easy showing notifications above the nav bar and below it'
  s.homepage     = "https://github.com/svlaev/sv-notification"
  s.license      = "MIT"
  s.author       = { "Stanislav Vlaev" => "stanislav.vlaev@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/svlaev/sv-notification.git", :tag => "#{s.version}" }
  s.source_files = "SVNotification/SVNotification.swift"
  s.requires_arc = true
end
