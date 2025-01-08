//
//  BaseDataHandler.swift
//  MyQiwi
//
//  Created by ailton on 01/01/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import Foundation

public class BaseDataHandler<T> {
    
    var arrItems = [T]()
    var isLoading = false
    
    public func numberOfItemsInSection() -> Int {
        return arrItems.count
    }
    
    public func cellForItemAtIndexPath(_ index: Int) -> T {
        return arrItems[index]
    }
}
