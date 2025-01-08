//
//  Result.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 04/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

enum Result<T> {
    
    case error(Error)
    case sucess(T)
}
