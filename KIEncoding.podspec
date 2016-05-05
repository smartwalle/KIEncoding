Pod::Spec.new do |s|
  s.name         = "KIEncoding"
  s.version      = "0.0.1"
  s.summary      = "KIEncoding"

  s.description  = <<-DESC
                   KIEncoding is an encoding & decoding toolkit for iOS platform. it's include RSA、AES and so on.
                   DESC

  s.homepage     = "https://github.com/smartwalle/KIEncoding"
  s.license      = "MIT"
  s.author       = { "SmartWalle" => "smartwalle@gmail.com" }
  s.ios.deployment_target   = '6.0'

  s.source       = { :git => "https://github.com/smartwalle/KIEncoding.git", :tag => "#{s.version}"}
  s.source_files  = "KIEncoding/KIEncoding/*.{h,m}", "KIEncoding/KIDigest/*.{h,m}", "KIEncoding/KIHMAC/*.{h,m}", "KIEncoding/KIOpenSSL/KIAES/*.{h,m}", "KIEncoding/KIOpenSSL/KIRSA/*.{h,m}", "KIEncoding/KIOpenSSL/KIPKCS5/*.{h,m}"
  s.requires_arc = true

  s.dependency "KIOpenSSL"

end
