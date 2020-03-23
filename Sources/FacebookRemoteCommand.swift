//
//  FacebookRemoteCommand.swift
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

public class FacebookRemoteCommand {

    var facebookTracker: FacebookTrackable

    public init(facebookTracker: FacebookTrackable = FacebookTracker()) {
        self.facebookTracker = facebookTracker
    }

    /// Parses the remote command
    public func remoteCommand() -> TealiumRemoteCommand {
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
            case FacebookConstants.Commands.setAutoLogAppEventsEnabled:
                guard let autoLogEvents = payload[FacebookConstants.Settings.autoLogEventsEnabled] as? Bool else {
                    print("\(FacebookConstants.Error.prepend)setAutoLogAppEventsEnabled - \(FacebookConstants.Settings.autoLogEventsEnabled) must be populated.")
                    return
                }
                return self.facebookTracker.setAutoLogAppEventsEnabled(autoLogEvents)
            case FacebookConstants.Commands.setAutoInitEnabled:
                guard let autoInit = payload[FacebookConstants.Settings.autoInitEnabled] as? Bool else {
                    print("\(FacebookConstants.Error.prepend)setAutoInitEnabled - \(FacebookConstants.Settings.autoInitEnabled) must be populated.")
                    return
                }
                return self.facebookTracker.setAutoInitEnabled(autoInit)
            case FacebookConstants.Commands.enableAdvertiserIDCollection:
                guard let enableAidCollection = payload[FacebookConstants.Settings.advertiserIDCollectionEnabled] as? Bool else {
                    print("\(FacebookConstants.Error.prepend)enableAdvertiserIDCollection - \(FacebookConstants.Settings.advertiserIDCollectionEnabled) must be populated.")
                    return
                }
                return self.facebookTracker.enableAdvertiserIDCollection(enableAidCollection)
            case FacebookConstants.Commands.logPurchase:
                if let purchase = payload[FacebookConstants.Purchase.purchase] as? [String: Any],
                    let amount = purchase[FacebookConstants.Purchase.purchaseAmount] as? Double,
                    let currency = purchase[FacebookConstants.Purchase.purchaseCurrency] as? String {
                    guard let parameters = purchase[FacebookConstants.Purchase.purchaseParameters] as? [String: Any] else {
                        return self.facebookTracker.logPurchase(of: amount, with: currency)
                    }
                    return self.facebookTracker.logPurchase(of: amount, with: currency, and: typeCheck(parameters))
                } else {
                    print("\(FacebookConstants.Error.prepend)logPurchase - Required variables do not exist in the payload.")
                }
            case FacebookConstants.Commands.setUser:
                guard let userData = payload[FacebookConstants.User.user] as? [String: String] else {
                    print("\(FacebookConstants.Error.prepend)setUser - User object must be populated.")
                    return
                }
                do {
                    let json = try JSONSerialization.data(withJSONObject: userData, options: .prettyPrinted)
                    return self.facebookTracker.setUser(from: json)
                } catch {
                    print("\(FacebookConstants.Error.prepend)setUser - Could not convert userData to json.")
                }
            case FacebookConstants.Commands.setUserId:
                guard let userId = payload[FacebookConstants.User.userId] as? String else {
                    print("\(FacebookConstants.Error.prepend)setUserId - User id must be poulated.")
                    return
                }
                self.facebookTracker.setUserId(to: userId)
            case FacebookConstants.Commands.clearUserId:
                self.facebookTracker.clearUserId()
            case FacebookConstants.Commands.clearUser:
                self.facebookTracker.clearUser()
            case FacebookConstants.Commands.updateUserValue:
                if let userValue = payload[FacebookConstants.User.userParameterValue] as? String,
                    let userKey = payload[FacebookConstants.User.userParameter] as? String {
                    return self.facebookTracker.setUser(value: userValue, for: userKey)
                } else {
                    print("""
                        \(FacebookConstants.Error.prepend)updateUserValue - \(FacebookConstants.User.userParameter)
                               and \(FacebookConstants.User.userParameterValue) must be populated.
                        """)
                }
            case FacebookConstants.Commands.logProductItem:
                guard let productItemData = payload[FacebookConstants.Product.productItem] as? [String: Any] else {
                    print("\(FacebookConstants.Error.prepend)logProductItem - Product item object must be populated.")
                    return
                }
                do {
                    let json = try JSONSerialization.data(withJSONObject: productItemData, options: .prettyPrinted)
                    return self.facebookTracker.logProductItem(using: json)
                } catch {
                    print("\(FacebookConstants.Error.prepend)logProductItem - Could not convert productItemData to json.")
                }
            case FacebookConstants.Commands.setFlushBehavior:
                guard let flushBehavior = payload[FacebookConstants.Flush.flushBehavior] as? String, let flush = UInt(flushBehavior) else {
                    print("\(FacebookConstants.Error.prepend)setFlushBehavior - \(FacebookConstants.Flush.flushBehavior) must be populated.")
                    return
                }
                return self.facebookTracker.setFlushBehavior(flushBehavior: UInt(flush))
            case FacebookConstants.Commands.flush:
                return self.facebookTracker.flush()
            case FacebookConstants.Commands.achievedLevel:
                guard let eventParameters = payload[FacebookConstants.Event.eventParameters] as? [String: Any],
                    let _ = eventParameters[FacebookConstants.Event.level] as? String else {
                        print("\(FacebookConstants.Error.prepend)achievedLevel - \(FacebookConstants.Event.level) must be populated.")
                        return
                }
                return self.facebookTracker.logEvent(AppEvents.Name.achievedLevel, with: payload)
            case FacebookConstants.Commands.unlockedAchievement:
                guard let eventParameters = payload[FacebookConstants.Event.eventParameters] as? [String: Any],
                    let _ = eventParameters[FacebookConstants.Event.description] as? String else {
                        print("\(FacebookConstants.Error.prepend)unlockedAchievement - \(FacebookConstants.Event.description) must be populated.")
                        return
                }
                return self.facebookTracker.logEvent(AppEvents.Name.unlockedAchievement, with: eventParameters)
            case FacebookConstants.Commands.completedRegistration:
                guard let eventParameters = payload[FacebookConstants.Event.eventParameters] as? [String: Any],
                    let _ = eventParameters[FacebookConstants.Event.registrationMethod] as? String else {
                        print("\(FacebookConstants.Error.prepend)completedRegistration - \(FacebookConstants.Event.registrationMethod) must be populated.")
                        return
                }
                return self.facebookTracker.logEvent(AppEvents.Name.completedRegistration, with: payload)
            case FacebookConstants.Commands.completedTutorial:
                guard let eventParameters = payload[FacebookConstants.Event.eventParameters] as? [String: Any],
                    let _ = eventParameters[FacebookConstants.Event.contentID] as? String else {
                        print("\(FacebookConstants.Error.prepend)completedTutorial - \(FacebookConstants.Event.contentID) must be populated.")
                        return
                }
                return self.facebookTracker.logEvent(AppEvents.Name.completedTutorial, with: eventParameters)
            case FacebookConstants.Commands.initiatedCheckout:
                guard let value = payload[FacebookConstants.Event.valueToSum] as? Double else {
                    print("\(FacebookConstants.Error.prepend)initiatedCheckout - \(FacebookConstants.Event.valueToSum) must be populated.")
                    return
                }
                return self.facebookTracker.logEvent(AppEvents.Name.initiatedCheckout, with: value)
            case FacebookConstants.Commands.searched:
                guard let eventParameters = payload[FacebookConstants.Event.eventParameters] as? [String: Any],
                    let _ = eventParameters[FacebookConstants.Event.searchString] as? String else {
                        print("\(FacebookConstants.Error.prepend)searched - \(FacebookConstants.Event.searchString) must be populated.")
                        return
                }
                return self.facebookTracker.logEvent(AppEvents.Name.searched, with: eventParameters)
            default:
                if let fbEvent = FacebookConstants.StandardEventNames(rawValue: lowercasedCommand) {
                    let event = self.facebookEvent[fbEvent]
                    if let valueToSum = payload[FacebookConstants.Event.valueToSum] as? Double {
                        if let properties = payload[FacebookConstants.Event.eventParameters] as? [String: Any] {
                            return self.facebookTracker.logEvent(event, with: valueToSum, and: properties)
                        } else {
                            return self.facebookTracker.logEvent(event, with: valueToSum)
                        }
                    } else if let properties = payload[FacebookConstants.Event.eventParameters] as? [String: Any] {
                        return self.facebookTracker.logEvent(event, with: properties)
                    } else {
                        return self.facebookTracker.logEvent(event)
                    }
                }
                break
            }
        }
    }

    func typeCheck(_ params: [String: Any]) -> [String: Any] {
        return params.reduce(into: [String: Any]()) { result, dict in
            switch dict.value {
            case is Int:
                fallthrough
            case is UInt:
                fallthrough
            case is Bool:
                fallthrough
            case is Float:
                fallthrough
            case is Double:
                fallthrough
            case is String:
                result[dict.key] = dict.value
            default:
                print("\(FacebookConstants.Error.prepend)logPurchase - The purchase parameter values must either be a String or Int.")
                break
            }
        }
    }
    
    let facebookEvent = EnumMap<FacebookConstants.StandardEventNames, AppEvents.Name> { command in
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

}

extension TealiumRemoteCommand {
    static let commandName = "command_name"
}
