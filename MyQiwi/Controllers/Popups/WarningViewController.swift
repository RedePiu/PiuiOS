//
//  WarningViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 29/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class WarningViewController: UIBaseViewController {

    // MARK: Outlets

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnClose: UIButton!

    // MARK: Variables

    var mActionId: Int = 0
    var mCanClose: Bool = false
    var delegate: BaseDelegate?

    // MARK: Constants

    static let ACTION_RESTART = 1
    static let ACTION_LOGOUT = 2
    static let ACTION_CLOSE = 3
    static let ACTION_SEND_DOCS = 4

    // MARK: Init

    init() {
        super.init(nibName: "WarningViewController", bundle: Bundle.main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Ciclo de vida

    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
    }

    override func setupViewWillAppear() {

        self.btnClose.isHidden = mCanClose
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: IBActions
extension WarningViewController {

    @IBAction func clickContinue(sender: UIButton) {
        self.onHandler()
    }

    @IBAction func clickClose(sender: UIButton) {
        self.dismissPage(sender)
    }
}

// MARK: Custom methods

extension WarningViewController {

    func onHandler() {

        if mActionId == WarningViewController.ACTION_CLOSE {
            // Fechar o app ?
            // Verificar o que sera apresentado
            return
        }

        if mActionId == WarningViewController.ACTION_SEND_DOCS {
            startDocumentValidationActivity()
            return
        }

        if mActionId == WarningViewController.ACTION_LOGOUT {
            UserRN.clearLoggedUser()
        }

        // Restart App
        backToMainScreen(self)
    }

    func startDocumentValidationActivity() {
        // DocumentValidationViewController
    }
}

// MARK: Custom
extension WarningViewController {

    func getLogoutIntent() {

        imgAvatar.image = UIImage(named: "ic_father")
        lbTitle.text = "logout_title".localized
        lbDesc.text = "logout_desc".localized
        btnContinue.setTitle("logout_button".localized, for: .normal)
        btnClose.isHidden = true
        mActionId = WarningViewController.ACTION_LOGOUT
    }

    func getSeqOrSignErrorIntent() {

        imgAvatar.image = UIImage(named: "ic_robot")
        lbTitle.text = "auth_title".localized
        lbDesc.text = "auth_desc".localized
        btnContinue.setTitle("auth_button".localized, for: .normal)
        mActionId = WarningViewController.ACTION_RESTART
    }

    func getCETErrorIntent() {

        imgAvatar.image = UIImage(named: "ic_robot")
        lbTitle.text = "cet_error_title".localized
        lbDesc.text = "cet_error_desc".localized
        btnContinue.setTitle("cet_error_button".localized, for: .normal)
        mActionId = WarningViewController.ACTION_CLOSE
    }
}

// MARK: SetupUI

extension WarningViewController: SetupUI {

    func setupUI() {
        Theme.default.greenButton(self.btnContinue)
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.textAsMessage(self.lbDesc)
        Theme.default.redButton(self.btnClose)
    }

    func setupTexts() {
        self.btnContinue.setTitle("logout_button".localized, for: .normal)
        self.lbTitle.text = "logout_title".localized
        self.lbDesc.text = "logout_desc".localized
    }
}
