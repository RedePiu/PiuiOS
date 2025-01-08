//
//  BankRN.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 08/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class BankRN: BaseRN {
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    func getBankList() -> [MenuItem] {
        
        var mainMenu = [MenuItem]()
        var banks = BankDAO().getAll()
        
        for bank in banks {
            mainMenu.append(MenuItem(id: bank.id, description: "", action: 0, imageMenu: String(bank.id)))
        }
        
//        mainMenu.append(MenuItem(id: ActionFinder.Bank.ITAU, description: "", action: 0, imageMenu: String(ActionFinder.Bank.ITAU)))
//        mainMenu.append(MenuItem(id: ActionFinder.Bank.BRADESCO, description: "", action: 0, imageMenu: String(ActionFinder.Bank.BRADESCO)))
//        mainMenu.append(MenuItem(id: ActionFinder.Bank.BANCO_DO_BRASIL, description: "", action: 0, imageMenu: String(ActionFinder.Bank.BANCO_DO_BRASIL)))
//        mainMenu.append(MenuItem(id: ActionFinder.Bank.SANTANDER, description: "", action: 0, imageMenu: String(ActionFinder.Bank.SANTANDER)))
//        mainMenu.append(MenuItem(id: ActionFinder.Bank.CAIXA, description: "", action: 0, imageMenu: String(ActionFinder.Bank.CAIXA)))
        mainMenu.append(MenuItem(id: ActionFinder.Bank.NO_BANK, description: "", action: 0, imageMenu: "nobank"))
        
        return mainMenu
    }
    
    func getBank(bankId: Int) -> Bank {
        let bank = BankDAO().get(primaryKey: bankId)
        return bank
    }
    
    func deleteBank(bankRequest: BankRequest) {

        let deleteItemBody = DeleteItemBody(pkId: bankRequest.serverpk)
        let serviceBody = updateJsonWithHeader(jsonBody: deleteItemBody.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedDeleteData, json: serviceBody)
        
        callApi(EmptyObject.self, request: request) { (response) in
            
            //If failed to get the baptism response
            if response.sucess {
                DispatchQueue.main.async {
                    BankRequestDAO().delete(with: bankRequest)
                }
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: BankRN.self, param: Param.Contact.BANK_DELETE_RESPONSE,
                             result: response.sucess, object: nil)
        }
    }
}
