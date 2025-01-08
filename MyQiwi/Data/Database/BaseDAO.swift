//
//  BaseDAO.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 13/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

protocol BaseDAO {

    associatedtype T

    func getAll() -> [T]
    func update(with object: T)
    func insert(with object: T)
    func insert(with object: [T])
    func delete(with object: T)
    func delete(with object: [T])
}
