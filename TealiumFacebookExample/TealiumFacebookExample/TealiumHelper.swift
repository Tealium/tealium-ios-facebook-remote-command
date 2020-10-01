//
//  TealiumHelper.swift
//
//  Created by Christina S on 6/18/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation
import TealiumSwift
import FBSDKCoreKit
//import TealiumFacebook

let tealiumFacebookVersion = "1.0.0"
let tealiumLibraryVersion = "2.1.0"

enum TealiumConfiguration {
    static let account = "tealiummobile"
    static let profile = "facebook-tag"
    static let environment = "dev"
}

class TealiumHelper {

    static let shared = TealiumHelper()

    let config = TealiumConfig(account: TealiumConfiguration.account,
                               profile: TealiumConfiguration.profile,
                               environment: TealiumConfiguration.environment)

    var tealium: Tealium?
    
    // JSON Remote Command
    // let facebookRemoteCommand = FacebookRemoteCommand(type: .remote(url: "https://tags.tiqcdn.com/dle/tealiummobile/demo/facebook.json"))
    let facebookRemoteCommand = FacebookRemoteCommand(type: .local(file: "facebook"))
    private init() {
        config.shouldUseRemotePublishSettings = false
        config.batchingEnabled = false
        config.remoteAPIEnabled = true
        config.logLevel = .info
        config.collectors = [Collectors.Lifecycle]
        config.dispatchers = [Dispatchers.TagManagement, Dispatchers.RemoteCommands]
        
        config.addRemoteCommand(facebookRemoteCommand)
        
        tealium = Tealium(config: config)

    }


    public func start() {
        _ = TealiumHelper.shared
    }

    class func trackView(title: String, data: [String: Any]?) {
        let tealiumView = TealiumView(title, dataLayer: data)
        TealiumHelper.shared.tealium?.track(tealiumView)
    }
    
    class func trackEvent(title: String, data: [String: Any]?) {
        let tealiumEvent = TealiumEvent(title, dataLayer: data)
        TealiumHelper.shared.tealium?.track(tealiumEvent)
    }

}


// MARK: Facebook
extension TealiumHelper {

    // Init helper
    func initializeFacebook(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        Settings.enableLoggingBehavior(.appEvents)
        AppEvents.activateApp()
    }

}
