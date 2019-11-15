//
//  Purchase.swift
//  TealiumFacebookExample
//
//  Created by Christina S on 11/14/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation

struct Purchase: Encodable {
    var total: Double
    var currency: String
    var parameters: [String: String]

    static let `default` = Self(total: 19.99,
        currency: "USD",
        parameters: ["purchaseparameter1": "purchaseparamvalue1",
            "purchaseparameter2": "true"])

    init(total: Double, currency: String, parameters: [String: String]) {
        self.total = total
        self.currency = currency
        self.parameters = parameters
    }

    var data: [String: Any] {
        return ["product_event_object": Purchase.default.dictionary ?? [String: Any]()]
    }

}
