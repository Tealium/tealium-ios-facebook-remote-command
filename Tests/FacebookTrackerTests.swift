//
//  FacebookTrackerTests.swift
//  TealiumRemoteCommandTests
//
//  Created by Christina Sund on 5/22/19.
//  Copyright © 2019 Christina. All rights reserved.
//

import XCTest
@testable import TealiumFacebook
import TealiumRemoteCommands

class FacebookTrackerTests: XCTestCase {

    let facebookTracker = MockFacebookTracker()
    var facebookCommand: FacebookCommand!
    var remoteCommand: TealiumRemoteCommand!

    override func setUp() {
        facebookCommand = FacebookCommand(facebookTracker: facebookTracker)
        remoteCommand = facebookCommand.remoteCommand()
    }

    override func tearDown() {
    }

    func createRemoteCommandResponse(commandId: String, payload: [String: Any]) -> TealiumRemoteCommandResponse? {
        let responseDescription = HttpTestHelpers.httpRequestDescription(commandId: commandId, config: [:], payload: payload)
        if let description = responseDescription {
            return TealiumRemoteCommandResponse(urlString: description)
        }
        XCTFail("Could not create Remote Command Response description from stubs provided")
        return nil
    }

    func testLogEventWithParametersNoValue() {
        let expect = expectation(description: "test logEvent with parameters and no valueToSet")
        let payload: [String: Any] = ["command_name": "viewedcontent,addedtocart,customizeproduct",
                                      "event": ["fb_content": "[{\"id\": \"1234\", \"quantity\": 2, \"item_price\": 5.99}, {\"id\": \"5678\", \"quantity\": 1, \"item_price\": 9.99}]",
                                                "fb_content_type": "product",
                                                "fb_currency": "USD"]]
        if let response = createRemoteCommandResponse(commandId: "facebook", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(3, facebookTracker.logEventWithParametersNoValueCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }

    func testLogEventWithValueNoParameters() {
        let expect = expectation(description: "test logEvent with valueToSet and no parameters")
        let payload: [String: Any] = ["command_name": "submitapplication,subscribe,schedule", "_valueToSum": 21.99]
        if let response = createRemoteCommandResponse(commandId: "facebook", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(3, facebookTracker.logEventWithValueNoParametersCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }

    func testLogEventWithValueAndParameters() {
        let expect = expectation(description: "test logEvent with valueToSet and parameters")
        let payload: [String: Any] = ["command_name": "addedtowishlist,completedtutorial,searched",
                                      "event": ["fb_content": "[{\"id\": \"1234\", \"quantity\": 2, \"item_price\": 5.99}, {\"id\": \"5678\", \"quantity\": 1, \"item_price\": 9.99}]",
                                                "fb_content_type": "product",
                                                "fb_currency": "USD",
                                                "fb_search_string": "hello",
                                                "fb_content_id": "abc123"],
                                      "_valueToSum": 21.99]
        if let response = createRemoteCommandResponse(commandId: "facebook", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, facebookTracker.logEventWithValueAndParametersCount)
            XCTAssertEqual(2, facebookTracker.logEventWithParametersNoValueCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }

    func testLogEventNoValueNoParameters() {
        let expect = expectation(description: "test logEvent no valueToSet and no parameters")
        let payload: [String: Any] = ["command_name": "rated, spentcredits, contact"]
        if let response = createRemoteCommandResponse(commandId: "facebook", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(3, facebookTracker.logEventNoValueNoParametersCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }

    func testLogPurchaseWithParameters() {
        let expect = expectation(description: "test logPurchase with parameters")
        let payload: [String: Any] = ["command_name": "logpurchase", "purchase": [
            "fb_purchase_amount": 9.99,
            "fb_purchase_currency": "USD",
            "fb_purchase_parameters": ["purchaseparam1": "purchase1value",
                                       "param2": "purchase2value"]]]
        if let response = createRemoteCommandResponse(commandId: "facebook", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, facebookTracker.logPurchaseWithParametersCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }

    func testLogPurchaseNoParameters() {
        let expect = expectation(description: "test logPurchase no parameters")
        let payload: [String: Any] = ["command_name": "logpurchase", "purchase": [
            "fb_purchase_amount": 9.99,
            "fb_purchase_currency": "USD"]]
        if let response = createRemoteCommandResponse(commandId: "facebook", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, facebookTracker.logPurchaseNoParametersCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }

    func testProductItem() {
        let expect = expectation(description: "test logProductItem")
        let payload: [String: Any] = ["command_name": "logproductitem",
                                      "product_item": ["fb_product_item_id": "asdf123",
                                                       "fb_product_availability": 0,
                                                       "fb_product_condition": 0,
                                                       "fb_product_description": "test",
                                                       "fb_product_image_link": "https://www.imagelink.com",
                                                       "fb_product_link": "https://www.link.com",
                                                       "fb_product_title": "test",
                                                       "fb_product_gtin": "test",
                                                       "fb_product_price_amount": 7.99,
                                                       "fb_product_price_currency": "USD",
                                                       "fb_product_parameters": ["productparam1": "productparam1value"]]]
        if let response = createRemoteCommandResponse(commandId: "facebook", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, facebookTracker.logProductItemCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }

    func testSetUser() {
        let expect = expectation(description: "test setUser")
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
        if let response = createRemoteCommandResponse(commandId: "facebook", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, facebookTracker.setUserCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }

    func testSetUserValue() {
        let expect = expectation(description: "test setUserValue")
        let payload = ["command_name": "updateuservalue", "fb_user_value": "test", "fb_user_key": "ln"]
        if let response = createRemoteCommandResponse(commandId: "facebook", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, facebookTracker.setUserValueCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }
    
    func testSetUserId() {
        let expect = expectation(description: "test setUserId")
        let payload: [String: Any] = ["command_name": "setuserid",
                                      "fb_user_id": "ABC123"]
        if let response = createRemoteCommandResponse(commandId: "facebook", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, facebookTracker.setUserIdCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }
    
    func testClearUser() {
        let expect = expectation(description: "test clearUser")
        let payload: [String: Any] = ["command_name": "clearuser"]
        if let response = createRemoteCommandResponse(commandId: "facebook", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, facebookTracker.clearUserCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }
    
    func testClearUserId() {
        let expect = expectation(description: "test clearUserId")
        let payload: [String: Any] = ["command_name": "clearuserid"]
        if let response = createRemoteCommandResponse(commandId: "facebook", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, facebookTracker.clearUserIdCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }

    func testFlush() {
        let expect = expectation(description: "test flush")
        let payload = ["command_name": "flush"]
        if let response = createRemoteCommandResponse(commandId: "facebook", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, facebookTracker.flushCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }
    
    func testLogEventCompletedRegistrationWithReqParameter() {
        let expect = expectation(description: "test logEvent with valueToSet and parameters")
        let payload: [String: Any] = ["command_name": "completedregistration",
                                      "event": ["fb_registration_method": "twitter"]]
        if let response = createRemoteCommandResponse(commandId: "facebook", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, facebookTracker.logEventWithParametersNoValueCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }
    
    func testLogEventCompletedRegistrationNoRequiredParameter() {
        let expect = expectation(description: "test logEvent with valueToSet and parameters")
        let payload: [String: Any] = ["command_name": "completedregistration"]
        if let response = createRemoteCommandResponse(commandId: "facebook", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(0, facebookTracker.logEventWithParametersNoValueCount)
            XCTAssertEqual(0, facebookTracker.logEventNoValueNoParametersCount)
            XCTAssertEqual(0, facebookTracker.logEventWithValueAndParametersCount)
            XCTAssertEqual(0, facebookTracker.logEventWithValueNoParametersCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }
    
    func testLogEventInitiatedCheckoutWithReqParameter() {
        let expect = expectation(description: "test logEvent with valueToSet and parameters")
        let payload: [String: Any] = ["command_name": "initiatedcheckout","_valueToSum": 21.99]
        if let response = createRemoteCommandResponse(commandId: "facebook", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, facebookTracker.logEventWithValueNoParametersCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }
    
    func testLogEventInitiatedCheckoutNoRequiredParameter() {
        let expect = expectation(description: "test logEvent with valueToSet and parameters")
        let payload: [String: Any] = ["command_name": "initiatedcheckout"]
        if let response = createRemoteCommandResponse(commandId: "facebook", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(0, facebookTracker.logEventWithParametersNoValueCount)
            XCTAssertEqual(0, facebookTracker.logEventNoValueNoParametersCount)
            XCTAssertEqual(0, facebookTracker.logEventWithValueAndParametersCount)
            XCTAssertEqual(0, facebookTracker.logEventWithValueNoParametersCount)
        }
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }

}
