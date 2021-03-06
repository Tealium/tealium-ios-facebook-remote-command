//
//  FacebookInstance.swift
//  TealiumFacebook
//
//  Created by Christina S on 5/20/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation
#if COCOAPODS
    import TealiumSwift
    import FBSDKCoreKit
#else
    import TealiumCore
    import TealiumTagManagement
    import TealiumRemoteCommands
    import FacebookCore
#endif

public protocol FacebookCommand {
    // Initialize
    func initialize()
    // Settings
    func setAutoLogAppEventsEnabled(_ enabled: Bool)
    func enableAdvertiserIDCollection(_ enabled: Bool)
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
    func setFlushBehavior(flushBehavior: UInt)
    func flush()
}

public class FacebookInstance: FacebookCommand, TealiumRegistration {

    public init() { }
    
    // MARK: Initialize
    public func initialize() {
        DispatchQueue.main.async {
            ApplicationDelegate.shared.application(UIApplication.shared, didFinishLaunchingWithOptions: [:])
            Settings.enableLoggingBehavior(.appEvents)
            AppEvents.activateApp()
        }
    }
    
    // MARK: Settings
    public func setAutoLogAppEventsEnabled(_ enabled: Bool) {
        Settings.isAutoLogAppEventsEnabled = enabled
    }
    
    public func enableAdvertiserIDCollection(_ enabled: Bool) {
        Settings.isAdvertiserIDCollectionEnabled = enabled
    }
    
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
    
    public func application(_ application: UIApplication,
                            didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        AppEvents.logPushNotificationOpen(userInfo)
    }
    
    // MARK: Product
    public func logProductItem(using data: Data) {
        do {
            let product = try JSONDecoder().decode(FacebookProductItem.self, from: data)
            guard let availability = AppEvents.ProductAvailability(rawValue: product.productAvailablility.toUInt), let condition = AppEvents.ProductCondition(rawValue: product.productCondition.toUInt) else {
                print("\(FacebookConstants.errorPrefix)logProductItem - Product availability and condition are required, the type should be Integer")
                return
            }
            AppEvents.logProductItem(product.productId, availability: availability, condition: condition, description: product.productDescription, imageLink: product.productImageLink, link: product.productLink, title: product.productTitle, priceAmount: product.productPrice, currency: product.productCurrency, gtin: product.productGtin, mpn: product.productMpn, brand: product.productBrand, parameters: product.productParameters)
        } catch {
            print("\(FacebookConstants.errorPrefix)logProductItem - Unable to decode product item")
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
            print("\(FacebookConstants.errorPrefix)setUser - Could not decode UserParameters: \(error)")
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
    public func setFlushBehavior(flushBehavior: UInt) {
        guard let flush = AppEvents.FlushBehavior(rawValue: flushBehavior) else {
            print("\(FacebookConstants.errorPrefix)Could not set flush behavior because the value is invalid")
            return
        }
        AppEvents.flushBehavior = flush
    }
    
    public func flush() {
        AppEvents.flush()
    }
    
}

