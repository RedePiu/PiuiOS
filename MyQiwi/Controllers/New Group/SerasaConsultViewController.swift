//
//  SerasaConsultViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 12/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class SerasaConsultViewController: UIBaseViewController {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var lbValue: UILabel!
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        self.setupTableView()
    }
}

extension SerasaConsultViewController: BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
    }
}

// MARK: TabBar Delegate
extension SerasaConsultViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if UserRN.hasLoggedUser() {
            //mUserRN?.getUserInfo()
            Util.showWarningController(self)
        }
    }
}

//MARK: Actions
extension SerasaConsultViewController {
    
    @IBAction func nextStepConsult(_ sender: Any?) {
        
        if QiwiOrder.isCPFConsult() {
            self.performSegue(withIdentifier: Constants.Segues.CHOOSE_CPF, sender: nil)
        } else {
            Util.showAlertYesNo(
                self,
                message: "credit_analysis_validate_cpf_msg".localized.replacingOccurrences(of: "{cpf}", with: UserRN.getLoggedUser().cpf),
                completionOK: {
                    GenericDataInputViewController.inputType = .CNPJ
                    self.performSegue(withIdentifier: Constants.Segues.GENERIC_INPUT, sender: nil)
            },
                completionCancel: {
                    GenericDataInputViewController.inputType = .CPF
                    self.performSegue(withIdentifier: Constants.Segues.GENERIC_INPUT, sender: nil)
            })
        }
    }
}

extension SerasaConsultViewController: SetupUI {
    
    func setupTableView(){
        
    }
    
    func setupUI(){
        Theme.default.backgroundCard(self)
        Theme.default.orageButton(self.btnBack)
        Theme.default.greenButton(self.btnContinue)
    }
    
    func setupTexts() {
        self.btnBack.setTitle("back".localized, for: .normal)
        self.btnContinue.setTitle("continue_label".localized, for: .normal)
    
        Theme.default.textAsListTitle(self.lbTitle)
        Util.setTextBarIn(self, title: QiwiOrder.productName)
        
        let serasaValue = SerasaRN(delegate: self).getSerasaValue(prvId: QiwiOrder.getPrvID())
        lbValue.text = Util.formatCoin(value: serasaValue.maxValue)
        
        QiwiOrder.setTransitionAndValue(value: serasaValue.maxValue)
    }
}
