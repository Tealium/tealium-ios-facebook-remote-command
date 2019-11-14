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
    var customerName: String
    var level: String
    var registrationMethod: String
    
    static let `default` = Self(customerId: "adventure",
                                customerName: "parzival",
                                level: "99999999",
                                registrationMethod: "extra life")
    
    init(customerId: String, customerName: String, level: String, registrationMethod: String) {
        self.customerId = customerId
        self.customerName = customerName
        self.level = level
        self.registrationMethod = registrationMethod
    }
    
}
