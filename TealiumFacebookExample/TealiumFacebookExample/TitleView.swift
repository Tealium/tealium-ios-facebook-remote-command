//
//  TitleView.swift
//  TealiumFacebookExample
//
//  Created by Christina on 10/23/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import SwiftUI

struct TitleView: View {
    @State var alertShown = false
    var versions: Alert {
        Alert(title: Text("Tealium Facebook \(tealiumFacebookVersion)"),
              message: Text("Tealium Swift \(tealiumLibraryVersion)"),
              dismissButton: Alert.Button.default(Text("Ok")))
    }
    var body: some View {
         HStack {
           Text("TealiumFacebookExample")
               .font(.title)
           Spacer()
           Button(action: {
            self.alertShown.toggle()
           }, label: {
               Image(systemName: "info.circle")
           }).alert(isPresented: $alertShown, content: { self.versions })
       }.padding()
    }
}

#if DEBUG
struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
#endif
