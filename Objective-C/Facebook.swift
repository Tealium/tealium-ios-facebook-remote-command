//
//  Facebook.swift
//  TealiumRemoteCommand
//
//  Created by Christina Sund on 5/21/19.
//  Copyright © 2019 Christina. All rights reserved.
//

import Foundation

/// Decode product_item object from payload
struct FacebookProductItem: Decodable {
    
    var productId: String
    var productAvailablility: Int
    var productCondition: Int
    var productDescription: String
    var productImageLink: String
    var productLink: String
    var productTitle: String
    var productGtin: String?
    var productMpn: String?
    var productBrand: String?
    var productPrice: Double
    var productCurrency: String
    var productParameters: [String: String]?
    
    enum ProductItemParameters: String, CodingKey {
        case productId = "fb_product_item_id"
        case productAvailablility = "fb_product_availability"
        case productCondition = "fb_product_condition"
        case productDescription = "fb_product_description"
        case productImageLink = "fb_product_image_link"
        case productLink = "fb_product_link"
        case productTitle = "fb_product_title"
        case productGtin = "fb_product_gtin"
        case productMpn = "fb_product_mpn"
        case productBrand = "fb_product_brand"
        case productPrice = "fb_product_price_amount"
        case productCurrency = "fb_product_price_currency"
        case productParameters = "fb_product_parameters"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ProductItemParameters.self)
        productId = try values.decode(String.self, forKey: .productId)
        productAvailablility = try values.decode(Int.self, forKey: .productAvailablility)
        productCondition = try values.decode(Int.self, forKey: .productCondition)
        productDescription = try values.decode(String.self, forKey: .productDescription)
        productImageLink = try values.decode(String.self, forKey: .productImageLink)
        productLink = try values.decode(String.self, forKey: .productLink)
        productTitle = try values.decode(String.self, forKey: .productTitle)
        productGtin = try values.decodeIfPresent(String.self, forKey: .productGtin)
        productMpn = try values.decodeIfPresent(String.self, forKey: .productMpn)
        productBrand = try values.decodeIfPresent(String.self, forKey: .productBrand)
        productPrice = try values.decode(Double.self, forKey: .productPrice)
        productCurrency = try values.decode(String.self, forKey: .productCurrency)
        productParameters = try values.decodeIfPresent([String: String].self, forKey: .productParameters)
    }
    
}

/// Decode user object from payload
struct FacebookUser: Decodable {
    
    var email: String?
    var firstName: String?
    var lastName: String?
    var phone: String?
    var dob: String?
    var gender: String?
    var city: String?
    var state: String?
    var zip: String?
    var country: String?
    
    enum UserParameters: String, CodingKey {
        case email = "em"
        case firstName = "fn"
        case lastName = "ln"
        case phone = "ph"
        case dob = "dob"
        case gender = "ge"
        case city = "ct"
        case state = "st"
        case zip = "zp"
        case country = "country"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: UserParameters.self)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        dob = try values.decodeIfPresent(String.self, forKey: .dob)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        zip = try values.decodeIfPresent(String.self, forKey: .zip)
        country = try values.decodeIfPresent(String.self, forKey: .country)
    }
    
}

/// All keys associated with Facebook remote command
enum Facebook {
    
    enum StandardEventNames: String, CaseIterable {
        case achievelevel
        case adclick
        case adimpression
        case addpaymentinfo
        case addtocart
        case addtowishlist
        case completeregistration
        case completetutorial
        case logcontact
        case viewedcontent
        case search
        case rate
        case customizeproduct
        case donate
        case findlocation
        case schedule
        case starttrial
        case submitapplication
        case subscribe
        case subscriptionheartbeat
        case initiatecheckout
        case purchase
        case unlockachievement
        case spentcredits
    }
    
    enum Commands {
        static let logPurchase = "logpurchase"
        static let setUser = "setuser"
        static let setUserId = "setuserid"
        static let clearUser = "clearuser"
        static let clearUserId = "clearuserid"
        static let updateUserValue = "updateuservalue"
        static let logProductItem = "logproductitem"
        static let pushNotificationOpen = "logpushnotificationopen"
        static let flush = "flush"
    }
    
    enum Event {
        static let eventParameters = "event"
        static let valueToSum = "fb_value_to_sum"
    }
    
    enum User {
        static let userParameter = "fb_user_value"
        static let userParameterValue = "fb_user_key"
        static let user = "user"
        static let userId = "fb_user_id"
    }
    
    enum Product {
        static let productPrice = "fb_product_price_amount"
        static let productCurrency = "fb_product_price_currency"
        static let productParameters = "fb_product_parameters"
        static let productItem = "product_item"
    }
    
    enum Purchase {
        static let purchaseAmount = "fb_purchase_amount"
        static let purchaseCurrency = "fb_purchase_currency"
        static let purchaseParameters = "fb_purchase_parameters"
        static let purchase = "purchase"
    }
    
    enum Push {
        static let pushAction = "fb_push_action"
        static let pushPayload = "fb_push_payload"
        static let push = "push"
    }
    
    static let commandName = "command_name"
}


