//
//  DeleteItemBody.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class DeleteItemBody: BasePojo {

    @objc dynamic var pkId : Int = 0

    required convenience init?(map: Map) {
        self.init()
    }

    override func mapping(map: Map) {
        pkId <- map["pkdado"]
    }

    convenience init(pkId: Int) {
        self.init()
        self.pkId = pkId
    }
}
