//
//  TealiumHelper.swift
//
//  Created by Christina Sund on 6/18/19.
//  Copyright © 2019 Christina. All rights reserved.
//

import Foundation
import TealiumSwift
import FBSDKCoreKit
import TFB

let tealiumFacebookVersion = "0.0.1"
let tealiumLibraryVersion = "1.9.1"

enum TealiumConfiguration {
    static let account = "tealiummobile"
    static let profile = "facebook"
    static let environment = "dev"
}

class TealiumHelper {

    static let shared = TealiumHelper()

    let config = TealiumConfig(account: TealiumConfiguration.account,
                               profile: TealiumConfiguration.profile,
                               environment: TealiumConfiguration.environment)

    var tealium: Tealium?

    private init() {
        config.logLevel = .verbose
        config.shouldUseRemotePublishSettings = false
        config.batchingEnabled = false
        tealium = Tealium(config: config,
                          enableCompletion: { [weak self] _ in
                              guard let self = self else { return }
                              guard let remoteCommands = self.tealium?.remoteCommands() else {
                                  return
                              }
                              // MARK: Facebook
                              let facebookCommand = FacebookCommand(facebookTracker: FacebookTracker())
                              let facebookRemoteCommand = facebookCommand.remoteCommand()
                              remoteCommands.add(facebookRemoteCommand)
                          })

    }


    public func start() {
        _ = TealiumHelper.shared
    }

    class func trackView(title: String, data: [String: Any]?) {
        TealiumHelper.shared.tealium?.track(title: title, data: data, completion: nil)
    }

    class func trackEvent(title: String, data: [String: Any]?) {
        TealiumHelper.shared.tealium?.track(title: title, data: data, completion: nil)
    }

}


// MARK: Facebook
extension TealiumHelper {

    // Init helper
    func initializeFacebook(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(UIApplication.shared, didFinishLaunchingWithOptions: [:])
        Settings.enableLoggingBehavior(.appEvents)
        AppEvents.activateApp()
    }

}
