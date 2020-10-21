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
    var id: String // custom - purchase_parameters object
    var promoCode: String // custom - purchase_parameters object

    static let `default` = Self(total: 19.99,
                                currency: "USD",
                                id: "ORDER123",
                                promoCode: "SUMMER20")

    init(total: Double, currency: String, id: String, promoCode: String) {
        self.id = id
        self.total = total
        self.currency = currency
        self.promoCode = promoCode
    }

    var dictionary: [String: Any] {
        ["order_id": id, "order_subtotal": total, "currency": currency, "order_coupon_code": promoCode]
    }

}
