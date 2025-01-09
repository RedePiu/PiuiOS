//
//  Sequence_Extensions.swift
//  MyQiwi
//
//  Created by Thiago Silva on 08/01/25.
//  Copyright © 2025 Qiwi. All rights reserved.
//

import Foundation

extension Sequence where Element: Hashable {
    func unique(from array: [Element]) -> [Element] {
        var set = Set<Element>()
        
        let result = array.filter {
            guard !set.contains($0) else {
                return false
            }
            set.insert($0)
            return true
        }
        
        return result
    }
}
