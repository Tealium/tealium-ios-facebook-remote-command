//
//  FacebookInstanceTests.swift
//  TealiumFacebook
//
//  Created by Christina S on 5/22/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import XCTest
@testable import TealiumFacebook
import TealiumRemoteCommands

class FacebookInstanceTests: XCTestCase {

    let facebookInstance = MockFacebookInstance()
    var facebookCommand: FacebookRemoteCommand!

    override func setUp() {
        facebookCommand = FacebookRemoteCommand(facebookInstance: facebookInstance)
    }

    override func tearDown() {
    }
    
    // MARK: Webview Remote Command Tests

    func testInitialize() {
        let payload: [String: Any] = ["command_name": "initialize"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.initializeCount)
    }
    
    func testLogEventWithParametersNoValue() {
        let payload: [String: Any] = ["command_name": "viewedcontent,addedtocart,customizeproduct",
                                      "event": ["fb_content": "[{\"id\": \"1234\", \"quantity\": 2, \"item_price\": 5.99}, {\"id\": \"5678\", \"quantity\": 1, \"item_price\": 9.99}]",
                                                "fb_content_type": "product",
                                                "fb_currency": "USD"]]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(3, facebookInstance.logEventWithParametersNoValueCount)
    }

    func testLogEventWithValueNoParameters() {
        let payload: [String: Any] = ["command_name": "submitapplication,subscribe,schedule", "_valueToSum": 21.99]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(3, facebookInstance.logEventWithValueNoParametersCount)
    }

    func testLogEventWithValueAndParameters() {
        let payload: [String: Any] = ["command_name": "addedtowishlist,completedtutorial,searched",
                                      "event": ["fb_content": "[{\"id\": \"1234\", \"quantity\": 2, \"item_price\": 5.99}, {\"id\": \"5678\", \"quantity\": 1, \"item_price\": 9.99}]",
                                                "fb_content_type": "product",
                                                "fb_currency": "USD",
                                                "fb_search_string": "hello",
                                                "fb_content_id": "abc123"],
                                      "_valueToSum": 21.99]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logEventWithValueAndParametersCount)
        XCTAssertEqual(2, facebookInstance.logEventWithParametersNoValueCount)
    }

    func testLogEventNoValueNoParameters() {
        let payload: [String: Any] = ["command_name": "rated, spentcredits, contact"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(3, facebookInstance.logEventNoValueNoParametersCount)
    }

    func testLogPurchaseWithParameters() {
        let payload: [String: Any] = ["command_name": "logpurchase", "purchase": [
            "fb_purchase_amount": 9.99,
            "fb_purchase_currency": "USD",
            "fb_purchase_parameters": ["purchaseparam1": "purchase1value",
                                       "param2": "purchase2value"]]]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logPurchaseWithParametersCount)
    }

    func testLogPurchaseNoParameters() {
        let payload: [String: Any] = ["command_name": "logpurchase", "purchase": [
            "fb_purchase_amount": 9.99,
            "fb_purchase_currency": "USD"]]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logPurchaseNoParametersCount)
    }

    func testProductItem() {
        let payload: [String: Any] = ["command_name": "logproductitem",
                                      "product_item": ["fb_product_item_id": ["asdf123"],
                                                       "fb_product_availability": [0],
                                                       "fb_product_condition": [0],
                                                       "fb_product_description": ["test"],
                                                       "fb_product_image_link": ["https://www.imagelink.com"],
                                                       "fb_product_link": ["https://www.link.com"],
                                                       "fb_product_title": ["test"],
                                                       "fb_product_gtin": ["test"],
                                                       "fb_product_price_amount": [7.99],
                                                       "fb_product_price_currency": ["USD"],
                                                       "fb_product_parameters": ["productparam1": "productparam1value"]]]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logProductItemCount)
    }

    func testSetUser() {
        let payload: [String: Any] = ["command_name": "setuser",
                                      "user": ["em": "test@test.com",
                                               "fn": "test",
                                               "ln": "test",
                                               "ph": "test",
                                               "dob": "test",
                                               "ge": "test",
                                               "ct": "test",
                                               "st": "test",
                                               "zp": "test",
                                               "country": "test"]]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.setUserCount)
    }

    func testSetUserValue() {
        let payload = ["command_name": "updateuservalue", "fb_user_value": "test", "fb_user_key": "ln"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.setUserValueCount)
    }
    
    func testSetUserId() {
        let payload: [String: Any] = ["command_name": "setuserid",
                                      "fb_user_id": "ABC123"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.setUserIdCount)
    }
    
    func testClearUser() {
        let payload: [String: Any] = ["command_name": "clearuser"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.clearUserCount)
    }
    
    func testClearUserId() {
        let payload: [String: Any] = ["command_name": "clearuserid"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.clearUserIdCount)
    }

    func testFlush() {
        let payload = ["command_name": "flush"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.flushCount)
    }
    
    func testLogEventCompletedRegistrationWithReqParameter() {
        let payload: [String: Any] = ["command_name": "completedregistration",
                                      "event": ["fb_registration_method": "twitter"]]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logEventWithParametersNoValueCount)
    }
    
    func testLogEventCompletedRegistrationNoRequiredParameter() {
        let payload: [String: Any] = ["command_name": "completedregistration"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.logEventWithParametersNoValueCount)
        XCTAssertEqual(0, facebookInstance.logEventNoValueNoParametersCount)
        XCTAssertEqual(0, facebookInstance.logEventWithValueAndParametersCount)
        XCTAssertEqual(0, facebookInstance.logEventWithValueNoParametersCount)
    }
    
    func testLogEventInitiatedCheckoutWithReqParameter() {
        let payload: [String: Any] = ["command_name": "initiatedcheckout","_valueToSum": 21.99]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logEventWithValueNoParametersCount)
    }
    
    func testLogEventInitiatedCheckoutNoRequiredParameter() {
        let payload: [String: Any] = ["command_name": "initiatedcheckout"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.logEventWithParametersNoValueCount)
        XCTAssertEqual(0, facebookInstance.logEventNoValueNoParametersCount)
        XCTAssertEqual(0, facebookInstance.logEventWithValueAndParametersCount)
        XCTAssertEqual(0, facebookInstance.logEventWithValueNoParametersCount)
    }

    func testLogPurchaseWithInvalidParameters() {
        // Missing currency, which is required
        let payload: [String: Any] = ["command_name": "logpurchase", "purchase": [
            "fb_purchase_amount": 9.99
        ]]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.logPurchaseNoParametersCount)
        XCTAssertEqual(0, facebookInstance.logPurchaseWithParametersCount)
    }

    func testMultipleCommandsInSinglePayload() {
        let payload: [String: Any] = ["command_name": "initialize,flush,clearuser"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.initializeCount)
        XCTAssertEqual(1, facebookInstance.flushCount)
        XCTAssertEqual(1, facebookInstance.clearUserCount)
    }

    func testDebugModeEnabled() {
        let payload: [String: Any] = ["command_name": "initialize", "debug": true]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.initializeCount)
    }

    func testAchievedLevelWithRequiredParameter() {
        let payload: [String: Any] = [
            "command_name": "achievedlevel",
            "event": ["fb_level": 5]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logEventWithParametersNoValueCount)
    }

    func testAchievedLevelNoRequiredParameter() {
        let payload: [String: Any] = [
            "command_name": "achievedlevel",
            "event": ["some_other_param": "value"]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.logEventWithParametersNoValueCount)
    }

    func testUnlockedAchievementWithRequiredParameter() {
        let payload: [String: Any] = [
            "command_name": "unlockedachievement",
            "event": ["fb_description": "Master Achiever"]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logEventWithParametersNoValueCount)
    }

    func testUnlockedAchievementNoRequiredParameter() {
        let payload: [String: Any] = [
            "command_name": "unlockedachievement",
            "event": ["some_other_param": "value"]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.logEventWithParametersNoValueCount)
    }

    func testSetAutoLogAppEventsEnabled() {
        let payload: [String: Any] = [
            "command_name": "setautologappeventsenabled",
            "auto_log_events_enabled": true
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.setAutoLogAppEventsEnabledCount)
    }

    func testSetAutoLogAppEventsEnabledMissingParameter() {
        let payload: [String: Any] = [
            "command_name": "setautologappeventsenabled"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.setAutoLogAppEventsEnabledCount)
    }

    func testEnableAdvertiserIDCollection() {
        let payload: [String: Any] = [
            "command_name": "enableadvertiseridcollection",
            "advertiser_id_collection_enabled": true
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.enableAdvertiserIDCollectionCount)
    }

    func testEnableAdvertiserIDCollectionMissingParameter() {
        let payload: [String: Any] = [
            "command_name": "enableadvertiseridcollection"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.enableAdvertiserIDCollectionCount)
    }

    func testCompletedTutorialWithRequiredParameter() {
        let payload: [String: Any] = [
            "command_name": "completedtutorial",
            "event": ["fb_content_id": "tutorial_1"]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logEventWithParametersNoValueCount)
    }

    func testSearchedWithRequiredParameter() {
        let payload: [String: Any] = [
            "command_name": "searched",
            "event": ["fb_search_string": "product xyz"]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logEventWithParametersNoValueCount)
    }

    func testSetFlushBehavior() {
        let payload: [String: Any] = [
            "command_name": "setflushbehavior",
            "flush_behavior": "1"  // Valid flush behavior value
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.setFlushBehaviorCount)
    }

    func testSetFlushBehaviorInvalidValue() {
        let payload: [String: Any] = [
            "command_name": "setflushbehavior",
            "flush_behavior": "invalid"  // Not a number
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.setFlushBehaviorCount)
    }
}
