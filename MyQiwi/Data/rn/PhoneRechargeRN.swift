//
//  PhoneRechargeRN.swift
//  MyQiwi
//
//  Created by ailton on 27/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import Foundation

class PhoneRechargeRN : BaseRN {
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    public func getMenuOperatorList() -> [MenuItem] {
        
        var mainMenu = [MenuItem]()
        
        mainMenu.append(MenuItem(id: 0, description: "Oi", action: 1, imageMenu: "menu_oi"))
        mainMenu.append(MenuItem(id: 0, description: "Claro", action: 2, imageMenu: "menu_claro"))
        mainMenu.append(MenuItem(id: 0, description: "Tim", action: 3, imageMenu: "menu_tim"))
        mainMenu.append(MenuItem(id: 0, description: "Nextel", action: 4, imageMenu: "menu_nextel"))
        mainMenu.append(MenuItem(id: 0, description: "Vivo", action: 5, imageMenu: "menu_vivo"))
        
        return mainMenu
    }
    
    public func getOperatorList() {
        
        var operators: [Operator] = []
        
        // Create request
        let serviceBody = getServiceBody(EmptyObject.self, objectData: EmptyObject())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedOperatorList, object: serviceBody)
        
        callApi(OperatorListResponse.self, request: request) { (operatorListResponse) in
            
            //If failed to get the baptism response
            if operatorListResponse.sucess {
                operators = (operatorListResponse.body?.data?.operators)!
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: PhoneRechargeRN.self, param: Param.Contact.PHONE_RECHARGE_OP_LIST_RESPONSE,
                             result: operatorListResponse.sucess, object: operators as AnyObject)
        }
    }
    
    public func getOperatorListAsMenuList() {
        
        var operators: [Operator] = []
        var menus: [MenuItem] = []
        
        // Create request
        let serviceBody = getServiceBody(EmptyObject.self, objectData: EmptyObject())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedOperatorList, object: serviceBody)
        
        callApi(OperatorListResponse.self, request: request) { (operatorListResponse) in
            
            //If failed to get the baptism response
            if operatorListResponse.sucess {
                operators = (operatorListResponse.body?.data?.operators)!
                
                for op in operators {
                    //(description: String, image: String, id: Int, data: Data?)
                    menus.append(MenuItem(description: op.name, image: op.imagePath, id: op.id, prvid: op.prvId, data: op))
                }
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: PhoneRechargeRN.self, param: Param.Contact.PHONE_RECHARGE_OP_LIST_AS_MENU_RESPONSE,
                             result: operatorListResponse.sucess, object: menus as AnyObject)
        }
    }
    
    public func getAvailablesValues(ddd: String, operatorId: Int) {
        
        var operators: [OperatorValue] = []
        
        // Create request
        //        let serviceBody = getServiceBody(OperatorValuesBody.self, objectData: OperatorValuesBody(operatorId: operatorId, ddd: ddd))
        
        let operatorValuesRequest = OperatorValuesBody(operatorId: operatorId, ddd: ddd)
        let serviceBody = updateJsonWithHeader(jsonBody: operatorValuesRequest.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedOperatorValueList, json: serviceBody)
        
        callApi(OperatorValuesResponse.self, request: request) { (operatorValuesResponse) in
            
            //If failed to get the baptism response
            if operatorValuesResponse.sucess {
                operators = (operatorValuesResponse.body?.data?.values)!
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: PhoneRechargeRN.self, param: Param.Contact.PHONE_RECHARGE_AVAILABLE_VALUES_RESPONSE,
                             result: operatorValuesResponse.sucess, object: operators as AnyObject)
        }
    }
    
//    if (operatorName == null || operatorName.isEmpty()) {
//    sendContact(Param.Contact.PHONE_RECHARGE_VERIFY_OPERATOR_RESPONSE, false);
//    return;
//    }
//
//    ServiceResponse<OperatorListResponse> operatorResponse = callApi(services().getOperatorList(getServiceBody(null)));
//    Operator operator = null;
//
//    if (operatorResponse.isSucess()) {
//    operatorResponse.updateData(mGson.fromJson(getDataObj(operatorResponse), OperatorListResponse.class));
//    List<Operator> operators = operatorResponse.getBody().getData().getOperators();
//
//    for (Operator operatorAux : operators) {
//    if (operatorAux.getName().toLowerCase().contains(operatorName.toLowerCase())) {
//    operator = operatorAux;
//    break;
//    }
//    }
//    }
    
    //sendContact(Param.Contact.PHONE_RECHARGE_VERIFY_OPERATOR_RESPONSE, operator != null, operator);
    public func consultInternationalNumber(phone: String) {
        
        var values = [InternationalValue]()
        
        // Create request
        let serviceBody = getServiceBody(InternationalPhoneConsultBody.self, objectData: InternationalPhoneConsultBody(phone: phone.removeAllOtherCaracters()))
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedInternationalPhoneConsult, object: serviceBody)
        
        callApiForList(InternationalValue.self, request: request) { (response) in
            
            //If failed to get the baptism response
            if response.sucess {
                values = (response.body?.data) ?? [InternationalValue]()
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: PhoneRechargeRN.self, param: Param.Contact.PHONE_INTERNATIONAL_RECHARGE_CONSULT_RESPONSE,
                             result: response.sucess && !values.isEmpty, object: values as AnyObject)
        }
    }
    
    //sendContact(Param.Contact.PHONE_RECHARGE_VERIFY_OPERATOR_RESPONSE, operator != null, operator);
    public func verifyOperator(operatorName: String) {
        
        if (operatorName.isEmpty) {
            self.sendContact(fromClass: PhoneRechargeRN.self, param: Param.Contact.PHONE_RECHARGE_VERIFY_OPERATOR_RESPONSE)
        }
        
        var operators: [Operator] = []
        var operatorAux = Operator()
        
        // Create request
        let serviceBody = getServiceBody(EmptyObject.self, objectData: EmptyObject())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedOperatorList, object: serviceBody)
        
        callApi(OperatorListResponse.self, request: request) { (operatorListResponse) in
            
            //If failed to get the baptism response
            if operatorListResponse.sucess {
                operators = (operatorListResponse.body?.data?.operators)!
                
                for op in operators {
                    //(description: String, image: String, id: Int, data: Data?)
                    if op.name.lowercased() == operatorName.lowercased() {
                        operatorAux = op
                    }
                }
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: PhoneRechargeRN.self, param: Param.Contact.PHONE_RECHARGE_VERIFY_OPERATOR_RESPONSE,
                             result: operatorAux.id != 0, object: operatorAux as AnyObject)
        }
    }
    
    public func getAvailableListAsMenuList(ddd: String, operatorId: Int) {
        
        var operators: [OperatorValue] = []
        var menus: [MenuItem] = []
        
        // Create request
        let objectData = OperatorValuesBody(operatorId: operatorId, ddd: ddd)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedOperatorValueList, json: serviceBody)
        
        callApi(OperatorValuesResponse.self, request: request) { (operatorValuesResponse) in
            
            //If failed to get the baptism response
            if operatorValuesResponse.sucess {
                operators = (operatorValuesResponse.body?.data?.values)!
                
                for op in operators {
                    //(description: String, image: String, id: Int, data: Data?)
                    menus.append(MenuItem(description: "R$\(op.maxValue))", data: op))
                }
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: PhoneRechargeRN.self, param: Param.Contact.PHONE_RECHARGE_AVAILABLE_VALUES_AS_MENU_RESPONSE,
                             result: operatorValuesResponse.sucess, object: menus as AnyObject)
        }
    }
}
