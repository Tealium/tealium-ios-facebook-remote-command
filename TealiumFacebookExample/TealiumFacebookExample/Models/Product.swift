//
//  Product.swift
//  TealiumFacebookExample
//
//  Created by Christina S on 11/14/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation

struct Product: Encodable {
    var id: String
    var availability: Int
    var condition: Int
    var description: String
    var imageUrl: String
    var url: String
    var name: String
    var gtin: String
    var brand: String
    var price: Double
    var currency: String
    var onlineStoreId: String // custom - product_parameters object
    var bulkDiscountPercentage: String // custom - product_parameters object

    static let `default` = Self(id: "abc123",
        availability: 1,
        condition: 2,
        description: "really cool",
        imageUrl: "https://link.to.image",
        url: "https://link.to.product",
        name: "some cool product",
        gtin: "ASDF235562SDFSDF",
        brand: "awesome brand",
        price: 19.99, currency: "USD",
        onlineStoreId: "ABC234SDF",
        bulkDiscountPercentage: "15"
    )
    
    init(id: String,
         availability: Int,
         condition: Int,
         description: String,
         imageUrl: String,
         url: String,
         name: String,
         gtin: String,
         brand: String,
         price: Double,
         currency: String,
         onlineStoreId: String,
         bulkDiscountPercentage: String) {
        self.id = id
        self.availability = availability
        self.condition = condition
        self.description = description
        self.imageUrl = imageUrl
        self.url = url
        self.name = name
        self.gtin = gtin
        self.brand = brand
        self.price = price
        self.currency = currency
        self.onlineStoreId = onlineStoreId
        self.bulkDiscountPercentage = bulkDiscountPercentage
    }
    
    var dictionary: [String: Any] {
        ["product_id": [id],
         "product_availability": [availability],
         "product_condition": [condition],
         "product_description": [description],
         "product_image_url": [imageUrl],
         "product_url": [url],
         "product_name": [name],
         "product_gtin": [gtin],
         "product_brand": [brand],
         "product_unit_price": [price],
         "currency": currency,
         "online_store_id": [onlineStoreId],
         "product_bulk_discount": [bulkDiscountPercentage]]
    }

}
