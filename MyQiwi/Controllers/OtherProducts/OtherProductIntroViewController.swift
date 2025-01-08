//
//  OtherProductIntroViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 03/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class OtherProductIntroViewController: UIBaseViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var heightTextView: NSLayoutConstraint!
    @IBOutlet weak var btnSeeMore: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    // MARK: Variables
    
    var isExpand = true
    var menuItem: MenuItem!

    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
    }
    
    override func setupViewWillAppear() {
        
        self.imgLogo.image = UIImage(named: Util.formatImagePath(path: self.menuItem.imageMenu ?? ""))
        
        var imagePath = Util.formatImagePath(path: self.menuItem.imageMenu ?? "")
        if imagePath.localized.count < 50 {
            imagePath = imagePath.localized
        }
        self.textView.text = imagePath.localized
        self.textView.tintColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiDark)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: IBActions
extension OtherProductIntroViewController {
    
    @IBAction func showMore(sender: UIButton) {
        
        Log.print(self.heightTextView.constant)
        Log.print(self.textView.contentSize)
        
        self.isExpand = !self.isExpand
        
        if self.isExpand {
            // Aumentar altura
            self.heightTextView.constant = self.textView.text.count >= 1600 ? 850 : 450
            self.btnSeeMore.setTitle("see_less".localized, for: .normal)
        }else {
            // Diminuir altura
            self.heightTextView.constant = 150
            self.btnSeeMore.setTitle("see_more".localized, for: .normal)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func clickContinue(sender: UIButton) {
        
        if QiwiOrder.isRvCharge() {
            let msg = "credit_analysis_validate_cpf_msg".localized
                .replacingOccurrences(of: "{cpf}", with: UserRN.getLoggedUser().cpf)
            
            Util.showAlertYesNo(
                self,
                message: msg,
                completionOK: {
                    //Se ele usar o proprio cpf, já vai para a tela de valores
                    QiwiOrder.checkoutBody.requestRv?.cdSubscriber = ""//cpf em branco é o uso proprio
                    ListGenericViewController.stepListGeneric = .SELECT_VALUE
                    self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
            },
                completionCancel: {
                    //Se não, devemos coletar o cpf dele
                    GenericDataInputViewController.inputType = .CPF
                    self.performSegue(withIdentifier: Constants.Segues.GENERIC_INPUT, sender: nil)
            })
            
            return
        }
        
        if QiwiOrder.isUltragaz() {
            self.performSegue(withIdentifier: Constants.Segues.ULTRAGAZ, sender: nil)
            return
        }
        
        if QiwiOrder.isTelesena() {
            self.performSegue(withIdentifier: Constants.Segues.TELESENA_VALUES, sender: nil)
            return
        }
        
        ListGenericViewController.stepListGeneric = .SELECT_VALUE
        self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
    }
    
    @IBAction func clickBack(sender: UIButton) {
        self.popPage(sender)
    }
}

// MARK: SetupUI
extension OtherProductIntroViewController: SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.orageButton(self.btnBack)
        Theme.default.greenButton(self.btnContinue)
        
        self.btnSeeMore.titleLabel?.font = FontCustom.helveticaBold.font(20)
    }
    
    func setupTexts() {
        self.btnSeeMore.setTitle("see_more".localized, for: .normal)
        Util.setTextBarIn(self, title: "app_name".localized)
    }
}
