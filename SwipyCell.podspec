Pod::Spec.new do |s|
  s.name = "SwipyCell"
  s.version = "4.1.0"
  s.summary = "Easy to use UITableViewCell implementing swiping to trigger actions (known from the Mailbox App)"
  s.homepage = "https://github.com/moritzsternemann/SwipyCell"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Moritz Sternemann" => "opensource@moritzsternemann.de" }
  s.social_media_url = "https://twitter.com/strnmn"
  s.platform = :ios, "12.0"
  s.swift_version = "5.3"
  s.source = { :git => "https://github.com/moritzsternemann/SwipyCell.git", :tag => s.version }
  s.source_files = "Sources/SwipyCell"
end
