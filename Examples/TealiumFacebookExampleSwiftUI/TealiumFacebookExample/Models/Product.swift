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
    var parameters: [String: String]

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
        parameters: ["productparameter1": "productparamvalue1",
                     "productparameter2": "22.00"]
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
         parameters: [String: String]) {
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
        self.parameters = parameters
    }
    
    var data: [String: Any] {
        return ["purchse_object": Product.default.dictionary ?? [String: Any]()]
    }

}
