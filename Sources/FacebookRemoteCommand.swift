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
    var debug = false

    public init(facebookTracker: FacebookTrackable = FacebookTracker()) {
        self.facebookTracker = facebookTracker
    }

    /// Parses the remote command
    public func remoteCommand() -> TealiumRemoteCommand {
        return TealiumRemoteCommand(commandId: "facebook", description: "Facebook Remote Command") { response in
            let payload = response.payload()
            guard let command = payload[FacebookConstants.commandName] as? String else {
                return
            }
            if let tagDebug = payload[FacebookConstants.debug] as? Bool {
                self.debug = tagDebug
            }
            let commands = command.split(separator: FacebookConstants.separator)
            let facebookCommands = commands.map { command in
                return command.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
            self.parseCommands(facebookCommands, payload: payload)
        }
    }

    public func parseCommands(_ commands: [String], payload: [String: Any]) {
        commands.forEach {
            let command = FacebookConstants.Commands(rawValue: $0.lowercased())
            switch command {
            case .setAutoLogAppEventsEnabled:
                guard let autoLogEvents = payload[FacebookConstants.Settings.autoLogEventsEnabled] as? Bool else {
                    if debug {
                        print("\(FacebookConstants.errorPrefix)setAutoLogAppEventsEnabled - \(FacebookConstants.Settings.autoLogEventsEnabled) must be populated.")
                    }
                    return
                }
                return self.facebookTracker.setAutoLogAppEventsEnabled(autoLogEvents)
            case .setAutoInitEnabled:
                guard let autoInit = payload[FacebookConstants.Settings.autoInitEnabled] as? Bool else {
                    if debug {
                        print("\(FacebookConstants.errorPrefix)setAutoInitEnabled - \(FacebookConstants.Settings.autoInitEnabled) must be populated.")
                    }
                    return
                }
                return self.facebookTracker.setAutoInitEnabled(autoInit)
            case .enableAdvertiserIDCollection:
                guard let enableAidCollection = payload[FacebookConstants.Settings.advertiserIDCollectionEnabled] as? Bool else {
                    if debug {
                        print("\(FacebookConstants.errorPrefix)enableAdvertiserIDCollection - \(FacebookConstants.Settings.advertiserIDCollectionEnabled) must be populated.")
                    }
                    return
                }
                return self.facebookTracker.enableAdvertiserIDCollection(enableAidCollection)
            case .logPurchase:
                if let purchase = payload[FacebookConstants.Purchase.purchase] as? [String: Any],
                    let amount = purchase[FacebookConstants.Purchase.purchaseAmount] as? String,
                    let value = Double(amount),
                    let currency = purchase[FacebookConstants.Purchase.purchaseCurrency] as? String {
                    guard let parameters = purchase[FacebookConstants.Purchase.purchaseParameters] as? [String: Any] else {
                        return self.facebookTracker.logPurchase(of: value, with: currency)
                    }
                    return self.facebookTracker.logPurchase(of: value, with: currency, and: typeCheck(parameters))
                } else {
                    if debug {
                        print("\(FacebookConstants.errorPrefix)logPurchase - Required variables do not exist in the payload.")
                    }
                }
            case .setUser:
                guard let userData = payload[FacebookConstants.User.user] as? [String: String] else {
                    if debug {
                        print("\(FacebookConstants.errorPrefix)setUser - User object must be populated.")
                    }
                    return
                }
                setUser(with: userData)
            case .setUserId:
                guard let userId = payload[FacebookConstants.User.userId] as? String else {
                    if debug {
                        print("\(FacebookConstants.errorPrefix)setUserId - User id must be poulated.")
                    }
                    return
                }
                self.facebookTracker.setUserId(to: userId)
            case .clearUserId:
                self.facebookTracker.clearUserId()
            case .clearUser:
                self.facebookTracker.clearUser()
            case .updateUserValue:
                if let userValue = payload[FacebookConstants.User.userParameterValue] as? String,
                    let userKey = payload[FacebookConstants.User.userParameter] as? String {
                    return self.facebookTracker.setUser(value: userValue, for: userKey)
                } else {
                    if debug {
                        print("""
                            \(FacebookConstants.errorPrefix)updateUserValue - \(FacebookConstants.User.userParameter)
                                   and \(FacebookConstants.User.userParameterValue) must be populated.
                            """)
                    }
                }
            case .logProductItem:
                guard let productItemData = payload[FacebookConstants.Product.productItem] as? [String: Any] else {
                    if debug {
                        print("\(FacebookConstants.errorPrefix)logProductItem - Product item object must be populated with all required parameters.")
                    }
                    return
                }
                logProductItem(with: productItemData)
            case .setFlushBehavior:
                guard let flushBehavior = payload[FacebookConstants.Flush.flushBehavior] as? String, let flush = UInt(flushBehavior) else {
                    if debug {
                        print("\(FacebookConstants.errorPrefix)setFlushBehavior - \(FacebookConstants.Flush.flushBehavior) must be populated.")
                    }
                    return
                }
                return self.facebookTracker.setFlushBehavior(flushBehavior: UInt(flush))
            case .flush:
                return self.facebookTracker.flush()
            case .achieveLevel:
                guard let eventParameters = payload[FacebookConstants.Event.eventParameters] as? [String: Any],
                    let _ = eventParameters[FacebookConstants.Event.level] as? String else {
                        if debug {
                            print("\(FacebookConstants.errorPrefix)achievedLevel - \(FacebookConstants.Event.level) must be populated.")
                        }
                        return
                }
                return self.facebookTracker.logEvent(AppEvents.Name.achievedLevel, with: typeCheck(eventParameters))
            case .unlockAchievement:
                guard let eventParameters = payload[FacebookConstants.Event.eventParameters] as? [String: Any],
                    let _ = eventParameters[FacebookConstants.Event.description] as? String else {
                        if debug {
                            print("\(FacebookConstants.errorPrefix)unlockedAchievement - \(FacebookConstants.Event.description) must be populated.")
                        }
                        return
                }
                return self.facebookTracker.logEvent(AppEvents.Name.unlockedAchievement, with: typeCheck(eventParameters))
            case .completeRegistration:
                guard let eventParameters = payload[FacebookConstants.Event.eventParameters] as? [String: Any],
                    let _ = eventParameters[FacebookConstants.Event.registrationMethod] as? String else {
                        if debug {
                            print("\(FacebookConstants.errorPrefix)completedRegistration - \(FacebookConstants.Event.registrationMethod) must be populated.")
                        }
                        return
                }
                return self.facebookTracker.logEvent(AppEvents.Name.completedRegistration, with: typeCheck(eventParameters))
            case .completeTutorial:
                guard let eventParameters = payload[FacebookConstants.Event.eventParameters] as? [String: Any],
                    let _ = eventParameters[FacebookConstants.Event.contentID] as? String else {
                        if debug {
                            print("\(FacebookConstants.errorPrefix)completedTutorial - \(FacebookConstants.Event.contentID) must be populated.")
                        }
                        return
                }
                return self.facebookTracker.logEvent(AppEvents.Name.completedTutorial, with: typeCheck(eventParameters))
            case .initiateCheckout:
                guard let value = payload[FacebookConstants.Event.valueToSum] as? Double else {
                    if debug {
                        print("\(FacebookConstants.errorPrefix)initiatedCheckout - \(FacebookConstants.Event.valueToSum) must be populated.")
                    }
                    return
                }
                return self.facebookTracker.logEvent(AppEvents.Name.initiatedCheckout, with: value)
            case .search:
                guard let eventParameters = payload[FacebookConstants.Event.eventParameters] as? [String: Any],
                    let _ = eventParameters[FacebookConstants.Event.searchString] as? String else {
                        if debug {
                            print("\(FacebookConstants.errorPrefix)searched - \(FacebookConstants.Event.searchString) must be populated.")
                        }
                        return
                }
                return self.facebookTracker.logEvent(AppEvents.Name.searched, with: typeCheck(eventParameters))
            default:
                if let fbEvent = FacebookConstants.StandardEventNames(rawValue: $0.lowercased()) {
                    let event = AppEvents.Name(eventName: fbEvent)
                    if let valueToSum = payload[FacebookConstants.Event.valueToSum] as? Double {
                        if let properties = payload[FacebookConstants.Event.eventParameters] as? [String: Any] {
                            return facebookTracker.logEvent(event, with: valueToSum, and: typeCheck(properties))
                        } else {
                            return facebookTracker.logEvent(event, with: valueToSum)
                        }
                    } else if let properties = payload[FacebookConstants.Event.eventParameters] as? [String: Any] {
                        return facebookTracker.logEvent(event, with: typeCheck(properties))
                    } else {
                        return facebookTracker.logEvent(event)
                    }
                }
                break
            }
        }
    }

    private func typeCheck(_ params: [String: Any], and offset: Int? = nil) -> [String: Any] {
        var index = 0
        if let offset = offset {
            index = offset
        }
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
            case let value as [Int]:
                result[dict.key] = value[index]
            case let value as [UInt]:
                result[dict.key] = value[index]
            case let value as [Bool]:
                result[dict.key] = value[index]
            case let value as [Float]:
                result[dict.key] = value[index]
            case let value as [Double]:
                result[dict.key] = value[index]
            case let value as [String]:
                result[dict.key] = value[index]
            case let value as [String: Any]:
                result[dict.key] = typeCheck(value)
            default:
                print("\(FacebookConstants.errorPrefix)eCommerce - Parameter values must either be a String or Int.")
                break
            }
        }
    }
    
    private func logProductItem(with productData: [String: Any]) {
        guard let productId = productData[FacebookConstants.Product.productId] as? [String] else {
            if debug {
                print("\(FacebookConstants.errorPrefix)logProductItem - Required parameters not populated.")
            }
            return
        }
        productId.enumerated().forEach {
            let validatedProductData = typeCheck(productData, and: $0.offset)
            do {
                let json = try JSONSerialization.data(withJSONObject: validatedProductData, options: .prettyPrinted)
                return self.facebookTracker.logProductItem(using: json)
            } catch {
                if debug {
                    print("\(FacebookConstants.errorPrefix)logProductItem - Could not convert productItemData to json.")
                }
            }
        }
    }
    
    private func setUser(with userData: [String: Any]) {
        do {
            let json = try JSONSerialization.data(withJSONObject: userData, options: .prettyPrinted)
            return self.facebookTracker.setUser(from: json)
        } catch {
            if debug {
                print("\(FacebookConstants.errorPrefix)setUser - Could not convert userData to json.")
            }
        }
    }

}

fileprivate extension AppEvents.Name {
    init(eventName: FacebookConstants.StandardEventNames) {
        switch eventName {
        case .adclick:
            self = AppEvents.Name.adClick
        case .adimpression:
            self = AppEvents.Name.adImpression
        case .addpaymentinfo:
            self = AppEvents.Name.addedPaymentInfo
        case .addtocart:
            self = AppEvents.Name.addedToCart
        case .addtowishlist:
            self = AppEvents.Name.addedToWishlist
        case .contact:
            self = AppEvents.Name.contact
        case .viewedcontent:
            self = AppEvents.Name.viewedContent
        case .rate:
            self = AppEvents.Name.rated
        case .customizeproduct:
            self = AppEvents.Name.customizeProduct
        case .donate:
            self = AppEvents.Name.donate
        case .findlocation:
            self = AppEvents.Name.findLocation
        case .schedule:
            self = AppEvents.Name.schedule
        case .starttrial:
            self = AppEvents.Name.startTrial
        case .submitapplication:
            self = AppEvents.Name.submitApplication
        case .subscribe:
            self = AppEvents.Name.subscribe
        case .spentcredits:
            self = AppEvents.Name.spentCredits
        }
    }
}
