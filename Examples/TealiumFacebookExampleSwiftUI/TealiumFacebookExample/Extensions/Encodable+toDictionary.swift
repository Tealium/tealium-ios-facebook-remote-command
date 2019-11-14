//
//  Encodable+toDictionary.swift
//  TealiumFacebookExample
//
//  Created by Christina S on 11/14/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
