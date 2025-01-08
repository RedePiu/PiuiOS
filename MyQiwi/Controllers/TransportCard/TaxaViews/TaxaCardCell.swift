//
//  TaxaCardCell.swift
//  MyQiwi
//
//  Created by Daniel Catini on 09/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import UIKit

class TaxaCardCell: UITableViewCell {
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnCharge: UIButton!
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var lbName: UILabel!
    
    var item: TaxaCardResponse! {
        
        didSet {
            self.displayContent(item: item)
        }
    }
    
    func displayContent(item: TaxaCardResponse) {
        switch QiwiOrder.selectedMenu.prvID {
        case ActionFinder.Transport.Prodata.Caieiras.COMUM, 
             ActionFinder.Transport.Prodata.Caieiras.ESCOLAR:
            imgLogo?.image = UIImage(named: "100505")
        case ActionFinder.Transport.Prodata.Cajamar.COMUM, 
             ActionFinder.Transport.Prodata.Cajamar.ESCOLAR:
            imgLogo?.image = UIImage(named: "100540")
        case ActionFinder.Transport.Prodata.FrancodaRocha.COMUM, 
             ActionFinder.Transport.Prodata.FrancodaRocha.ESCOLAR:
            imgLogo?.image = UIImage(named: "100530")
        case ActionFinder.Transport.Prodata.Osasco.COMUM, 
             ActionFinder.Transport.Prodata.Osasco.ESCOLAR:
            imgLogo?.image = UIImage(named: "100525")
        case ActionFinder.Transport.Prodata.SantanadeParnaiba.COMUM, 
             ActionFinder.Transport.Prodata.SantanadeParnaiba.ESCOLAR:
            imgLogo?.image = UIImage(named: "100535")
        default: break
        }
        lbName?.text = item.cliente
        lbNumber?.text = "\(item.tipo?.Nome ?? "") - \(item.cartao)"
        btnCharge.setText("escolher")
        print(item.cartao)
        print(item.cliente)
        
        self.prepareCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Resetar style
        Theme.default.greenButton(self.btnCharge ?? UIButton())
    }
    
    // MARK: Custom fuction
    
    func redimensionCell() {
        self.contentView.height(90)
    }
    
    func prepareCell() {
        
        redimensionCell()
        
        Theme.default.greenButton(self.btnCharge ?? UIButton())
        
        if item.cliente.isEmpty {
            self.lbNumber?.setupTitleMedium()
            return
        }
        
        self.lbNumber?.setupMessageNormal()
        self.lbName?.setupTitleMedium()
    }
    
}
