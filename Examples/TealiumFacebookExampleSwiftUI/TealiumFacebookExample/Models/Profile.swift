//
//  Profile.swift
//  TealiumFacebookExample
//
//  Created by Christina S on 11/13/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation

struct Profile {
    var userId: String
    var userName: String
    var level: String
    var registrationMethod: String
    
    static let `default` = Self(userId: "adventure",
                                userName: "parzival",
                                level: "99999999",
                                registrationMethod: "extra life")
    
    init(userId: String, userName: String, level: String, registrationMethod: String) {
        self.userId = userId
        self.userName = userName
        self.level = level
        self.registrationMethod = registrationMethod
    }
    
}
