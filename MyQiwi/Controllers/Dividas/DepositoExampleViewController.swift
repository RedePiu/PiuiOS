//
//  DepositoExampleViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 17/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class DepositoExampleViewController : UIBaseViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var imgImage: UIImageView!
    var bankId = 0
    var isCaixaEletronico = false
    var imagePos = 0
    
    override func setupViewDidLoad() {
        //self.setupUI()
        self.setupTexts()
    }
    
    init() {
        super.init(nibName: "ReceiptExampleViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DepositoExampleViewController {
    
    func setInputNames() {
        var image: UIImage?
        
        switch self.bankId {
            case ActionFinder.Bank.ITAU:
                if imagePos == 0 {
                    image = UIImage(named: self.isCaixaEletronico ? "img_itau_ce" : "img_itau_bc")
                } else {
                    image = UIImage(named: self.isCaixaEletronico ? "img_itau_ce2" : "img_itau_bc")
                }
            break
            
            case ActionFinder.Bank.BRADESCO:
                if imagePos == 0 {
                    image = UIImage(named: self.isCaixaEletronico ? "img_bradesco_ce" : "img_bradesco_bc")
                } else {
                    image = UIImage(named: self.isCaixaEletronico ? "img_bradesco_ce2" : "img_bradesco_bc")
                }
                
            break
            
            case ActionFinder.Bank.SANTANDER:
                image = UIImage(named: "img_santander_ce")
            break
            
            case ActionFinder.Bank.BANCO_DO_BRASIL:
                image = UIImage(named: self.isCaixaEletronico ? "img_banco_brasil_ce" : "img_banco_brasil_bc")
            break
            
        default:
            image = UIImage(named: "img_santander_ce")
        }
        
        self.imgImage.image = image
    }
}

extension DepositoExampleViewController : SetupUI {
    func setupUI() {
        self.setInputNames()
    }
    
    func setupTexts() {
        self.navigationTitle.title = "dividas_deposito_example".localized
//        Util.setTextBarIn(self, title: "dividas_deposito_example".localized)
    }
}
