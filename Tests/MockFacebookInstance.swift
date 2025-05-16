//
//  MockFacebookInstance.swift
//  TealiumFacebook
//
//  Created by Christina Sund on 5/22/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation
@testable import TealiumFacebook
import FBSDKCoreKit

class MockFacebookInstance: FacebookCommand {

    var didCallOnReady = false
    var isInitialized = false
    var didCheckAdvertiserTracking = false
    var didClearUser = false
    var didClearUserId = false
    var didFlush = false
    
    private var onReadyCallbacks: [() -> Void] = []
    var launchOptionsParam: [UIApplication.LaunchOptionsKey: Any]?
    var autoLogAppEventsEnabled: Bool?
    var advertiserIDCollectionEnabled: Bool?
    var loggedEvents: [(name: AppEvents.Name, valueToSum: Double?, parameters: [String: Any]?)] = []
    var loggedPurchases: [(amount: Double, currency: String, parameters: [String: Any]?)] = []
    var loggedProductItemData: Data?
    var userIdParam: String?
    var userDataParam: Data?
    var userKeyValueParams: [(key: String, value: String?)] = []
    var flushBehaviorParam: UInt?
    
    func triggerOnReadyCallbacks() {
        for callback in onReadyCallbacks {
            callback()
        }
    }
    
    func onReady(_ onReady: @escaping () -> Void) {
        didCallOnReady = true
        onReadyCallbacks.append(onReady)
        onReady()
    }
    
    func initialize(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        isInitialized = true
        launchOptionsParam = launchOptions
        
        triggerOnReadyCallbacks()
    }
    
    func setAutoLogAppEventsEnabled(_ enabled: Bool) {
        autoLogAppEventsEnabled = enabled
    }
    
    func enableAdvertiserIDCollection(_ enabled: Bool) {
        advertiserIDCollectionEnabled = enabled
    }
    
    func checkAdvertiserTracking() {
        didCheckAdvertiserTracking = true
    }
    
    func logEvent(_ event: AppEvents.Name, with parameters: [String: Any]) {
        loggedEvents.append((name: event, valueToSum: nil, parameters: parameters))
    }
    
    func logEvent(_ event: AppEvents.Name, with valueToSum: Double) {
        loggedEvents.append((name: event, valueToSum: valueToSum, parameters: nil))
    }
    
    func logEvent(_ event: AppEvents.Name, with valueToSum: Double, and parameters: [String: Any]) {
        loggedEvents.append((name: event, valueToSum: valueToSum, parameters: parameters))
    }
    
    func logEvent(_ event: AppEvents.Name) {
        loggedEvents.append((name: event, valueToSum: nil, parameters: nil))
    }
    
    func logPurchase(of amount: Double, with currency: String) {
        loggedPurchases.append((amount: amount, currency: currency, parameters: nil))
    }
    
    func logPurchase(of amount: Double, with currency: String, and parameters: [String: Any]) {
        loggedPurchases.append((amount: amount, currency: currency, parameters: parameters))
    }
    
    func logProductItem(using data: Data) {
        loggedProductItemData = data
    }
    
    func setUserId(to userid: String) {
        userIdParam = userid
    }
    
    func setUser(from data: Data) {
        userDataParam = data
    }
    
    func setUser(value: String?, for key: String) {
        userKeyValueParams.append((key: key, value: value))
    }
    
    func clearUser() {
        didClearUser = true
        userKeyValueParams = []
    }
    
    func clearUserId() {
        didClearUserId = true
        userIdParam = nil
    }
    
    func setFlushBehavior(flushBehavior: UInt) {
        flushBehaviorParam = flushBehavior
    }
    
    func flush() {
        didFlush = true
    }
}
