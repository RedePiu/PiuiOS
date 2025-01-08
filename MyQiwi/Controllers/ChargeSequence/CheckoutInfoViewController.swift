//
//  CheckoutInfoViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 11/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class CheckoutInfoViewController: UIBaseViewController {
    
    // MARK: Outlets
    @IBOutlet weak var viewUltragaz: ViewUltragazVouncher!
    @IBOutlet weak var viewCashback: ViewCashback!
    @IBOutlet weak var viewStatusOrder: ViewStatusOrder!
    @IBOutlet weak var viewBankInfo: ViewBankInfo!
    @IBOutlet weak var viewCaixaEconomica: ViewCaixaEconomica!
    @IBOutlet weak var viewTransportInstructions: ViewTransportInstructions!
    @IBOutlet weak var viewPIXInfo: ViewPIXInfo!
//    @IBOutlet weak var viewTakeReceiveLocation: CardInfoGeneric!
    
    // MARK: Variables
    private var textReceipt: String?
    lazy var checkoutRN = CheckoutRN(delegate: self)
    var mOrder: Order?
    var mConsultaPix: ConsultaPIX?
    var mBankId: Int?
    var mPhone: String = ""
    
    // MARK: Ciclo de vida
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc fileprivate func takeImageView() {
        self.textReceipt = self.viewStatusOrder.viewReceipt.textReceipt.text
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: Constants.Segues.SHOW_RECEIPT, sender: nil)
        }
    }
    
    fileprivate func takePhotoView() {
        Util.snapShotView(self, view: self.viewStatusOrder.viewReceipt.textReceipt)
    }
}

extension CheckoutInfoViewController: SetupUI {
    func setupUI() {
        Theme.default.backgroundCard(self)
        self.viewBankInfo.isHidden = true
        self.viewCaixaEconomica.isHidden = true
        self.viewUltragaz.isHidden = true
        self.viewCashback.isHidden = true
        self.viewStatusOrder.btReason.isHidden = true
        self.viewStatusOrder.viewReceipt.isHidden = true
        self.viewStatusOrder.btShare.isHidden = true
        self.viewTransportInstructions.isHidden = true
        self.viewPIXInfo.isHidden = true
//        self.viewTakeReceiveLocation.isHidden = true
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: QiwiOrder.productName)
        
        var image: String
        var title: String
        var desc: String
        var buttonText: String
        var buttonColor: UIColor
        
//        viewTakeReceiveLocation.titleLabel.text = ""
//        viewTakeReceiveLocation.descriptionLabel.text = ""
//        viewTakeReceiveLocation.imageView.image = UIImage(named: "img_student1")

        self.viewStatusOrder.hideResendOptions()
        
        print("@! >>> ORDER ", mOrder?.value)
        print("@! >>> ORDER_STATUS ", mOrder?.status)
        
        if mOrder != nil && mOrder?.status == Order.Status.finished {
            image = "ic_green_done"
            title = "checkout_success_finished".localized
            desc = "checkout_success_finished_desc".localized
            buttonText = "checkout_button_go_to_orders".localized
            buttonColor = Theme.default.green
            
            if QiwiOrder.isPayingWithPrePago() && !UserRN.canShowReceiptPrePago() {
                desc = "checkout_success_finished_prepago_desc".localized
                buttonText = "checkout_button_go_to_orders_menu".localized
                
                self.viewStatusOrder.btnSee.addTarget(self, action: #selector(onClickBackToMenu), for: .touchUpInside)
                self.viewStatusOrder.showResendOptions()
                self.viewStatusOrder.btnResendReceipt.addTarget(self, action: #selector(onClickSendReceipt), for: .touchUpInside)
            } else {
                self.viewStatusOrder.hideResendOptions()
                self.viewStatusOrder.btnSee.addTarget(self, action: #selector(onClickOrderDetails), for: .touchUpInside)
            }
            
            if mOrder?.receipt != nil && !(mOrder?.receipt.isEmpty)! && (!QiwiOrder.isPayingWithPrePago() ||
                (QiwiOrder.isPayingWithPrePago() && UserRN.canShowReceiptPrePago())) {
//                self.viewTakeReceiveLocation.isHidden = false
                self.viewStatusOrder.viewReceipt.setReceipt(receipt: mOrder?.receipt ?? "", isTelesena: mOrder?.prvId == ActionFinder.Prvids.TELESENA)
                self.viewStatusOrder.viewReceipt.isHidden = false
                self.viewStatusOrder.viewReceipt.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(takeImageView)))
                self.viewStatusOrder.btShare.isHidden = false
                self.viewStatusOrder.btShare.addTarget(self, action: #selector(onClickShare), for: .touchUpInside)
            }
            
            if ActionFinder.isActionFromAnyTransport(action: QiwiOrder.selectedMenu.action) {
                self.viewTransportInstructions.isHidden = QiwiOrder.instructionsViewIsHidden

                if !ActionFinder.isRechargeTransporCard(action: QiwiOrder.selectedMenu.action) {
                    //self.viewTransportInstructions.showUrbsAlert(rechargeDate: self.mOrder!.date)
                    self.viewTransportInstructions.show72HourRemaining()
                    
                    //remover alerta de 72 horas se for os prvIDs do prodatat nova
                    let prvids = [100525,100526,100527,100528,100476,100477,100505,100506,100540,100541,100530,100531,100535,100536,100572,100573]
                    if prvids.contains(QiwiOrder.getPrvID()) {
                        self.viewTransportInstructions.hide72HourRemaining()
                    }
                    
                    if ActionFinder.isRechargeTransporCardUrbs(action: QiwiOrder.selectedMenu.action) {
                        self.viewTransportInstructions.showUrbsCondition()
                    }
                } else {
                    self.viewTransportInstructions.hideUrbsAlert()
                }
            }
            
            if self.mOrder?.prvId == ActionFinder.Prvids.ULTRAGAZ && !(self.mOrder?.valeGas.isEmpty ?? true) {
                self.viewUltragaz.setCode(code: self.mOrder?.valeGas ?? "")
                self.viewUltragaz.isHidden = false
            }
            
            if self.mOrder?.hasCashback ?? false {
                self.viewCashback.controller = self
                self.viewCashback.orderId = self.mOrder?.id ?? 0
                self.viewCashback.value = self.mOrder?.cashbackValue ?? 0
                self.viewCashback.showView()
                self.viewCashback.isHidden = false
            }
        }
        else if mOrder != nil && mOrder?.status == Order.Status.pendent {
            image = "ic_pending"
            title = "checkout_success_pendent".localized
            desc = "checkout_success_finished_desc".localized
            buttonText = "checkout_button_go_to_orders".localized
            buttonColor = Theme.default.yellow
            
            if QiwiOrder.checkoutBody.transition?.bankRequest != nil {
                self.viewBankInfo.setBankInfo(bank: BankDAO().get(primaryKey: self.mBankId!), value: QiwiOrder.checkoutBody.transition?.transitionValue ?? 0)
                self.viewBankInfo.isHidden = false
            }
            
            if QiwiOrder.checkoutBody.transition?.pix != nil  {
                self.viewPIXInfo.sender = self
                self.viewPIXInfo.setValue(value: QiwiOrder.getTransitionValue())
                self.viewPIXInfo.isHidden = false
            }
            
            //fix
            //criar regra para chamada de nova API, para recuperar o texto do pix copia e cola.
            if QiwiOrder.checkoutBody.transition?.pix_v2 != nil {
                if self.mConsultaPix?.qrCodePayload != "" {
                    self.viewPIXInfo.sender = self
                    self.viewPIXInfo.setValue(value: QiwiOrder.getTransitionValue())
                    self.viewPIXInfo.lbKey.text = self.mConsultaPix?.qrCodePayload
                    self.viewPIXInfo.lbDesc.text = "payments_method_pix_v2".localized.lowercased()
                    self.viewPIXInfo.lbTimeLimit.text = "Clique em copiar e cole na área Pix do seu banco para finalizar o pagamento.\rO PIX deve ser realizado em até 10 minutos!"
                    self.viewPIXInfo.lbTitle.text = "Chave PIX"
                    self.viewPIXInfo.isHidden = false
                }
            }
            
            if QiwiOrder.isPayingWithPrePago() && !UserRN.canShowReceiptPrePago() {
                buttonText = "checkout_button_go_to_orders_menu".localized
                self.viewStatusOrder.btnSee.addTarget(self, action: #selector(onClickBackToMenu), for: .touchUpInside)
            } else {
                self.viewStatusOrder.btnSee.addTarget(self, action: #selector(onClickOrderDetails), for: .touchUpInside)
            }
            
//            let showView = QiwiOrder.isPayingWithBankTransfer() && QiwiOrder.checkoutBody.transition.bankRequest?.bankId == ActionFinder.Bank.CAIXA
//            self.viewCaixaEconomica.setOrderId(orderId: self.mOrder!.id)
//            self.viewCaixaEconomica.isHidden = !showView
        } else {
            image = "ic_red_error"
            title = "checkout_failed".localized
            desc = "checkout_failed_desc".localized
            buttonText = "checkout_button_go_to_orders_menu".localized
            buttonColor = Theme.default.red
            
            if mOrder != nil && mOrder?.obs != nil && !(mOrder?.obs?.isEmpty)! {
                self.viewStatusOrder.btReason.isHidden = false
            }
            self.viewStatusOrder.btnSee.addTarget(self, action: #selector(onClickBackToMenu), for: .touchUpInside)
        }
        
        let uiimage = UIImage(named: image)
        self.viewStatusOrder.imgIconType.image = uiimage
        self.viewStatusOrder.lbStatus.text = title
        self.viewStatusOrder.lbInfo.text = desc
        self.viewStatusOrder.btnSee.setTitle(buttonText)
        self.viewStatusOrder.btnSee.backgroundColor = buttonColor
        self.viewStatusOrder.btReason.addTarget(self, action: #selector(onClickReason), for: .touchUpInside)
        
        QiwiOrder.sendContact(param: Param.Contact.NEED_UPDATE_DATA)
    }
    
    @objc func onClickShare() {
        Util.snapShotView(self, view: self.viewStatusOrder.viewReceipt.textReceipt)
    }
    
    @objc func onClickReason() {
        Util.showAlertDefaultOK(self, message: (mOrder?.obs)!)
    }
    
    @objc func onClickSendReceipt() {
        Util.showLoading(self)
        self.checkoutRN.resendReceipt(phone: self.mPhone, orderId: self.mOrder!.id)
    }
    
    @objc func onClickBackToMenu() {
        self.btnClose()
    }
    
    @objc func onClickOrderDetails() {
        self.performSegue(withIdentifier: Constants.Segues.ORDER_DETAIL, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.ORDER_DETAIL {
            if let vc = segue.destination as? OrderDetailViewController {
                // Passa item
                vc.orderId = (self.mOrder?.id)!
            }
            return
        }
        
        if segue.identifier == Constants.Segues.SHOW_RECEIPT {
            if let navigtionController = segue.destination as? UINavigationController {
                if let receiptViewController = navigtionController.topViewController as? ReceiptViewController {
                    receiptViewController.text = self.textReceipt
                }
            }
        }
    }
}

extension CheckoutInfoViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            if param == Param.Contact.CHECKOUT_RESEND_RECEIPT_RESPONSE {
                self.dismissPage(nil)
                
                if result {
                    self.viewStatusOrder.showSentMessage(phone: self.mPhone)
                    self.viewStatusOrder.startResendTimer()
                }
            }
        }
    }
}
