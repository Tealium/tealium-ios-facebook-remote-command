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

    func testLogPurchaseWithParameters() {
        let payload: [String: Any] = [
            "command_name": "logpurchase",
            "purchase": [
                "fb_purchase_amount": 9.99,
                "fb_purchase_currency": "USD",
                "fb_purchase_parameters": [
                    "purchaseparam1": "purchase1value",
                    "param2": "purchase2value"
                ]
            ]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logPurchaseWithParametersCount)
        XCTAssertEqual(0, facebookInstance.logPurchaseNoParametersCount)
    }

    func testLogPurchaseNoParameters() {
        let payload: [String: Any] = [
            "command_name": "logpurchase", 
            "purchase": [
                "fb_purchase_amount": 9.99,
                "fb_purchase_currency": "USD"
            ]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.logPurchaseWithParametersCount)
        XCTAssertEqual(1, facebookInstance.logPurchaseNoParametersCount)
    }

    func testLogPurchaseMissingPurchaseObject() {
        let payload: [String: Any] = [
            "command_name": "logpurchase"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.logPurchaseNoParametersCount)
        XCTAssertEqual(0, facebookInstance.logPurchaseWithParametersCount)
    }
    
    func testLogPurchaseMissingCurrency() {
        let payload: [String: Any] = [
            "command_name": "logpurchase",
            "purchase": [
                "fb_purchase_amount": 9.99
            ]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.logPurchaseNoParametersCount)
        XCTAssertEqual(0, facebookInstance.logPurchaseWithParametersCount)
    }
    
    func testLogPurchaseWithStringAmount() {
        let payload: [String: Any] = [
            "command_name": "logpurchase",
            "purchase": [
                "fb_purchase_amount": "19.99",
                "fb_purchase_currency": "EUR"
            ]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logPurchaseNoParametersCount)
        XCTAssertEqual(0, facebookInstance.logPurchaseWithParametersCount)
    }

    func testLogPurchaseWithDoubleAmount() {
        let payload: [String: Any] = [
            "command_name": "logpurchase",
            "purchase": [
                "fb_purchase_amount": 19.99,
                "fb_purchase_currency": "USD"
            ]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logPurchaseNoParametersCount)
        XCTAssertEqual(0, facebookInstance.logPurchaseWithParametersCount)
    }
     
    func testLogPurchaseWithIntAmount() {
        let payload: [String: Any] = [
            "command_name": "logpurchase",
            "purchase": [
                "fb_purchase_amount": 25,
                "fb_purchase_currency": "USD"
            ]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logPurchaseNoParametersCount)
        XCTAssertEqual(0, facebookInstance.logPurchaseWithParametersCount)
    }
    
    func testLogPurchaseWithParametersInPayload() {
        let payload: [String: Any] = [
            "command_name": "logpurchase",
            "purchase": [
                "fb_purchase_amount": 14.99,
                "fb_purchase_currency": "USD"
            ],
            "fb_purchase_parameters": [
                "purchaseparam1": "purchase1value",
                "param2": "purchase2value"
            ]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logPurchaseWithParametersCount)
        XCTAssertEqual(0, facebookInstance.logPurchaseNoParametersCount)
    }
    
    func testLogPurchaseMissingAmount() {
        let payload: [String: Any] = [
            "command_name": "logpurchase",
            "purchase": [
                "fb_purchase_currency": "USD"
            ]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logPurchaseNoParametersCount)
        XCTAssertEqual(0, facebookInstance.logPurchaseWithParametersCount)
    }

    func testSetUser() {
        let payload: [String: Any] = [
            "command_name": "setuser",
            "user": [
                "em": "test@test.com",
                "fn": "test",
                "ln": "test",
                "ph": "test",
                "dob": "test",
                "ge": "test",
                "ct": "test",
                "st": "test",
                "zp": "test",
                "country": "test"
            ]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.setUserCount)
    }

    func testSetUserMissingParameters() {
        let payload: [String: Any] = [
            "command_name": "setuser"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.setUserCount)
    }

    func testSetUserId() {
        let payload: [String: Any] = [
            "command_name": "setuserid",
            "fb_user_id": "ABC123"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.setUserIdCount)
    }

    func testSetUserIdMissingParameters() {
        let payload: [String: Any] = [
            "command_name": "setuserid"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.setUserIdCount)
    }
    
    func testClearUserId() {
        let payload: [String: Any] = ["command_name": "clearuserid"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.clearUserIdCount)
    }
    
    func testClearUser() {
        let payload: [String: Any] = ["command_name": "clearuser"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.clearUserCount)
    }

    func testSetUserValue() {
        let payload = [
            "command_name": "updateuservalue", 
            "fb_user_value": "test", 
            "fb_user_key": "ln"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.setUserValueCount)
    }
    
    func testSetUserValueMissingValue() {
        let payload = [
            "command_name": "updateuservalue",
            "fb_user_key": "ln"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.setUserValueCount)
    }
    
    func testSetUserValueMissingKey() {
        let payload = [
            "command_name": "updateuservalue",
            "fb_user_value": "test"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.setUserValueCount)
    }

    func testProductItem() {
        let payload: [String: Any] = [
            "command_name": "logproductitem",
            "product_item": [
                "fb_product_item_id": ["asdf123"],
                "fb_product_availability": [0],
                "fb_product_condition": [0],
                "fb_product_description": ["test"],
                "fb_product_image_link": ["https://www.imagelink.com"],
                "fb_product_link": ["https://www.link.com"],
                "fb_product_title": ["test"],
                "fb_product_gtin": ["test"],
                "fb_product_price_amount": [7.99],
                "fb_product_price_currency": ["USD"],
                "fb_product_parameters": ["productparam1": "productparam1value"]
            ]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logProductItemCount)
    }

    func testProductItemMissingParameters() {
        let payload: [String: Any] = [
            "command_name": "logproductitem"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.logProductItemCount)
    }

    func testProductItemWithParametersInPayload() {
        let payload: [String: Any] = [
            "command_name": "logproductitem",
            "product_item": [
                "fb_product_item_id": ["asdf123"],
                "fb_product_availability": [0],
                "fb_product_condition": [0],
                "fb_product_description": ["test"],
                "fb_product_image_link": ["https://www.imagelink.com"],
                "fb_product_link": ["https://www.link.com"],
                "fb_product_title": ["test"],
                "fb_product_gtin": ["test"],
                "fb_product_price_amount": [7.99],
                "fb_product_price_currency": ["USD"]
            ],
            "fb_product_parameters": [
                "external_param1": "value1",
                "external_param2": "value2"
            ]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logProductItemCount)
    }

    func testProductItemWithMultipleProducts() {
        let payload: [String: Any] = [
            "command_name": "logproductitem",
            "product_item": [
                "fb_product_item_id": ["prod1", "prod2", "prod3"],
                "fb_product_availability": [0, 1, 0],
                "fb_product_condition": [0, 0, 0],
                "fb_product_description": ["desc1", "desc2", "desc3"],
                "fb_product_image_link": ["https://img1.com", "https://img2.com", "https://img3.com"],
                "fb_product_link": ["https://link1.com", "https://link2.com", "https://link3.com"],
                "fb_product_title": ["title1", "title2", "title3"],
                "fb_product_price_amount": [10.99, 20.99, 30.99],
                "fb_product_price_currency": ["USD", "EUR", "GBP"]
            ]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(3, facebookInstance.logProductItemCount)
    }

    func testSetFlushBehavior() {
        let payload: [String: Any] = [
            "command_name": "setflushbehavior", 
            "flush_behavior": "0"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.setFlushBehaviorCount)
    }

    func testSetFlushBehaviorMissingParameter() {
        let payload: [String: Any] = [
            "command_name": "setflushbehavior"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.setFlushBehaviorCount)
    }

    func testFlush() {
        let payload = ["command_name": "flush"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.flushCount)
    }
    
    func testAchievedLevel() {
        let payload: [String: Any] = [
            "command_name": "achievedlevel",
            "event": ["fb_level": "5"]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logEventWithParametersNoValueCount)
    }

    func testAchievedLevelMissingParameter() {
        let payload: [String: Any] = [
            "command_name": "achievedlevel"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.logEventWithParametersNoValueCount)
        XCTAssertEqual(0, facebookInstance.logEventNoValueNoParametersCount)
        XCTAssertEqual(0, facebookInstance.logEventWithValueAndParametersCount)
        XCTAssertEqual(0, facebookInstance.logEventWithValueNoParametersCount)
    }

    func testUnlockedAchievement() {
        let payload: [String: Any] = [
            "command_name": "unlockedachievement",
            "event": ["fb_description": "Gold Medal"]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logEventWithParametersNoValueCount)
    }

    func testUnlockedAchievementMissingParameter() {
        let payload: [String: Any] = [
            "command_name": "unlockedachievement"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.logEventWithParametersNoValueCount)
        XCTAssertEqual(0, facebookInstance.logEventNoValueNoParametersCount)
        XCTAssertEqual(0, facebookInstance.logEventWithValueAndParametersCount)
        XCTAssertEqual(0, facebookInstance.logEventWithValueNoParametersCount)
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
    
    func testCompletedTutorial() {
        let payload: [String: Any] = [
            "command_name": "completedtutorial",
            "event": ["fb_content_id": "tutorial_1"]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logEventWithParametersNoValueCount)
    }

    func testCompletedTutorialMissingParameter() {
        let payload: [String: Any] = [
            "command_name": "completedtutorial"
        ]
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
    
    func testSearched() {
        let payload: [String: Any] = [
            "command_name": "searched",
            "event": ["fb_search_string": "test search"]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logEventWithParametersNoValueCount)
    }

    func testSearchedMissingParameter() {
        let payload: [String: Any] = [
            "command_name": "searched"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.logEventWithParametersNoValueCount)
    }

    func testLogEventWithParametersNoValue() {
        let payload: [String: Any] = [
            "command_name": "viewedcontent,addedtocart,customizeproduct",
            "event": [
                "fb_content": "[{\"id\": \"1234\", \"quantity\": 2, \"item_price\": 5.99}, {\"id\": \"5678\", \"quantity\": 1, \"item_price\": 9.99}]",
                "fb_content_type": "product",
                "fb_currency": "USD"
            ]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(3, facebookInstance.logEventWithParametersNoValueCount)
    }

    func testLogEventWithValueNoParameters() {
        let payload: [String: Any] = [
            "command_name": "submitapplication,subscribe,schedule", 
            "_valueToSum": 21.99
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(3, facebookInstance.logEventWithValueNoParametersCount)
    }

    func testLogEventWithValueAndParameters() {
        let payload: [String: Any] = [
            "command_name": "addedtowishlist,completedtutorial,searched",
            "event": [
                "fb_content": "[{\"id\": \"1234\", \"quantity\": 2, \"item_price\": 5.99}, {\"id\": \"5678\", \"quantity\": 1, \"item_price\": 9.99}]",
                "fb_content_type": "product",
                "fb_currency": "USD",
                "fb_search_string": "hello",
                "fb_content_id": "abc123"
            ],
            "_valueToSum": 21.99
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.logEventWithValueAndParametersCount)
        XCTAssertEqual(2, facebookInstance.logEventWithParametersNoValueCount)
    }

    func testLogEventNoValueNoParameters() {
        let payload: [String: Any] = ["command_name": "rated, spentcredits, contact"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(3, facebookInstance.logEventNoValueNoParametersCount)
    }

}
