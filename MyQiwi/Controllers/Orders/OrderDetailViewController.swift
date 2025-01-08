//
//  OrderDetailViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 08/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIBaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lbProductName: UILabel!
    
    @IBOutlet weak var lbLabelOrderNumber: UILabel!
    @IBOutlet weak var lbOrderNumber: UILabel!
    
    @IBOutlet weak var lbLabelOrderDate: UILabel!
    @IBOutlet weak var lbOrderDate: UILabel!
    
    @IBOutlet weak var lbLabelOrderPaymentMethod: UILabel!
    @IBOutlet weak var lbOrderPaymentMethod: UILabel!
    
    @IBOutlet weak var lbLabelOrderStatus: UILabel!
    @IBOutlet weak var lbOrderStatus: UILabel!
    @IBOutlet weak var btnSeeReasonCancelled: UIButton!
    
    @IBOutlet weak var lbLabelOrderPrice: UILabel!
    @IBOutlet weak var lbOrderPrice: UILabel!
    
    @IBOutlet weak var lbLabelOrderSelectedBank: UILabel!
    @IBOutlet weak var lbOrderSelectedBank: UILabel!
    @IBOutlet weak var svSelectedBank: UIStackView!
    @IBOutlet weak var lbDescOrderDetails: UILabel!
    @IBOutlet weak var lbOrderDetails: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var viewTransportInstructions: ViewTransportInstructions!
    @IBOutlet weak var viewProductInfo: UIView!
    @IBOutlet weak var viewReceipt: ViewReceipt!
    @IBOutlet weak var viewBankInfo: ViewBankInfo!
    @IBOutlet weak var viewEmpty: ViewEmpty!
    @IBOutlet weak var viewDetails: UIStackView!
    @IBOutlet weak var viewCaixaEconomica: ViewCaixaEconomica!
    @IBOutlet weak var viewCashback: ViewCashback!
    @IBOutlet weak var viewUltragaz: ViewUltragazVouncher!
    @IBOutlet weak var viewPIXInfo: ViewPIXInfo!
    
    @IBOutlet weak var viewResendReceipt: UIStackView!
    @IBOutlet weak var lbReceiptSentTo: UILabel!
    @IBOutlet weak var lbReceiptTimer: UILabel!
    @IBOutlet weak var btnResendReceipt: UIButton!
    
    // MARK: Variables
    lazy var checkoutRN = CheckoutRN(delegate: self)
    var orderId: Int = 0
    var transitionId: Int = 0
    var transitionDate: String = ""
    var order: Order?
    var consultaPIX: ConsultaPIX?
    var canUpdate = true
    var canShowReceipt = true
    var updateOrderProtocol: UpdateOrderProtocol?
    
    private var textReceipt: String?
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
    }
    
    override func setupViewWillAppear() {
        
        if self.canUpdate {
            self.updateOrder()
        } else {
            self.canUpdate = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onClickReason(_ sender: Any) {
        Util.showAlertDefaultOK(self, message: self.order!.obs!)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        if self.viewCashback.cashBackApplied {
            self.updateOrderProtocol?.updateOrder()
        }
        
        self.popPage()
    }
}

// MARK: Prepare For Segue

extension OrderDetailViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.Segues.SHOW_RECEIPT {
            
            if let navigtionController = segue.destination as? UINavigationController {
                if let receiptViewController = navigtionController.topViewController as? ReceiptViewController {
                    receiptViewController.isTelesena = self.order?.prvId == ActionFinder.Prvids.TELESENA
                    receiptViewController.text = self.textReceipt
                }
            }
        }
    }
}

// MARK: IBActions

extension OrderDetailViewController {
    
    @IBAction func clickShare(sender: UIButton) {
        
        self.takePhotoView()
    }
}

// MARK: Custom Methods
extension OrderDetailViewController {
    
    @objc fileprivate func takeImageView() {
        self.textReceipt = self.viewReceipt.textReceipt.text
        DispatchQueue.main.async {
            self.canUpdate = false
            self.performSegue(withIdentifier: Constants.Segues.SHOW_RECEIPT, sender: nil)
        }
    }
    
    fileprivate func takePhotoView() {
        Util.snapShotView(self, view: self.viewReceipt.stackView)
    }
    
    func getOrder() {
        if self.orderId != 0 {
            OrderRN(delegate: self).getOrder(orderNumber: self.orderId)
        } else {
            if self.transitionDate.isEmpty {
                OrderRN(delegate: self).getTransaction(transactionId: self.transitionId)
            } else {
                OrderRN(delegate: self).getTransactionNew(transactionId: self.transitionId, transitionDate: self.transitionDate)
            }
            
        }
    }
    
    func updateOrder() {
        hideAll()
        
        Util.showLoading(self) {
            self.getOrder()
        }
    }
    
    func showProduct() {
        
        self.hideAll()
        
        // Não tendo conteudo
        guard let orderDetail = self.order else {
            
            // Mostrar vazio
            self.viewEmpty.isHidden = true
            return
        }

        // Texto navigation
        Util.setTextBarIn(self, title: "order_toolbar_title".localized
            .replacingOccurrences(of: "{number}", with: String(orderDetail.getOrderOrTransitionId())))
        
        if orderDetail.status == .canceled && orderDetail.obs != nil && !(orderDetail.obs?.isEmpty)! {
            self.btnSeeReasonCancelled.isHidden = false
        }
        
        //MOCKED TELE SENA
//        orderDetail.prvId = 100250
//        orderDetail.name = "Tele Sena"
//        var s = ""
//        s = "========================================\r"
//        s += "Telesena\r"
//        s += "========================================\r"
//        s += "Lideranca Capitalizacao S/A\r"
//        s += "CNPJ: 60.853.264/0001-10\r"
//        s += "Data/Hora: 07/10/2020 13:51:50\r"
//        s += "----------------------------------------\r"
//        s += "Numero da Transacao QIWI: 16181\r"
//        s += "No do Pedido: 489-1244460-0\r"
//        s += "----------------------------------------\r"
//        s += "Telesena 29 Aniversario\r"
//        s += "PROC Susep Numero:15414.610500/2020-11\r"
//        s += "Data Resgate:08/11/2021\r"
//        s += "\r"
//        s += "\r"
//        s += "Produto: 3\r"
//        s += "Serie: 197\r"
//        s += "Titulo: 4141125  Dv: 0\r"
//        s += "----------------------------------------\r"
//        s += "Valor Total: R$ 12,00\r"
//        s += "----------------------------------------\r"
//        s += "Aprovado pela Superintendencia de\r"
//        s += "Seguros Privados - SUSEP.  Consulte as\r"
//        s += "condicoes gerais e preencha\r"
//        s += "a Ficha de Cadastro obrigatoria no site\r"
//        s += "www.telesena.com.br\r"
//        s += "----------------------------------------\r"
//        s += "Acesse o link abaixo\r"
//        s += "stg.telesena.digital/BoBLB\r"
//        s += "----------------------------------------\r"
//        s += "\r"
//
//        orderDetail.receipt = s
        
        var discountValue = Double()
        var orderValue = Double(orderDetail.value)
        
        for c in QiwiOrder.coupons ?? [] {
            discountValue += c.value
        }
        
        // Info produto
        self.imgProduct.image = UIImage(named: String(orderDetail.prvId)) ?? nil
        self.lbProductName.text = orderDetail.name
        self.lbOrderNumber.text = String(orderDetail.getOrderOrTransitionId())
        self.lbOrderDate.text = Util.formatDate(orderDetail.getOrderDate())
        self.lbOrderStatus.text = orderDetail.getStatusOrder()
        if QiwiOrder.isPayingWithCoupon() {
            self.lbOrderPrice.text = Util.formatCoin(value: Double(orderValue-discountValue/100))
        } else {
            self.lbOrderPrice.text = Util.formatCoin(value: orderDetail.value)
        }
        //self.lbOrderPrice.text = Util.formatCoin(value: orderDetail.value)
        
        if !orderDetail.details.isEmpty {
            self.viewDetails.isHidden = false
            self.viewDetails.superview?.isHidden = false
            self.lbOrderDetails.text = orderDetail.details
        } else {
            self.viewDetails.isHidden = true
            self.viewDetails.superview?.isHidden = true
        }
        
        if orderDetail.getPaymentOrder().isEmpty {
            self.lbLabelOrderPaymentMethod.isHidden = true
            self.lbOrderPaymentMethod.isHidden = true
        } else {
            self.lbLabelOrderPaymentMethod.isHidden = true
            self.lbOrderPaymentMethod.isHidden = true
            self.lbOrderPaymentMethod.text = orderDetail.getPaymentOrder()
        }
        
        if orderDetail.paymentMethod == .pre_pago && orderDetail.status == .finished && !UserRN.canShowReceiptPrePago() {
            self.viewResendReceipt.isHidden = false
            self.lbReceiptSentTo.isHidden = true
            self.lbReceiptTimer.isHidden = true
            
            self.btnResendReceipt.addTarget(self, action: #selector(onClickSendReceipt), for: .touchUpInside)
        } else {
            
            self.viewResendReceipt.isHidden = true
        }

        self.svSelectedBank.isHidden = true
        if orderDetail.paymentMethod.rawValue == ActionFinder.Payments.BANK_TRANSFER {
            var bankInfo = orderDetail.bankAgency! + " // " + orderDetail.bankAccount!
            
            if orderDetail.bankAccountDv != nil && !(orderDetail.bankAccountDv?.isEmpty)! {
                bankInfo = bankInfo + "-" + orderDetail.bankAccountDv!
            }
            
            let bank = PaymentRN(delegate: self).getBank(bankId: orderDetail.bankId!)
            bankInfo = bankInfo + " (" + bank.bankName + ")"
            self.lbOrderSelectedBank.text = bankInfo
            self.svSelectedBank.isHidden = false
            
            if orderDetail.status == .pendent {
                self.viewBankInfo.setBankInfo(bank: bank, value: self.order?.value ?? 0)
                self.viewBankInfo.isHidden = false
            }
        }
        
        if orderDetail.paymentMethod.rawValue == ActionFinder.Payments.PIX {
            if orderDetail.status == .pendent {
                self.viewPIXInfo.sender = self
                self.viewPIXInfo.setValue(value: self.order?.value ?? 0)
                if self.consultaPIX?.qrCodePayload != "" {
                    self.viewPIXInfo.lbKey.text = self.consultaPIX?.qrCodePayload
                    self.viewPIXInfo.lbDesc.text = "payments_method_pix_v2".localized.lowercased()
                    self.viewPIXInfo.lbTimeLimit.text = "Clique em copiar e cole na área Pix do seu banco para finalizar o pagamento.\rO PIX deve ser realizado em até 10 minutos!"
                    self.viewPIXInfo.lbTitle.text = "Chave PIX"
                }
                self.viewPIXInfo.isHidden = false
            }
        }
        
        if orderDetail.receipt.isEmpty || (!self.canShowReceipt && !UserRN.canShowReceiptPrePago()) {
            self.btnShare.isHidden = true
            self.viewReceipt.isHidden = true
//            self.viewReceipt.lbLabelReceipt.isHidden = true
//            self.viewReceipt.textReceipt.isHidden = true
            self.viewReceipt.textReceipt.text = ""
        } else {
            self.btnShare.isHidden = false
            self.viewReceipt.isHidden = false
//            self.viewReceipt.lbLabelReceipt.isHidden = false
//            self.viewReceipt.textReceipt.isHidden = false
            self.viewReceipt.setReceipt(receipt: orderDetail.receipt, isTelesena: orderDetail.prvId == ActionFinder.Prvids.TELESENA)
        }
        
        // Mostra views
        self.viewProductInfo.isHidden = false
        
        if ActionFinder.isPrvIdFromAnyTransportCharge(prvId: orderDetail.prvId) && orderDetail.status == .finished {
            self.viewTransportInstructions.isHidden = false
            
            if ActionFinder.isPrvFromUrbs(prvId: orderDetail.prvId) {
                self.viewTransportInstructions.showUrbsAlert(rechargeDate: self.order!.date)
            } else {
                self.viewTransportInstructions.hideUrbsAlert()
            }
        }
        
//        if orderDetail.isCaixaOrder() {
//            self.viewCaixaEconomica.isHidden = false
//            
//            if orderDetail.isCaixaOrderCodeSent() {
//                self.viewCaixaEconomica.setCaixaCode(orderId: self.orderId, caixaCode: orderDetail.complement)
//            } else {
//                self.viewCaixaEconomica.setOrderId(orderId: self.orderId)
//            }
//        }
        
        if orderDetail.status == .finished && orderDetail.prvId == ActionFinder.Prvids.ULTRAGAZ {
            self.viewUltragaz.setCode(code: orderDetail.valeGas)
            self.viewUltragaz.isHidden = false
        }
        
        if self.order?.hasCashback ?? false {
            self.viewCashback.controller = self
            self.viewCashback.orderId = self.order?.id ?? 0
            self.viewCashback.value = self.order?.cashbackValue ?? 0
            self.viewCashback.showView()
            self.viewCashback.isHidden = false
        }
        
        self.changeColorOrderStatus(orderStatus: orderDetail.status)
    }
    
    @objc func onClickSendReceipt() {
        Util.showLoading(self)
        self.checkoutRN.resendReceipt(phone: "11111111111", orderId: self.orderId)
    }
}

// MARK: Control UI
extension OrderDetailViewController {
    
    func hideAll() {
        self.viewTransportInstructions.isHidden = true
        self.viewProductInfo.isHidden = true
        self.viewBankInfo.isHidden = true
        self.viewEmpty.isHidden = true
        self.btnSeeReasonCancelled.isHidden = true
        self.viewCaixaEconomica.isHidden = true
        self.viewCashback.isHidden = true
        self.viewUltragaz.isHidden = true
        self.viewPIXInfo.isHidden = true
    }
    
    func changeColorOrderStatus(orderStatus: Order.Status) {
        
        switch orderStatus {
        case .canceled:
            self.lbOrderStatus.textColor = Theme.default.red
            break
        case .pendent:
            self.lbOrderStatus.textColor = Theme.default.orange
            break
        case .finished:
            self.lbOrderStatus.textColor = Theme.default.green
            break
        }
    }
    
    func showWarning() {
        Util.showController(WarningViewController.self, sender: self, completion: { controller in controller.getLogoutIntent() })
    }
    
    func startResendTimer() {
        
        if self.timer != nil {
            self.timer?.invalidate()
        }
        
        self.btnResendReceipt.isEnabled = false
        
        var count = 60
        let textTimer = "order_timer".localized
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            
            if count == 0 {
                self.lbReceiptTimer.isHidden = true
                self.timer?.invalidate()
                self.btnResendReceipt.isEnabled = true
                return
            }

            self.lbReceiptTimer.isHidden = false
            self.lbReceiptTimer.text = textTimer.replacingOccurrences(of: "{sec}", with: String(count))
            count = count - 1
        })
    }
}

//Param.Contact.ORDERS_ORDER_RESPONSE
extension OrderDetailViewController: BaseDelegate {
   
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            
            if param == Param.Contact.CHECKOUT_RESEND_RECEIPT_RESPONSE {
                self.dismiss(animated: true, completion: nil)
                
                if result {
                    self.startResendTimer()
                }
            }
            
            if param == Param.Contact.ORDERS_ORDER_RESPONSE || param == Param.Contact.ORDERS_TRANSACTION_RESPONSE {
                //remove o loading
                self.dismiss(animated: true, completion: nil)
                
                if UserRN.hasLoggedUser(){
                    Util.removeNeedLogin(self)
                    
                    if result {
                        self.order = (object as! Order)
                    } else {
                        self.order = nil
                    }
                    
                    self.showProduct()
                } else {
                    self.dismissPage(self.order)
                    self.showWarning()
                }
            }
            
            if param == Param.Contact.ORDERS_PIX_RESPONSE {
                //remove o loading
                self.dismiss(animated: true, completion: nil)
                
                if UserRN.hasLoggedUser(){
                    Util.removeNeedLogin(self)
                    
                    if result {
                        let array = (object as! Array<Any>)
                        self.consultaPIX = (array[0] as! ConsultaPIX)
                        self.order = (array[1] as! Order)
                    } else {
                        self.order = nil
                    }
                    
                    self.showProduct()
                } else {
                    self.dismissPage(self.order)
                    self.showWarning()
                }
            }
            
        }
    }
}

// MARK: SetupUI

extension OrderDetailViewController: SetupUI {
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        self.setupProductInfo()
        
        viewReceipt.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(takeImageView)))
    }
    
    func setupTexts() {
        self.btnShare.setTitle("order_share_button".localized, for: .normal)
        self.btnResendReceipt.setTitle("order_resend_button".localized, for: .normal)
        self.viewEmpty.lbEmpty.text = "order_order_not_found".localized
    }
    
    func setupProductInfo() {
        
        Theme.OrderDetail.textAsProductName(self.lbProductName)
        
        Theme.OrderDetail.textAsLabel(self.lbLabelOrderNumber)
        Theme.OrderDetail.textAsLabel(self.lbLabelOrderDate)
        Theme.OrderDetail.textAsLabel(self.lbLabelOrderPaymentMethod)
        Theme.OrderDetail.textAsLabel(self.lbLabelOrderStatus)
        Theme.OrderDetail.textAsLabel(self.lbLabelOrderPrice)
        Theme.OrderDetail.textAsLabel(self.lbLabelOrderSelectedBank)
        Theme.OrderDetail.textAsLabel(self.lbDescOrderDetails)
        
        Theme.OrderDetail.textAsLabelValue(self.lbOrderNumber)
        Theme.OrderDetail.textAsLabelValue(self.lbOrderDate)
        Theme.OrderDetail.textAsLabelValue(self.lbOrderPaymentMethod)
        Theme.OrderDetail.textAsLabelValue(self.lbOrderStatus)
        Theme.OrderDetail.textAsLabelValue(self.lbOrderPrice)
        Theme.OrderDetail.textAsLabelValue(self.lbOrderSelectedBank)
        Theme.OrderDetail.textAsLabelValue(self.lbOrderDetails)
        
        Theme.default.orageButton(self.btnShare)
        Theme.default.orageButton(self.btnResendReceipt)
    }
}
