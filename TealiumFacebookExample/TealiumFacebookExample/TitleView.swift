//
//  TitleView.swift
//  TealiumFacebookExample
//
//  Created by Christina on 10/23/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import SwiftUI
import TealiumSwift
import TealiumFacebook

extension Bundle {
    func versionString() -> String {
        guard let dictionary = self.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else {
            return "0.0"
        }
        return "\(version)"
    }
}

struct TitleView: View {
    @State var alertShown = false
    var versions: Alert {
        Alert(title: Text("Tealium Facebook \(Bundle(for: FacebookRemoteCommand.self).versionString())"),
            message: Text("Tealium Swift \(Bundle(for: Tealium.self).versionString())"),
            dismissButton: Alert.Button.default(Text("Ok")))
    }
    var body: some View {
        HStack {
            Text("TealiumFacebookExample")
                .font(.title)
                .scaledToFill()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
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
