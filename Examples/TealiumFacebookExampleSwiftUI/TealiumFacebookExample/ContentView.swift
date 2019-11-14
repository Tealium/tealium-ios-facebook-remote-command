//
//  ContentView.swift
//  TealiumFacebookExample
//
//  Created by Christina on 10/23/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
           TitleView().padding(.bottom, 30)
            VStack(spacing: 30) {
                ButtonView(event: "Set User")
                ButtonView(event: "Update User Value")
                ButtonView(event: "Achieve Level")
                ButtonView(event: "Completed Registration")
                ButtonView(event: "Log Product Item")
                ButtonView(event: "Log Purchase") 
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
            
           ContentView()
               .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
               .previewDisplayName("iPhone 8")
            
           ContentView()
               .previewDevice(PreviewDevice(rawValue: "iPhone X"))
               .previewDisplayName("iPhone X")

           ContentView()
              .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
              .previewDisplayName("iPhone XS Max")
            
            ContentView()
               .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
               .previewDisplayName("iPad Pro (11-inch)")
        }
    }
}


#endif
