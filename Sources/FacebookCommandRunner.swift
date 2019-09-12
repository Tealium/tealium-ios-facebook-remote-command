//
//  FacebookCommandRunner.swift
//  TealiumRemoteCommand
//
//  Created by Christina Sund on 5/20/19.
//  Copyright © 2019 Christina. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import TealiumSwift

protocol FacebookCommandRunnable {
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

struct FacebookCommandRunner: FacebookCommandRunnable, TealiumRegistration {

    // MARK: Facebook Standard Events
    func logEvent(_ event: AppEvents.Name, with parameters: [String: Any]) {
        AppEvents.logEvent(event, parameters: parameters)
    }
    
    func logEvent(_ event: AppEvents.Name, with valueToSum: Double) {
        AppEvents.logEvent(event, valueToSum: valueToSum)
    }
    
    func logEvent(_ event: AppEvents.Name, with valueToSum: Double, and parameters: [String: Any]) {
        AppEvents.logEvent(event, valueToSum: valueToSum, parameters: parameters)
    }
    
    func logEvent(_ event: AppEvents.Name) {
        AppEvents.logEvent(event)
    }
    
    // MARK: Purchase
    func logPurchase(of amount: Double, with currency: String) {
        AppEvents.logPurchase(amount, currency: currency)
    }
    
    func logPurchase(of amount: Double, with currency: String, and parameters: [String: Any]) {
        AppEvents.logPurchase(amount, currency: currency, parameters: parameters)
    }
    
    // MARK: Push Notification
    func registerPushToken(_ pushToken: String) {
        AppEvents.setPushNotificationsDeviceToken(pushToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        AppEvents.logPushNotificationOpen(userInfo)
    }
    
    // MARK: Product
    func logProductItem(using data: Data) {
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
    func setUserId(to userid: String) {
        AppEvents.userID = userid
    }
    
    func setUser(from data: Data) {
        do {
            let user = try JSONDecoder().decode(FacebookUser.self, from: data)
            AppEvents.setUser(email: user.email, firstName: user.firstName, lastName: user.lastName, phone: user.phone, dateOfBirth: user.dob, gender: user.gender, city: user.city, state: user.state, zip: user.zip, country: user.country)
        } catch {
            print("Could not decode UserParameters: \(error)")
        }
    }
    
    func setUser(value: String?, for key: String) {
        AppEvents.setUserData(value, forType: AppEvents.UserDataType(key))
    }
    
    func clearUser() {
        AppEvents.clearUserData()
    }
    
    func clearUserId() {
        AppEvents.clearUserID()
    }
    
    // MARK: Flush Events
    func flush() {
        AppEvents.flush()
    }
    
    
}

