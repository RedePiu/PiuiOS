//
//  BillDetailsViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 22/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class BillDetailsViewController: UIBaseViewController {

    // MARK: Outlets

    @IBOutlet weak var lbLabelTitleValue: UILabel!
    @IBOutlet weak var imgHelpIcon: UIImageView!
    @IBOutlet weak var txtBillValue: MaterialField!
    @IBOutlet weak var lbMessageValue: UILabel!
    @IBOutlet weak var btnConfirmValue: UIButton!
    @IBOutlet weak var lbLabelTitleDueDate: UILabel!
    @IBOutlet weak var lbLabelValue: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbLabelDueDate: UILabel!
    @IBOutlet weak var lbDueDate: UILabel!
    @IBOutlet weak var txtDueDate: MaterialField!
    @IBOutlet weak var viewWarning: UICardInfoView!
    
    // Views
    @IBOutlet weak var viewCardValue: UIView!
    @IBOutlet weak var viewCardDueDate: UIView!
    @IBOutlet weak var viewCardContinue: ViewContinue!

    // MARK: Variables
    var price: Int = 0
    var dueDate: String = ""

    var stepBilPayment = Constants.StepBillPayment.VALUE

    // MARK: Ciclo de vida

    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupTextFields()
        self.touchLabelDueDate()
    }

    override func setupViewWillAppear() {
        self.hideAll()

        if self.price != 0 {
            self.lbPrice.text = Util.formatCoin(value: self.price)

            self.requestBillInfo()
        } else {
            self.changeLayout()
        }
    }
}

// MARK: IBActions
extension BillDetailsViewController {

    @IBAction func clickConfirmValue(sender: UIButton) {

        if let textPrice = self.txtBillValue.text {

            self.view.endEditing(true)

            // Valor vazio não passa o proximo step
            if textPrice.isEmpty {
                Util.showAlertDefaultOK(self, message: "bill_input_value_error".localized)
                return
            }

            // Aplicar o valor inserido
            self.lbPrice.text = textPrice

            let test = textPrice.removeAllCaractersExceptNumbers().removeAllOtherCaracters()

            self.price = Int(test) ?? 0

            //self.price = Int(textPrice.substring(2).removeAllOtherCaracters())!



            // Troca os cards
            self.requestBillInfo()
        }


    }

    @IBAction func clickContinue(sender: UIButton) {

        //
        self.txtBillValue.resignFirstResponder()

        if let dueDate = self.txtDueDate.text {

            // Sem vencimento
            if self.txtDueDate.isHidden && dueDate.isEmpty {
                Util.showAlertDefaultOK(self, message: "bill_due_date_validation_incorrent".localized)
                return
            }

//            if !Util.validateBirthday(dueDate) {
//                Util.showAlertDefaultOK(self, message: "bill_due_date_invalid".localized)
//                return
//            }
        }

        //

        QiwiOrder.setTransitionAndValue(value: self.price)
        ListGenericViewController.stepListGeneric = .SELECT_PAYMENT
        performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
    }

    @IBAction func clickBack(sender: UIButton) {

        self.controlStep(number: -1)
    }
}

// MARK: SetupUI
extension BillDetailsViewController: SetupUI {

    func setupUI() {

        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lbLabelTitleValue)
        Theme.default.textAsListTitle(self.lbLabelTitleDueDate)

        Theme.default.greenButton(self.btnConfirmValue)

        self.lbMessageValue.setupMessageMedium()

        self.lbLabelValue.font = FontCustom.helveticaRegular.font(16)
        self.lbLabelValue.textColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiDark)
        self.lbLabelValue.adjustsFontForContentSizeCategory = true

        self.lbLabelDueDate.font = FontCustom.helveticaRegular.font(16)
        self.lbLabelDueDate.textColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiDark)
        self.lbLabelDueDate.adjustsFontForContentSizeCategory = true

        self.lbPrice.setupTitleBold()
        self.lbDueDate.setupTitleBold()

        self.imgHelpIcon.image = UIImage(named: "ic_shopping")!.withRenderingMode(.alwaysTemplate)
        self.imgHelpIcon.tintColor = UIColor(hexString: Constants.Colors.Hex.colorPrimary)

        self.setupViewContinue()
    }

    func setupTexts() {

        self.btnConfirmValue.setTitle("confirm".localized, for: .normal)
        self.lbMessageValue.text = "bill_confirm_bill_value_desc".localized
        self.lbLabelTitleValue.text = "bill_confirm_bill_value".localized
        self.lbLabelTitleDueDate.text = "bill_confirm_detail".localized
        self.lbLabelValue.text = "bill_price".localized
        self.lbLabelDueDate.text = "bill_due_date".localized
        self.txtDueDate.placeholder = "bill_due_date_hint".localized
        self.txtBillValue.placeholder = "select_value_hint_add_value".localized
        Util.setTextBarIn(self, title: "bill_barcode_title_nav".localized)
    }

    func setupViewContinue() {

        // Texto
        self.viewCardContinue.btnContinue.setTitle("continue_label".localized, for: .normal)

        // Ações
        self.viewCardContinue.btnContinue.addTarget(self, action: #selector(clickContinue(sender:)), for: .touchUpInside)
        self.viewCardContinue.btnBack.addTarget(self, action: #selector(clickBack(sender:)), for: .touchUpInside)
    }

    func setupTextFields() {

        self.txtDueDate.formatPattern = Constants.FormatPattern.Default.BIRTHDAY.rawValue

        self.txtBillValue.addTarget(self, action: #selector(formatCurrency(_:)), for: .editingChanged)
        self.txtDueDate.addTarget(self, action: #selector(fillDueDate(_:)), for: .editingChanged)
    }

    func setupWarningview() {
        let warningText = PaymentRN(delegate: nil).getUnavailablePayments(prvid: QiwiOrder.getPrvID(), value: self.price)

        self.viewWarning.lbTitle.text = "alert".localized
        self.viewWarning.lbDesc.text = warningText
        self.viewWarning.imgIcon.setImage(named: "ic_alert")
        self.viewWarning.btn.isHidden = true

        self.viewWarning.isHidden = warningText == "payment_limit_can_not_use".localized
    }

    func touchLabelDueDate() {

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showEditDueDate))
        self.lbDueDate.addGestureRecognizer(tapGesture)
        self.lbDueDate.isUserInteractionEnabled = true
    }
}

// MARK: Selectors

extension BillDetailsViewController {

    @objc func showEditDueDate() {

        // Ocultar label, e mostrar textfield
        self.lbDueDate.isHidden = true
        self.txtDueDate.superview?.isHidden = false

        // Animar as views
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func fillDueDate(_ textfield: UITextField) {

        // Validar data, quando completa, escode textfield e deixa label
        if let dueDate = textfield.text {

            // Vencimento invalido
            if dueDate.count != Constants.FormatPattern.Default.BIRTHDAY.rawValue.count {
                textfield.superview?.isHidden = false
                self.lbDueDate.isHidden = true
                return
            }

            // Vencimento vencido
//            if !Util.validateBirthday(dueDate) {
//                Util.showAlertDefaultOK(self, message: "bill_due_date_invalid".localized)
//                return
//            }

            // Vencimento incorreto
//            if !Util.validadeDueDate(dueDate) {
//                Util.showAlertDefaultOK(self, message: "bill_due_date_error".localized)
//                return
//            }

            // Vencimento completo
            textfield.resignFirstResponder()
            textfield.superview?.isHidden = true
            self.lbDueDate.isHidden = false
            self.lbDueDate.text = dueDate

            //Animar as views
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func formatCurrency(_ textfield: UITextField) {

        // Format o valor
        if let amountString = self.txtBillValue.text?.currencyInputFormatting() {
            textfield.text = amountString
        }
    }
}

extension BillDetailsViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            if param == Param.Contact.BILL_REQUEST_RESPONSE {

                //BillDetailsResponse
                let response = object as! ServiceResponse<BillDetailsResponse>
                
                //Se foi sucesso, pulamos para o passo de data de vencimento
                if result {
                    self.dismiss(animated: true, completion: nil)
                    QiwiOrder.checkoutBody.requestBill?.bankslip?.nsuHost = (response.body?.data!.nsuHost)!
                    QiwiOrder.checkoutBody.requestBill?.bankslip?.barcode = (response.body?.data!.trnData)!
                    self.stepBilPayment = .DUE_DATE
                    self.changeLayout()
                    return
                }

                let isNotLoggout = response.body?.cod != nil && response.body?.cod != ResponseCodes.USER_NOT_LOGGED

                if (response.body?.cod != ResponseCodes.USER_NOT_LOGGED) {
                    self.dismiss(animated: true, completion: nil)
                }

                let msg = isNotLoggout ? response.body?.showMessages() ?? "bill_request_error".localized : "bill_request_error".localized
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                    //Util.showAlertDefaultOK(self, message: msg)
                    Util.showAlertDefaultOK(self, message: msg, titleOK: "OK", completionOK: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            self.dismiss(animated: true, completion: nil)
                        })
                    })
                })
            }
        }
    }
}

// MARK: Control UI
extension BillDetailsViewController {

    func hideAll() {
        self.lbLabelTitleValue.isHidden = true
        self.viewCardValue.isHidden = true
        self.lbLabelTitleDueDate.isHidden = true
        self.viewCardDueDate.isHidden = true
        self.txtDueDate.superview?.isHidden = true
        self.viewCardContinue.isHidden = true
        self.viewWarning.isHidden = true
    }

    func controlStep(number: Int) {

        // Incrementar / Decrementar o passo
        let currentStep = self.stepBilPayment.rawValue + number
        if let newStep = Constants.StepBillPayment(rawValue: currentStep) {
            self.stepBilPayment = newStep
            self.changeLayout()
        }
    }

    func requestBillInfo() {
        Util.showLoading(self) {
            BillRN(delegate: self).requestBillDetails(barCode: (QiwiOrder.factoryFebraban?.getBoleto().getLinhaDigitavel())!, isScan: QiwiOrder.isScan, value: self.price)
        }
    }

    func changeLayout() {

        self.hideAll()

        switch self.stepBilPayment {
        case .VALUE:
            self.showStepPrice()
            break
        case .DUE_DATE:
            self.showStepDueDate()
            break
        }
    }

    func showStepPrice() {
        self.lbLabelTitleValue.isHidden = false
        self.viewCardValue.isHidden = false

        // Formatar/Aplicar dados
        self.txtBillValue.text = String(self.price).currencyInputFormatting()
    }

    func showStepDueDate() {
        self.lbLabelTitleDueDate.isHidden = false
        self.viewCardDueDate.isHidden = false
        self.viewCardContinue.isHidden = false

        setupWarningview()

        // Aplicar vencimento
        self.lbDueDate.text = self.dueDate.isEmpty ? self.lbDueDate.text : self.dueDate

        // Sem vencimento, liberar edição
        if self.lbDueDate.text?.isEmpty ?? true {

            self.lbDueDate.isHidden = true
            self.txtDueDate.superview?.isHidden = false
        }else {
            // Oculta edição e mostrar label de vencimento
            self.lbDueDate.isHidden = false
            self.txtDueDate.superview?.isHidden = true
        }
    }
}
