Pod::Spec.new do |s|
  s.name         = "SwipyCell"
  s.version      = "1.0.0"
  s.summary      = "Easy to use UITableViewCell implementing swiping to trigger actions (known from the Mailbox App)"
  s.homepage     = "https://github.com/moritzsternemann/SwipyCell"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Moritz Sternemann" => "mail@moritzsternemann.de" }
  s.social_media_url   = "https://twitter.com/_iMoritz"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/moritzsternemann/SwipyCell.git", :tag => "v1.0.0" }
  s.source_files  = "Source"
end
