Pod::Spec.new do |s|

    # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.name         = "TealiumFacebook"
    s.module_name  = "TealiumFacebook"
    s.version      = "1.3.0"
    s.summary      = "Tealium Swift and Facebook integration"
    s.description  = <<-DESC
    Tealium's integration with Facebook for iOS.
    DESC
    s.homepage     = "https://github.com/Tealium/tealium-ios-facebook-remote-command"

    # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.license      = { :type => "Commercial", :file => "LICENSE.txt" }
    
    # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.authors            = { "Tealium Inc." => "tealium@tealium.com",
        "christinasund" => "christina.sund@tealium.com"}
    s.social_media_url   = "https://twitter.com/tealium"

    # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.swift_version = "5.2"
    s.platform     = :ios, "11.0"

    # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.source       = { :git => "https://github.com/Tealium/tealium-ios-facebook-remote-command.git", :tag => "#{s.version}" }

    # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.ios.source_files      = "Sources/*.{swift}"

    # ――― Dependencies ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.ios.dependency 'tealium-swift/Core', ' ~> 2.9'
    s.ios.dependency 'tealium-swift/RemoteCommands', ' ~> 2.9'
    s.ios.dependency 'FBSDKCoreKit', ' ~> 12.2'

end
