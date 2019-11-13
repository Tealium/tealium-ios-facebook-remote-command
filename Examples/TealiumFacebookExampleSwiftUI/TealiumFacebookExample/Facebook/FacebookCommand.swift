//
//  FacebookCommand.swift
//  TealiumRemoteCommand
//
//  Created by Christina Sund on 5/20/19.
//  Copyright © 2019 Christina. All rights reserved.
//

import Foundation
import FBSDKCoreKit
#if COCOAPODS
    import TealiumSwift
#else
    import TealiumCore
    import TealiumDelegate
    import TealiumTagManagement
    import TealiumRemoteCommands
#endif

public class FacebookCommand {

    let facebookEvent = EnumMap<Facebook.StandardEventNames, AppEvents.Name> { command in
        switch command {
        case .achievedlevel:
            return AppEvents.Name.achievedLevel
        case .adclick:
            return AppEvents.Name.adClick
        case .adimpression:
            return AppEvents.Name.adImpression
        case .addedpaymentinfo:
            return AppEvents.Name.addedPaymentInfo
        case .addedtocart:
            return AppEvents.Name.addedToCart
        case .addedtowishlist:
            return AppEvents.Name.addedToWishlist
        case .completedregistration:
            return AppEvents.Name.completedRegistration
        case .completedtutorial:
            return AppEvents.Name.completedTutorial
        case .contact:
            return AppEvents.Name.contact
        case .viewedcontent:
            return AppEvents.Name.viewedContent
        case .searched:
            return AppEvents.Name.searched
        case .rated:
            return AppEvents.Name.rated
        case .customizeproduct:
            return AppEvents.Name.customizeProduct
        case .donate:
            return AppEvents.Name.donate
        case .findlocation:
            return AppEvents.Name.findLocation
        case .schedule:
            return AppEvents.Name.schedule
        case .starttrial:
            return AppEvents.Name.startTrial
        case .submitapplication:
            return AppEvents.Name.submitApplication
        case .subscribe:
            return AppEvents.Name.subscribe
        case .initiatedcheckout:
            return AppEvents.Name.initiatedCheckout
        case .unlockedachievement:
            return AppEvents.Name.unlockedAchievement
        case .spentcredits:
            return AppEvents.Name.spentCredits
        }
    }

    var facebookTracker: FacebookTrackable

    init(facebookTracker: FacebookTrackable) {
        self.facebookTracker = facebookTracker
    }

    /// Parses the remote command
    func remoteCommand() -> TealiumRemoteCommand {
        return TealiumRemoteCommand(commandId: "facebook", description: "Facebook Remote Command") { response in
            let payload = response.payload()
            guard let command = payload[TealiumRemoteCommand.commandName] as? String else {
                return
            }
            let commands = command.split(separator: ",")
            let facebookCommands = commands.map { command in
                return command.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
            self.parseCommands(facebookCommands, payload: payload)
        }
    }

    public func parseCommands(_ commands: [String], payload: [String: Any]) {
        commands.forEach { command in
            let lowercasedCommand = command.lowercased()
            switch lowercasedCommand {
            case Facebook.Commands.setAutoLogAppEventsEnabled:
                guard let autoLogEvents = payload[Facebook.Settings.autoLogEventsEnabled] as? Bool else {
                    print("\(Facebook.Error.prepend)setAutoLogAppEventsEnabled - \(Facebook.Settings.autoLogEventsEnabled) must be populated.")
                    return
                }
                return self.facebookTracker.setAutoLogAppEventsEnabled(autoLogEvents)
            case Facebook.Commands.setAutoInitEnabled:
                guard let autoInit = payload[Facebook.Settings.autoInitEnabled] as? Bool else {
                    print("\(Facebook.Error.prepend)setAutoInitEnabled - \(Facebook.Settings.autoInitEnabled) must be populated.")
                    return
                }
                return self.facebookTracker.setAutoInitEnabled(autoInit)
            case Facebook.Commands.enableAdvertiserIDCollection:
                guard let enableAidCollection = payload[Facebook.Settings.advertiserIDCollectionEnabled] as? Bool else {
                    print("\(Facebook.Error.prepend)enableAdvertiserIDCollection - \(Facebook.Settings.advertiserIDCollectionEnabled) must be populated.")
                    return
                }
                return self.facebookTracker.enableAdvertiserIDCollection(enableAidCollection)
            case Facebook.Commands.logPurchase:
                if let purchase = payload[Facebook.Purchase.purchase] as? [String: Any],
                    let amount = purchase[Facebook.Purchase.purchaseAmount] as? Double,
                    let currency = purchase[Facebook.Purchase.purchaseCurrency] as? String {
                    guard let parameters = purchase[Facebook.Purchase.purchaseParameters] as? [String: Any] else {
                        return self.facebookTracker.logPurchase(of: amount, with: currency)
                    }
                    return self.facebookTracker.logPurchase(of: amount, with: currency, and: parameters)
                } else {
                    print("\(Facebook.Error.prepend)logPurchase - Required variables do not exist in the payload.")
                }
            case Facebook.Commands.setUser:
                guard let userData = payload[Facebook.User.user] as? [String: Any] else {
                    print("\(Facebook.Error.prepend)setUser - User object must be populated.")
                    return
                }
                do {
                    let json = try JSONSerialization.data(withJSONObject: userData, options: .prettyPrinted)
                    return self.facebookTracker.setUser(from: json)
                } catch {
                    print("\(Facebook.Error.prepend)setUser - Could not convert userData to json.")
                }
            case Facebook.Commands.setUserId:
                guard let userId = payload[Facebook.User.userId] as? String else {
                    print("\(Facebook.Error.prepend)setUserId - User id must be poulated.")
                    return
                }
                self.facebookTracker.setUserId(to: userId)
            case Facebook.Commands.clearUserId:
                self.facebookTracker.clearUserId()
            case Facebook.Commands.clearUser:
                self.facebookTracker.clearUser()
            case Facebook.Commands.updateUserValue:
                if let userValue = payload[Facebook.User.userParameterValue] as? String,
                    let userKey = payload[Facebook.User.userParameter] as? String {
                    return self.facebookTracker.setUser(value: userValue, for: userKey)
                } else {
                    print("""
                        \(Facebook.Error.prepend)updateUserValue - \(Facebook.User.userParameter)
                               and \(Facebook.User.userParameterValue) must be populated.
                        """)
                }
            case Facebook.Commands.logProductItem:
                guard let productItemData = payload[Facebook.Product.productItem] as? [String: Any] else {
                    print("\(Facebook.Error.prepend)logProductItem - Product item object must be populated.")
                    return
                }
                do {
                    let json = try JSONSerialization.data(withJSONObject: productItemData, options: .prettyPrinted)
                    return self.facebookTracker.logProductItem(using: json)
                } catch {
                    print("\(Facebook.Error.prepend)logProductItem - Could not convert productItemData to json.")
                }
            case Facebook.Commands.setFlushBehavior:
                guard let flushBehavior = payload[Facebook.Flush.flushBehavior] as? String, let flush = UInt(flushBehavior) else {
                    print("\(Facebook.Error.prepend)setFlushBehavior - \(Facebook.Flush.flushBehavior) must be populated.")
                    return
                }
                return self.facebookTracker.setFlushBehavior(flushBehavior: UInt(flush))
            case Facebook.Commands.flush:
                return self.facebookTracker.flush()
            case Facebook.Commands.achievedLevel:
                guard (payload[Facebook.Event.level] as? String) != nil else {
                    print("\(Facebook.Error.prepend)achievedLevel - \(Facebook.Event.level) must be populated.")
                    return
                }
                return self.facebookTracker.logEvent(AppEvents.Name.achievedLevel, with: payload)
            case Facebook.Commands.unlockedAchievement:
                guard (payload[Facebook.Event.description] as? String) != nil else {
                    print("\(Facebook.Error.prepend)unlockedAchievement - \(Facebook.Event.description) must be populated.")
                    return
                }
                return self.facebookTracker.logEvent(AppEvents.Name.unlockedAchievement, with: payload)
            case Facebook.Commands.completedRegistration:
                guard (payload[Facebook.Event.registrationMethod] as? String) != nil else {
                    print("\(Facebook.Error.prepend)completedRegistration - \(Facebook.Event.registrationMethod) must be populated.")
                    return
                }
                return self.facebookTracker.logEvent(AppEvents.Name.completedRegistration, with: payload)
            case Facebook.Commands.completedTutorial:
                guard (payload[Facebook.Event.contentID] as? String) != nil else {
                    print("\(Facebook.Error.prepend)completedTutorial - \(Facebook.Event.contentID) must be populated.")
                    return
                }
                return self.facebookTracker.logEvent(AppEvents.Name.completedTutorial, with: payload)
            case Facebook.Commands.initiatedCheckout:
                guard let value = payload[Facebook.Event.valueToSum] as? Double else {
                    print("\(Facebook.Error.prepend)initiatedCheckout - \(Facebook.Event.valueToSum) must be populated.")
                    return
                }
                return self.facebookTracker.logEvent(AppEvents.Name.initiatedCheckout, with: value)
            case Facebook.Commands.searched:
                guard (payload[Facebook.Event.searchString] as? String) != nil else {
                    print("\(Facebook.Error.prepend)searched - \(Facebook.Event.searchString) must be populated.")
                    return
                }
                return self.facebookTracker.logEvent(AppEvents.Name.searched, with: payload)
            default:
                if let fbEvent = Facebook.StandardEventNames(rawValue: lowercasedCommand) {
                    let event = self.facebookEvent[fbEvent]
                    if let valueToSum = payload[Facebook.Event.valueToSum] as? Double {
                        if let parameters = payload[Facebook.Event.eventParameters] as? [String: Any] {
                            return self.facebookTracker.logEvent(event, with: valueToSum, and: parameters)
                        } else {
                            return self.facebookTracker.logEvent(event, with: valueToSum)
                        }
                    } else if let parameters = payload[Facebook.Event.eventParameters] as? [String: Any] {
                        return self.facebookTracker.logEvent(event, with: parameters)
                    } else {
                        return self.facebookTracker.logEvent(event)
                    }
                }
                break
            }
        }
    }

}

extension TealiumRemoteCommand {
    static let commandName = "command_name"
}
