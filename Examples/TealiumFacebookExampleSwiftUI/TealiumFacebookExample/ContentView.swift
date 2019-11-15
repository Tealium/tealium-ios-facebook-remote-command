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
        VStack {
           TitleView().padding(.bottom, 30)
            VStack(spacing: 30) {
                ButtonView(event: "Set User", ["customer_id": profile.customerId])
                ButtonView(event: "Update User Value", ["customer_name": profile.customerName])
                ButtonView(event: "Achieve Level", ["event_object": ["level": profile.level]])
                ButtonView(event: "Completed Registration", ["event_object": ["registration_method": profile.registrationMethod]])
                ButtonView(event: "Log Product Item", product.data)
                ButtonView(event: "Log Purchase", purchase.data)
                ButtonView(event: "Flush")
            }
            Spacer()
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
               .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
               .previewDisplayName("iPad Pro (11-inch)")
        }
    }
}


#endif
