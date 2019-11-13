//
//  FacebookCommand.swift
//  TealiumRemoteCommand
//
//  Created by Christina Sund on 5/20/19.
//  Copyright © 2019 Christina. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import TealiumIOS

public class FacebookCommand: NSObject {
    
    let facebookEvent = EnumMap<Facebook.StandardEventNames, AppEvents.Name> { command in
        switch command {
        case .achievelevel:
            return AppEvents.Name.achievedLevel
        case .adclick:
            return AppEvents.Name.adClick
        case .adimpression:
            return AppEvents.Name.adImpression
        case .addpaymentinfo:
            return AppEvents.Name.addedPaymentInfo
        case .addtocart:
            return AppEvents.Name.addedToCart
        case .addtowishlist:
            return AppEvents.Name.addedToWishlist
        case .completeregistration:
            return AppEvents.Name.completedRegistration
        case .completetutorial:
            return AppEvents.Name.completedTutorial
        case .logcontact:
            return AppEvents.Name.contact
        case .viewedcontent:
            return AppEvents.Name.viewedContent
        case .search:
            return AppEvents.Name.searched
        case .rate:
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
        case .subscriptionheartbeat:
            return AppEvents.Name.subscriptionHeartbeat
        case .initiatecheckout:
            return AppEvents.Name.initiatedCheckout
        case .purchase:
            return AppEvents.Name.purchased
        case .unlockachievement:
            return AppEvents.Name.unlockedAchievement
        case .spentcredits:
            return AppEvents.Name.spentCredits
        }
    }
    
    var facebookTracker: FacebookTrackable
    
    @objc
    public init(facebookTracker: FacebookTrackable) {
        self.facebookTracker = facebookTracker
    }
    
    /// Parses the remote command
    @objc
    public func remoteCommand() -> TEALRemoteCommandResponseBlock {
        return { response in
            guard let payload = response?.requestPayload as? [String: Any] else {
                return
            }
            guard let command = payload[Facebook.commandName] as? String else {
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
            if let fbEvent = Facebook.StandardEventNames(rawValue: lowercasedCommand) {
                let event = self.facebookEvent[fbEvent]
                if let valueToSum = payload[Facebook.Event.valueToSum] as? Double {
                    if let parameters = payload[Facebook.Event.eventParameters] as? [String: Any] {
                        return self.facebookTracker.logEvent(event, with: valueToSum, and: parameters)
                    } else {
                        return self.facebookTracker.logEventWithValue(event, valueToSum: valueToSum)
                    }
                } else if let parameters = payload[Facebook.Event.eventParameters] as? [String: Any] {
                    return self.facebookTracker.logEvent(event, with: parameters)
                } else {
                    return self.facebookTracker.logEvent(event)
                }
            }
            switch lowercasedCommand {
            case Facebook.Commands.logPurchase:
                if let purchase = payload[Facebook.Purchase.purchase] as? [String: Any],
                    let amount = purchase[Facebook.Purchase.purchaseAmount] as? Double,
                    let currency = purchase[Facebook.Purchase.purchaseCurrency] as? String {
                    guard let parameters = purchase[Facebook.Purchase.purchaseParameters] as? [String: Any] else {
                        return self.facebookTracker.logPurchase(of: amount, with: currency)
                    }
                    return self.facebookTracker.logPurchase(of: amount, with: currency, and: parameters)
                }
            case Facebook.Commands.setUser:
                guard let userData = payload[Facebook.User.user] as? [String: Any] else {
                    print("User key doesn't exist in the payload")
                    return
                }
                do {
                    let json = try JSONSerialization.data(withJSONObject: userData, options: .prettyPrinted)
                    return self.facebookTracker.setUser(from: json)
                } catch {
                    print("Could not convert payload to json")
                }
            case Facebook.Commands.setUserId:
                guard let userId = payload[Facebook.User.userId] as? String else {
                    print("User id does not exist in the payload")
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
                }
            case Facebook.Commands.logProductItem:
                guard let productItemData = payload[Facebook.Product.productItem] as? [String: Any] else {
                    print("Product item key doesn't exist in the payload")
                    return
                }
                do {
                    let json = try JSONSerialization.data(withJSONObject: productItemData, options: .prettyPrinted)
                    return self.facebookTracker.logProductItem(using: json)
                } catch {
                    print("Could not convert payload to json")
                }
            case Facebook.Commands.flush:
                return self.facebookTracker.flush()
            default:
                break
            }
        }
    }
    
}
