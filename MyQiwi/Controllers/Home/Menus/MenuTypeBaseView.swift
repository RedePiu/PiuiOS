//
//  MenuTypeBaseView.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 04/07/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class MenuTypeBaseView : LoadBaseView {
    
    var delegate : BaseDelegate?
    var menus: [MenuItem]?
    
    func setupMenus(menus: [MenuItem]) {
        self.menus = menus
    }
    
    func sendContact(position: Int) {
        self.delegate?.onReceiveData(fromClass: MenuTypeBaseView.self, param: Param.Contact.MENU_CLICK, result: true, object: self.menus![position-1] as AnyObject)
    }
}
