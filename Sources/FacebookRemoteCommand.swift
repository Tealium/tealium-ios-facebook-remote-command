//
//  FacebookRemoteCommand.swift
//  TealiumFacebook
//
//  Created by Christina S on 5/20/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation
import FBSDKCoreKit
#if COCOAPODS
    import TealiumSwift
#else
    import TealiumCore
    import TealiumRemoteCommands
#endif

public class FacebookRemoteCommand: RemoteCommand {

    var facebookInstance: FacebookCommand?
    var debug = false

    public init(facebookInstance: FacebookCommand = FacebookInstance(), type: RemoteCommandType = .webview) {
        self.facebookInstance = facebookInstance
        weak var weakSelf: FacebookRemoteCommand?
        super.init(commandId: FacebookConstants.commandId,
                   description: FacebookConstants.description,
            type: type,
            completion: { response in
                guard let payload = response.payload else {
                    return
                }
                weakSelf?.processRemoteCommand(with: payload)
            })
        weakSelf = self
    }

    func processRemoteCommand(with payload: [String: Any]) {
        facebookInstance?.checkAdvertiserTracking()
        guard let facebookInstance = facebookInstance,
            let command = payload[FacebookConstants.commandName] as? String else {
                return
        }
        if let tagDebug = payload[FacebookConstants.debug] as? Bool,
            tagDebug == true {
            debug = true
        }
        let commands = command.split(separator: FacebookConstants.separator)
        let facebookCommands = commands.map { command in
            return command.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }

        facebookCommands.forEach {
            let command = FacebookConstants.Commands(rawValue: $0.lowercased())

            switch command {
            case .initialize:
                facebookInstance.initialize()
            case .setAutoLogAppEventsEnabled:
                guard let autoLogEvents = payload[FacebookConstants.Settings.autoLogEventsEnabled] as? Bool else {
                    if debug {
                        print("\(FacebookConstants.errorPrefix)setAutoLogAppEventsEnabled - \(FacebookConstants.Settings.autoLogEventsEnabled) must be populated.")
                    }
                    return
                }
                return facebookInstance.setAutoLogAppEventsEnabled(autoLogEvents)
            case .enableAdvertiserIDCollection:
                guard let enableAidCollection = payload[FacebookConstants.Settings.advertiserIDCollectionEnabled] as? Bool else {
                    if debug {
                        print("\(FacebookConstants.errorPrefix)enableAdvertiserIDCollection - \(FacebookConstants.Settings.advertiserIDCollectionEnabled) must be populated.")
                    }
                    return
                }
                return facebookInstance.enableAdvertiserIDCollection(enableAidCollection)
            case .logPurchase:
                var amount: Double = 0.0
                guard let purchase = payload[FacebookConstants.Purchase.purchase] as? [String: Any],
                      let currency = purchase[FacebookConstants.Purchase.purchaseCurrency] as? String else {
                    if debug {
                        print("\(FacebookConstants.errorPrefix)logPurchase - Required variables do not exist in the payload.")
                    }
                    return
                }
                
                if let value = purchase[FacebookConstants.Purchase.purchaseAmount] as? String,
                   let doubleValue = Double(value) {
                    amount = doubleValue
                } else if let value = purchase[FacebookConstants.Purchase.purchaseAmount] as? Double {
                    amount = value
                } else if let value = purchase[FacebookConstants.Purchase.purchaseAmount] as? Int {
                    amount = Double(value)
                }
                
                if let parameters = purchase[FacebookConstants.Purchase.purchaseParameters] as? [String: Any] {
                    return facebookInstance.logPurchase(of: amount, with: currency, and: typeCheck(parameters))
                }
                if let parameters = payload[FacebookConstants.Purchase.purchaseParameters] as? [String: Any] {
                    return facebookInstance.logPurchase(of: amount, with: currency, and: typeCheck(parameters))
                }
                return facebookInstance.logPurchase(of: amount, with: currency)
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
                facebookInstance.setUserId(to: userId)
            case .clearUserId:
                facebookInstance.clearUserId()
            case .clearUser:
                facebookInstance.clearUser()
            case .updateUserValue:
                if let userValue = payload[FacebookConstants.User.userParameterValue] as? String,
                    let userKey = payload[FacebookConstants.User.userParameter] as? String {
                    return facebookInstance.setUser(value: userValue, for: userKey)
                } else if debug {
                    print("""
                        \(FacebookConstants.errorPrefix)updateUserValue - \(FacebookConstants.User.userParameter)
                               and \(FacebookConstants.User.userParameterValue) must be populated.
                        """)
                }
            case .logProductItem:
                guard var productItemData = payload[FacebookConstants.Product.productItem] as? [String: Any] else {
                    print("\(FacebookConstants.errorPrefix)logProductItem - Product item object must be populated.")
                    return
                }
                if let parameters = payload[FacebookConstants.Product.fbProductParameters] as? [String: Any] {
                    productItemData[FacebookConstants.Product.fbProductParameters] = parameters
                }
                logProductItem(with: productItemData)
            case .setFlushBehavior:
                guard let flushBehavior = payload[FacebookConstants.Flush.flushBehavior] as? String, let flush = UInt(flushBehavior) else {
                    print("\(FacebookConstants.errorPrefix)setFlushBehavior - \(FacebookConstants.Flush.flushBehavior) must be populated.")
                    return
                }
                return facebookInstance.setFlushBehavior(flushBehavior: UInt(flush))
            case .flush:
                return facebookInstance.flush()
            case .achievedLevel:
                guard let eventParameters = payload[FacebookConstants.Event.eventParameters] as? [String: Any],
                    let _ = eventParameters[FacebookConstants.Event.level] else {
                        if debug {
                            print("\(FacebookConstants.errorPrefix)achievedLevel - \(FacebookConstants.Event.level) must be populated.")
                        }
                        return
                }
                return facebookInstance.logEvent(AppEvents.Name.achievedLevel, with: typeCheck(eventParameters))
            case .unlockedAchievement:
                guard let eventParameters = payload[FacebookConstants.Event.eventParameters] as? [String: Any],
                    let _ = eventParameters[FacebookConstants.Event.description] as? String else {
                        if debug {
                            print("\(FacebookConstants.errorPrefix)unlockedAchievement - \(FacebookConstants.Event.description) must be populated.")
                        }
                        return
                }
                return facebookInstance.logEvent(AppEvents.Name.unlockedAchievement, with: typeCheck(eventParameters))
            case .completedRegistration:
                guard let eventParameters = payload[FacebookConstants.Event.eventParameters] as? [String: Any],
                    let _ = eventParameters[FacebookConstants.Event.registrationMethod] as? String else {
                        if debug {
                            print("\(FacebookConstants.errorPrefix)completedRegistration - \(FacebookConstants.Event.registrationMethod) must be populated.")
                        }
                        return
                }
                return facebookInstance.logEvent(AppEvents.Name.completedRegistration, with: typeCheck(eventParameters))
            case .completedTutorial:
                guard let eventParameters = payload[FacebookConstants.Event.eventParameters] as? [String: Any],
                    let _ = eventParameters[FacebookConstants.Event.contentID] as? String else {
                        if debug {
                            print("\(FacebookConstants.errorPrefix)completedTutorial - \(FacebookConstants.Event.contentID) must be populated.")
                        }
                        return
                }
                return facebookInstance.logEvent(AppEvents.Name.completedTutorial, with: typeCheck(eventParameters))
            case .initiatedCheckout:
                guard let value = payload[FacebookConstants.Event.valueToSum] as? Double else {
                    if debug {
                        print("\(FacebookConstants.errorPrefix)initiatedCheckout - \(FacebookConstants.Event.valueToSum) must be populated.")
                    }
                    return
                }
                return facebookInstance.logEvent(AppEvents.Name.initiatedCheckout, with: value)
            case .searched:
                guard let eventParameters = payload[FacebookConstants.Event.eventParameters] as? [String: Any],
                    let _ = eventParameters[FacebookConstants.Event.searchString] as? String else {
                        if debug {
                            print("\(FacebookConstants.errorPrefix)searched - \(FacebookConstants.Event.searchString) must be populated.")
                        }
                        return
                }
                return facebookInstance.logEvent(AppEvents.Name.searched, with: typeCheck(eventParameters))
            default:
                let event = AppEvents.Name(eventName: $0.lowercased())
                if let valueToSum = payload[FacebookConstants.Event.valueToSum] as? Double {
                    if let properties = payload[FacebookConstants.Event.eventParameters] as? [String: Any] {
                        return facebookInstance.logEvent(event, with: valueToSum, and: typeCheck(properties))
                    } else {
                        return facebookInstance.logEvent(event, with: valueToSum)
                    }
                } else if let properties = payload[FacebookConstants.Event.eventParameters] as? [String: Any] {
                    return facebookInstance.logEvent(event, with: typeCheck(properties))
                } else {
                    return facebookInstance.logEvent(event)
                }
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
        guard let facebookInstance = facebookInstance else {
            return
        }
        
        if let _ = productData[FacebookConstants.Product.productId] as? String {
            let validatedProductData = typeCheck(productData)
            do {
                let json = try JSONSerialization.data(withJSONObject: validatedProductData, options: .prettyPrinted)
                return facebookInstance.logProductItem(using: json)
            } catch {
                if debug {
                    print("\(FacebookConstants.errorPrefix)logProductItem - Could not convert productItemData to json.")
                }
            }
        }
        
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
                return facebookInstance.logProductItem(using: json)
            } catch {
                if debug {
                    print("\(FacebookConstants.errorPrefix)logProductItem - Could not convert productItemData to json.")
                }
            }
        }
    }
    
    private func setUser(with userData: [String: Any]) {
        guard let facebookInstance = facebookInstance else {
            return
        }
        do {
            let json = try JSONSerialization.data(withJSONObject: userData, options: .prettyPrinted)
            return facebookInstance.setUser(from: json)
        } catch {
            if debug {
                print("\(FacebookConstants.errorPrefix)setUser - Could not convert userData to json.")
            }
        }
    }

}

fileprivate extension AppEvents.Name {
    init(eventName: String) {
        if let fbEvent = FacebookConstants.StandardEventNames(rawValue: eventName) {
            switch fbEvent {
            case .adclick:
                self = AppEvents.Name.adClick
            case .adimpression:
                self = AppEvents.Name.adImpression
            case .addedpaymentinfo:
                self = AppEvents.Name.addedPaymentInfo
            case .addedtocart:
                self = AppEvents.Name.addedToCart
            case .addedtowishlist:
                self = AppEvents.Name.addedToWishlist
            case .contact:
                self = AppEvents.Name.contact
            case .viewedcontent:
                self = AppEvents.Name.viewedContent
            case .rated:
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
        } else {
            self = AppEvents.Name(eventName)
        }
    }
}


extension Dictionary where Key == String, Value == Any {
    
    func toFacebookParameters() -> [AppEvents.ParameterName: Any] {
        let kvPairs: [(AppEvents.ParameterName, Any)] = self.map { (key, value) in
            return (AppEvents.ParameterName(rawValue: key), value)
        }
        return [AppEvents.ParameterName: Any](kvPairs, uniquingKeysWith: { f, s in f })
    }
}
