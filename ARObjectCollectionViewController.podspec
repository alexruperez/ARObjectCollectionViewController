Pod::Spec.new do |s|
  s.name         = "ARObjectCollectionViewController"
  s.version      = "1.0.1"
  s.summary      = "UIViewController subclass that can present a JSON NSString, JSON NSData, JSON URL, XML NSData, XML URL, RSS NSData, RSS URL, NSDictionary, NSArray, NSSet, UIImage EXIF Metadata..."
  s.homepage     = "https://github.com/alexruperez/ARObjectCollectionViewController"
  s.screenshots  = "https://raw.githubusercontent.com/alexruperez/ARObjectCollectionViewController/master/screenshot.png"
  s.license      = "MIT"
  s.author             = { "Alex Rupérez" => "contact@alexruperez.com" }
  s.social_media_url   = "http://twitter.com/alexruperez"
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/alexruperez/ARObjectCollectionViewController.git", :tag => s.version.to_s }
  s.source_files  = "ARObjectCollectionViewController/**/*.{h,m,swift}"
  s.public_header_files = "ARObjectCollectionViewController/**/*.h"
  s.frameworks = "UIKit", "CoreGraphics"
  s.requires_arc = true
end
