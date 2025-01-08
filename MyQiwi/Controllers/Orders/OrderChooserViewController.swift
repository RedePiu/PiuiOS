//
//  OrderChooserViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 10/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class OrderChooserViewController : UIBaseViewController {
    
    override func setupViewWillAppear() {
        
//        if ApplicationRN.isQiwiBrasil() {
//            performSegue(withIdentifier: Constants.Segues.ORDERS, sender: nil)
//            return
//        }
//        
//
        //let ordersVC = OrdersProViewController()
        
        //self.show(ordersVC, sender: nil)
        
        performSegue(withIdentifier: Constants.Segues.ORDERS, sender: nil)
    }
}
