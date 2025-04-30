//
//  TealiumHelper.swift
//
//  Created by Christina S on 6/18/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation
import TealiumSwift
import TealiumFacebook
import UIKit

enum TealiumConfiguration {
    static let account = "tealiummobile"
    static let profile = "facebook-tag"
    static let environment = "dev"
}

class TealiumHelper {

    static var shared: TealiumHelper!

    let config = TealiumConfig(account: TealiumConfiguration.account,
                               profile: TealiumConfiguration.profile,
                               environment: TealiumConfiguration.environment)

    var tealium: Tealium?
    
    // JSON Remote Command
    let facebookRemoteCommand: FacebookRemoteCommand
    
    init(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        config.shouldUseRemotePublishSettings = false
        config.batchingEnabled = false
        config.remoteAPIEnabled = true
        config.logLevel = .info
        config.collectors = [Collectors.Lifecycle]
        config.dispatchers = [Dispatchers.TagManagement, Dispatchers.RemoteCommands]
        
        facebookRemoteCommand = FacebookRemoteCommand(launchOptions: launchOptions, type: .local(file: "facebook", bundle: Bundle.main))
        
        config.addRemoteCommand(facebookRemoteCommand)
        
        tealium = Tealium(config: config)
    }

    class func start(launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        let helper = TealiumHelper.shared
        helper.facebookRemoteCommand.setLaunchOptions(launchOptions)
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
