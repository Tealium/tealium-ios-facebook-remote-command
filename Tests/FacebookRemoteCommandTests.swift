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

class FacebookRemoteCommandTests: XCTestCase {

    var facebookInstance: MockFacebookInstance!
    var facebookCommand: FacebookRemoteCommand!

    override func setUp() {
        facebookInstance = MockFacebookInstance()
        facebookCommand = FacebookRemoteCommand(facebookInstance: facebookInstance)
    }

    override func tearDown() {
    }
}

// MARK: - onReady Tests
extension FacebookRemoteCommandTests {
    func testOnReady() {
        facebookCommand.onReady { }  
        XCTAssertTrue(facebookInstance.didCallOnReady)  
    }

    func testOnReadyCalledAfterInitialize() {
        let onReadyIsCalled = expectation(description: "onReady is called")
        let command = FacebookRemoteCommand(facebookInstance: FacebookInstance())
        command.onReady {
            onReadyIsCalled.fulfill()
        }
        command.processRemoteCommand(with: ["command_name": "initialize"])
        waitForExpectations(timeout: 3.0)
    }
}

// MARK: - processRemoteCommand Tests
extension FacebookRemoteCommandTests {
    func testInitialize() {
        let payload: [String: Any] = ["command_name": "initialize"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertTrue(facebookInstance.isInitialized)
    }

    func testSetAutoLogAppEventsEnabled() {
        let payload: [String: Any] = [
            "command_name": "setautologappeventsenabled", 
            "auto_log_events_enabled": true
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(true, facebookInstance.autoLogAppEventsEnabled)
    }

    func testSetAutoLogAppEventsEnabledMissingParameter() {
        let payload: [String: Any] = [
            "command_name": "setautologappeventsenabled"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertNil(facebookInstance.autoLogAppEventsEnabled)
    }
  
    func testEnableAdvertiserIDCollection() {
        let payload: [String: Any] = [
            "command_name": "enableadvertiseridcollection", 
            "advertiser_id_collection_enabled": true
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(true, facebookInstance.advertiserIDCollectionEnabled)
    }

    func testEnableAdvertiserIDCollectionMissingParameter() {
        let payload: [String: Any] = [
            "command_name": "enableadvertiseridcollection"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertNil(facebookInstance.advertiserIDCollectionEnabled)
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
        XCTAssertEqual(1, facebookInstance.loggedPurchases.count)
        XCTAssertEqual(9.99, facebookInstance.loggedPurchases[0].amount)
        XCTAssertEqual("USD", facebookInstance.loggedPurchases[0].currency)
        XCTAssertNotNil(facebookInstance.loggedPurchases[0].parameters)
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
        XCTAssertEqual(1, facebookInstance.loggedPurchases.count)
        XCTAssertEqual(9.99, facebookInstance.loggedPurchases[0].amount)
        XCTAssertEqual("USD", facebookInstance.loggedPurchases[0].currency)
        XCTAssertNil(facebookInstance.loggedPurchases[0].parameters)
    }

    func testLogPurchaseMissingPurchaseObject() {
        let payload: [String: Any] = [
            "command_name": "logpurchase"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.loggedPurchases.count)
    }
    
    func testLogPurchaseMissingCurrency() {
        let payload: [String: Any] = [
            "command_name": "logpurchase",
            "purchase": [
                "fb_purchase_amount": 9.99
            ]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.loggedPurchases.count)
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
        XCTAssertEqual(1, facebookInstance.loggedPurchases.count)
        XCTAssertEqual(19.99, facebookInstance.loggedPurchases[0].amount)
        XCTAssertEqual("EUR", facebookInstance.loggedPurchases[0].currency)
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
        XCTAssertEqual(1, facebookInstance.loggedPurchases.count)
        XCTAssertEqual(19.99, facebookInstance.loggedPurchases[0].amount)
        XCTAssertEqual("USD", facebookInstance.loggedPurchases[0].currency)
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
        XCTAssertEqual(1, facebookInstance.loggedPurchases.count)
        XCTAssertEqual(25.0, facebookInstance.loggedPurchases[0].amount)
        XCTAssertEqual("USD", facebookInstance.loggedPurchases[0].currency)
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
        XCTAssertEqual(1, facebookInstance.loggedPurchases.count)
        XCTAssertEqual(14.99, facebookInstance.loggedPurchases[0].amount)
        XCTAssertEqual("USD", facebookInstance.loggedPurchases[0].currency)
        XCTAssertNotNil(facebookInstance.loggedPurchases[0].parameters)
    }
    
    func testLogPurchaseMissingAmount() {
        let payload: [String: Any] = [
            "command_name": "logpurchase",
            "purchase": [
                "fb_purchase_currency": "USD"
            ]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.loggedPurchases.count)
        XCTAssertEqual("USD", facebookInstance.loggedPurchases[0].currency)
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
        XCTAssertNotNil(facebookInstance.userDataParam)
    }

    func testSetUserMissingParameters() {
        let payload: [String: Any] = [
            "command_name": "setuser"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertNil(facebookInstance.userDataParam)
    }

    func testSetUserId() {
        let payload: [String: Any] = [
            "command_name": "setuserid",
            "fb_user_id": "ABC123"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual("ABC123", facebookInstance.userIdParam)
    }

    func testSetUserIdMissingParameters() {
        let payload: [String: Any] = [
            "command_name": "setuserid"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertNil(facebookInstance.userIdParam)
    }
    
    func testClearUserId() {
        let payload: [String: Any] = ["command_name": "clearuserid"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertTrue(facebookInstance.didClearUserId)
    }
    
    func testClearUser() {
        let payload: [String: Any] = ["command_name": "clearuser"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertTrue(facebookInstance.didClearUser)
    }

    func testSetUserValue() {
        let payload = [
            "command_name": "updateuservalue", 
            "fb_user_value": "test", 
            "fb_user_key": "ln"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.userKeyValueParams.count)
        XCTAssertEqual("ln", facebookInstance.userKeyValueParams[0].key)
        XCTAssertEqual("test", facebookInstance.userKeyValueParams[0].value)
    }
    
    func testSetUserValueMissingValue() {
        let payload = [
            "command_name": "updateuservalue",
            "fb_user_key": "ln"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.userKeyValueParams.count)
    }
    
    func testSetUserValueMissingKey() {
        let payload = [
            "command_name": "updateuservalue",
            "fb_user_value": "test"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.userKeyValueParams.count)
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
        XCTAssertNotNil(facebookInstance.loggedProductItemData)
    }

    func testProductItemMissingParameters() {
        let payload: [String: Any] = [
            "command_name": "logproductitem"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertNil(facebookInstance.loggedProductItemData)
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
        XCTAssertNotNil(facebookInstance.loggedProductItemData)
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
        XCTAssertNotNil(facebookInstance.loggedProductItemData)
    }

    func testSetFlushBehavior() {
        let payload: [String: Any] = [
            "command_name": "setflushbehavior", 
            "flush_behavior": "0"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.flushBehaviorParam)
    }

    func testSetFlushBehaviorMissingParameter() {
        let payload: [String: Any] = [
            "command_name": "setflushbehavior"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertNil(facebookInstance.flushBehaviorParam)
    }

    func testFlush() {
        let payload = ["command_name": "flush"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertTrue(facebookInstance.didFlush)
    }
    
    func testAchievedLevel() {
        let payload: [String: Any] = [
            "command_name": "achievedlevel",
            "event": ["fb_level": "5"]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.loggedEvents.count)
        XCTAssertNotNil(facebookInstance.loggedEvents[0].parameters)
    }

    func testAchievedLevelMissingParameter() {
        let payload: [String: Any] = [
            "command_name": "achievedlevel"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.loggedEvents.count)
    }

    func testUnlockedAchievement() {
        let payload: [String: Any] = [
            "command_name": "unlockedachievement",
            "event": ["fb_description": "Gold Medal"]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.loggedEvents.count)
        XCTAssertNotNil(facebookInstance.loggedEvents[0].parameters)
    }

    func testUnlockedAchievementMissingParameter() {
        let payload: [String: Any] = [
            "command_name": "unlockedachievement"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.loggedEvents.count)
    }
    
    func testLogEventCompletedRegistrationWithReqParameter() {
        let payload: [String: Any] = ["command_name": "completedregistration",
                                      "event": ["fb_registration_method": "twitter"]]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.loggedEvents.count)
        XCTAssertNotNil(facebookInstance.loggedEvents[0].parameters)
    }
    
    func testLogEventCompletedRegistrationNoRequiredParameter() {
        let payload: [String: Any] = ["command_name": "completedregistration"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.loggedEvents.count)
    }
    
    func testCompletedTutorial() {
        let payload: [String: Any] = [
            "command_name": "completedtutorial",
            "event": ["fb_content_id": "tutorial_1"]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.loggedEvents.count)
        XCTAssertNotNil(facebookInstance.loggedEvents[0].parameters)
    }

    func testCompletedTutorialMissingParameter() {
        let payload: [String: Any] = [
            "command_name": "completedtutorial"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.loggedEvents.count)
    }

    func testLogEventInitiatedCheckoutWithReqParameter() {
        let payload: [String: Any] = ["command_name": "initiatedcheckout","_valueToSum": 21.99]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.loggedEvents.count)
        XCTAssertEqual(21.99, facebookInstance.loggedEvents[0].valueToSum)
    }
    
    func testLogEventInitiatedCheckoutNoRequiredParameter() {
        let payload: [String: Any] = ["command_name": "initiatedcheckout"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.loggedEvents.count)
    }
    
    func testSearched() {
        let payload: [String: Any] = [
            "command_name": "searched",
            "event": ["fb_search_string": "test search"]
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, facebookInstance.loggedEvents.count)
        XCTAssertNotNil(facebookInstance.loggedEvents[0].parameters)
    }

    func testSearchedMissingParameter() {
        let payload: [String: Any] = [
            "command_name": "searched"
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, facebookInstance.loggedEvents.count)
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
        XCTAssertEqual(3, facebookInstance.loggedEvents.count)
        for event in facebookInstance.loggedEvents {
            XCTAssertNotNil(event.parameters)
            XCTAssertNil(event.valueToSum)
        }
    }

    func testLogEventWithValueNoParameters() {
        let payload: [String: Any] = [
            "command_name": "submitapplication,subscribe,schedule", 
            "_valueToSum": 21.99
        ]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(3, facebookInstance.loggedEvents.count)
        for event in facebookInstance.loggedEvents {
            XCTAssertEqual(21.99, event.valueToSum)
            XCTAssertNil(event.parameters)
        }
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
        XCTAssertEqual(3, facebookInstance.loggedEvents.count)
        var eventWithValueAndParamsCount = 0
        var eventWithParamsNoValueCount = 0
        
        for event in facebookInstance.loggedEvents {
            if event.valueToSum != nil && event.parameters != nil {
                eventWithValueAndParamsCount += 1
            } else if event.parameters != nil && event.valueToSum == nil {
                eventWithParamsNoValueCount += 1
            }
        }
        
        XCTAssertEqual(1, eventWithValueAndParamsCount)
        XCTAssertEqual(2, eventWithParamsNoValueCount)
    }

    func testLogEventNoValueNoParameters() {
        let payload: [String: Any] = ["command_name": "rated, spentcredits, contact"]
        facebookCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(3, facebookInstance.loggedEvents.count)
        for event in facebookInstance.loggedEvents {
            XCTAssertNil(event.valueToSum)
            XCTAssertNil(event.parameters)
        }
    }
}
