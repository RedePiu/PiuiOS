//
//  TransportCardRN.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 03/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class TransportCardRN: BaseRN {
    
    fileprivate let TRANSPORT_CARD_SAVED = "TRANSPORT_CARD_SAVED"

    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    func getCopyOfList(list: [TransportCard]) -> [TransportCard] {
        
        if list.isEmpty {
            return list;
        }
        
        var returnedList = [TransportCard]()
        
        for t in list {
            returnedList.append(TransportCard(serverpk: t.serverpk, number: t.number, name: t.name, type: t.type, cpf: t.cpf))
        }
        
        return returnedList
    }
    
    /**
     * Obtem a lista de bilhetes salvos no banco local.
     * O tipe é o de ActionFider.TransportCards.TypeCards.
     */
    func getSavedCards(type: Int) -> [TransportCard] {
        
        if type == 0 || type == 6 || type == ActionFinder.Transport.CardType.BILHETE_UNICO {
            return getCopyOfList(list: TransportCardDAO().getAllBilheteUnico(type: type))
        }
        
        return getCopyOfList(list: TransportCardDAO().getAllByType(type: type))
    }
    
    /**
     * Salva ou atualiza um cartao no banco
     */
    func saveCardOrUpdate(transportCard: TransportCard) {
        
//        let insertOrUpdateBody = InsertOrUpdateBody(transportCard: transportCard)
//        let serviceBody = getServiceBody(InsertOrUpdateBody.self, objectData: insertOrUpdateBody)

        let insertOrUpdateBody = InsertOrUpdateBody(transportCard: transportCard)
        let serviceBody = updateJsonWithHeader(jsonBody: insertOrUpdateBody.generateJsonBody())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedRegisterOrUpdateData, json: serviceBody)

        callApiDataInt(request: request) { (response) in

            var pk = 0
            if response.sucess && response.body?.data != nil {
                
                pk = (response.body?.data!)!
                if pk > 0 {
                    
                    DispatchQueue.main.async {
                        let dao = TransportCardDAO()
                        let transportCardAux = dao.get(cardNumber: transportCard.number)
                        transportCard.serverpk = pk
                        
                        //Objetos realm nao podem ser acessados de multiplas threads
                        //entao criamos um novo obj
                        let newCard = transportCard
                        
                        //nao existe
                        if transportCardAux.number.isEmpty {
                            dao.insert(with: newCard)
                        } else {
                            dao.update(with: newCard)
                        }
                        
                        self.sendContact(fromClass: UserRN.self, param: Param.Contact.TRANSPORT_CARD_SAVED, result: pk > 0, object: response)
                    }
                    return
                }
            }
            
            self.sendContact(fromClass: UserRN.self, param: Param.Contact.TRANSPORT_CARD_SAVED, result: pk > 0, object: response)
        }
    }
    
    /**
     * Remove um cartao do banco eu do servidor
     */
    func removeCard(transportCard: TransportCard) {
        //AuthenticatedDeleteData
        
        let objectData = DeleteItemBody(pkId: transportCard.serverpk)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedDeleteData, json: serviceBody)
        
        callApi(EmptyObject.self, request: request) { (response) in
            
            //If failed to get the baptism response
            if response.sucess {
                DispatchQueue.main.async {
                    TransportCardDAO().delete(with: transportCard)
                }
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: TransportCardRN.self, param: Param.Contact.TRANSPORT_CARD_REMOVED,
                             result: response.sucess, object: nil)
        }
    }
    
    /**
     * Remove um cartao do banco ou do servidor
     */
    func removeCard(transportCardNumber: String) {
        
        let transportCard = TransportCardDAO().get(cardNumber: transportCardNumber)
        self.removeCard(transportCard: transportCard)
    }
    
    func getTransportTypeFromList(transportTypes: [TransportCard], transportTypeId: Int) {
    }
    
    /**
     * Obtem a lista de materiais
     */
    func getTransportCardTutorials() -> [TransportCardNumberTutorial] {
        
        var tutorials: [TransportCardNumberTutorial] = []
        
        if QiwiOrder.isTransportRecharge() {
            tutorials.append(TransportCardNumberTutorial(frontImage: "cartao_1a", backImage: "cartao_1b"))
            tutorials.append(TransportCardNumberTutorial(frontImage: "cartao_2a", backImage: "cartao_2b"))
            tutorials.append(TransportCardNumberTutorial(frontImage: "cartao_3a", backImage: "cartao_3b"))
            tutorials.append(TransportCardNumberTutorial(frontImage: "cartao_4a", backImage: "cartao_4b"))
        }
        
        else if QiwiOrder.isTransportCittaMobiRecharge() {
            tutorials.append(TransportCardNumberTutorial(frontImage: "cittamobi_cartao_1a", backImage: "cittamobi_cartao_1b"))
            tutorials.append(TransportCardNumberTutorial(frontImage: "cittamobi_cartao_2a", backImage: "cittamobi_cartao_2b"))
            tutorials.append(TransportCardNumberTutorial(frontImage: "cittamobi_cartao_3a", backImage: "cittamobi_cartao_3b"))
        }
        else if QiwiOrder.isUrbsCharge() {
            tutorials.append(TransportCardNumberTutorial(frontImage: "urbs_cartao_avulso", backImage: "urbs_cartao_avulso"))
            tutorials.append(TransportCardNumberTutorial(frontImage: "urbs_cartao", backImage: "urbs_cartao"))
        }
        else if QiwiOrder.isMetrocardRecharge() {
            tutorials.append(TransportCardNumberTutorial(frontImage: "metrocard_1a", backImage: "metrocard_1a"))
        }
        else if QiwiOrder.isTransportProdataRecharge() {
            
            if QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.NossoRibeirao.CIDADAO {
                tutorials.append(TransportCardNumberTutorial(frontImage: "cittamobi_cartao_1a", backImage: "cittamobi_cartao_1b"))
                tutorials.append(TransportCardNumberTutorial(frontImage: "cittamobi_cartao_2a", backImage: "cittamobi_cartao_2b"))
                tutorials.append(TransportCardNumberTutorial(frontImage: "cittamobi_cartao_3a", backImage: "cittamobi_cartao_3b"))
            }
            else if QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.BemLegalMaceio.COMUM {
                tutorials.append(TransportCardNumberTutorial(frontImage: "bemlegalmaceio_a", backImage: "bemlegalmaceio_a"))
            }
            else if QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.Caieiras.COMUM || QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.Caieiras.ESCOLAR {
                tutorials.append(TransportCardNumberTutorial(frontImage: "bem_caieiras_cartao", backImage: "bem_caieiras_cartao"))
            }
            else if QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.RioClaro.COMUM || QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.RioClaro.ESCOLAR {
                tutorials.append(TransportCardNumberTutorial(frontImage: "rio_claro_cartao", backImage: "rio_claro_cartao"))
            }
            else if QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.Araraquara.COMUM || QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.Araraquara.ESCOLAR {
                tutorials.append(TransportCardNumberTutorial(frontImage: "araraquara_cartao", backImage: "araraquara_cartao"))
            }
            else {
                tutorials.append(TransportCardNumberTutorial(frontImage: "rapido_cartao", backImage: "rapido_cartao"))
            }
        }
        
        return tutorials
    }
    
    /**
     * Obtem a lista de valores disponiveis, com base no valor maximo
     */
    func getAvailableValues(limiteMin: Int, limiteMax: Int) -> [Int] {
        
        var list: [Int] = []
        
        
        if limiteMin <= 1000 && 1000 <= limiteMax {
            list.append(1000)
        }
        
        if limiteMin <= 3000 && 3000 <= limiteMax {
            list.append(3000)
        }
        
        if limiteMin <= 5000 && 5000 <= limiteMax {
            list.append(5000)
        }
        
        list.append(-1)
        return list
    }
    
    /**
     * Obtem a lista de valores disponiveis, com base no valor maximo
     */
    func getAvailableValues(limiteMax: Int) -> [Int] {
        
        var list: [Int] = []
        
        let max = limiteMax * 100
        
        if 1000 <= max {
            list.append(1000)
        }
        
        if 3000 <= max {
            list.append(3000)
        }
        
        if 5000 <= max {
            list.append(5000)
        }
        
        list.append(-1)
        return list
    }
    
    /**
     * Faz uma chamada no servidor para obter a lista de recargas disponiveis do cartao
     */
    func getTransportCardOptions(cardNumber: Int) {
        
        var transportTypes: [TransportTypeResponse] = []
        
        // Create request
        let objectData = TransportCardConsultBody(cardNumber: cardNumber)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedTransportCardConsult, json: serviceBody)
        
        callApiForList(TransportTypeResponse.self, request: request) { (transportTypeResponse) in
            
            //If failed to get the baptism response
            if transportTypeResponse.sucess {
                transportTypes = (transportTypeResponse.body?.data)!
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: TransportCardRN.self, param: Param.Contact.TRANSPORT_CARD_CONSULT_RESPONSE,
                             result: transportTypeResponse.sucess, object: transportTypes as AnyObject)
        }
    }
    
    /**
     * Faz uma chamada no servidor para obter a lista de recargas disponiveis do cartao
     */
    func getTransportCardCittaMobiOptions(cardNumber: Int) {
        
        var transportTypes: [TransportCittaMobiTypeResponse] = []
        
        // Create request
        let consultBody = TransportCardCittaMobiBody(cardNumber: cardNumber)
        let serviceBody = updateJsonWithHeader(jsonBody: consultBody.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedTransportCardCittaMobiConsult, json: serviceBody)
        
        callApiForList(TransportCittaMobiTypeResponse.self, request: request) { (transportTypeResponse) in
            
            //If failed to get the baptism response
            if transportTypeResponse.sucess {
                transportTypes = (transportTypeResponse.body?.data)!
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: TransportCardRN.self, param: Param.Contact.TRANSPORT_CARD_CITTAMOBI_CONSULT_RESPONSE,
                             result: transportTypeResponse.sucess, object: transportTypes as AnyObject)
        }
    }
    
    /**
     * Faz uma chamada no servidor para obter a lista de recargas disponiveis do cartao
     */
    func getTransportCardProdataOptions(cardNumber: Int) {
        
        var transportTypes: [TransportProdataCreditType] = [TransportProdataCreditType]()

        // Create request
        let consultBody = TransportProdataBody(prvid: QiwiOrder.getPrvID(), cardNumber: cardNumber)
        let serviceBody = updateJsonWithHeader(jsonBody: consultBody.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedTransportCardProdataConsult, json: serviceBody)
        var transportType = TransportProdataCreditType()

        callApi(TransportProdataConsultResponse.self, request: request) { (response) in

            //If failed to get the baptism response
            if response.sucess {
                transportTypes = (response.body?.data?.creditTypes)!
                transportType = transportTypes.first!
            }

            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: TransportCardRN.self, param: Param.Contact.TRANSPORT_CARD_PRODATA_CONSULT_RESPONSE,
                             result: response.sucess, object: transportType as AnyObject)
        }
        
//        var p1 = TransportProdataProduct()
//        p1.prvId = ActionFinder.Transport.Prodata.ESCOLAR
//        p1.desc = "Rápido Taubate - Escolar"
//        p1.isQuota = true
//        p1.minValue = 2
//        p1.maxValue = 5
//        p1.unitValue = 4.40
//
//        var transportType = TransportProdataCreditType()
//        transportType.typeCreditId = 1
//        transportType.desc = "Teste"
//        transportType.products = [TransportProdataProduct]()
//        transportType.products.append(p1)
//
//        self.sendContact(fromClass: TransportCardRN.self, param: Param.Contact.TRANSPORT_CARD_PRODATA_CONSULT_RESPONSE,
//                                     result: true, object: transportType as AnyObject)
    }
    
    /**
     * Utilizando a lista de recargas do metodo getTransportCardOptions(), obtem uma lista de menus para utilizar na tela
     */
    func getTransportTypeOptions(menuType: Int, transportTypes: [TransportTypeResponse]) -> [MenuItem] {
        
        var menuItems: [MenuItem] = []
        
        for transportType in transportTypes {
            
            if menuType == ActionFinder.Transport.MenuType.DIARIO {
                
                if transportType.code == ActionFinder.Transport.ChargeType.DIARIO_INTEGRADO {
                    
                    menuItems.append(MenuItem(description: "ônibus + metrô",
                                              image: "ic_bus_and_train",
                                              id: transportType.code,
                                              data: transportType))
                }
                else if transportType.code == ActionFinder.Transport.ChargeType.DIARIO_ONIBUS {
                    
                    menuItems.append(MenuItem(description: "ônibus",
                                              image: "ic_bus",
                                              id: transportType.code,
                                              data: transportType))
                }
                else if transportType.code == ActionFinder.Transport.ChargeType.DIARIO_TRILHO {
                    
                    menuItems.append(MenuItem(description: "metrô / CPTM",
                                              image: "ic_train",
                                              id: transportType.code,
                                              data: transportType))
                }
            }
            
            if menuType == ActionFinder.Transport.MenuType.ESTUDANTE_DIARIO {
                
                if menuType == ActionFinder.Transport.ChargeType.ESTUDANTE_DIARIO_INTEGRADO {
                    
                    menuItems.append(MenuItem(description: "ônibus + metrô",
                                              image: "ic_bus_and_train",
                                              id: transportType.code,
                                              data: transportType))
                    
                }
                else if menuType == ActionFinder.Transport.ChargeType.ESTUDANTE_DIARIO_ONIBUS {
                    
                    menuItems.append(MenuItem(description: "ônibus",
                                              image: "ic_bus",
                                              id: transportType.code,
                                              data: transportType))
                    
                }
                else if menuType == ActionFinder.Transport.ChargeType.ESTUDANTE_DIARIO_TRILHO {
                    
                    menuItems.append(MenuItem(description: "metrô / CPTM",
                                              image: "ic_train",
                                              id: transportType.code,
                                              data: transportType))
                }
                
            }
            
            if menuType == ActionFinder.Transport.MenuType.SEMANAL {
                
                if transportType.code == ActionFinder.Transport.ChargeType.SEMANAL_INTEGRADO {
                    
                    menuItems.append(MenuItem(description: "ônibus + metrô",
                                              image: "ic_bus_and_train",
                                              id: transportType.code,
                                              data: transportType))
                }
                else if transportType.code == ActionFinder.Transport.ChargeType.SEMANAL_ONIBUS {
                    
                    menuItems.append(MenuItem(description: "ônibus",
                                              image: "ic_bus",
                                              id: transportType.code,
                                              data: transportType))
                }
                else if transportType.code == ActionFinder.Transport.ChargeType.SEMANAL_TRILHO {
                    
                    menuItems.append(MenuItem(description: "metrô / CPTM",
                                              image: "ic_train",
                                              id: transportType.code,
                                              data: transportType))
                }
            }
            
            if menuType == ActionFinder.Transport.MenuType.ESTUDANTE_SEMANAL {
                
                if transportType.code == ActionFinder.Transport.ChargeType.ESTUDANTE_SEMANAL_INTEGRADO {
                    
                    menuItems.append(MenuItem(description: "ônibus + metrô",
                                              image: "ic_bus_and_train",
                                              id: transportType.code,
                                              data: transportType))
                    
                }
                else if transportType.code == ActionFinder.Transport.ChargeType.ESTUDANTE_SEMANAL_ONIBUS {
                    
                    menuItems.append(MenuItem(description: "ônibus",
                                              image: "ic_bus",
                                              id: transportType.code,
                                              data: transportType))
                    
                }
                else if transportType.code == ActionFinder.Transport.ChargeType.ESTUDANTE_SEMANAL_TRILHO {
                    
                    menuItems.append(MenuItem(description: "metrô / CPTM",
                                              image: "ic_train",
                                              id: transportType.code,
                                              data: transportType))
                    
                }
            }
            
            if menuType == ActionFinder.Transport.MenuType.MENSAL {
                
                if transportType.code == ActionFinder.Transport.ChargeType.MENSAL_INTEGRADO {
                 
                    menuItems.append(MenuItem(description: "ônibus + metrô",
                                              image: "ic_bus_and_train",
                                              id: transportType.code,
                                              data: transportType))
                    
                }
                else if transportType.code == ActionFinder.Transport.ChargeType.MENSAL_ONIBUS {
                    
                    menuItems.append(MenuItem(description: "ônibus",
                                              image: "ic_bus",
                                              id: transportType.code,
                                              data: transportType))
                    
                }
                else if transportType.code == ActionFinder.Transport.ChargeType.MENSAL_TRILHO {
                    
                    menuItems.append(MenuItem(description: "metrô / CPTM",
                                              image: "ic_train",
                                              id: transportType.code,
                                              data: transportType))
                    
                }
            }
            
            if menuType == ActionFinder.Transport.MenuType.ESTUDANTE_MENSAL {
                
                if transportType.code == ActionFinder.Transport.ChargeType.ESTUDANTE_MENSAL_INTEGRADO {
                    
                    menuItems.append(MenuItem(description: "ônibus + metrô",
                                              image: "ic_bus_and_train",
                                              id: transportType.code,
                                              data: transportType))
                    
                }
                else if transportType.code == ActionFinder.Transport.ChargeType.ESTUDANTE_MENSAL_ONIBUS {
                    
                    menuItems.append(MenuItem(description: "ônibus",
                                              image: "ic_bus",
                                              id: transportType.code,
                                              data: transportType))
                    
                }
                else if transportType.code == ActionFinder.Transport.ChargeType.ESTUDANTE_MENSAL_TRILHO {
                    
                    menuItems.append(MenuItem(description: "metrô / CPTM",
                                              image: "ic_train",
                                              id: transportType.code,
                                              data: transportType))
                    
                }
            }
        }
        
        return menuItems
    }
    
    /**
     * Obtem a lista de cotas disponiveis
     */
    func getTransportChargeOptions(transportTypes: [TransportTypeResponse]) -> [MenuItem] {
        
        var menuItems: [MenuItem] = []
        
        // COMUN
        for transportType in transportTypes {
            if transportType.code == ActionFinder.Transport.ChargeType.CREDITO_COMUM {
                menuItems.append(MenuItem(description: "comum", image: "ic_transport_comum", action: 0, id: ActionFinder.Transport.MenuType.COMUM, data: transportType))
                break
            }
        }
        
        // TAXA ESTUDANTE
        for transportType in transportTypes {
            if transportType.code == ActionFinder.Transport.ChargeType.TAXA_SOLICITACAO_DE_BENEFICIO {
                menuItems.append(MenuItem(description: "taxa estudante", image: "ic_transport_tax", action: 0, id: ActionFinder.Transport.MenuType.BENEFICIO, data: transportType))
                break
            }
        }
        
        // ESTUDANTE - COMUM
        for transportType in transportTypes {
            if transportType.code == ActionFinder.Transport.ChargeType.ESTUDANTE_COMUM {
                menuItems.append(MenuItem(description: "estudante", image: "ic_studant", action: 0, id: ActionFinder.Transport.MenuType.ESTUDANTE, data: transportType))
                break
            }
        }
        
        // ESTUDANTE - Diario
        for transportType in transportTypes {
            if transportType.code == ActionFinder.Transport.ChargeType.ESTUDANTE_DIARIO_INTEGRADO ||
                transportType.code == ActionFinder.Transport.ChargeType.ESTUDANTE_DIARIO_ONIBUS ||
                transportType.code == ActionFinder.Transport.ChargeType.ESTUDANTE_DIARIO_TRILHO {
                
                menuItems.append(MenuItem(description: "estudante diário", image: "ic_transport_diario", action: 0, id: ActionFinder.Transport.MenuType.ESTUDANTE_DIARIO, data: transportType))
                break
            }
        }
        
        // ESTUDANTE - Semanal
        for transportType in transportTypes {
            if transportType.code == ActionFinder.Transport.ChargeType.ESTUDANTE_SEMANAL_INTEGRADO ||
                transportType.code == ActionFinder.Transport.ChargeType.ESTUDANTE_SEMANAL_ONIBUS ||
                transportType.code == ActionFinder.Transport.ChargeType.ESTUDANTE_SEMANAL_TRILHO {
                
                menuItems.append(MenuItem(description: "estudante semanal", image: "ic_transport_diario", action: 0, id: ActionFinder.Transport.MenuType.ESTUDANTE_SEMANAL, data: transportType))
                break
            }
        }
        
        // ESTUDANTE - mensal
        for transportType in transportTypes {
            if transportType.code == ActionFinder.Transport.ChargeType.ESTUDANTE_MENSAL_INTEGRADO ||
                transportType.code == ActionFinder.Transport.ChargeType.ESTUDANTE_MENSAL_ONIBUS ||
                transportType.code == ActionFinder.Transport.ChargeType.ESTUDANTE_MENSAL_TRILHO {
                
                menuItems.append(MenuItem(description: "estudante mensal", image: "ic_transport_mensal", action: 0, id: ActionFinder.Transport.MenuType.ESTUDANTE_MENSAL, data: transportType))
                break
            }
        }
        
        // COMUM - DIARIO
        for transportType in transportTypes {
            if transportType.code == ActionFinder.Transport.ChargeType.DIARIO_INTEGRADO ||
                transportType.code == ActionFinder.Transport.ChargeType.DIARIO_ONIBUS ||
                transportType.code == ActionFinder.Transport.ChargeType.DIARIO_TRILHO {
                
                menuItems.append(MenuItem(description: "diário", image: "ic_transport_diario", action: 0, id: ActionFinder.Transport.MenuType.DIARIO, data: transportType))
                break
            }
        }
        
        // COMUM SEMANAL
        for transportType in transportTypes {
            if transportType.code == ActionFinder.Transport.ChargeType.SEMANAL_INTEGRADO ||
                transportType.code == ActionFinder.Transport.ChargeType.SEMANAL_ONIBUS ||
                transportType.code == ActionFinder.Transport.ChargeType.SEMANAL_INTEGRADO {
                
                menuItems.append(MenuItem(description: "semanal", image: "ic_transport_diario", action: 0, id: ActionFinder.Transport.MenuType.SEMANAL, data: transportType))
                break
            }
        }
        
        // COMUM MENSAL
        for transportType in transportTypes {
            if transportType.code == ActionFinder.Transport.ChargeType.MENSAL_TRILHO ||
                transportType.code == ActionFinder.Transport.ChargeType.MENSAL_ONIBUS ||
                transportType.code == ActionFinder.Transport.ChargeType.MENSAL_TRILHO {
                
                menuItems.append(MenuItem(description: "mensal", image: "ic_transport_mensal", action: 0, id: ActionFinder.Transport.MenuType.MENSAL, data: transportType))
                break
            }
        }
        return menuItems
    }
    
    /**
     * Obtem a lista de cotas disponiveis
     */
    func getTransportChargeOptionsCittaMobi(transportTypes: [TransportCittaMobiTypeResponse]) -> [MenuItem] {
        
        var menuItems: [MenuItem] = []
        
        // COMUN
        for transportType in transportTypes {
            if transportType.cod == ActionFinder.Transport.MenuTypeCittaMobi.CIDADAO {
                menuItems.append(MenuItem(description: "cidadão", image: "ic_transport_comum", id: ActionFinder.Transport.MenuTypeCittaMobi.CIDADAO, prvid: transportType.prvId, data: transportType))
                break
            }
        }
        
        // ESTUDANTE
        for transportType in transportTypes {
            if transportType.cod == ActionFinder.Transport.MenuTypeCittaMobi.ESTUDANTE {
                menuItems.append(MenuItem(description: "estudate", image: "ic_studant", id: ActionFinder.Transport.MenuTypeCittaMobi.ESTUDANTE, prvid: transportType.prvId, data: transportType))
                break
            }
        }
        
        // EXPRESS
        for transportType in transportTypes {
            if transportType.cod == ActionFinder.Transport.MenuTypeCittaMobi.EXPRESS {
                menuItems.append(MenuItem(description: "expresso", image: "ic_transport_comum", id: ActionFinder.Transport.MenuTypeCittaMobi.EXPRESS, prvid: transportType.prvId, data: transportType))
                break
            }
        }
        
        return menuItems
    }
    
    /**
     * Obtem a lista de cotas disponiveis
     */
    func getTransportChargeOptionsProdata(transportTypes: [TransportProdataProduct]) -> [MenuItem] {
        
        var menuItems: [MenuItem] = []
        
        // CIDADAO
        for transportType in transportTypes {
            if transportType.prvId == ActionFinder.Transport.Prodata.RapidoTaubate.CIDADAO || transportType.prvId == ActionFinder.Transport.Prodata.NossoRibeirao.CIDADAO {
                menuItems.append(MenuItem(description: "cidadão", image: "ic_transport_comum", id: transportType.prvId, prvid: transportType.prvId, data: transportType))
                break
            }
        }
        
        // COMUN
        for transportType in transportTypes {
            if transportType.prvId == ActionFinder.Transport.Prodata.RapidoTaubate.COMUM ||
                transportType.prvId == ActionFinder.Transport.Prodata.BemLegalMaceio.COMUM ||
                transportType.prvId == ActionFinder.Transport.Prodata.Caieiras.COMUM ||
                transportType.prvId == ActionFinder.Transport.Prodata.SaoCarlos.COMUM ||
                transportType.prvId == ActionFinder.Transport.Prodata.SaoSebastiao.COMUM ||
                transportType.prvId == ActionFinder.Transport.Prodata.PresidentePrudente.COMUM ||
                transportType.prvId == ActionFinder.Transport.Prodata.Indaiatuba.COMUM ||
                transportType.prvId == ActionFinder.Transport.Prodata.Limeira.COMUM ||
                transportType.prvId == ActionFinder.Transport.Prodata.Osasco.COMUM ||
                transportType.prvId == ActionFinder.Transport.Prodata.FrancodaRocha.COMUM ||
                transportType.prvId == ActionFinder.Transport.Prodata.SantanadeParnaiba.COMUM ||
                transportType.prvId == ActionFinder.Transport.Prodata.Cajamar.COMUM ||
                transportType.prvId == ActionFinder.Transport.Prodata.RioClaro.COMUM ||
                transportType.prvId == ActionFinder.Transport.Prodata.Araraquara.COMUM {
                menuItems.append(MenuItem(description: "comum", image: "ic_transport_comum", id: transportType.prvId, prvid: transportType.prvId, data: transportType))
                break
            }
        }
        
        // ESCOLAR
        for transportType in transportTypes {
            if ActionFinder.Transport.Prodata.RapidoTaubate.IsEscolar(prvid: transportType.prvId) ||
                transportType.prvId == ActionFinder.Transport.Prodata.Caieiras.ESCOLAR ||
                transportType.prvId == ActionFinder.Transport.Prodata.SaoCarlos.ESCOLAR ||
                transportType.prvId == ActionFinder.Transport.Prodata.SaoSebastiao.ESCOLAR ||
                transportType.prvId == ActionFinder.Transport.Prodata.PresidentePrudente.ESCOLAR ||
                transportType.prvId == ActionFinder.Transport.Prodata.Indaiatuba.ESCOLAR ||
                transportType.prvId == ActionFinder.Transport.Prodata.Limeira.ESCOLAR ||
                transportType.prvId == ActionFinder.Transport.Prodata.Osasco.ESCOLAR ||
                transportType.prvId == ActionFinder.Transport.Prodata.FrancodaRocha.ESCOLAR ||
                transportType.prvId == ActionFinder.Transport.Prodata.SantanadeParnaiba.ESCOLAR ||
                transportType.prvId == ActionFinder.Transport.Prodata.Cajamar.ESCOLAR ||
                transportType.prvId == ActionFinder.Transport.Prodata.RioClaro.ESCOLAR ||
                transportType.prvId == ActionFinder.Transport.Prodata.Araraquara.ESCOLAR {
                menuItems.append(MenuItem(description: "escolar", image: "ic_studant", id: transportType.prvId, prvid: transportType.prvId, data: transportType))
                break
            }
        }
        
        // ESTUDANTE
        for transportType in transportTypes {
            if transportType.prvId == ActionFinder.Transport.Prodata.NossoRibeirao.ESTUDANTE || transportType.prvId == ActionFinder.Transport.Prodata.BemLegalMaceio.ESTUDANTE {
                menuItems.append(MenuItem(description: "estudante", image: "ic_studant", id: transportType.prvId, prvid: transportType.prvId, data: transportType))
                break
            }
        }
        
        // RAPIDO
        for transportType in transportTypes {
            if transportType.prvId == ActionFinder.Transport.Prodata.RapidoTaubate.RAPIDO {
                menuItems.append(MenuItem(description: "rápido", image: "ic_train", id: transportType.prvId, prvid: transportType.prvId, data: transportType))
                break
            }
        }
        
        // expresso
        for transportType in transportTypes {
            if transportType.prvId == ActionFinder.Transport.Prodata.NossoRibeirao.EXPRESSO {
                menuItems.append(MenuItem(description: "expresso", image: "ic_train", id: transportType.prvId, prvid: transportType.prvId, data: transportType))
                break
            }
        }
        
        // EMPRESARIAL
        for transportType in transportTypes {
            if transportType.prvId == ActionFinder.Transport.Prodata.RapidoTaubate.EMPRESARIAL {
                menuItems.append(MenuItem(description: "empresarial", image: "ic_company", id: transportType.prvId, prvid: transportType.prvId, data: transportType))
                break
            }
        }
        
        // VT
        for transportType in transportTypes {
            if transportType.prvId == ActionFinder.Transport.Prodata.RapidoTaubate.VT {
                menuItems.append(MenuItem(description: "VT", image: "ic_bus", id: transportType.prvId, prvid: transportType.prvId, data: transportType))
                break
            }
        }
        
        // Faixa 1
        for transportType in transportTypes {
            if transportType.prvId == ActionFinder.Transport.Prodata.SaoCarlos.FAIXA1 {
                menuItems.append(MenuItem(description: "faixa 1", image: "ic_bus", id: transportType.prvId, prvid: transportType.prvId, data: transportType))
                break
            }
        }
        
        // Faixa 2
        for transportType in transportTypes {
            if transportType.prvId == ActionFinder.Transport.Prodata.SaoCarlos.FAIXA2 {
                menuItems.append(MenuItem(description: "faixa 2", image: "ic_bus", id: transportType.prvId, prvid: transportType.prvId, data: transportType))
                break
            }
        }
        
        // PREFEITURA
        for transportType in transportTypes {
            if transportType.prvId == ActionFinder.Transport.Prodata.SaoSebastiao.ESCOLARPREFEITURA {
                menuItems.append(MenuItem(description: "prefeitura", image: "ic_company", id: transportType.prvId, prvid: transportType.prvId, data: transportType))
                break
            }
        }
        
        //prvid == ActionFinder.Transport.Prodata.RapidoTaubate.CIDADAO
//
//        let terminalType = MenuItemRN.getTerminalType()
//        if !ApplicationRN.isQiwiPro() && terminalType == ActionFinder.TerminalType.TAUBATE {
//
//            menuItems.append(MenuItem(description: "cadastrar ou verificar formulário de estudante", action: ActionFinder.ID_STUDENT_FORM, imageMenu: "ic_studant"))
//        }
        
        return menuItems
    }
}
