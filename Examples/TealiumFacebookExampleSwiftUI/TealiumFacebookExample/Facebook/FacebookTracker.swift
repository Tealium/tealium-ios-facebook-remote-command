//
//  FacebookTracker.swift
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

public protocol FacebookTrackable {
    // Facebook Standard Events
    func logEvent(_ event: AppEvents.Name, with parameters: [String: Any])
    func logEvent(_ event: AppEvents.Name, with valueToSum: Double)
    func logEvent(_ event: AppEvents.Name, with valueToSum: Double, and parameters: [String: Any])
    func logEvent(_ event: AppEvents.Name)
    func logPurchase(of amount: Double, with currency: String)
    func logPurchase(of amount: Double, with currency: String, and parameters: [String: Any])
    // Push Notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    // Product
    func logProductItem(using data: Data)
    // User
    func setUserId(to userid: String)
    func setUser(from data: Data)
    func setUser(value: String?, for key: String)
    func clearUser()
    func clearUserId()
    // Flush Events
    func flush()
}

public class FacebookTracker: FacebookTrackable, TealiumRegistration {

    // MARK: Facebook Standard Events
    public func logEvent(_ event: AppEvents.Name, with parameters: [String: Any]) {
        AppEvents.logEvent(event, parameters: parameters)
    }
    
    public func logEvent(_ event: AppEvents.Name, with valueToSum: Double) {
        AppEvents.logEvent(event, valueToSum: valueToSum)
    }
    
    public func logEvent(_ event: AppEvents.Name, with valueToSum: Double, and parameters: [String: Any]) {
        AppEvents.logEvent(event, valueToSum: valueToSum, parameters: parameters)
    }
    
    public func logEvent(_ event: AppEvents.Name) {
        AppEvents.logEvent(event)
    }
    
    // MARK: Purchase
    public func logPurchase(of amount: Double, with currency: String) {
        AppEvents.logPurchase(amount, currency: currency)
    }
    
    public func logPurchase(of amount: Double, with currency: String, and parameters: [String: Any]) {
        AppEvents.logPurchase(amount, currency: currency, parameters: parameters)
    }
    
    // MARK: Push Notification
    public func registerPushToken(_ pushToken: String) {
        AppEvents.setPushNotificationsDeviceToken(pushToken)
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        AppEvents.logPushNotificationOpen(userInfo)
    }
    
    // MARK: Product
    public func logProductItem(using data: Data) {
        do {
            let product = try JSONDecoder().decode(FacebookProductItem.self, from: data)
            guard let availability = AppEvents.ProductAvailability(rawValue: product.productAvailablility.convertToUInt), let condition = AppEvents.ProductCondition(rawValue: product.productCondition.convertToUInt) else {
                print("Product availability and condition are required, the type should be Integer")
                return
            }
            AppEvents.logProductItem(product.productId, availability: availability, condition: condition, description: product.productDescription, imageLink: product.productImageLink, link: product.productLink, title: product.productTitle, priceAmount: product.productPrice, currency: product.productCurrency, gtin: product.productGtin, mpn: product.productMpn, brand: product.productBrand, parameters: product.productParameters)
        } catch {
            print("Unable to decode product item")
        }
        

    }
    
    // MARK: User
    public func setUserId(to userid: String) {
        AppEvents.userID = userid
    }
    
    public func setUser(from data: Data) {
        do {
            let user = try JSONDecoder().decode(FacebookUser.self, from: data)
            AppEvents.setUser(email: user.email, firstName: user.firstName, lastName: user.lastName, phone: user.phone, dateOfBirth: user.dob, gender: user.gender, city: user.city, state: user.state, zip: user.zip, country: user.country)
        } catch {
            print("Could not decode UserParameters: \(error)")
        }
    }
    
    public func setUser(value: String?, for key: String) {
        AppEvents.setUserData(value, forType: AppEvents.UserDataType(key))
    }
    
    public func clearUser() {
        AppEvents.clearUserData()
    }
    
    public func clearUserId() {
        AppEvents.clearUserID()
    }
    
    // MARK: Flush Events
    public func flush() {
        AppEvents.flush()
    }
    
    
}

