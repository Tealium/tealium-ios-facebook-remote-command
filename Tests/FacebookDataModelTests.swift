//
//  FacebookDataModelTests.swift
//  TealiumFacebook
//
//  Created by Christina S on 5/22/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import XCTest
@testable import TealiumFacebook
import TealiumRemoteCommands
import FBSDKCoreKit

class FacebookDataModelTests: XCTestCase {

    override func setUp() { }

    override func tearDown() { }
}

// MARK: - User Model Tests
extension FacebookDataModelTests {
    func testDecodeUser() {
        let payload: [String: Any] = ["em": "test@test.com",
                                      "fn": "john",
                                      "ln": "doe",
                                      "ph": "8885559999",
                                      "dob": "06/01/1980",
                                      "ge": "male",
                                      "ct": "san diego",
                                      "st": "ca",
                                      "zp": "92121",
                                      "country": "US"]
        do {
            let userData = try JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
            let user = try JSONDecoder().decode(FacebookUser.self, from: userData)
            XCTAssertEqual("test@test.com", user.email)
            XCTAssertEqual("john", user.firstName)
            XCTAssertEqual("doe", user.lastName)
            XCTAssertEqual("8885559999", user.phone)
            XCTAssertEqual("06/01/1980", user.dob)
            XCTAssertEqual("male", user.gender)
            XCTAssertEqual("san diego", user.city)
            XCTAssertEqual("ca", user.state)
            XCTAssertEqual("92121", user.zip)
            XCTAssertEqual("US", user.country)
        } catch {
            XCTFail("Decoding user failed with error: \(error)")
        }
    }
}

// MARK: - Product Model Tests
extension FacebookDataModelTests {
    func testDecodeProductItemsWithAllRequiredValues() {
        let payload: [String: Any] = ["fb_product_item_id": "asdf123",
                                      "fb_product_availability": 0,
                                      "fb_product_condition": 0,
                                      "fb_product_description": "test description",
                                      "fb_product_image_link": "https://www.imagelink.com",
                                      "fb_product_link": "https://www.link.com",
                                      "fb_product_title": "test title",
                                      "fb_product_gtin": "test gtin",
                                      "fb_product_price_amount": 7.99,
                                      "fb_product_price_currency": "USD",
                                      "fb_product_parameters": ["productparam1": "productparam1value"]]

        do {
            let productData = try JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
            let product = try JSONDecoder().decode(FacebookProductItem.self, from: productData)
            XCTAssertEqual("asdf123", product.productId)
            XCTAssertEqual(0, product.productAvailablility)
            XCTAssertEqual(0, product.productCondition)
            XCTAssertEqual("test description", product.productDescription)
            XCTAssertEqual("https://www.imagelink.com", product.productImageLink)
            XCTAssertEqual("https://www.link.com", product.productLink)
            XCTAssertEqual("test title", product.productTitle)
            XCTAssertEqual("test gtin", product.productGtin)
            XCTAssertEqual(7.99, product.productPrice)
            XCTAssertEqual("USD", product.productCurrency)
            XCTAssertEqual(["productparam1": "productparam1value"], product.productParameters)
        } catch {
            XCTFail("Decoding productItem failed with error: \(error)")
        }
    }

    func testDecodeProductItemsWithMissingValues() {
        let payload: [String: Any] = ["fb_product_item_id": "asdf123",
                                      "fb_product_title": "test title",
                                      "fb_product_gtin": "test gtin",
                                      "fb_product_price_amount": 7.99,
                                      "fb_product_price_currency": "USD",
                                      "fb_product_parameters": ["productparam1": "productparam1value"]]

        do {
            let productData = try JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
            _ = try JSONDecoder().decode(FacebookProductItem.self, from: productData)
            XCTFail("Should not even make it past the decode")
        } catch {
            XCTAssertTrue(true, "This should fail because all required params are not present")
        }
    }
}

// MARK: - Conversion Tests
extension FacebookDataModelTests {
    func testConvertProductAvailability() {
        // Test all valid availability values
        XCTAssertEqual(AppEvents.ProductAvailability.inStock, AppEvents.ProductAvailability(rawValue: 0))
        XCTAssertEqual(AppEvents.ProductAvailability.outOfStock, AppEvents.ProductAvailability(rawValue: 1))
        XCTAssertEqual(AppEvents.ProductAvailability.preOrder, AppEvents.ProductAvailability(rawValue: 2))
        XCTAssertEqual(AppEvents.ProductAvailability.availableForOrder, AppEvents.ProductAvailability(rawValue: 3))
        XCTAssertEqual(AppEvents.ProductAvailability.discontinued, AppEvents.ProductAvailability(rawValue: 4))
    }
    
    func testConvertProductAvailabilityWithInvalidValue() {
        let availability = AppEvents.ProductAvailability(rawValue: 999)
        XCTAssertNotEqual(availability, AppEvents.ProductAvailability.inStock)
        XCTAssertNotEqual(availability, AppEvents.ProductAvailability.outOfStock)
        XCTAssertNotEqual(availability, AppEvents.ProductAvailability.preOrder)
        XCTAssertNotEqual(availability, AppEvents.ProductAvailability.availableForOrder)
        XCTAssertNotEqual(availability, AppEvents.ProductAvailability.discontinued)
    }

    func testConvertProductCondition() {
        // Test all valid condition values
        XCTAssertEqual(AppEvents.ProductCondition.new, AppEvents.ProductCondition(rawValue: 0))
        XCTAssertEqual(AppEvents.ProductCondition.refurbished, AppEvents.ProductCondition(rawValue: 1))
        XCTAssertEqual(AppEvents.ProductCondition.used, AppEvents.ProductCondition(rawValue: 2))
    }
    
    func testConvertProductConditionWithInvalidValue() {
        let condition = AppEvents.ProductCondition(rawValue: 999)
        XCTAssertNotEqual(condition, AppEvents.ProductCondition.new)
        XCTAssertNotEqual(condition, AppEvents.ProductCondition.refurbished)
        XCTAssertNotEqual(condition, AppEvents.ProductCondition.used)
    }
    
    func testConvertFlushBehavior() {
        // Test all valid flush behavior values
        XCTAssertEqual(AppEvents.FlushBehavior.auto, AppEvents.FlushBehavior(rawValue: 0))
        XCTAssertEqual(AppEvents.FlushBehavior.explicitOnly, AppEvents.FlushBehavior(rawValue: 1))
    }
    
    func testConvertFlushBehaviorWithInvalidValue() {
        let flushBehavior = AppEvents.FlushBehavior(rawValue: 999)
        XCTAssertNotEqual(flushBehavior, AppEvents.FlushBehavior.auto)
        XCTAssertNotEqual(flushBehavior, AppEvents.FlushBehavior.explicitOnly)
    }
}   
