//
//  MenuItemDataHandler.swift
//  MyQiwi
//
//  Created by ailton on 01/01/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import UIKit

class MenuItemDataHandler: BaseDataHandler<MenuItem> {

    lazy var mMenuItemRN = MenuItemRN()
    lazy var mPhoneRechargeRN = PhoneRechargeRN(delegate: self)
    lazy var mPaymentRN = PaymentRN(delegate: self)
    lazy var mBankRN = BankRN(delegate: self)
    lazy var mTransportRN = TransportCardRN(delegate: self)
    lazy var mTransportUrbsRN = TransportCardUrbsRN(delegate: self)
    var delegate: BaseDelegate?
    var menuType: Int = 0
    var transportTypes: [TransportTypeResponse]?
    var transportTypesCittaMobi: [TransportCittaMobiTypeResponse]?
    var transportTypeProdata: TransportProdataCreditType?

    init(delegate: BaseDelegate?) {
        self.delegate = delegate
    }

    func fillAsMainMenuList() {
        self.arrItems = mMenuItemRN.getMainList()
    }

    func fillOperatorList() {
        mPhoneRechargeRN.getOperatorListAsMenuList()
    }

    func fillPhoneRechargeValues(ddd: String, operatorId: Int) -> Void {
        mPhoneRechargeRN.getAvailableListAsMenuList(ddd: ddd, operatorId: operatorId)
    }

    func fillTransportCardOptions() {
        mTransportRN.getTransportCardOptions(cardNumber: (QiwiOrder.checkoutBody.requestTransport?.cardNumber)!)
    }

    func fillTransportCardCittaMobiOptions() {
        mTransportRN.getTransportCardCittaMobiOptions(cardNumber: (QiwiOrder.checkoutBody.requestTransportCittaMobi?.cardNumber)!)
    }
    
    func fillTransportCardProdataOptions() {
        mTransportRN.getTransportCardProdataOptions(cardNumber: (QiwiOrder.checkoutBody.requestProdata?.cardNumber)!)
    }

    func fillTransportCardUrbsOptions() {
        mTransportUrbsRN.getChargeOptionsList(cardNumber: QiwiOrder.checkoutBody.requestUrbs!.cardNumber)
    }

    func fillUltragazValues() {
        UltragazRN(delegate: self).consultValues(lat: QiwiOrder.checkoutBody.requestUltragaz!.latitude, long: QiwiOrder.checkoutBody.requestUltragaz!.longitude)
    }

    func fillTransportCardWhereWillUse() {
        self.arrItems = mTransportRN.getTransportTypeOptions(menuType: self.menuType, transportTypes: self.transportTypes!)
    }

    func fillTransportValues() {
        self.arrItems = self.convertValuesToMenuList(values: mTransportRN.getAvailableValues(limiteMax: Int(QiwiOrder.transportTypeSelected!.maxAmount)))
    }

    func fillTransportCittaMobiValues() {
        self.arrItems = self.convertValuesToMenuList(values: mTransportRN.getAvailableValues(limiteMax: Int(QiwiOrder.transportTypeCittaMobiSelected!.maxValue)))
    }
    
    func fillTransportProdataValues() {
        
        if QiwiOrder.transportProdataProduct != nil && QiwiOrder.transportProdataProduct!.isQuota {
            self.arrItems = self.convertValuesToMenuList(values: mTransportRN.getAvailableValues(limiteMin: QiwiOrder.transportProdataProduct!.minValue, limiteMax: QiwiOrder.transportProdataProduct!.maxValue))
        } else {
            let limit = PaymentRN.getMaxValueForProduct(prvid: QiwiOrder.getPrvID())
            self.arrItems = self.convertValuesToMenuList(values: mTransportRN.getAvailableValues(limiteMax: limit))
        }
    }

    func fillTransportUrbsValues() {
        self.arrItems = self.convertValuesToMenuList(values: mTransportUrbsRN.getAvailableValues(limiteMax: Int(QiwiOrder.urbsBalanceSelected!.maxRechargeValue*100)))
    }

    func fillMetrocardValueList() {
        self.arrItems = self.convertValuesToMenuList(values: MetrocardRN(delegate: self).getAvailableValues(limiteMax: QiwiOrder.maxValue))
    }

    func fillInternationalPhoneList() {
        self.arrItems = self.convertInternationalPhoneValueToList(values: QiwiOrder.internationalPhoneValueList!)
    }

    func fillDonationList() {
        self.arrItems = self.convertValuesToMenuList(values: DonationRN(delegate: self).getValueList())
    }

    func fillPaymentList() {
        self.arrItems = mPaymentRN.getAvailablePaymentMethods()
    }

    func fillBankList() {
        self.arrItems = mBankRN.getBankList()
    }

    func fillQiwiChargeValues() {
        self.arrItems = self.convertValuesToMenuList(values: PaymentRN(delegate: self).getQiwiRechargeAvailableValues())
    }

    func fillQiwiTransferValues() {
        self.arrItems = self.convertValuesToMenuList(values: CreditQiwiTransferRN(delegate: self).getValueList(balance: QiwiOrder.userBalance))
    }

    func fillRvValueList(prvId: Int) {
        self.arrItems = mPaymentRN.getAvailableRvValuesAsMenu(prvId: prvId)
    }

    func fillPinofflineValueList(prvId: Int) {
        self.arrItems = mPaymentRN.getAvailablePinofflineValuesAsMenu(prvId: prvId)
    }

    func fillIncommValueList(prvId: Int) {
        self.arrItems = mPaymentRN.getAvailableIncommValuesAsMenu(prvId: prvId)
    }

    func fillAvailableQiwiTransferValues(balance: Int) {
        self.arrItems = self.convertValuesToMenuList(values: CreditQiwiTransferRN(delegate: self).getValueList(balance: balance))
    }

    func fillDrTerapiaValueList() {
        PaymentRN(delegate: self).getDrTerapiaValues();
    }
}

extension MenuItemDataHandler {

    func convertValuesToMenuList(values: [Int]) -> [MenuItem] {
        var menus: [MenuItem] = []
        //convenience init(description: String, image: String, action: Int, id: Int, data: AnyObject?)
        for value in values {
            menus.append(MenuItem(description: Util.formatCoin(value: value), data: value as AnyObject))
        }

        return menus
    }

    func convertInternationalPhoneValueToList(values: [InternationalValue]) -> [MenuItem] {
        var menus: [MenuItem] = []

        //convenience init(description: String, image: String, action: Int, id: Int, data: AnyObject?)
        for value in values {
            menus.append(MenuItem(description: Util.formatCoin(value: value.originalValue, currency: value.currency), data: value as AnyObject))
        }

        return menus
    }

    func convertUltragazToValueList(products: [UltragazProduct]) -> [MenuItem] {
        var menus: [MenuItem] = []

        for p in products {
            menus.append(MenuItem(description: Util.formatCoin(value: p.value), data: p))
        }
        return menus
    }

    func convertDrTerapiaValuesToList(values: [DrTerapiaValue]) -> [MenuItem] {
        var menus: [MenuItem] = []

        //convenience init(description: String, image: String, action: Int, id: Int, data: AnyObject?)
        for value in values {
            menus.append(MenuItem(description: Util.formatCoin(value: value.value), descAux: value.desc, data: value as AnyObject))
        }

        return menus
    }
}

// MARK: Delegate Base
extension MenuItemDataHandler: BaseDelegate {

    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {

        if (param == Param.Contact.NET_REQUEST_ERROR) {
            self.delegate?.onReceiveData(fromClass: MenuItemDataHandler.self, param: param, result: result, object: object)
            return
        }

        if fromClass == UltragazRN.self {
            if param == Param.Contact.ULTRAGAZ_VALUES_RESPONSE {
                if result {
                    self.arrItems = self.convertUltragazToValueList(products: object as! [UltragazProduct])
                }
                self.delegate?.onReceiveData(fromClass: MenuItemDataHandler.self, param: param, result: result, object: object)
            }
        }

        //If its telling to finish
        if (fromClass == PhoneRechargeRN.self) {
            if (param == Param.Contact.PHONE_RECHARGE_OP_LIST_AS_MENU_RESPONSE) {
                if (result) {
                    self.arrItems = (object as! [MenuItem])
                }
                self.delegate?.onReceiveData(fromClass: MenuItemDataHandler.self, param: param, result: result, object: object)
            }
        }

        if fromClass == TransportCardUrbsRN.self {
            if param == Param.Contact.TRANSPORT_CARD_URBS_AVAILABLE_CARDS_RESPONSE {
                self.arrItems = object as! [MenuItem]
                self.delegate?.onReceiveData(fromClass: MenuItemDataHandler.self, param: param, result: result, object: object)
            }
        }

        if fromClass == PaymentRN.self {
            if param == Param.Contact.DRTERAPIA_VALUES_RESPONSE {
                if result {
                    self.arrItems = convertDrTerapiaValuesToList(values: object as! [DrTerapiaValue])
                }

                self.delegate?.onReceiveData(fromClass: fromClass, param: param, result: result, object: object)
            }
        }

        if fromClass == TransportCardRN.self {
            if param == Param.Contact.TRANSPORT_CARD_CONSULT_RESPONSE {
                if !result {
                    self.delegate?.onReceiveData(fromClass: MenuItemDataHandler.self, param: Param.Contact.NET_REQUEST_ERROR, result: false, object: object)
                } else {
                    self.transportTypes = (object as! [TransportTypeResponse])
                    self.arrItems = self.mTransportRN.getTransportChargeOptions(transportTypes: self.transportTypes!)
                    self.delegate?.onReceiveData(fromClass: MenuItemDataHandler.self, param: param, result: result, object: object)
                }
            }

            if param == Param.Contact.TRANSPORT_CARD_CITTAMOBI_CONSULT_RESPONSE {
                if !result {
                    self.delegate?.onReceiveData(fromClass: MenuItemDataHandler.self, param: Param.Contact.NET_REQUEST_ERROR, result: false, object: object)
                } else {
                    self.transportTypesCittaMobi = (object as! [TransportCittaMobiTypeResponse])
                    self.arrItems = self.mTransportRN.getTransportChargeOptionsCittaMobi(transportTypes: self.transportTypesCittaMobi!)
                    self.delegate?.onReceiveData(fromClass: MenuItemDataHandler.self, param: param, result: result, object: object)
                }
            }
            
            if param == Param.Contact.TRANSPORT_CARD_PRODATA_CONSULT_RESPONSE {
                if !result {
                    self.delegate?.onReceiveData(fromClass: MenuItemDataHandler.self, param: Param.Contact.NET_REQUEST_ERROR, result: false, object: object)
                } else {
                    self.transportTypeProdata = (object as! TransportProdataCreditType)
                    QiwiOrder.checkoutBody.requestProdata?.creditTypeId = self.transportTypeProdata!.typeCreditId
                    
                    self.arrItems = self.mTransportRN.getTransportChargeOptionsProdata(transportTypes: self.transportTypeProdata!.products)
                    self.delegate?.onReceiveData(fromClass: MenuItemDataHandler.self, param: param, result: result, object: object)
                }
            }
        }
    }
}
