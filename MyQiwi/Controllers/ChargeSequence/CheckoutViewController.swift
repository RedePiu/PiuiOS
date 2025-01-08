//
//  CheckoutViewController.swift
//  MyQiwi
//
//  Created by ailton on 28/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import UIKit

class CheckoutViewController: UIBaseViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var lblTitle: UILabel!
    
    // View Container
    @IBOutlet weak var viewOrder: UIView!
    @IBOutlet weak var viewContinue: ViewContinue!
    @IBOutlet weak var viewBankTransfer: ViewBankTransfer!
    @IBOutlet weak var viewBalance: ViewBalance!
    @IBOutlet weak var viewSaveCard: ViewSaveCard!
    @IBOutlet weak var viewQiwiTransfer: PresentationCardCell!
    @IBOutlet weak var viewQiwiPass: UIView!
    @IBOutlet weak var viewReceiptDesc: UICardView!
    @IBOutlet weak var viewCoupon: UICardView!
    @IBOutlet weak var viewPIX: ViewPIX!
    
    //Send receipt (pro)
    @IBOutlet weak var viewSendReceipt: UICardView!
    @IBOutlet weak var txtPhoneReceipt: MaterialField!
    @IBOutlet weak var btnCoupons: UIButton!
    
    // View Detail Order
    @IBOutlet weak var svTax: UIStackView!
    @IBOutlet weak var svTotalValue: UIStackView!
    @IBOutlet weak var svDiscount: UIStackView!
    @IBOutlet weak var spaceTax: UIView!
    @IBOutlet weak var spaceTotalValue: UIView!
    @IBOutlet weak var spaceDiscountSpace: UIView!
    @IBOutlet weak var lbLabelProduct: UILabel!
    @IBOutlet weak var lbLabelPrice: UILabel!
    @IBOutlet weak var lbLabelTax: UILabel!
    @IBOutlet weak var lbDiscount: UILabel!
    @IBOutlet weak var lbLabelTotalPrice: UILabel!
    @IBOutlet weak var lbLabelDetails: UILabel!
    @IBOutlet weak var lbLabelDiscount: UILabel!
    
    //Coupon
    @IBOutlet weak var svApplyCoupon: UIStackView!
    @IBOutlet weak var svCouponApplied: UIStackView!
    @IBOutlet weak var btnRemoveAppliedCoupons: UIButton!
    
    @IBOutlet weak var lbProduct: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbTax: UILabel!
    @IBOutlet weak var lbDetails: UILabel!
    @IBOutlet weak var lbTotalValue: UILabel!
    
    // View Qiwi Password
    @IBOutlet weak var lbLabelPassword: UILabel!
    @IBOutlet weak var lbWrongPass: UILabel!
    @IBOutlet weak var btnForgotPass: UIButton!
    @IBOutlet weak var txtPassword: MaterialField!
    @IBOutlet weak var txtReceiptDesc: UITextField!
    
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    private var taxes = [Tax]()
    
    // MARK: Constants
    let STEP_ORDER = 0
    let STEP_QIWI_TRANSFER_DETAILS = 1
    let STEP_BANK = 2
    let STEP_QIWI_PASS = 3
    let STEP_CREDIT_CARD_TOKEN = 4
    let STEP_PIX = 5
    let STEP_PIXV2 = 7
    let STEP_STATUS = 6
    
    // MARK: Variables
    var stepCheckout = 0
    var mOrder: Order?
    var mConsultaPix: ConsultaPIX?
    var mSelectedBank: Bank?
    var mDiscountValue = 0
    lazy var mCheckoutRN = CheckoutRN(delegate: self)
    
    var qiwiCoupons = [RequestCoupons]()
    
    private var totalValueWithDiscount = Float()
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func setupViewWillAppear() {
        changeLayout(step: QiwiOrder.isQiwiTransfer() ? STEP_QIWI_TRANSFER_DETAILS : STEP_ORDER)
    }
    
    @IBAction func onClickBackToolbar(_ sender: Any) {
        self.clickBack()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        //        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        //            if self.view.frame.origin.y == 0 {
        //                self.view.frame.origin.y -= keyboardSize.height
        //            }
        //        }
        
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if #available(iOS 11, *) {
            self.bottomLayoutConstraint.constant = keyboardFrame.height - self.view.safeAreaInsets.bottom
        } else {
            self.bottomLayoutConstraint.constant = keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //        if self.view.frame.origin.y != 0 {
        //            self.view.frame.origin.y = 81
        //        }
        
        self.bottomLayoutConstraint.constant = 0
    }
}

extension CheckoutViewController: PromocodeSelected {
    func promocodeSelected(coupons: [Coupon]) {
        QiwiOrder.coupons = coupons
        
        if !coupons.isEmpty {
            var buttonCoupon = QiwiOrder.coupons!.count == 1 ? "coupon_one_applied".localized : "coupon_multiple_applied".localized
            buttonCoupon = buttonCoupon.replacingOccurrences(of: "{value}", with: String(QiwiOrder.coupons!.count))
            self.btnRemoveAppliedCoupons.setTitle(buttonCoupon, for: .normal)
            
            self.btnRemoveAppliedCoupons.isHidden = false
            self.svCouponApplied.isHidden = false
            self.svApplyCoupon.isHidden = true
            
            self.doActionAfter(after: 0.3, completion: {
                //Checa os valores novamente caso aplicado
                Util.showLoading(self) {
                    self.mCheckoutRN.checkTaxes(prvId: QiwiOrder.checkoutBody.transition?.prvId ?? 0)
                }
            })
        }
    }
}

extension CheckoutViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if (fromClass == CheckoutRN.self) {
                self.dismissPage(self)
                
                switch param {
                case Param.Contact.CHECKOUT_CHECK_TAX_RESPONSE:
                    let tax = self.mCheckoutRN.verifyTaxes(taxes: object as! [Tax], paymentType: QiwiOrder.getPaymentType())
                    self.updateValue(tax: tax)
                case Param.Contact.USER_QIWI_PASS_WRONG_ERROR:
                    self.lbWrongPass.isHidden = false
                    self.txtPassword.text = ""
                case Param.Contact.CHECKOUT_REQUEST, Param.Contact.CHECKOUT_REQUEST_FAILED:
                    if (result) {
                        self.mOrder = (object as? Order)!
                    } else {
                        self.mOrder = nil
                    }
                    self.changeLayout(step: self.STEP_STATUS)
                case Param.Contact.CHECKOUT_REQUEST_PIX:
                    if (result) {
                        let array = (object as! Array<Any>)
                        self.mConsultaPix = (array[0] as? ConsultaPIX)!
                        self.mOrder = (array[1] as! Order)
                    } else {
                        self.mConsultaPix = nil
                        self.mOrder = nil
                    }
                    self.changeLayout(step: self.STEP_STATUS)
                default:
                    break
                }
            }
            
            if fromClass == ViewBankTransfer.self {
                if param == Param.Contact.BANK_SELECTED {
                    
                    self.sendCheckoutRequest(coupons: nil)
                }
            }
            
            if fromClass == ViewPIX.self {
                if param == Param.Contact.SHOW_BACK_AND_CONTINUE_BUTTON {
                    self.viewContinue.showBackAndContinueButtons()
                }
                else if param == Param.Contact.SHOW_ONLY_BACK_BUTTON {
                    self.viewContinue.showOnlyBackButton()
                }
            }
            
            if fromClass == ViewPIXPersonCell.self {
                if param == Param.Contact.LIST_CLICK {
                    
                    let pix = object as! PIXRequest
                    
                    if pix.document == UserRN.getLoggedUser().cpf {
                        QiwiOrder.checkoutBody.transition?.pix?.name = ""
                        QiwiOrder.checkoutBody.transition?.pix?.document = ""
                    } else {
                        QiwiOrder.checkoutBody.transition?.pix?.name = pix.name
                        QiwiOrder.checkoutBody.transition?.pix?.document = pix.document
                    }
                    
                    QiwiOrder.checkoutBody.transition?.pix?.save = false
                    self.sendCheckoutRequest(coupons: nil)
                }
            }
            
            if fromClass == OrderRN.self {
                self.dismissPage(self)
            }
        })
    }
}

extension CheckoutViewController {
    
    @IBAction func onClickRemoveCoupons(_ sender: Any) {
        QiwiOrder.coupons = nil
        self.svDiscount.isHidden = true
        self.spaceDiscountSpace.isHidden = true
        self.svCouponApplied.isHidden = true
        self.btnRemoveAppliedCoupons.isHidden = true
        
        self.svTotalValue.isHidden = true
        self.spaceTotalValue.isHidden = true
        
        self.svApplyCoupon.isHidden = false
        
        //Checa os valores novamente caso aplicado
        Util.showLoading(self) {
            self.mCheckoutRN.checkTaxes(prvId: QiwiOrder.checkoutBody.transition?.prvId ?? 0)
        }
    }
    
    @IBAction func onClickCoupon(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segues.PROMO_CODE, sender: nil)
    }
    
    @IBAction func onClickForgotQiwiPass(sender: UIButton) {
        self.performSegue(withIdentifier: Constants.Segues.FORGOT_QIWI_PASSWORD, sender: nil)
    }
    
    func sendCheckoutRequest(coupons: [RequestCoupons]?) {
        Util.showController(LoadingViewController.self, sender: self) { (controller) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.mCheckoutRN.sendCheckoutRequest()
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.STATUS_ORDER {
            if let navVC = segue.destination as? CheckoutInfoViewController {
                navVC.mOrder = self.mOrder
                
                if self.mConsultaPix != nil {
                    navVC.mConsultaPix = self.mConsultaPix
                }
                
                if QiwiOrder.isPayingWithPrePago() && !UserRN.canShowReceiptPrePago() {
                    navVC.mPhone = self.txtPhoneReceipt.text!
                }
                
                if QiwiOrder.checkoutBody.transition?.bankRequest != nil {
                    navVC.mBankId = QiwiOrder.checkoutBody.transition?.bankRequest?.bankId
                }
            }
        }
        
        if segue.identifier == Constants.Segues.PROMO_CODE {
            if let nav = segue.destination as? UINavigationController {
                if let vc = nav.viewControllers.first as? PromoCodeViewController {
                    vc.comingFrom = .CHECKOUT
                    vc.promocodeSelected = self
                }
            }
        }
        
        if segue.identifier == Constants.Segues.FORGOT_QIWI_PASSWORD {
            ForgotPasswordQiwiViewController.toolbarTitle = "create_qiwi_title_toolbar_what_is_qiwi_pass".localized
        }
    }
}

// MARK: IBActions
extension CheckoutViewController {
    
    @IBAction func clickContinue(sender: UIButton) {
        if self.stepCheckout == STEP_ORDER {
            
            if mDiscountValue == QiwiOrder.getTransitionValue() {
                QiwiOrder.checkoutBody.transition?.token = nil
                QiwiOrder.checkoutBody.transition?.bankRequest = nil
                QiwiOrder.checkoutBody.transition?.qiwiBalance = nil
                self.sendCheckoutRequest(coupons: qiwiCoupons)
                return
            }
            
            //Validação
            if QiwiOrder.isPayingWithPrePago() && !UserRN.canShowReceiptPrePago() {
                let phone = self.txtPhoneReceipt.text!.removeAllOtherCaracters()
                
                if phone.count < 10 {
                    Util.showAlertDefaultOK(self, message: "checkout_send_receipt_phone_invalid".localized)
                    return
                }
                
                if QiwiOrder.isClickBus() {
                    QiwiOrder.checkoutBody.requestClickbus?.buyerPhone = phone
                }
                
                if QiwiOrder.isUltragaz() {
                    QiwiOrder.checkoutBody.requestUltragaz?.phone = phone
                }
                
                QiwiOrder.checkoutBody.transition?.phoneReceipt = phone
            } else {
                QiwiOrder.checkoutBody.transition?.phoneReceipt = nil
            }
            
            if QiwiOrder.isQiwiCharge() {
                if QiwiOrder.checkoutBody.transition?.bankRequest != nil {
                    self.changeLayout(step: STEP_BANK)
                }
                
                else if QiwiOrder.checkoutBody.transition?.pix != nil {
                    self.changeLayout(step: STEP_PIX)
                }
                
                else if QiwiOrder.checkoutBody.transition?.pix_v2 != nil {
                    self.changeLayout(step: STEP_PIXV2)
                }
            }
            
            else if QiwiOrder.checkoutBody.transition?.qiwiBalance != nil || QiwiOrder.checkoutBody.transition?.prePago != nil || QiwiOrder.isQiwiTransferToPrePago() {
                self.changeLayout(step: STEP_QIWI_PASS)
            }
            
            else if QiwiOrder.checkoutBody.transition?.token != nil {
                self.changeLayout(step: STEP_CREDIT_CARD_TOKEN)
            }
            
            else if QiwiOrder.checkoutBody.transition?.bankRequest != nil {
                self.changeLayout(step: STEP_BANK)
            }
            
            else if QiwiOrder.checkoutBody.transition?.pix != nil {
                self.changeLayout(step: STEP_PIX)
            }
            
            else if QiwiOrder.checkoutBody.transition?.pix_v2 != nil {
                self.changeLayout(step: STEP_PIXV2)
            }
            
            return
        }
        
        if self.stepCheckout == STEP_QIWI_TRANSFER_DETAILS {
            QiwiOrder.checkoutBody.transition?.qiwiBalance = QiwiBalanceRequest()
            self.changeLayout(step: STEP_QIWI_PASS)
        }
    }
    
    @IBAction func clickFinish(sender: UIButton) {
        //Se esta digitando a senha, devemos validar
        switch stepCheckout {
        case STEP_ORDER:
            QiwiOrder.checkoutBody.transition?.pix_v2 = PIXV2Request()
            QiwiOrder.checkoutBody.transition?.pix_v2?.valor = Int(totalValueWithDiscount)
//            self.changeLayout(step: STEP_ORDER)
            print("@! >>> PIX_V2 ", QiwiOrder.checkoutBody.transition?.pix_v2)
            print("@! >>> STEP_ORDER")
            print("@! >>> ", Double(Double(totalValueWithDiscount/100)))
        case STEP_QIWI_PASS:
            print("@! >>> STEP_QIWI_PASS")
            if txtPassword.text?.count != 6 {
                Util.showAlertDefaultOK(self, message: "checkout_input_qiwi_pass".localized)
                return
            }
            QiwiOrder.qiwiPass = txtPassword.text!
        case STEP_PIX:
            let pix = self.viewPIX.getInputRequest()
            if pix == nil {
                Util.showAlertDefaultOK(self, message: "invalid_input".localized)
                return
            }
            QiwiOrder.checkoutBody.transition?.pix?.name = pix!.name
            QiwiOrder.checkoutBody.transition?.pix?.document = pix!.document
            QiwiOrder.checkoutBody.transition?.pix?.save = true
        case STEP_PIXV2:
            if QiwiOrder.checkoutBody.transition?.value ?? 0 <= 0 {
                Util.showAlertDefaultOK(self, message: "invalid_input".localized)
                return
            }
            QiwiOrder.checkoutBody.transition?.pix_v2?.valor = QiwiOrder.checkoutBody.transition?.value ?? 0
        case STEP_BANK:
            if !self.viewBankTransfer.validateFields() {
                Util.showAlertDefaultOK(self, message: "invalid_input".localized)
                return
            }
            QiwiOrder.checkoutBody.transition?.bankRequest = self.viewBankTransfer.createBankRequestFromInput()
        case STEP_CREDIT_CARD_TOKEN:
            if (self.viewSaveCard.txtCVV.text?.count)! < 3 {
                Util.showAlertDefaultOK(self, message: "invalid_input".localized)
                return
            }
            let cvv = self.viewSaveCard.txtCVV.text!
            QiwiOrder.checkoutBody.transition?.token?.cvv = cvv
        default:
            break
        }
        
        if QiwiOrder.isQiwiTransfer() {
            QiwiOrder.checkoutBody.creditQiwiTransferRequest?.receiptDesc = self.txtReceiptDesc.text ?? ""
        }
        
        self.sendCheckoutRequest(coupons: qiwiCoupons)
    }
    
    @IBAction func clickBack() {
        
        //Se a barra estiver com o excluir em cima, somente volta a barra ao normal
        if self.viewBankTransfer.isEditingTableView == true {
            self.viewBankTransfer.resetNavigation()
            
            self.viewBankTransfer.isEditingTableView = false
            return
        }
        
        if self.stepCheckout == STEP_ORDER || self.stepCheckout == STEP_QIWI_TRANSFER_DETAILS {
            if (QiwiOrder.isClickBus()) {
                ClickBusBaseViewController.backwardStep()
            }
            self.popPage()
            return
        }
        
        if self.stepCheckout == STEP_QIWI_PASS {
            if QiwiOrder.isQiwiTransfer() {
                self.changeLayout(step: STEP_QIWI_TRANSFER_DETAILS)
                return
            }
        }
        
        self.changeLayout(step: STEP_ORDER)
    }
}

extension CheckoutViewController {
    
    func hasCoupons() -> Bool {
        return QiwiOrder.coupons != nil && !QiwiOrder.coupons!.isEmpty
    }
    
    func applyCoupon(purchaseValue: Int) {
        if !self.hasCoupons() {
            self.svDiscount.isHidden = true
            self.spaceDiscountSpace.isHidden = true
            self.svTotalValue.isHidden = true
            self.spaceTotalValue.isHidden = true
            mDiscountValue = 0
            
            QiwiOrder.updateDesc(value: purchaseValue - mDiscountValue)
            return
        }
        
        //Converte os cupons para o tipo request
        var requestCoupons = [RequestCoupons]()
        var totalDiscount: Double = 0
        for c in QiwiOrder.coupons ?? [] {
            requestCoupons.append(RequestCoupons(code: c.code))
            totalDiscount += c.value
        }
        
        self.qiwiCoupons = requestCoupons
        
        if totalDiscount > Double(purchaseValue/100) {
            mDiscountValue = purchaseValue
        } else {
            mDiscountValue = Int(totalDiscount*100)
        }
        
        //Adiciona no checkout
        QiwiOrder.checkoutBody.transition?.coupons = requestCoupons
        
        //coloca o valor do desconto na tela
        self.svDiscount.isHidden = false
        self.spaceDiscountSpace.isHidden = false
        self.lbDiscount.text = "-" + Util.formatCoin(value: totalDiscount)
        
        
        QiwiOrder.updateDesc(value: purchaseValue - mDiscountValue)
        self.lbDetails.text = QiwiOrder.details
        
        self.lbTotalValue.text = Util.formatCoin(value: purchaseValue - mDiscountValue)
        self.svTotalValue.isHidden = false
        self.spaceTotalValue.isHidden = false
        
        self.totalValueWithDiscount = Float(Double(purchaseValue - mDiscountValue)/100)
        print("@! >>> purchaseValue_toInt ", Double(purchaseValue - mDiscountValue)/100)
    }
    
    func updateValue(tax: Tax) {
        let paymentType = QiwiOrder.getPaymentType()
        
        print("@! >>> paymentTypeId", tax.paymentTypeId)
        print("@! >>> paymentType", paymentType)
        print("@! >>> salestaxOperation", tax.salestaxOperation)
        
        //Não has taxas
        if tax.value <= 0 || tax.paymentTypeId != 0 && tax.paymentTypeId != paymentType {
            return
        }
        
        var taxValue: String = ""
        var value = QiwiOrder.checkoutBody.transition?.value ?? 0
        let intTax = Int(tax.value.nextUp * 100)
        
        //se houver cupom, aplica
        self.applyCoupon(purchaseValue: QiwiOrder.getValue())
        
        //1 deve ser incrementado
        if tax.salestaxOperation == 1 {
            if tax.isFixed {
                value = value + intTax
                taxValue = "+ \(Util.formatCoin(value: intTax))"
                print("@! >>> taxa ", taxValue)
            } else {
                value = value + Int(Double(value) * (tax.value/100))
                taxValue = "+ \(tax.value)%"
                print("@! >>> taxa ", taxValue)
            }
        }
        
        //2 deve diminuir
        else if tax.salestaxOperation == 2 {
            if tax.isFixed {
                value = value - intTax
                taxValue = "- \(Util.formatCoin(value: tax.value))"
                print("@! >>> taxa ", taxValue)
            } else {
                value = value - Int(Double(value) * (tax.value/100))
                taxValue = "- \(tax.value)%"
                print("@! >>> taxa ", taxValue)
            }
        }
        
        DispatchQueue.main.async {
            guard let newValueTax = QiwiOrder.checkoutBody.transition?.value else { return }
            print("@! >>> taxa ", newValueTax/100)
            print("@! >>> taxa ", tax.value/100)
            //Apply coupon again with tax
            self.applyCoupon(purchaseValue: value)
            QiwiOrder.setTransitionValue(value: value)
            QiwiOrder.updateDesc(value: value-self.mDiscountValue)
            
            let details = QiwiOrder.details + " " + "checkout_taxes".localized.replacingOccurrences(of: "{tax}", with: taxValue)
            self.lbDetails.text = details
            self.lbTax.text = taxValue.isEmpty ? "" : taxValue
            self.lbTotalValue.text = Util.formatCoin(value: value-self.mDiscountValue)
            
            self.svTax.isHidden = false
            self.spaceTax.isHidden = false
            self.svTotalValue.isHidden = false
            self.spaceTotalValue.isHidden = false
        }
    }
    
    func validatePaymentMethod() -> Bool {
        if QiwiOrder.checkoutBody.transition?.qiwiBalance != nil {
            lbWrongPass.isHidden = true
            
            if txtPassword.text?.count != 6 {
                return false
            }
            
            QiwiOrder.checkoutBody.transition?.qiwiBalance?.pass = txtPassword.text!
        }
        
        else if QiwiOrder.checkoutBody.transition?.token != nil {
            
            if (self.viewSaveCard.txtCVV.text?.count)! < 3 {
                return false
            }
        }
        
        else if QiwiOrder.checkoutBody.transition?.bankRequest != nil {
            
        }
        
        return true
    }
}

// MARK: SetupUI
extension CheckoutViewController {
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lblTitle)
        
        self.viewBankTransfer.delegate = self
        self.viewBankTransfer.viewController = self
        self.viewPIX.delegate = self
        self.viewPIX.setupViewWithoutCard()
        self.viewPIX.setBackgroundColor(color: UIColor.clear, duration: 0.5)
        self.txtPassword.isSecureTextEntry = PassVisibility.isHidden()
        self.txtPassword.isVisibleRightView = false
        
        self.txtPassword.rightButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        
        self.txtPassword.setLenght(6)
        
        self.setupViewOrderDetail()
        self.setupViewQiwiPass()
    }
    
    func setupTexts() {
        
        self.lblTitle.text = "checkout_order_detail".localized
        
        Util.setTextBarIn(self, title: "checkout_title".localized)
    }
    
    @objc func showPassword() {
        self.txtPassword.isSecureTextEntry = !self.txtPassword.isSecureTextEntry
        
        PassVisibility.showPopupIfCan(sender: self)
        PassVisibility.setIsHidden(isHidden: self.txtPassword.isSecureTextEntry)
    }
    
    func showViewContinue() {
        
        self.viewContinue.btnContinue.removeTarget(nil, action: nil, for: .allEvents)
        
        switch self.stepCheckout {
            
        case STEP_QIWI_TRANSFER_DETAILS: fallthrough
        case STEP_ORDER:
            if !QiwiOrder.isPayingWithCoupon() {
                self.viewContinue.btnBack.addTarget(self, action: #selector(clickBack), for: .touchUpInside)
                self.viewContinue.btnContinue.addTarget(self, action: #selector(clickContinue(sender:)), for: .touchUpInside)
                self.viewContinue.btnContinue.setTitle("continue_label".localized, for: .normal)
            } else {
                self.viewContinue.btnBack.addTarget(self, action: #selector(clickBack), for: .touchUpInside)
                self.viewContinue.btnContinue.addTarget(self, action: #selector(clickFinish(sender:)), for: .touchUpInside)
                self.viewContinue.btnContinue.setTitle("finish".localized, for: .normal)
            }
            break
            
        case STEP_CREDIT_CARD_TOKEN: fallthrough
        case STEP_QIWI_PASS:
            self.viewContinue.btnContinue.removeTarget(self, action: nil, for: .allEvents)
            self.viewContinue.btnContinue.addTarget(self, action: #selector(clickFinish(sender:)), for: .touchUpInside)
            self.viewContinue.btnContinue.setTitle("finish".localized, for: .normal)
            break
            
        case STEP_PIX: fallthrough
        case STEP_BANK:
            self.viewContinue.btnContinue.removeTarget(self, action: nil, for: .allEvents)
            self.viewContinue.btnContinue.addTarget(self, action: #selector(clickFinish(sender:)), for: .touchUpInside)
            self.viewContinue.btnContinue.setTitle("finish".localized, for: .normal)
            self.viewBankTransfer.btnFinish.addTarget(self, action: #selector(clickFinish(sender:)), for: .touchUpInside)
            break
            
        case STEP_PIXV2:
            self.viewContinue.btnContinue.removeTarget(self, action: nil, for: .allEvents)
            self.viewContinue.btnContinue.addTarget(self, action: #selector(clickFinish(sender:)), for: .touchUpInside)
            self.viewContinue.btnContinue.setTitle("finish".localized, for: .normal)
            self.viewBankTransfer.btnFinish.addTarget(self, action: #selector(clickFinish(sender:)), for: .touchUpInside)
            break
            
            
        case STEP_STATUS:
            break
        default:
            return
        }
    }
}

extension CheckoutViewController {
    
    func setupViewOrderDetail() {
        Theme.Checkout.OrderDetail.textAsLabelOrder(self.lbLabelProduct)
        Theme.Checkout.OrderDetail.textAsLabelOrder(self.lbLabelPrice)
        Theme.Checkout.OrderDetail.textAsLabelOrder(self.lbLabelTotalPrice)
        Theme.Checkout.OrderDetail.textAsLabelOrder(self.lbLabelTax)
        Theme.Checkout.OrderDetail.textAsLabelOrder(self.lbLabelDetails)
        Theme.Checkout.OrderDetail.textAsLabelOrder(self.lbLabelDiscount)
        
        Theme.Checkout.OrderDetail.textAsValueOrder(self.lbProduct)
        Theme.Checkout.OrderDetail.textAsValueOrder(self.lbPrice)
        Theme.Checkout.OrderDetail.textAsValueOrder(self.lbTax)
        Theme.Checkout.OrderDetail.textAsDetailMessage(self.lbDetails)
        Theme.Checkout.OrderDetail.textAsDetailMessage(self.lbDiscount)
        
        self.lbDiscount.textColor = .systemGreen
        self.lbLabelProduct.text = "checkout_product".localized
        self.lbLabelPrice.text = "checkout_value".localized
        self.lbLabelTax.text = "checkout_tax".localized
        self.lbLabelDetails.text = "checkout_detalhes".localized
        self.lbLabelDiscount.text = "checkout_discount".localized
        
        //self.svTax.isHidden = true
        self.spaceTax.isHidden = true
        self.svTotalValue.isHidden = true
        self.spaceTotalValue.isHidden = true
        self.svDiscount.isHidden = true
        self.spaceDiscountSpace.isHidden = true
        
        self.addDetails()
        
        QiwiOrder.setTransitionValue(value: QiwiOrder.getValue())
        QiwiOrder.updateDesc(value: QiwiOrder.getValue())
        
        self.lbProduct.text = QiwiOrder.productName
        if QiwiOrder.isPayingWithCoupon() {
            self.lbPrice.text = Util.formatCoin(value: Double(Double(totalValueWithDiscount) / 100))
        } else {
            self.lbPrice.text = Util.formatCoin(value: QiwiOrder.checkoutBody.transition?.value ?? 0)
        }
        self.lbDetails.text = QiwiOrder.details
        self.lbTax.text = ""
        
        Util.showLoading(self) {
            self.mCheckoutRN.checkTaxes(
                prvId: QiwiOrder.checkoutBody.transition?.prvId ?? 0
            )
        }
    }
    
    func addDetails() {
        if QiwiOrder.isTransportRecharge() {
            if QiwiOrder.isBilheteUnicoComum() {
                QiwiOrder.details = "checkout_transport_value".localized
                    .replacingOccurrences(of: "{value}", with: Util.formatCoin(value: QiwiOrder.checkoutBody.transition?.value ?? 0))
            } else {
                QiwiOrder.details = "checkout_transport_type".localized
                    .replacingOccurrences(of: "{type}", with: (QiwiOrder.checkoutBody.requestTransport?.desc)!)
                    .replacingOccurrences(of: "{value}", with: Util.formatCoin(value: QiwiOrder.checkoutBody.transition?.value ?? 0))
            }
        }
    }
    
    func setupViewQiwiPass() {
        Theme.Checkout.QiwiPass.textAsLabelPass(self.lbLabelPassword)
        Theme.default.textAsError(self.lbWrongPass)
        Theme.Checkout.QiwiPass.textAsWrongPass(self.btnForgotPass)
        
        self.txtPassword.placeholder = "payments_qiwi_pass_hint".localized
        self.lbLabelPassword.text = "checkout_qiwi_pass_info".localized
        self.lbWrongPass.text = "payments_qiwi_pass_wrong".localized
        self.btnForgotPass.setTitle("forgot_qiwi_pass_what_is_qiwi_pass".localized, for: .normal)
        
        self.txtPassword.setLenght(6)
    }
    
    func setupQiwiBalanceView() {
        if QiwiOrder.checkoutBody.transition?.qiwiBalance == nil {
            self.viewBalance.isHidden = true
            return
        }
        
        self.viewBalance.isHidden = false
        self.viewBalance.hideButtons()
        self.viewBalance.updateBalance()
    }
    
    func verifyAvailableCoupons() {
        //Verify coupons
        let coupons = CouponRN(delegate: self).getAvailableCoupons()
        
        if !coupons.isEmpty {
            var availableForThisPurchase = 0
            
            print("@! >>> PRV_ID ", QiwiOrder.getPrvID())
            
            for c in coupons {
                let purchase = c.isCouponAvailableForPrvAndValue(
                    prvid: QiwiOrder.getPrvID(),
                    value: QiwiOrder.getValue()) ? availableForThisPurchase + 1 : availableForThisPurchase
                //Se estiver disponivel para esta compra, incrementa 1, se não deixa igual
                availableForThisPurchase = purchase
            }
            
            if availableForThisPurchase > 0 {
                let title = "coupon_you_have_x_cupom_button".localized.replacingOccurrences(of: "{count}", with: String(availableForThisPurchase))
                btnCoupons.setTitle(title, for: .normal)
                return
            }
        }
        
        btnCoupons.setTitle("coupon_add_coupon_button".localized, for: .normal)
    }
}

extension CheckoutViewController {
    
    func hideAll() {
        self.viewSendReceipt.isHidden = true
        self.viewOrder.isHidden = true
        self.viewContinue.isHidden = true
        self.viewBankTransfer.isHidden = true
        self.viewBalance.isHidden = true
        self.viewSaveCard.isHidden = true
        self.viewQiwiPass.isHidden = true
        self.viewQiwiTransfer.isHidden = true
        self.viewReceiptDesc.isHidden = true
        self.viewCoupon.isHidden = true
        self.viewPIX.isHidden = true
    }
    
    func changeLayout(step: Int) {
        
        self.hideAll()
        stepCheckout = step
        
        switch self.stepCheckout {
            
        case STEP_QIWI_TRANSFER_DETAILS:
            self.lblTitle.text = "credit_qiwi_transfer_details".localized
            self.viewQiwiTransfer.isHidden = false
            
            var name = QiwiOrder.checkoutBody.creditQiwiTransferRequest?.name
            if name?.isEmpty ?? true {
                name = "Outro"
            }
            
            self.viewQiwiTransfer.lblNameUser.text = name
            self.viewQiwiTransfer.lblNumberUser.text = QiwiOrder.checkoutBody.creditQiwiTransferRequest?.phone.formatText(format: "(##) #####-####")
            self.viewQiwiTransfer.lbPrice.text = Util.formatCoin(value: QiwiOrder.checkoutBody.transition?.value ?? 0)
            
            self.viewReceiptDesc.isHidden = false
            self.viewContinue.isHidden = false
            self.viewContinue.showBackAndContinueButtons()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                self.view.endEditing(true)
            })
            break
        case STEP_ORDER:
            self.lblTitle.text = "checkout_order_detail".localized
            self.viewOrder.isHidden = false
            self.viewContinue.isHidden = false
            self.viewContinue.showBackAndContinueButtons()
            
            if QiwiOrder.isPayingWithPrePago() && !UserRN.canShowReceiptPrePago() {
                self.viewSendReceipt.isHidden = false
                self.txtPhoneReceipt.formatPattern = Constants.FormatPattern.Cell.ddPhone.rawValue
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                self.view.endEditing(true)
            })
            
            if !QiwiOrder.isPayingWithCoupon() {
                self.verifyAvailableCoupons()
            }
            
            if QiwiOrder.isPayingWithCoupon() {
                self.verifyAvailableCoupons()
            }
            
            if QiwiOrder.isPayingWithPIX() {
                self.viewPIX.setupInitialView()
            }
            
            self.viewCoupon.isHidden = ApplicationRN.isQiwiPro() || QiwiOrder.isPayingWithCoupon()
            
            self.setupQiwiBalanceView()
            
            if QiwiOrder.checkoutBody.transition?.pix_v2 != nil {
                self.stepCheckout = STEP_PIXV2
            }
            
            break
        case STEP_BANK:
            self.mSelectedBank = BankRN(delegate: self).getBank(bankId: (QiwiOrder.checkoutBody.transition?.bankRequest?.bankId)!)
            self.viewBankTransfer.setBank(bank: mSelectedBank!)
            self.lblTitle.text = "checkout_input_bank".localized
            self.viewBankTransfer.isHidden = false
            self.viewContinue.isHidden = false
            self.viewContinue.showOnlyBackButton()
            break
        case STEP_PIX:
            self.viewPIX.isHidden = false
            self.viewContinue.isHidden = false
            self.viewContinue.showOnlyBackButton()
            break
        case STEP_PIXV2:
            //parei aqui, preciso entender como fazer o sistema chamar a API
            //self.viewPIX.isHidden = false
            //self.viewSaveCard.isHidden = false
            //self.viewPIXInfo.isHidden = false
            self.viewContinue.isHidden = false
            self.viewContinue.showBackAndContinueButtons()
            break
        case STEP_CREDIT_CARD_TOKEN:
            self.lblTitle.text = "checkout_input_cvv".localized
            self.viewSaveCard.isHidden = false
            self.viewContinue.isHidden = false
            self.viewContinue.showBackAndContinueButtons()
            break
        case STEP_QIWI_PASS:
            self.lblTitle.text = "checkout_input_qiwi_pass".localized
            self.viewContinue.isHidden = false
            self.viewQiwiPass.isHidden = false
            self.viewContinue.showBackAndContinueButtons()
            self.txtPassword.becomeFirstResponder()
            break
        case STEP_STATUS:
            let coupons = QiwiOrder.checkoutBody.transition?.coupons
            if mOrder != nil && coupons != nil && !coupons!.isEmpty {
                CouponDAO().delete(coupons: coupons!)
            }
            performSegue(withIdentifier: Constants.Segues.STATUS_ORDER, sender: nil)
            break
        default:
            break
        }
        
        self.showViewContinue()
    }
}
