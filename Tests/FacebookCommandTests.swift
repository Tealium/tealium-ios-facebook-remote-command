//
//  FacebookCommandTests.swift
//  TealiumFacebook
//
//  Created by Christina S on 5/22/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import XCTest
@testable import TealiumFacebook
import TealiumRemoteCommands
import FBSDKCoreKit

class FacebookCommandTests: XCTestCase {

    let facebookInstance = FacebookInstance()
    var facebookCommand: FacebookRemoteCommand!

    override func setUp() {
        facebookCommand = FacebookRemoteCommand(facebookInstance: facebookInstance)
    }

    override func tearDown() { }

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

    func testConvertProductAvailability() {
        let availability = 1
        guard let productAvailability: AppEvents.ProductAvailability = AppEvents.ProductAvailability(rawValue: availability.toUInt) else {
            XCTFail("Could not convert product availability")
            return
        }
        XCTAssertEqual(AppEvents.ProductAvailability.outOfStock, productAvailability)
    }

    func testConvertProductCondition() {
        let condition = 2
        guard let productCondition: AppEvents.ProductCondition = AppEvents.ProductCondition(rawValue: condition.toUInt) else {
            XCTFail("Could not convert product condition")
            return
        }
        XCTAssertEqual(AppEvents.ProductCondition.used, productCondition)
    }

}
