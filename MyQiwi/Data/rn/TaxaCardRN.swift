//
//  TaxaCardRN.swift
//  MyQiwi
//
//  Created by Daniel Catini on 04/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import Foundation
import UIKit

class TaxaCardRN : BaseRN {
    
    
    func DeleteAll()
    {
        CartaoTaxaDAO().deleteAll()
        TipoCargaTaxaDAO().deleteAll()
        LayoutFormDAO().deleteAll()
    }
    
    /**
     * Obtem a lista de cartoes salvos no banco local.
     *
     */
    func getAllCards() -> [TaxaCardResponse] {
        
        return CartaoTaxaDAO().getAll();
    }
    
    func getCardResponses(idEmissor: Int, cpf: String) {
        var taxaCard: [TaxaCardResponse] = []
        
        let objectData = TaxaConsultaCartao(idEmissor: idEmissor,cpf: cpf.removeAllOtherCaracters())
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedTaxaGetCards, json: serviceBody)
        
        callApiForList(TaxaCardResponse.self, request: request) { (response) in
            // Deletar todos
            CartaoTaxaDAO().deleteAll()
            
            if response.sucess {
                taxaCard = (response.body?.data)!
                
                //Or if were successfully connected.
                //Delete all taxes to replace for the newest
                if taxaCard.count > 0 {
                    // Inserir todos novamente
                    CartaoTaxaDAO().insert(with: taxaCard)
                }
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: TaxaCardRN.self, param: Param.Contact.TAXA_GET_CARD_RESPONSE,
                             result: response.sucess, object: taxaCard as AnyObject)
        }
    }
    
    /**
     * Obtem a lista de cartoes salvos no banco local.
     *
     */
    func getAllCardTypes() -> [MenuCardTypeResponse] {
        return TipoCargaTaxaDAO().getAll();
    }
    
    func getMenuCardTypeResponses(idEmissor: Int) {
        var taxaCard: [MenuCardTypeResponse] = []
        
        let objectData = TaxaConsultaTipoCarga(idEmissor: idEmissor)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedTaxaGetCardTypes, json: serviceBody)
        
        callApiForList(MenuCardTypeResponse.self, request: request) { (response) in
            // Deletar todos
            TipoCargaTaxaDAO().deleteAll()
            
            if response.sucess {
                taxaCard = (response.body?.data)!
                
                //Or if were successfully connected.
                //Delete all taxes to replace for the newest
                if taxaCard.count > 0 {
                    // Inserir todos novamente
                    TipoCargaTaxaDAO().insert(with: taxaCard)
                }
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: TaxaCardRN.self, param: Param.Contact.TAXA_GET_TYPE_CARD_RESPONSE,
                             result: response.sucess, object: taxaCard as AnyObject)
        }
    }
    
    /**
     * Obtem a lista de cartoes salvos no banco local.
     *
     */
    func getAllLayoutForm() -> [LayoutFormResponse] {
        
        return LayoutFormDAO().getAll();
    }
    
    func getLayoutFormResponses(idEmissor: Int, id_tipo_formulario_carga: Int, via: Int, fl_dependente: Bool) {
        var layoutForm: [LayoutFormResponse] = []
        
        let objectData = LayoutForm(idEmissor: idEmissor, id_tipo_formulario_carga: id_tipo_formulario_carga, via: via, fl_dependente: fl_dependente)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedTaxaLayoutForm, json: serviceBody)
        
        callApiForList(LayoutFormResponse.self, request: request) { (response) in
            // Deletar todos
            LayoutFormDAO().deleteAll()
            
            if response.sucess {
                layoutForm = (response.body?.data)!
                
                //Or if were successfully connected.
                //Delete all taxes to replace for the newest
                if layoutForm.count > 0 {
                    // Inserir todos novamente
                    LayoutFormDAO().insert(with: layoutForm)
                }
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: TaxaCardRN.self, param: Param.Contact.TAXA_LAYOUT_FORM_RESPONSE,
                             result: response.sucess, object: layoutForm as AnyObject)
        }
    }
    
    func createFormResponses(
        idEmissor: Int,
        id_formulario_tipo_cartao: Int,
        cpf: String,
        campos: [CampoCreateForm] = [CampoCreateForm](),
        failCompletion: ((String) -> Void)?
    ) {
        var createForm: CreateFormResponse = CreateFormResponse()
        
        let objectData = CreateForm(idEmissor: idEmissor, id_formulario_tipo_cartao: id_formulario_tipo_cartao, cpf: cpf, campos: campos)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedTaxaCreateForm, json: serviceBody)
        
        callApi(CreateFormResponse.self, request: request) { (response) in
            
            if response.sucess {
                if let data = response.body?.data {
                    createForm = data
                }
            }
            
            else {
                response.body?.messages.forEach({
                    failCompletion?($0)
                })
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(
                fromClass: TaxaCardRN.self,
                param: Param.Contact.TAXA_CREATE_FORM_RESPONSE,
                result: response.sucess,
                object: createForm as AnyObject
            )
        }
    }
    
    /**
     * Obtem a lista de cartoes salvos no banco local.
     *
     */
    
    func getAllGetForms() -> [GetFormsResponse] {
        return GetFormsDAO().getAll();
    }
    
    func getAllCamposForm() -> [CampoFormResponse] {
        return CamposFormDAO().getAll()
    }
   
    func getFormsResponses(idEmissor: Int, cpf: String) {
        var getForms: [GetFormsResponse] = []
        
        let objectData = GetForms(idEmissor: idEmissor, cpf: cpf)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedTaxaGetForms, json: serviceBody)
        
        
        callApiForList(GetFormsResponse.self, request: request) { (response) in
            GetFormsDAO().deleteAll()
            
            if response.sucess {
                getForms = (response.body?.data)!
                
                for item in getForms {
                    CamposFormDAO().insert(with: item.Campos)
                }
                
                if getForms.count > 0 {
                    GetFormsDAO().insert(with: getForms)
                    
                    getForms.forEach({
                        CamposFormDAO().insert(with: $0.Campos)
                    })
                }
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(
                fromClass: TaxaCardRN.self,
                param: Param.Contact.TAXA_GET_FORM_RESPONSE,
                result: response.sucess,
                object: getForms as AnyObject
            )
        }
    }
    
    /**
     * Obtem a lista de cartoes salvos no banco local.
     *
     */
    
    func getAllGetTaxas() -> [GetTaxasResponse] {
        
        return GetTaxasDAO().getAll();
    }
   
    func getTaxaResponses(idEmissor: Int) {
        var getTaxas: [GetTaxasResponse] = []
        
        let objectData = GetTaxas(idEmissor: idEmissor)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedTaxaGet, json: serviceBody)
        
        callApiForList(GetTaxasResponse.self, request: request) { (response) in
            // Deletar todos
            GetTaxasDAO().deleteAll()
            
            if response.sucess {
                getTaxas = (response.body?.data)!
                
                //Or if were successfully connected.
                //Delete all taxes to replace for the newest
                 if getTaxas.count > 0 {
                    // Inserir todos novamente
                    GetTaxasDAO().insert(with: getTaxas)
                }
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: TaxaCardRN.self, param: Param.Contact.TAXA_GET_TAXA_RESPONSE,
                             result: response.sucess, object: getTaxas as AnyObject)
        }
    }
   
    func getCamposTaxaResponses(taxa: GetTaxasResponse) {
        taxa.Campos = []
        
        let objectData = GetCamposTaxa(idTaxa: taxa.Id_Taxa)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedCamposTaxaGet, json: serviceBody)
        
        callApiForList(CamposGetTaxasResponse.self, request: request) { (response) in
            // Deletar todos
            //GetTaxasDAO().deleteAll()
            
            if response.sucess {
                taxa.Campos = (response.body?.data)!
                
                //Or if were successfully connected.
                //Delete all taxes to replace for the newest
                //if getTaxas.count > 0 {
                    // Inserir todos novamente
                    //GetTaxasDAO().insert(with: getTaxas)
                //}
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: TaxaCardRN.self, param: Param.Contact.TAXA_GET_CAMPO_TAXA_RESPONSE,
                             result: response.sucess, object: taxa as AnyObject)
        }
    }
    
    func sendFormUpdate(idFormulario: Int, campos: [CampoCreateForm], failCompletion: ((String) -> Void)?) {
        var createForm = Bool()
        let objectData = UpdateFormModel(
            id_formulario: idFormulario,
            campos: campos
        )
        let serviceBody = updateJsonWithHeader(
            jsonBody: objectData.toJSONString() ?? ""
        )
        let request = RestApi().generedRequestPost(
            url: BaseURL.AuthenticatedTaxaUpdateForm,
            json: serviceBody
        )
        
        callApi(UpdateFormModel.self, request: request) { response in
            
            print("@! >>> UPDATE_MODEL_RESPONSE: ", response)
            
            if response.sucess {
                createForm = true
            } else {
                response.body?.messages.forEach {
                    failCompletion?($0)
                    print("@! >>> UPDATE_MODEL_ERROR: ", $0)
                }
            }
            
            self.sendContact(
                fromClass: TaxaCardRN.self,
                param: Param.Contact.TAXA_GET_FORM_UPDATE,
                result: response.sucess,
                object: createForm as AnyObject
            )
        }
    }
}
