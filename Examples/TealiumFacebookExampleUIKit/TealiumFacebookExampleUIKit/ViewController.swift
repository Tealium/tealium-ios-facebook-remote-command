//
//  ViewController.swift
//  TealiumFacebookExampleUIKit
//
//  Created by Christina on 10/24/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TealiumFacebookExample"
        addRightNavigationBarInfoButton()
    }
    
    func addRightNavigationBarInfoButton() {
        let infoButton = UIButton(type: .infoDark)
        infoButton.addTarget(self, action: #selector(self.showInfoScreen), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
    }

    @objc func showInfoScreen() {
        let alertController = UIAlertController(title: "Tealium Facebook \(tealiumFacebookVersion)",
            message: "Tealium Swift \(tealiumLibraryVersion)",
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    @IBAction func setUserTapped(_ sender: UIButton) {
        TealiumHelper.trackEvent(title: "setUser", data: ["customer_id": "CUST123"])
    }
    
    @IBAction func updateUserTapped(_ sender: UIButton) {
        TealiumHelper.trackEvent(title: "updateUserValue", data: ["customer_name": "John Doe"])
    }
    
    @IBAction func achieveLevel(_ sender: UIButton) {
        TealiumHelper.trackEvent(title: "achievedLevel", data: ["level": "Level 5"])
    }
    
    @IBAction func completedRegistration(_ sender: UIButton) {
        TealiumHelper.trackEvent(title: "completedRegistration", data: ["registration_method": "Twitter"])
    }

    
    @IBAction func logProductItem(_ sender: UIButton) {
        let productItemData: [String: Any] = ["product_event_object":
            ["product_id": "abc12354",
             "product_availability": 1,
             "product_condition": 2,
             "product_description": "really cool",
             "product_image_url": "https://link.to.image",
             "product_url": "https://link.to.product",
             "product_name": "some cool product",
             "product_gtin": "ASDF235562SDFSDF",
             "product_brand": "awesome brand",
             "product_unit_price": 19.99,
             "product_currency": "USD",
             "product_parameters": ["productparameter1": "productparamvalue1",
                                    "productparameter2": "22.00"]]]
        TealiumHelper.trackEvent(title: "logProductItem", data: productItemData)
    }
    
    @IBAction func logPurchase(_ sender: UIButton) {
        let purchaseData: [String: Any] = ["purchase_object":
            ["order_total": 19.99,
             "order_currency": "USD",
             "purchase_parameters": ["purchaseparameter1": "purchaseparamvalue1",
                                     "purchaseparameter2": true]]]
        TealiumHelper.trackEvent(title: "logPurchase", data: purchaseData)
    }
    
    @IBAction func flush(_ sender: UIButton) {
        TealiumHelper.trackEvent(title: "flush", data: nil)
    }

}

