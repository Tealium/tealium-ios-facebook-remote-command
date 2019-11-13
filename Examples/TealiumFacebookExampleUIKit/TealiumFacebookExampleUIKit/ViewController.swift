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
        let alertController = UIAlertController(title: "Tealium Facebook 0.0.1", message: "Tealium Swift 1.8.1", preferredStyle: .alert)
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
        TealiumHelper.trackEvent(title: "logProductItem", data: ["product_id": "abc123",
                                                                 "product_name": "chocolate",
                                                                 "product_price": 9.99])
    }
    
    @IBAction func logPurchase(_ sender: UIButton) {
        TealiumHelper.trackEvent(title: "logPurchase", data: ["purchase": ["product_id": "abc123",
                                                                            "product_name": "chocolate",
                                                                            "product_price": 9.99]])
    }
    
    @IBAction func flush(_ sender: UIButton) {
        TealiumHelper.trackEvent(title: "flush", data: nil)
    }

}

