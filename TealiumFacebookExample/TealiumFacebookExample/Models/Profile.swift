//
//  Profile.swift
//  TealiumFacebookExample
//
//  Created by Christina S on 11/13/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation

struct Profile {
    var customerId: String
    var user: User
    var level: String
    var registrationMethod: String

    static let `default` = Self(customerId: "adventure",
                                user: User.default,
                                level: "99999999",
                                registrationMethod: "extra life")

    init(customerId: String,
         user: User,
         level: String,
         registrationMethod: String) {
        self.customerId = customerId
        self.user = user
        self.level = level
        self.registrationMethod = registrationMethod
    }

}

struct User {
    var customerFirstName: String
    var customerLastName: String
    var customerPhone: String
    var customerGender: String
    var customerCity: String
    var customerState: String
    var customerZip: String
    var customerCountry: String

    static let `default` = Self(customerFirstName: "John",
        customerLastName: "Doe",
        customerPhone: "858-555-6666",
        customerGender: "M",
        customerCity: "San Diego",
        customerState: "CA",
        customerZip: "92121",
        customerCountry: "US")

    init(customerFirstName: String,
        customerLastName: String,
        customerPhone: String,
        customerGender: String,
        customerCity: String,
        customerState: String,
        customerZip: String,
        customerCountry: String) {
        self.customerFirstName = customerFirstName
        self.customerLastName = customerLastName
        self.customerPhone = customerPhone
        self.customerGender = customerGender
        self.customerCity = customerCity
        self.customerState = customerState
        self.customerZip = customerZip
        self.customerCountry = customerCountry
    }

    var dictionary: [String: String] {
        ["customer_first_name": customerFirstName,
            "customer_last_name": customerLastName,
            "customer_phone": customerPhone,
            "customer_gender": customerGender,
            "customer_city": customerCity,
            "customer_state": customerState,
            "customer_zip": customerZip,
            "customer_country": customerCountry]
    }
}
