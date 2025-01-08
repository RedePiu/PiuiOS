//
//  SeatCollectionViewCell.swift
//  MyQiwi
//
//  Created by Thyago on 19/08/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class SeatCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgSeat: UIImageView!
    @IBOutlet weak var lbNumber: UILabel!
    
    var item : Seat! {
        
        didSet {
            
            self.lbNumber.text = item.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func prepareCell() {
        
        self.imgSeat.image = UIImage(named: "ic_seat")!.withRenderingMode(.alwaysTemplate)
        self.imgSeat.tintColor = UIColor(hexString: Constants.Colors.Hex.colorButtonRed)
    }
}
