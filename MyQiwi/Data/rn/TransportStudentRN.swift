//
//  TransportStudentRN.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 25/08/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import Foundation

class TransportStudentRN : BaseRN {
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    static func setAlreadyClickAtStudentForm(clicked: Bool) {
        UserDefaults.standard.set(clicked, forKey: PrefsKeys.PREFS_USER_ALREADY_CLICKED_STUDENT_FORM)
        UserDefaults.standard.synchronize()
    }

    static func alreadyClickAtStudentForm() -> Bool {
        return UserDefaults.standard.bool(forKey: PrefsKeys.PREFS_USER_ALREADY_CLICKED_STUDENT_FORM)
    }
    
    func sendOrUpdateForm(form: StudentForm) {
        let serviceBody = updateJsonWithHeader(jsonBody: form.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedStudentAddOrEditForm, json: serviceBody)
        
        callApi(StudentFormResponse.self, request: request) { (response) in
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: TransportStudentRN.self, param: Param.Contact.STUDENT_ADD_OR_EDIT_FORM_RESPONSE,
                             result: response.sucess, object: response.body?.data)
        }
    }
    
    func getFormResponses(cpf: String) {
        let objectData = StudentFormStatusBody(cpf: cpf.removeAllOtherCaracters())
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedStudentGetForm, json: serviceBody)
        
        callApi(StudentForm.self, request: request) { (response) in
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: TransportStudentRN.self, param: Param.Contact.STUDENT_GET_FORM_RESPONSE,
                             result: response.sucess, object: response.body?.data)
        }
    }
    
    func consultFormStatus(cpf: String) {
        let objectData = StudentFormStatusBody(cpf: cpf.removeAllOtherCaracters())
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedStudentConsultForm, json: serviceBody)
        
        callApi(StudentFormStatusResponse.self, request: request) { (response) in
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: TransportStudentRN.self, param: Param.Contact.STUDENT_FORM_CONSULT_RESPONSE,
                             result: response.sucess, object: response.body?.data)
        }
    }
    
    func getSchoolsAndBusLines(idEmissor: Int) {
        let objectData = TransportStudentSchoolConsult(idEmissor: idEmissor)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let requestSchool = RestApi().generedRequestPost(url: BaseURL.AuthenticatedStudentSchoolList, json: serviceBody)
        
        var schools = [School]()
        var busLines = [BusLine]()
        
        callApiForList(School.self, request: requestSchool) { (response) in
            
            //If failed to get the baptism response
            if response.sucess {
                schools = (response.body?.data)!
            }
            
            let serviceBody = self.updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
            let requestBusLine = RestApi().generedRequestPost(url: BaseURL.AuthenticatedStudentBusLineList, json: serviceBody)
            self.callApiForList(BusLine.self, request: requestBusLine) { (response) in
                
                //If failed to get the baptism response
                if response.sucess {
                    busLines = (response.body?.data)!
                }
                
                var objs = [AnyObject]()
                objs.append(schools as AnyObject)
                objs.append(busLines as AnyObject)
                
                // Mostrar uma tela que não foi possivel, abrir o app
                self.sendContact(fromClass: TransportStudentRN.self, param: Param.Contact.STUDENT_BUS_LINE_LIST_RESPONSE,
                                 result: response.sucess, object: objs as AnyObject)
            }
        }
    }
}
