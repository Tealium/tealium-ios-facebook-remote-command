//
//  Facebook.swift
//  TealiumRemoteCommand
//
//  Created by Christina Sund on 5/21/19.
//  Copyright © 2019 Christina. All rights reserved.
//

import Foundation
import FBSDKCoreKit

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
        case completedregistration
        case viewedcontent
        case searched
        case rated
        case completedtutorial
        case addedtocart
        case addedtowishlist
        case initiatedcheckout
        case addedpaymentinfo
        case achievedlevel
        case unlockedachievement
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
    
    enum Commands {
        static let initialize = "initialize"
        static let setAutoLogAppEventsEnabled = "setautologappeventsenabled"
        static let setAutoInitEnabled = "setautoinitenabled"
        static let enableAdvertiserIDCollection = "enableadvertiseridcollection"
        static let logPurchase = "logpurchase"
        static let setUser = "setuser"
        static let setUserId = "setuserid"
        static let clearUser = "clearuser"
        static let clearUserId = "clearuserid"
        static let updateUserValue = "updateuservalue"
        static let logProductItem = "logproductitem"
        static let setFlushBehavior = "setflushbehavior"
        static let flush = "flush"
        static let achievedLevel = "achievedlevel"
        static let unlockedAchievement = "unlockedachievement"
        static let completedRegistration = "completedregistration"
        static let completedTutorial = "completedtutorial"
        static let initiatedCheckout = "initiatedcheckout"
        static let searched = "searched"
        static let activatedApp = "activatedapp"
        static let deactivatedApp = "deactivatedapp"
        static let sessionInterruptions = "sessioninterruptions"
        static let timebetweensessions = "timebetweensessions"
        static let adClicked = "adclicked"
        static let adImpression = "adimpression"
        static let addedPaymentinfo = "addedpaymentinfo"
        static let addedToCart = "addedtocart"
        static let addedToWishlist = "addedtowishlist"
        static let contact = "contact"
        static let viewedContent = "viewedcontent"
        static let rated = "rated"
        static let customizeProduct = "customizeproduct"
        static let donate = "donate"
        static let findLocation = "findlocation"
        static let schedule = "schedule"
        static let startTrial = "starttrial"
        static let submitApplication = "submitapplication"
        static let subscribe = "subscribe"
        static let purchased = "purchased"
        static let spentCredits = "spentcredits"
        static let liveStreamingStart = "livestreamingstart"
        static let liveStreamingStop = "livestreamingstop"
        static let liveStreamingPause = "livestreamingpause"
        static let liveStreamingResume = "livestreamingresume"
        static let liveStreamingError = "livestreamingerror"
        static let liveStreamingUpdateStatus = "livestreamingupdatestatus"
        static let productCatalogUpdate = "productcatalogupdate"
    }
    
    enum Error {
        static let prepend = "[❗️] TealiumFacebook Remote Command Error: "
    }
    
    enum Event {
        static let eventParameters = "event"
        static let valueToSum = "fb_value_to_sum"
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
        static let productPrice = "fb_product_price_amount"
        static let productCurrency = "fb_product_price_currency"
        static let productParameters = "fb_product_parameters"
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
        static let purchaseParameters = "fb_purchase_parameters"
        static let purchase = "purchase"
    }
    
    enum Push {
        static let pushAction = "fb_push_action"
        static let pushPayload = "fb_push_payload"
        static let push = "push"
    }
    
    enum Settings {
        static let autoLogEventsEnabled = "auto_log_events_enabled"
        static let autoInitEnabled = "auto_init_enabled"
        static let advertiserIDCollectionEnabled = "advertiser_id_collection_enabled"
    }
    
    enum User {
        static let user = "user" // userData object
        static let userParameter = "fb_user_value"
        static let userParameterValue = "fb_user_key"
        static let userId = "fb_user_id"
    }
    
}


