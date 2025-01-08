//
//  PaymentRN.swift
//  MyQiwi
//
//  Created by ailton on 02/01/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class PaymentRN: BaseRN {
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    func updatePaymentLimitsForPreUser() {
        //AuthenticatedPaymentLimitPreUser
        
        var objectResponse = UpdatePreUserdataResponse()
        
        let serviceBody = getServiceBody(EmptyObject.self, objectData: EmptyObject())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedPaymentLimitPreUser, object: serviceBody)
        
        callApi(UpdatePreUserdataResponse.self, request: request) { (response) in
            
            //If failed to get the baptism response
            if response.sucess {
                objectResponse = (response.body?.data)!
                
                if !objectResponse.paymentLimits.isEmpty {
                    
                    for limit in objectResponse.paymentLimits {
                        if limit.minValue == 1 {
                            limit.minValue = 100
                        }
                    }
                    
                    PaymentTypeLimitPrvIdDAO().deleteAll()
                    PaymentTypeLimitPrvIdDAO().insert(with: objectResponse.paymentLimits)
                }
                
                if !objectResponse.incommValues.isEmpty {
                    
                    var pk = 0
                    for incommValue in objectResponse.incommValues {

                        pk += 1
                        incommValue.pk = pk
                        if incommValue.minValue <= 1 {
                            incommValue.minValue = 1
                        }
                    }

                    // Deletar todos
                    // Inserir todos novamente
                    IncommValueDAO().deleteAll()
                    IncommValueDAO().insert(with: objectResponse.incommValues)
                }
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: PaymentRN.self, param: Param.Contact.PAYMENT_GET_PAYMENTS_PRE_RESPONSE,
                             result: response.sucess, object: objectResponse as AnyObject)
        }
    }
    
    func getAvailableIncommValuesAsMenu(prvId: Int) -> [MenuItem] {
        let values: [IncommValue] = IncommValueDAO().get(prvid: prvId)
        var menus = [MenuItem]()
        
        //convenience init(description: String, image: String, action: Int, id: Int, data: AnyObject?)
        var desc = ""
        for value in values {
            if prvId == ActionFinder.PLAYSTATION_PLUS_PRVID {
                desc = value.desc.substring(0, value.desc.getCharIndex(char: "-"))
            } else {
                desc = ""
            }
            
            if (value.minValue == value.maxValue) {
                menus.append(MenuItem(description: Util.formatCoin(value: value.maxValue), descAux: desc, data: value as AnyObject))
            } else {
                menus.append(MenuItem(description: "select_value_other_value".localized, descAux: desc, data: value as AnyObject))
                QiwiOrder.minValue = Util.doubleToInt(value.minValue)
                QiwiOrder.maxValue = Util.doubleToInt(value.maxValue)
            }
        }
        
        return menus
    }
    
    func getAvailablePinofflineValuesAsMenu(prvId: Int) -> [MenuItem] {
        let values: [PinofflineValue] = PinofflineValueDAO().get(prvid: prvId)
        var menus = [MenuItem]()
        
        //convenience init(description: String, image: String, action: Int, id: Int, data: AnyObject?)
        for value in values {
            menus.append(MenuItem(description: Util.formatCoin(value: value.value), data: value as AnyObject))
        }
        
        return menus
    }
    
    func getAvailableRvValuesAsMenu(prvId: Int) -> [MenuItem] {
        let values: [RvValue] = RVDAO().getList(prvid: prvId)
        var menus = [MenuItem]()
        
        if values.count == 1 && values.first!.minValue != values.first!.maxValue {
            
            QiwiOrder.minValue = Util.doubleToInt(values.first!.minValue)
            QiwiOrder.maxValue = Util.doubleToInt(values.first!.maxValue)
            
            let rvValueOriginal = values.first!
            let rvValue = RvValue()
            rvValue.prvid = rvValueOriginal.prvid
            rvValue.prodCod = rvValueOriginal.prodCod
            rvValue.desc = rvValueOriginal.desc
            
            // try to add R$10
            if 1000 >= QiwiOrder.minValue && 1000 <= QiwiOrder.maxValue {
                menus.append(MenuItem(description: Util.formatCoin(value: 1000), data: RvValue(rvToCopy: rvValueOriginal, value: 10.0)))
            }
            
            // try to add R$30
            if 3000 >= QiwiOrder.minValue && 3000 <= QiwiOrder.maxValue {
                menus.append(MenuItem(description: Util.formatCoin(value: 3000), data: RvValue(rvToCopy: rvValueOriginal, value: 30.0)))
            }
            
            // try to add R$50
            if 5000 >= QiwiOrder.minValue && 5000 <= QiwiOrder.maxValue {
                menus.append(MenuItem(description: Util.formatCoin(value: 5000), data: RvValue(rvToCopy: rvValueOriginal, value: 50.0)))
            }
            
            // try to add R$10
            if 7000 >= QiwiOrder.minValue && 7000 <= QiwiOrder.maxValue {
                menus.append(MenuItem(description: Util.formatCoin(value: 7000), data: RvValue(rvToCopy: rvValueOriginal, value: 70.0)))
            }
            
            menus.append(MenuItem(description: "Outro", data: rvValueOriginal))
        }
        else {
            
            var min: Double = 999999999
            var max: Double = 0
            
            //convenience init(description: String, image: String, action: Int, id: Int, data: AnyObject?)
            for value in values {
                
                if value.minValue == value.maxValue {
                    menus.append(MenuItem(description: Util.formatCoin(value: value.maxValue), data: value as AnyObject))
                } else {
                    menus.append(MenuItem(description: "Outro", data: value as AnyObject))
                }
                
                if value.minValue < min {
                    min = value.minValue
                }
                
                if value.maxValue > max {
                    max = value.maxValue
                }
            }
            
            QiwiOrder.minValue = Util.doubleToInt(min)
            QiwiOrder.maxValue = Util.doubleToInt(max)
        }
        
        return menus
    }
    
    /**
     * Get the list of available values to recharge the Qiwi Account
     * @return A list of available values to recharge
     */
    func getQiwiRechargeAvailableValues() -> [Int] {
        
        var list: [Int] = []
        
        list.append(500)
        list.append(1000)
        list.append(3000)
        list.append(5000)
        list.append(10000)
        list.append(20000)
        list.append(-1)
        return list
    }
    
    public static func getMinValueForProduct(prvid: Int) -> Int {
        
        let payments = PaymentTypeLimitPrvIdDAO().getAll(prvid: prvid)
        var minValue = 99999999
        
        //If has values
        if !payments.isEmpty {
            for payment in payments {
                if payment.minValue < minValue && payment.prvId != 0 {
                    minValue = payment.minValue
                }
            }
        }
        //if has no value, min is 1000 (R$1)
        else {
            minValue = 100
        }
        
        if minValue < 100 {
            minValue = 100
        }
        
        return minValue
    }
    
    public static func getMaxValueForProduct(prvid: Int) -> Int {
        
        let payments = PaymentTypeLimitPrvIdDAO().getAll(prvid: prvid)
        var maxValue = 100
        
        //If has values
        if !payments.isEmpty {
            for payment in payments {
                if payment.maxValue > maxValue && payment.prvId != 0 {
                    maxValue = payment.maxValue
                }
            }
        }
        //if has no value, min is 1000 (R$1)
        else {
            maxValue = 100000
        }
        
        return maxValue
    }
    
    /**
     * Get the list of all payment limits. need to be called when a payment method is selected.
     *
     */
    public func getPaymentLimit(prvid: Int, paymentMethod: Int) -> PaymentTypeLimitPrvId {
        return PaymentTypeLimitPrvIdDAO().get(prvid: prvid, paymentId: paymentMethod)
    }
    
    /**
     * Get the list of all payment limits. need to be called when a payment method is selected.
     *
     */
    public func getPaymentLimits(prvid: Int) -> [String] {
        var str: [String] = []
        
        var limit = PaymentTypeLimitPrvIdDAO().get(prvid: prvid, paymentId: ActionFinder.Payments.CREDIT_CARD)
        str.append(limit.prvId != 0 ? Util.formatCoin(value: limit.minValue) : "payment_limit_unlimited".localized)
        str.append(limit.prvId != 0 ? Util.formatCoin(value: limit.maxValue) : "payment_limit_unlimited".localized)
        
        limit = PaymentTypeLimitPrvIdDAO().get(prvid: prvid, paymentId: ActionFinder.Payments.QIWI_BALANCE)
        str.append(limit.prvId != 0 ? Util.formatCoin(value: limit.minValue) : "payment_limit_unlimited".localized)
        str.append(limit.prvId != 0 ? Util.formatCoin(value: limit.maxValue) : "payment_limit_unlimited".localized)
        
        limit = PaymentTypeLimitPrvIdDAO().get(prvid: prvid, paymentId: ActionFinder.Payments.BANK_TRANSFER)
        str.append(limit.prvId != 0 ? Util.formatCoin(value: limit.minValue) : "payment_limit_unlimited".localized)
        str.append(limit.prvId != 0 ? Util.formatCoin(value: limit.maxValue) : "payment_limit_unlimited".localized)
        
        limit = PaymentTypeLimitPrvIdDAO().get(prvid: prvid, paymentId: ActionFinder.Payments.PIX)
        str.append(limit.prvId != 0 ? Util.formatCoin(value: limit.minValue) : "payment_limit_unlimited".localized)
        str.append(limit.prvId != 0 ? Util.formatCoin(value: limit.maxValue) : "payment_limit_unlimited".localized)
        
        limit = PaymentTypeLimitPrvIdDAO().get(prvid: prvid, paymentId: Order.Payment.pre_pago.rawValue)
        str.append(limit.prvId != 0 ? Util.formatCoin(value: limit.minValue) : "payment_limit_unlimited".localized)
        str.append(limit.prvId != 0 ? Util.formatCoin(value: limit.maxValue) : "payment_limit_unlimited".localized)
        
        return str
    }
    
    func valueIsAvailable(menu: MenuItem, paymentType: Int) -> MenuItem {
        menu.notAvailable = !self.valueIsAvailable(paymentType: paymentType)
        
        return menu
    }
    
    func valueIsAvailable(paymentType: Int) -> Bool {
        let checkoutRN = CheckoutRN(delegate: nil)
        
        let tax = checkoutRN.checkTaxesForPaymentMethod(prvId: QiwiOrder.getPrvID(), paymentType: paymentType)
        let valueWithTax = checkoutRN.getValueWithTax(tax: tax, value: QiwiOrder.getValue())
        let valueLimit = PaymentTypeLimitPrvIdDAO().get(prvid: QiwiOrder.getPrvID(), paymentId: paymentType)
        
        return valueWithTax >= valueLimit.minValue && valueWithTax <= valueLimit.maxValue
    }
    
    public func getAvailablePaymentMethods() -> [MenuItem] {
        
        var mainMenu = [MenuItem]()

        if !QiwiOrder.isQiwiCharge() {
            
            let creditCardLimit = getPaymentLimit(prvid: QiwiOrder.getPrvID(), paymentMethod: ActionFinder.Payments.CREDIT_CARD)
            
            if creditCardLimit.prvId > 0 {
                var menuCredit = MenuItem(id: ActionFinder.Payments.CREDIT_CARD, description: "payments_method_credit_card".localized.lowercased(), action: ActionFinder.Payments.CREDIT_CARD, imageMenu: "ic_creditcard", data: creditCardLimit.maxValue as AnyObject)
                menuCredit = valueIsAvailable(menu: menuCredit, paymentType: ActionFinder.Payments.CREDIT_CARD)
                mainMenu.append(menuCredit)
            }
            
            
            let qiwiCreditLimit = getPaymentLimit(prvid: QiwiOrder.getPrvID(), paymentMethod: ActionFinder.Payments.QIWI_BALANCE)
            
            if qiwiCreditLimit.prvId > 0 {
                var menuQiwiCredit = MenuItem(id: ActionFinder.Payments.QIWI_BALANCE, description: "payments_method_qiwi_account".localized.lowercased(), action: ActionFinder.Payments.QIWI_BALANCE, imageMenu: "ic_logo_piu_rounded_no_padding", data: qiwiCreditLimit.maxValue as AnyObject)
                menuQiwiCredit = valueIsAvailable(menu: menuQiwiCredit, paymentType: ActionFinder.Payments.QIWI_BALANCE)
                mainMenu.append(menuQiwiCredit)
            }
        }
        
        let pixLimit = getPaymentLimit(prvid: QiwiOrder.getPrvID(), paymentMethod: ActionFinder.Payments.PIX)
        if pixLimit.prvId > 0 {
            if ApplicationRN.isQiwiBrasil() {
                var menuPIX = MenuItem(id: ActionFinder.Payments.PIX, description: "payments_method_pix_v2".localized.lowercased(), action: ActionFinder.Payments.PIXV2, imageMenu: "ic_pix", data: pixLimit.maxValue as AnyObject)
                //valida limites que deve ser o mesmo do PIX antigo
                menuPIX = valueIsAvailable(menu: menuPIX, paymentType: ActionFinder.Payments.PIX)
                mainMenu.append(menuPIX)
                
            } else if ApplicationRN.isQiwiPro() {
                
                var menuPIX = MenuItem(id: ActionFinder.Payments.PIX, description: "payments_method_pix".localized.lowercased(), action: ActionFinder.Payments.PIX, imageMenu: "ic_pix", data: pixLimit.maxValue as AnyObject)
                menuPIX = valueIsAvailable(menu: menuPIX, paymentType: ActionFinder.Payments.PIX)
                mainMenu.append(menuPIX)
                
            }
        }
        
        /*
        let bankTransferLimit = getPaymentLimit(prvid: QiwiOrder.getPrvID(), paymentMethod: ActionFinder.Payments.BANK_TRANSFER)
        if bankTransferLimit.prvId > 0 {
            var menuBankTransfer = MenuItem(id: ActionFinder.Payments.BANK_TRANSFER, description: "payments_method_bank_transfer".localized.lowercased(), action: ActionFinder.Payments.BANK_TRANSFER, imageMenu: "ic_bank_transfer", data: bankTransferLimit.maxValue as AnyObject)
            menuBankTransfer = valueIsAvailable(menu: menuBankTransfer, paymentType: ActionFinder.Payments.BANK_TRANSFER)
            mainMenu.append(menuBankTransfer)
        }
         */
        
//        var menuPIX = MenuItem(id: ActionFinder.Payments.PIX, description: "payments_method_pix".localized.lowercased(), action: ActionFinder.Payments.PIX, imageMenu: "ic_pix", data: 10000 as AnyObject)
//        mainMenu.append(menuPIX)
        
        //Promocode
        if ApplicationRN.isQiwiBrasil() {
            let menuPromocode = MenuItem(id: ActionFinder.Payments.PROMO_CODE, description: "payments_method_promo_code".localized.lowercased(), action: ActionFinder.Payments.PROMO_CODE, imageMenu: "ic_divida")
            mainMenu.append(menuPromocode)
        }
        
        if QiwiOrder.isQiwiCharge() {
            //Dinheiro
            mainMenu.append(MenuItem(id: ActionFinder.Payments.MONEY, description: "payments_method_money".localized.lowercased(), action: ActionFinder.Payments.MONEY, imageMenu: "ic_payment_methods"))
            
            //Cartão de crédito no ATM
            mainMenu.append(MenuItem(id: ActionFinder.Payments.CREDIT_CARD_ATM, description: "payments_method_credit_card_atm".localized.lowercased(), action: ActionFinder.Payments.CREDIT_CARD_ATM, imageMenu: "ic_creditcard"))
        }
        
//        if ApplicationRN.isQiwiPro() && QiwiOrder.isQiwiCharge() {
//            mainMenu.append(MenuItem(id: ActionFinder.Payments.BILL, description: "payments_method_bill".localized.lowercased(), action: ActionFinder.Payments.BILL, imageMenu: "ic_barcode"))
//        }
        
        return mainMenu
    }
    
    public func getBank(bankId: Int) -> Bank {
        return BankDAO().get(primaryKey: bankId)
    }
    
    public func getSavedBankAccount(bankId: Int) -> [BankRequest] {
        return BankRequestDAO().getAllFromBank(bankId: bankId)
    }
    
    public func getAllSavedBankAccount() -> [BankRequest] {
        return BankRequestDAO().getAll()
    }
    
    public func GetSavedPixRequests() -> [PIXRequest] {
        return PIXRequestDAO().getAll()
    }
    
    public func removePIXRequestFromServer(pixRequest: PIXRequest) {
        
        // Create request
        let deleteItemBody = DeleteItemBody(pkId: pixRequest.serverpk)
        let serviceBody = updateJsonWithHeader(jsonBody: deleteItemBody.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedDeleteData, json: serviceBody)
        
        callApi(request: request) { (response) in
            
            //se removeu do server, removemos do banco
            if response.sucess {
                DispatchQueue.main.async {
                    PIXRequestDAO().delete(with: pixRequest)
                }
            }
            
            self.sendContact(fromClass: PaymentRN.self, param: Param.Contact.PHONE_RECHARGE_DELETE_PHONE_RESPONSE,
                             result: response.sucess, object: nil)
        }
    }
    
    func getUnavailablePayments(prvid: Int, value: Int) -> String {
        let checkoutRN = CheckoutRN(delegate: nil)
        var msg = "payment_limit_can_not_use".localized
        
        let taxCreditCard = checkoutRN.checkTaxesForPaymentMethod(prvId: QiwiOrder.getPrvID(), paymentType: ActionFinder.Payments.CREDIT_CARD)
        let taxQiwi = checkoutRN.checkTaxesForPaymentMethod(prvId: QiwiOrder.getPrvID(), paymentType: ActionFinder.Payments.QIWI_BALANCE)
        let taxPIX = checkoutRN.checkTaxesForPaymentMethod(prvId: QiwiOrder.getPrvID(), paymentType: ActionFinder.Payments.PIX)
        let taxBank = checkoutRN.checkTaxesForPaymentMethod(prvId: QiwiOrder.getPrvID(), paymentType: ActionFinder.Payments.BANK_TRANSFER)
        
        let hasCreditTax = checkoutRN.getValueWithTax(tax: taxCreditCard, value: value) >  getPaymentLimit(prvid: QiwiOrder.getPrvID(), paymentMethod: ActionFinder.Payments.CREDIT_CARD).maxValue
        
        let hasQiwiTax = checkoutRN.getValueWithTax(tax: taxQiwi, value: value) >  getPaymentLimit(prvid: QiwiOrder.getPrvID(), paymentMethod: ActionFinder.Payments.QIWI_BALANCE).maxValue
        
        let hasPIXTax = checkoutRN.getValueWithTax(tax: taxPIX, value: value) >  getPaymentLimit(prvid: QiwiOrder.getPrvID(), paymentMethod: ActionFinder.Payments.PIX).maxValue
        
        let hasBankTax = checkoutRN.getValueWithTax(tax: taxBank, value: value) >  getPaymentLimit(prvid: QiwiOrder.getPrvID(), paymentMethod: ActionFinder.Payments.BANK_TRANSFER).maxValue
        
        if hasCreditTax {
            msg += "payment_limit_type_credit_card".localized
        }
        
        if hasQiwiTax {
            if hasCreditTax && (hasBankTax || hasPIXTax) {
                msg += ", "
            }
            else if hasCreditTax {
                msg += " e "
            }
            
            msg += "payment_limit_type_qiwi_balance".localized
        }
        
        if hasPIXTax {
            if (hasCreditTax || hasQiwiTax) && hasBankTax {
                msg += ", "
            }
            else if hasCreditTax || hasQiwiTax {
                msg += " e "
            }
            
            msg += "payment_limit_type_pix".localized
        }
        
        if hasBankTax {
            if hasCreditTax || hasQiwiTax || hasPIXTax {
                msg += " e "
            }
            
            msg += "payment_limit_type_bank_transfer".localized
        }
        
        return msg
    }
    
    public func getQiwiPointList(latitude: Double, longitude: Double, raio: Int, isFirstConsult: Bool, paymentType: Int) {
        var points = [QiwiPoint]()
        
        // Create request
        let objRequest = QiwiPointListBody(latitude: latitude, longitude: longitude, raio: raio, isFirstConsult: isFirstConsult, paymentType: paymentType)
        let serviceBody = updateJsonWithHeader(jsonBody: objRequest.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedQiwiPointsMap, json: serviceBody)
        
        callApiForList(QiwiPoint.self, request: request) { (response) in
            
            if response.sucess {
                points = (response.body?.data)!
            }
            
            self.sendContact(fromClass: PaymentRN.self, param: Param.Contact.QIWIPOINTS_RESPONSE,
                             result: response.sucess, object: points as AnyObject)
        }
    }
    
    public func getDrTerapiaValues() {
        var values = [DrTerapiaValue]()
        
        // Create request
        let objRequest = DrTerapiaConsultValuesBody(prvid: QiwiOrder.getPrvID())
        let serviceBody = updateJsonWithHeader(jsonBody: objRequest.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedGetDrTerapiaValues, json: serviceBody)
        
        callApiForList(DrTerapiaValue.self, request: request) { (response) in
            
            if response.sucess {
                values = (response.body?.data)!
            }
            
            self.sendContact(fromClass: PaymentRN.self, param: Param.Contact.DRTERAPIA_VALUES_RESPONSE,
                             result: response.sucess, object: values as AnyObject)
        }
    }
    
//    public void getUnavailablePayments(final List<Tax> taxes, final long prvId, final long value) {
//
//    createThread(new Runnable() {
//    @Override
//    public void run() {
//    long mCreditValue = value, mQiwiValue = value, mTransferValue = value;
//    Tax creditTax = null, qiwiBalanceTax = null, transferTax = null, anyTax = null;
//    unavailablePayment.setValue(value);
//
//    if (taxes != null && !taxes.isEmpty()) {
//    for (Tax tax : taxes) {
//    long valueTax = CheckoutRN.getValueWithTax(tax, value);
//
//    if (tax.getPaymentTypeId() == ActionFinder.Payments.CREDIT_CARD) {
//    creditTax = tax;
//    mCreditValue = valueTax;
//    }
//
//    if (tax.getPaymentTypeId() == ActionFinder.Payments.QIWI_BALANCE) {
//    qiwiBalanceTax = tax;
//    mQiwiValue = valueTax;
//    }
//    if (tax.getPaymentTypeId() == ActionFinder.Payments.BANK_TRANSFER) {
//    transferTax = tax;
//    mTransferValue = valueTax;
//    }
//
//    if (tax.getPaymentTypeId() == ActionFinder.Payments.ANY_PAYMENT) {
//    mCreditValue = valueTax;
//    mQiwiValue = valueTax;
//    mTransferValue = valueTax;
//    anyTax = tax;
//    }
//    }
//    }
//
//    PaymentTypeLimitPrvId creditLimit = getDatabaseInstance().paymentTypesLimitPrvIdDAO().get(prvId, ActionFinder.Payments.CREDIT_CARD);
//    if (creditLimit != null) {
//    if (mCreditValue > creditLimit.getMaxValue()) {
//    unavailablePaymentsValues.add(new UnavailablePayment(creditTax == null ? anyTax : creditTax,creditLimit,mCreditValue == value ? value : mCreditValue,value));
//    }
//    }
//
//    PaymentTypeLimitPrvId creditQiwiLimit = getDatabaseInstance().paymentTypesLimitPrvIdDAO().get(prvId, ActionFinder.Payments.QIWI_BALANCE);
//    if (creditQiwiLimit != null) {
//    if (mQiwiValue > creditQiwiLimit.getMaxValue()) {
//    unavailablePaymentsValues.add(new UnavailablePayment(qiwiBalanceTax == null ? anyTax : qiwiBalanceTax,creditLimit,mQiwiValue == value ? value : mQiwiValue,value));
//
//    }
//    }
//
//    PaymentTypeLimitPrvId transferLimit = getDatabaseInstance().paymentTypesLimitPrvIdDAO().get(prvId, ActionFinder.Payments.BANK_TRANSFER);
//    if (transferLimit != null) {
//    if (mTransferValue > transferLimit.getMaxValue()) {
//    unavailablePaymentsValues.add(new UnavailablePayment(transferTax == null ? anyTax : transferTax,creditLimit,mTransferValue == value ? value : mTransferValue,value));
//    }
//    }
//
//    sendContact(Param.Contact.PAYMENT_BILL_VALUE_VALIDATION, !unavailablePaymentsValues.isEmpty(), unavailablePaymentsValues);
//    }
//    });
//    }
}
