//
//  ButtonView.swift
//  TealiumFacebookExample
//
//  Created by Christina on 10/23/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import SwiftUI

struct ButtonView: View {
    var title: String
    var data: [String: Any]?
    
    init(event title: String,
         _ data: [String: Any]? = nil) {
        self.title = title
        guard let data = data else { return }
        self.data = data
    }
    
    var body: some View {
        Button(action: {
            let eventName = self.title.lowercased().replacingOccurrences(of: " ", with: "")
            TealiumHelper.trackEvent(title: eventName,
                                     data: self.data)
        }) {
           Text(title)
               .frame(width: 200.0)
               .padding()
               .background(Color.gray)
               .foregroundColor(.white)
               .cornerRadius(10)
               .shadow(radius: 8)
               .overlay(
                   RoundedRectangle(cornerRadius: 10)
                       .stroke(Color.purple, lineWidth: 2)
               )
               
       }
    }
}

#if DEBUG
struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(event: "Test")
    }
}
#endif
