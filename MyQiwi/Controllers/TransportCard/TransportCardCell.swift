//
//  TransportCardSelectCell.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 02/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class TransportCardCell: UIBaseTableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnCharge: UIButton!
    @IBOutlet weak var btSaldo: UIButton!
    @IBOutlet weak var btExtrato: UIButton!
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var lbName: UILabel?
    
    @IBOutlet weak var viewUrbsBtns: UIView!
    // MARK: Variables
    
    var item: TransportCard! {
        didSet {
            if item.type == ActionFinder.Transport.CardType.BILHETE_UNICO || item.type == 0 {
                self.imgLogo.image = UIImage(named: "100058")
                self.viewUrbsBtns.isHidden = true
            }
            else if item.type == ActionFinder.Transport.CardType.NOSSO {
                self.imgLogo.image = UIImage(named: "logo_nosso")
                self.viewUrbsBtns.isHidden = true
            }
            else if item.type == ActionFinder.Transport.CardType.BEM_LEGAL {
                self.imgLogo.image = UIImage(named: "menu_produto_bem_legal_maceio")
                self.viewUrbsBtns.isHidden = true
            }
            else if item.type == ActionFinder.Transport.CardType.SAO_VICENTE {
                self.imgLogo.image = UIImage(named: "menu_produto_sao_vicente")
                self.viewUrbsBtns.isHidden = true
            }
            else if item.type == ActionFinder.Transport.CardType.SAO_SEBASTIAO {
                self.imgLogo.image = UIImage(named: "menu_produto_sao_sebastiao")
                self.viewUrbsBtns.isHidden = true
            }
            else if item.type == ActionFinder.Transport.CardType.SAO_CARLOS {
                self.imgLogo.image = UIImage(named: "menu_produto_sao_carlos")
                self.viewUrbsBtns.isHidden = true
            }
            else if item.type == ActionFinder.Transport.CardType.SANTANA_PARNAIBA {
                self.imgLogo.image = UIImage(named: "menu_produto_santana_de_parnaiba")
                self.viewUrbsBtns.isHidden = true
            }
            else if item.type == ActionFinder.Transport.CardType.OSASCO {
                self.imgLogo.image = UIImage(named: "menu_produto_osasco")
                self.viewUrbsBtns.isHidden = true
            }
            else if item.type == ActionFinder.Transport.CardType.FRANCO_ROCHA {
                self.imgLogo.image = UIImage(named: "menu_produto_franco_da_rocha")
                self.viewUrbsBtns.isHidden = true
            }
            else if item.type == ActionFinder.Transport.CardType.CAJAMAR {
                self.imgLogo.image = UIImage(named: "menu_produto_cajamar")
                self.viewUrbsBtns.isHidden = true
            }
            else if item.type == ActionFinder.Transport.CardType.RIO_CLARO {
                self.imgLogo.image = UIImage(named: "menu_produto_rio_claro")
                self.viewUrbsBtns.isHidden = true
            }
            else if item.type == ActionFinder.Transport.CardType.CAIEIRAS {
                self.imgLogo.image = UIImage(named: "menu_produto_caieiras")
                self.viewUrbsBtns.isHidden = true
            }
            else if item.type == ActionFinder.Transport.CardType.ARARAQUARA {
                self.imgLogo.image = UIImage(named: "menu_araraquara")
                self.viewUrbsBtns.isHidden = true
            }
            else if item.type == ActionFinder.Transport.CardType.PRESIDENTE_PRUDENTE {
                self.imgLogo.image = UIImage(named: "menu_produto_presidente_prudente")
                self.viewUrbsBtns.isHidden = true
            }
            else if item.type == ActionFinder.Transport.CardType.RAPIDO_TAUBATE {
                self.imgLogo.image = UIImage(named: "menu_produto_rapido")
                self.viewUrbsBtns.isHidden = true
            }
            else if item.type == ActionFinder.Transport.CardType.URBS {
                self.imgLogo.image = UIImage(named: "logo_urbs")
                self.viewUrbsBtns.isHidden = false
            }
            else if item.type == ActionFinder.Transport.CardType.METROCARD {
                self.imgLogo.image = UIImage(named: "logo_metrocard")
                self.viewUrbsBtns.isHidden = true
            }
            
            self.lbName?.text = item.name
            self.lbNumber.text = "\(item.number)"
            self.prepareCell()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Resetar style
        Theme.default.greenButton(self.btnCharge)
    }
    
    // MARK: Custom fuction
    
    func redimensionCell() {
        if viewUrbsBtns.isHidden {
            self.contentView.height(60)
        } else {
            self.contentView.height(90)
        }
    }
    
    func prepareCell() {
        redimensionCell()
        Theme.default.greenButton(self.btnCharge)
        
        if item.name.isEmpty {
            self.lbNumber.setupTitleMedium()
            return
        }
        
        self.lbNumber.setupMessageNormal()
        self.lbName?.setupTitleMedium()
    }
}
