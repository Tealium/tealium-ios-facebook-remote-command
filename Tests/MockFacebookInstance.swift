//
//  MockFacebookInstance.swift
//  TealiumFacebook
//
//  Created by Christina Sund on 5/22/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation
@testable import TealiumFacebook
import FacebookCore

class MockFacebookInstance: FacebookCommand {
    
    var initializeCount = 0
    var setAutoLogAppEventsEnabledCount = 0
    var setAutoInitEnabledCount = 0
    var enableAdvertiserIDCollectionCount = 0
    var logEventWithParametersNoValueCount = 0
    var logEventWithValueNoParametersCount = 0
    var logEventWithValueAndParametersCount = 0
    var logEventNoValueNoParametersCount = 0
    var logPurchaseNoParametersCount = 0
    var logPurchaseWithParametersCount = 0
    var logPushNotificationOpenNoActionCount = 0
    var logPushNotificationOpenWithActionCount = 0
    var logProductItemCount = 0
    var setUserCount = 0
    var setUserIdCount = 0
    var clearUserCount = 0
    var clearUserIdCount = 0
    var setUserValueCount = 0
    var setFlushBehaviorCount = 0
    var flushCount = 0
    
    func initialize() {
        initializeCount += 1
    }
    
    func setAutoLogAppEventsEnabled(_ enabled: Bool) {
        setAutoLogAppEventsEnabledCount += 1
    }
    
    func setAutoInitEnabled(_ enabled: Bool) {
        setAutoInitEnabledCount += 1
    }
    
    func enableAdvertiserIDCollection(_ enabled: Bool) {
        enableAdvertiserIDCollectionCount += 1
    }
    
    func logEvent(_ event: AppEvents.Name, with parameters: [String : Any]) {
        logEventWithParametersNoValueCount += 1
    }
    
    func logEvent(_ event: AppEvents.Name, with valueToSum: Double) {
        logEventWithValueNoParametersCount += 1
    }
    
    func logEvent(_ event: AppEvents.Name, with valueToSum: Double, and parameters: [String : Any]) {
        logEventWithValueAndParametersCount += 1
    }
    
    func logEvent(_ event: AppEvents.Name) {
        logEventNoValueNoParametersCount += 1
    }
    
    func logPurchase(of amount: Double, with currency: String) {
        logPurchaseNoParametersCount += 1
    }
    
    func logPurchase(of amount: Double, with currency: String, and parameters: [String : Any]) {
        logPurchaseWithParametersCount += 1
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        logPushNotificationOpenNoActionCount += 1
    }
    
    func logProductItem(using data: Data) {
        logProductItemCount += 1
    }
    
    func setUser(from data: Data) {
        setUserCount += 1
    }
    
    func setUser(value: String?, for key: String) {
        setUserValueCount += 1
    }
    
    func setUserId(to userid: String) {
        setUserIdCount += 1
    }
    
    func clearUser() {
        clearUserCount += 1
    }
    
    func clearUserId() {
        clearUserIdCount += 1
    }
    
    func setFlushBehavior(flushBehavior: UInt) {
        setFlushBehaviorCount += 1
    }
    
    func flush() {
        flushCount += 1
    }
    
}
