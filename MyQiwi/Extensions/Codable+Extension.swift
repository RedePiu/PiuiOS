//
//  Codable+Extension.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 06/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

extension Encodable {
    
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
