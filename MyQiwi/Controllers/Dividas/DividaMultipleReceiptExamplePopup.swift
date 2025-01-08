//
//  DividaMultipleReceiptExamplePopup.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 22/09/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class DividaMultipleReceiptExamplePopup: UIBaseViewController {
    
    // MARK: Init
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var imgReceipt1: UIImageView!
    @IBOutlet weak var imgReceipt2: UIImageView!
    @IBOutlet weak var lbReceipt1: UILabel!
    @IBOutlet weak var lbReceipt2: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    var bankId = 0
    var isCaixaEletronico = false
    
    init() {
        super.init(nibName: "DividaMultipleReceiptExamplePopup", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onClickImage1(tapGestureRecognizer:)))
        imgReceipt1.isUserInteractionEnabled = true
        imgReceipt1.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(onClickImage2(tapGestureRecognizer:)))
        imgReceipt2.isUserInteractionEnabled = true
        imgReceipt2.addGestureRecognizer(tapGestureRecognizer2)
    }
    
    override func setupViewWillAppear() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: Custom methods

extension DividaMultipleReceiptExamplePopup {
    
    @objc func onClickImage1(tapGestureRecognizer: UITapGestureRecognizer)
    {
        startExampleScreen(0)
    }
    
    @objc func onClickImage2(tapGestureRecognizer: UITapGestureRecognizer)
    {
        startExampleScreen(1)
    }
    
    func startExampleScreen(_ imagePos: Int) {
        DispatchQueue.main.async {
            Util.showController(DepositoExampleViewController.self, sender: self, completion: { vc in
                vc.bankId = self.bankId
                vc.isCaixaEletronico = self.isCaixaEletronico
                vc.imagePos = imagePos
                vc.setInputNames()
            })
        }
    }
}

// MARK: SetupUI

extension DividaMultipleReceiptExamplePopup: SetupUI {
    
    func setupUI() {
        Theme.default.textAsListTitle(self.lbTitle)
        
        Theme.default.blueButton(self.btnClose)
    }
    
    func setupTexts() {
        self.btnClose.setTitle("close".localized, for: .normal)
        self.lbTitle.text = "dividas_multiple_example_title".localized
        self.lbDesc.text = "dividas_multiple_example_desc".localized
    }
    
    func setImages() {
        
        var image1: UIImage
        var image2: UIImage
        var title1 = "Terminal"
        var title2 = "Maquina"
        
        if self.bankId == ActionFinder.Bank.ITAU {
            image1 = UIImage(named: self.isCaixaEletronico ? "img_itau_ce" : "img_itau_bc")!
            image2 = UIImage(named: self.isCaixaEletronico ? "img_itau_ce" : "img_itau_bc")!
        }
        
        else { //if self.bankId == ActionFinder.Bank.BRADESCO {
            
            image1 = UIImage(named: self.isCaixaEletronico ? "img_bradesco_ce" : "img_itau_bc")!
            image2 = UIImage(named: self.isCaixaEletronico ? "img_bradesco_ce" : "img_itau_bc")!
        }
        
        self.imgReceipt1.image = image1
        self.imgReceipt2.image = image2
        self.lbReceipt1.text = title1
        self.lbReceipt2.text = title2
    }
}


