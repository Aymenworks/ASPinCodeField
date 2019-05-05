Pod::Spec.new do |spec|
  spec.name         = "ASPinCodeField"
  spec.version      = "1.0.3"
  spec.summary      = "Another PinCode View"

  spec.description  = <<-DESC
    Another PinCode View
  DESC

  spec.homepage     = "https://github.com/Aymenworks/ASPinCodeField"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Aymen Rebouh" => "aymenmse@gmail.com" }
  spec.social_media_url   = "https://twitter.com/aymenworks"
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/Aymenworks/ASPinCodeField.git", :tag => "#{spec.version}" }
  spec.source_files  = ['ASPinCodeField/**/*.{swift,h}']
  spec.public_header_files = 'ASPinCodeField/**/*.h'
  spec.requires_arc = true
  spec.ios.deployment_target = '9.0'
  spec.swift_version = "5.0"
end
