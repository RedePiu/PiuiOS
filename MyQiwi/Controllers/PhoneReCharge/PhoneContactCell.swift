//
//  ContactTableViewCell.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 04/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class PhoneContactCell: UIBaseTableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var imgOperadora: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    
    
    // MARK: Variables
    
    // Object PhoneContat, Tag, Reference UIViewController, Action (Selector)
    var item: (PhoneContact, Int, UIViewController, Selector)! {
        
        didSet {
        
            if item.0.op == nil || (item.0.op?.isEmpty)! {
                self.imgOperadora.image = UIImage(named: "ic_no_picture")
            } else {
                
                //National
                if (item.0.op! != "0") {
                    self.imgOperadora.image = UIImage(named: Operator.getOperatorSampleName(operatorName: item.0.op!))
                }
                //International
                else {
                    self.imgOperadora.image = UIImage(named: "ic_earth_asia")
                }
            }
            
            self.lblName.text = item.0.name
            
            //National
            if (item.0.ddd) != "0" {
                self.lblNumber.text = "(\(item.0.ddd)) \(item.0.number)"
            }
            //International
            else {
                self.lblNumber.text = item.0.number
            }
            
            self.btnMore.tag = item.1
            self.btnMore.addTarget(item.2, action: item.3, for: .touchUpInside)
        }
    }
}
