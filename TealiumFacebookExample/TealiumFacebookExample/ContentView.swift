//
//  ContentView.swift
//  TealiumFacebookExample
//
//  Created by Christina on 10/23/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var profile: Profile
    var product: Product
    var purchase: Purchase
    var body: some View {
        ScrollView {
            VStack {
               TitleView()
                VStack(spacing: 20) {
                    ButtonView(event: "Set User", profile.user.dictionary)
                    ButtonView(event: "Set User Id", ["customer_id": profile.customerId])
                    ButtonView(event: "Update User Value", ["customer_update_key": "customer_last_name", "customer_update_value": "Smith"])
                    ButtonView(event: "Achieve Level", ["level": profile.level])
                    ButtonView(event: "Completed Registration", ["registration_method": profile.registrationMethod])
                    ButtonView(event: "Add To Cart", ["product_id": [product.id], "product_price": [product.price]])
                    ButtonView(event: "Log Product Item", product.dictionary)
                    ButtonView(event: "Log Purchase", purchase.dictionary)
                    ButtonView(event: "Flush")
                }
                Spacer()
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            ContentView(profile: Profile.default, product: Product.default, purchase: Purchase.default)
               .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
               .previewDisplayName("iPhone 8")
            
           ContentView(profile: Profile.default, product: Product.default, purchase: Purchase.default)
               .previewDevice(PreviewDevice(rawValue: "iPhone X"))
               .previewDisplayName("iPhone X")

           ContentView(profile: Profile.default, product: Product.default, purchase: Purchase.default)
              .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
              .previewDisplayName("iPhone XS Max")
            
            ContentView(profile: Profile.default, product: Product.default, purchase: Purchase.default)
               .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (1st generation)"))
               .previewDisplayName("iPad Pro (11-inch)")
            
            ContentView(profile: Profile.default, product: Product.default, purchase: Purchase.default)
               .previewDevice(PreviewDevice(rawValue: "iPhone SE (1st generation)"))
               .previewDisplayName("iPhone SE (1st generation)")
            
            ContentView(profile: Profile.default, product: Product.default, purchase: Purchase.default)
               .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
               .previewDisplayName("iPhone SE (2nd generation)")
        }
    }
}


#endif
