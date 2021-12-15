//
//  FacebookConstants.swift
//  TealiumFacebook
//
//  Created by Christina S on 5/21/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation
#if COCOAPODS
    import FBSDKCoreKit
#else
    import FacebookCore
#endif

/// All keys associated with Facebook remote command
enum FacebookConstants {
    static let version = "1.2.0"
    static let commandId = "facebook"
    static let description = "Facebook Remote Command"
    static let commandName = "command_name"
    static let debug = "debug"
    static let separator: Character = ","
    static let errorPrefix = "TealiumFacebook Error: "
    
    enum StandardEventNames: String, CaseIterable {
        case viewedcontent
        case rated
        case addedtocart
        case addedtowishlist
        case addedpaymentinfo
        case spentcredits
        case contact
        case customizeproduct
        case donate
        case findlocation
        case schedule
        case starttrial
        case submitapplication
        case subscribe
        case adimpression
        case adclick
    }
    
    enum Commands: String {
        case initialize = "initialize"
        case setAutoLogAppEventsEnabled = "setautologappeventsenabled"
        case setAutoInitEnabled = "setautoinitenabled"
        case enableAdvertiserIDCollection = "enableadvertiseridcollection"
        case logPurchase = "logpurchase"
        case setUser = "setuser"
        case setUserId = "setuserid"
        case clearUser = "clearuser"
        case clearUserId = "clearuserid"
        case updateUserValue = "updateuservalue"
        case logProductItem = "logproductitem"
        case setFlushBehavior = "setflushbehavior"
        case flush = "flush"
        case achievedLevel = "achievedlevel"
        case unlockedAchievement = "unlockedachievement"
        case completedRegistration = "completedregistration"
        case completedTutorial = "completedtutorial"
        case initiatedCheckout = "initiatedcheckout"
        case searched = "searched"
        case activatedApp = "activatedapp"
        case deactivatedApp = "deactivatedapp"
        case sessionInterruptions = "sessioninterruptions"
        case timebetweensessions = "timebetweensessions"
        case adClicked = "adclicked"
        case adImpression = "adimpression"
        case addedPaymentinfo = "addedpaymentinfo"
        case addedToCart = "addedtocart"
        case addedToWishlist = "addedtowishlist"
        case contact = "contact"
        case viewedContent = "viewedcontent"
        case rated = "rated"
        case customizeProduct = "customizeproduct"
        case donate = "donate"
        case findLocation = "findlocation"
        case schedule = "schedule"
        case startTrial = "starttrial"
        case submitApplication = "submitapplication"
        case subscribe = "subscribe"
        case purchased = "purchased"
        case spentCredits = "spentcredits"
        case liveStreamingStart = "livestreamingstart"
        case liveStreamingStop = "livestreamingstop"
        case liveStreamingPause = "livestreamingpause"
        case liveStreamingResume = "livestreamingresume"
        case liveStreamingError = "livestreamingerror"
        case liveStreamingUpdateStatus = "livestreamingupdatestatus"
        case productCatalogUpdate = "productcatalogupdate"
    }
    
    enum Event {
        static let eventParameters = "event" // Event object
        static let valueToSum = "_valueToSum"
        static let currency = "fb_currency"
        static let registrationMethod = "fb_registration_method"
        static let contentType = "fb_content_type"
        static let content = "fb_content"
        static let contentID = "fb_content_id"
        static let searchString = "fb_search_string"
        static let success = "fb_success"
        static let maxRatingValue = "fb_max_rating_value"
        static let paymentInfoAvailable = "fb_payment_info_available"
        static let numItems = "fb_num_items"
        static let level = "fb_level"
        static let description = "fb_description"
        static let mobileLaunchSource = "fb_mobile_launch_source"
        static let adType = "ad_type"
        static let orderID = "fb_order_id"
    }
    
    enum Flush {
        static let flushBehavior = "flush_behavior"
    }
    
    enum Product {
        static let productItem = "product_item" // logProductItem object
        static let productId = "fb_product_item_id"
        static let productPrice = "fb_product_price_amount"
        static let productCurrency = "fb_product_price_currency"
        static let fbProductParameters = "fb_product_parameters"
        static let productCustomLabel0 = "fb_product_custom_label_0"
        static let productCustomLabel1 = "fb_product_custom_label_1"
        static let productCustomLabel2 = "fb_product_custom_label_2"
        static let productCustomLabel3 = "fb_product_custom_label_3"
        static let productCustomLabel4 = "fb_product_custom_label_4"
        static let category = "fb_product_category"
        static let appLinkIOSUrl = "fb_product_applink_ios_url"
        static let appLinkIOSAppStoreID = "fb_product_applink_ios_app_store_id"
        static let appLinkIOSAppName = "fb_product_applink_ios_app_name"
        static let appLinkIPhoneUrl = "fb_product_applink_iphone_url"
        static let appLinkIPhoneAppStoreID = "fb_product_applink_iphone_app_store_id"
        static let appLinkIPhoneAppName = "fb_product_applink_iphone_app_name"
        static let appLinkIPadUrl = "fb_product_applink_ipad_url"
        static let appLinkIPadAppStoreID = "fb_product_applink_ipad_app_store_id"
        static let appLinkIPadAppName = "fb_product_applink_ipad_app_name"
        static let appLinkAndroidUrl = "fb_product_applink_android_url"
        static let appLinkAndroidPackage = "fb_product_applink_android_package"
        static let appLinkAndroidAppName = "fb_product_applink_android_app_name"
        static let appLinkWindowsPhoneUrl = "fb_product_applink_windows_phone_url"
        static let appLinkWindowsPhoneAppID = "fb_product_applink_windows_phone_app_id"
        static let appLinkWindowsPhoneAppName = "fb_product_applink_windows_phone_app_name"
    }
    
    enum Purchase {
        static let purchaseAmount = "fb_purchase_amount"
        static let purchaseCurrency = "fb_purchase_currency"
        static let purchaseParameters = "fb_purchase_parameters" // Custom purchase parameters object
        static let purchase = "purchase" // Purchase object
    }
    
    enum Push {
        static let pushAction = "fb_push_action"
        static let pushPayload = "fb_push_payload"
        static let push = "push" // Push object (userInfo)
    }
    
    enum Settings {
        static let autoLogEventsEnabled = "auto_log_events_enabled"
        static let autoInitEnabled = "auto_init_enabled"
        static let advertiserIDCollectionEnabled = "advertiser_id_collection_enabled"
    }
    
    enum User {
        static let user = "user" // userData object
        static let userParameter = "fb_user_key"
        static let userParameterValue = "fb_user_value"
        static let userId = "fb_user_id"
    }
    
}

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
