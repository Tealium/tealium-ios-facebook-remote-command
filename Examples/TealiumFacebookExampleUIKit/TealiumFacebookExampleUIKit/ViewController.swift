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
        TealiumHelper.trackEvent(title: "set_user", data: nil)
    }
    
    @IBAction func updateUserTapped(_ sender: UIButton) {
        TealiumHelper.trackEvent(title: "update_user_value", data: nil)
    }
    
    @IBAction func achieveLevel(_ sender: UIButton) {
        TealiumHelper.trackEvent(title: "achieve_level", data: nil)
    }
    
    @IBAction func logProductItem(_ sender: UIButton) {
        TealiumHelper.trackEvent(title: "log_product_item", data: nil)
    }
    
    @IBAction func logPurchase(_ sender: UIButton) {
        TealiumHelper.trackEvent(title: "log_product_item", data: nil)
    }
    
    @IBAction func flush(_ sender: UIButton) {
        TealiumHelper.trackEvent(title: "flush", data: nil)
    }

}

