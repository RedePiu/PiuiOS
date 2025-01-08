//
//  ContactsRN.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 08/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class ContactsRN: BaseRN {
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    func getNationalContacts() -> [PhoneContact] {
        return getCopyOfList(list: PhoneContactDAO().getAllNational())
    }
    
    func getInternationalContacts() -> [PhoneContact] {
        return getCopyOfList(list: PhoneContactDAO().getAllInternational())
    }

    func getCopyOfList(list: [PhoneContact]) -> [PhoneContact] {
        
        if list.isEmpty {
            return list;
        }
        
        var returnedList = [PhoneContact]()
        
        for t in list {
            returnedList.append(PhoneContact(appId: t.appid, serverPk: t.serverpk, name: t.name, ddd: t.ddd, number: t.number, photo: t.photo ?? "", op: t.op ?? ""))
        }
        
        return returnedList
    }
    
    /**
     * Salva ou atualiza um cartao no banco
     */
    func saveCardOrUpdate(phoneContact: PhoneContact) {
        
        //        let insertOrUpdateBody = InsertOrUpdateBody(transportCard: transportCard)
        //        let serviceBody = getServiceBody(InsertOrUpdateBody.self, objectData: insertOrUpdateBody)
        
        let insertOrUpdateBody = InsertOrUpdateBody(phoneContact: phoneContact)
        let serviceBody = updateJsonWithHeader(jsonBody: insertOrUpdateBody.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedRegisterOrUpdateData, json: serviceBody)
        
        callApiDataInt(request: request) { (response) in
            
            var pk = 0
            if response.sucess && response.body?.data != nil {
                
                pk = (response.body?.data!)!
                if pk > 0 {
                    
                    DispatchQueue.main.async {
                        let dao = PhoneContactDAO()
                        let phoneContactAux = dao.get(number: phoneContact.number)
                        
                        //Objetos realm nao podem ser acessados de multiplas threads
                        //entao criamos um novo obj
//                        let newContact = PhoneContact()
//                        newContact.serverpk = pk
//                        newContact.ddd = phoneContactAux.ddd
//                        newContact.number = phoneContactAux.number
//                        newContact.name = phoneContactAux.name
//                        newContact.op = phoneContactAux.op
                        
                        let newContact = phoneContact
                        newContact.serverpk = pk
                        
                        //nao existe
                        if phoneContactAux.number.isEmpty {
                            dao.insert(with: newContact)
                        } else {
                            dao.update(with: newContact)
                        }
                        
                        self.sendContact(fromClass: ContactsRN.self, param: Param.Contact.PHONE_RECHARGE_INSERT_PHONE_RESPONSE, result: pk > 0, object: response)
                    }
                    return
                }
            }
            
            self.sendContact(fromClass: UserRN.self, param: Param.Contact.PHONE_RECHARGE_INSERT_PHONE_RESPONSE, result: pk > 0, object: response)
        }
    }
    
    /**
     * Remove the credit card token from server.<br><br>
     *
     * It will contact throw Param: CREDIT_CARD_BRAND_LIST_RESPONSE
     */
    public func removeContact(contact: PhoneContact) {
        
        // Create request
        let deleteItemBody = DeleteItemBody(pkId: contact.serverpk)
        let serviceBody = updateJsonWithHeader(jsonBody: deleteItemBody.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedDeleteData, json: serviceBody)
        
        callApi(request: request) { (response) in
            
            //se removeu do server, removemos do banco
            if response.sucess {
                DispatchQueue.main.async {
                    PhoneContactDAO().delete(with: contact)
                }
            }
            
            self.sendContact(fromClass: ContactsRN.self, param: Param.Contact.PHONE_RECHARGE_DELETE_PHONE_RESPONSE,
                             result: response.sucess, object: nil)
        }
    }
}
