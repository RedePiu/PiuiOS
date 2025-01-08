//
//  UserRN.swift
//  MyQiwi
//
//  Created by ailton on 31/12/16.
//  Copyright © 2016 Qiwi. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class UserRN: BaseRN {

    static var userDefaults: UserDefaults {
        return UserDefaults.standard
    }

    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }

    static func savePhoneNumber(phone: String) {
        UserDefaults.standard.set(phone, forKey: PrefsKeys.PREFS_LAST_LOGGED_PHONE)
    }

    static func getLastPhoneNumber() -> String {
        return UserDefaults.standard.string(forKey: PrefsKeys.PREFS_LAST_LOGGED_PHONE) ?? ""
    }

    static func setEmailAndDateIsNeeded(needed: Bool) {
        UserDefaults.standard.set(needed, forKey: PrefsKeys.PREFS_EMAIL_AND_DATE_BIRTH_NEEDED)
    }

    static func isEmailAndDateIsNeeded() -> Bool {
        return UserDefaults.standard.bool(forKey: PrefsKeys.PREFS_EMAIL_AND_DATE_BIRTH_NEEDED)
    }

    static func generateEmail() -> String {
        return "qiwiemail" + Date().toFormat("ddMMyyyyHHmmss") + "@qiwi.com.br"
    }

    static func generateDateOfBirth() -> String {
        return "01/01/2000"
    }

    // This function will check and send baptism if app hasn't been baptized yet.
    // It will also send initialization settings to recreate all menus and default business params.
    func sendBaptismAndInitialize(sender: UIViewController,location: CLLocation) {

        //If returns 0, has to baptism again
        let num = SQiwi.tC()
        if num == 0 {

            //Get the baptismp body object
            let baptism = getDefaultBaptism(location: location)
            let serviceBody = getServiceBody(BaptismBody.self, objectData: baptism, seq: -1, generateSignture: false)

            // Create request
            let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedBaptism, object: serviceBody)

            callApi(BaptismResponse.self, request: request) { (baptismResponse) in

                //If failed to get the baptism response
                if !baptismResponse.sucess {

                    // Mostrar uma tela que não foi possivel, abrir o app
                    self.sendContact(fromClass: UserRN.self, param: Param.Contact.FINISH_ACTIVITY, result: true, object: nil)
                    return
                }

                if let data =  baptismResponse.body?.data {

                    //Or if were successfully connected.
                    let sqr = SQiwi.vB(b: data.b)

                    //If it's different from 0, should finish the app
                    if sqr != 0 {

                        // Mostrar uma tela que não foi possivel, abrir o app
                        self.sendContact(fromClass: UserRN.self, param: Param.Contact.FINISH_ACTIVITY, result: false, object: nil)
                        return
                    }

                    self.setSequential(seq: Int(data.seq) ?? -1)

                }else {
                    // sem conteudo no data
                    // não prosseguir, e informar
                    return
                }

                UserDefaults.standard.set(true, forKey: PrefsKeys.PREFS_PASSWORD_VISIBILITY_CAN_SHOW_POPUP)
                UserDefaults.standard.set(true, forKey: PrefsKeys.PREFS_PASSWORD_VISIBILITY_IS_HIDDEN)
                UserDefaults.standard.synchronize()

                self.Initialization(sender: sender, location: location)
            }

            return
        }

        self.Initialization(sender: sender, location: location)
    }

    func Initialization(sender: UIViewController, location: CLLocation) {

        //Now app has already been baptized and it's ready to get all menus
        let initializationBody = UserRN.getDefaultInitialization(location: location)
//        let serviceInitializationBody = getServiceBody(objectData: initializationBody, seq: 0, generateSignture: true)

        //This needed to force JSON fields to stand at the right position
        let ordenetedJson = initializationBody.generateJsonBody()
        let serviceInitializationBody = updateJsonWithHeader(jsonBody: ordenetedJson, seq: 0, generateSignture: true)

        // Create request
        let resquestInitialization = RestApi().generedRequestPost(url: BaseURL.AuthenticatedInitialization, json: serviceInitializationBody)

        //Make request
        callApi(InitializationResponse.self, request: resquestInitialization) { (initializationResponse) in

            print("@! ~> resquestInitialization ", resquestInitialization)
            //If failed to get the baptism response
            if !initializationResponse.sucess {

                // Mostrar uma tela que não foi possivel, abrir o app
                self.sendContact(fromClass: UserRN.self, param: Param.Contact.FINISH_ACTIVITY, result: false, object: nil)
                return
            }

            //Updates the S

            //Can continue if isn't valid
            if !RestHelper.setS(serviceResponse: initializationResponse) {

                // Mostrar uma tela que não foi possivel, abrir o app
                self.sendContact(fromClass: UserRN.self, param: Param.Contact.FINISH_ACTIVITY, result: false, object: nil)
                return
            }

            // Extract optional
            if let data = initializationResponse.body?.data {

                //Saves the ip id
                _ = SQiwi.sTA(a: data.p)

                let appVersionText = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
                let appVersion = Int(appVersionText ?? "0") ?? 0

                //Can continue if isn't valid
                if appVersion < data.appVersion {

                    //Mostrar tela para atualizar o app
                    DispatchQueue.main.async {
                        Util.showController(UpdateNeededViewController.self, sender: sender)
                    }

                    return
                }

                //Updates the sequential
                self.setS(s: data.s)
                self.setSequential(seq: (initializationResponse.header?.seq ?? 0) + 1)
                UserRN.setEmailAndDateIsNeeded(needed: data.isValidateDoc)

                UserRN.setNeedUpdatePayments(needUpdate: true)
                ApplicationRN.setNeedInitialization(need: false)

                // Apagar tudo
                //DBManager.shared.deleteAllDatabase()

                //Or if were successfully connected.
                //Delete all menus to replace for the newest
                if !data.menuList.isEmpty {
                    // Deletar todos
                    // Inserir todos novamente

                    //REMOVER APÓS CORREÇAO DE CARACTER NO BANCO
                    for menu in data.menuList {
                        if menu.dadId == ActionFinder.MENUID_OTHERS || menu.dadId == ActionFinder.MENUID_OTHERS_NEW {

                            if menu.desc == "TV Pre-Paga" {
                                menu.desc = "TV Pré-Paga"
                            }
                            else if menu.desc == "Servico de Musica" {
                                menu.desc = "Serviço de Música"
                            }
                            else if menu.desc == "Doacao" {
                                menu.desc = "Doação"
                            }
                            else if menu.desc == "Saude" {
                                menu.desc = "Saúde"
                            }
                            else if menu.desc == "Capitalizacao" {
                                menu.desc = "Capitalização"
                            }
                        }
                    }

//                    let menu = MenuItem(description: "Roblox", image: "menus/menu_produto_roblox", action: ActionFinder.ACTION_INCOMM, id: 0, data: nil)
//                    menu.prvID = 100333
//                    menu.order = -101
//                    menu.dadId = 105
//                    data.menuList.append(menu)

//                    let telesena = MenuItem(description: "Razer Gold", image: "menus/menu_produto_razer_gold", action: ActionFinder.ACTION_INCOMM, id: 0, data: nil)
//                    telesena.prvID = 100332
//                    telesena.order = -100
//                    telesena.dadId = 105
//                    data.menuList.append(telesena)

//                    let menu = MenuItem(description: "", image: "menus/menu_produto_ultragaz", action: ActionFinder.ACTION_ULTRAGAZ, id: 0, data: nil)
//                    menu.prvID = 100208
//                    menu.order = -101
//                    menu.dadId = 105
//                    data.menuList.append(menu)
//
//                    let menu = MenuItem(description: "", image: "menus/menu_nosso", action: ActionFinder.ACTION_TRANSPORT_CARD_PRODATA, id: 0, data: nil)
//                    menu.prvID = 100270
//                    menu.order = -101
//                    menu.dadId = 105
//                    data.menuList.append(menu)

                    MenuItemRN.tempTerminalDefinition(menus: data.menuList)
                    MenuItemDAO().deleteAll()
                    MenuItemDAO().insert(with: data.menuList)
                }

                //Or if were successfully connected.
                //Delete all taxes to replace for the newest
                if data.taxes != nil && !(data.taxes?.isEmpty)! {
                    // Deletar todos
                    // Inserir todos novamente
                    TaxesDAO().deleteAll()
                    TaxesDAO().insert(with: data.taxes!)
                }

                //Or if were successfully connected.
                //Delete all taxes to replace for the newest
                if data.paymentTypes != nil && !(data.paymentTypes?.isEmpty)! {
                    // Deletar todos
                    // Inserir todos novamente
                    PaymentTypeDAO().deleteAll()
                    PaymentTypeDAO().insert(with: data.paymentTypes!)
                }

                //Or if were successfully connected.
                //Delete all taxes to replace for the newest
                if data.attendanceQuestions != nil && !(data.attendanceQuestions?.isEmpty)! {
                    // Deletar todos
                    // Inserir todos novamente
                    AttendanceQuestionDAO().deleteAll()
                    AttendanceQuestionDAO().insert(with: data.attendanceQuestions!)
                }

                //Or if were successfully connected.
                //Delete all taxes to replace for the newest
                if data.banks != nil && !(data.banks?.isEmpty)! {
                    // Deletar todos
                    // Inserir todos novamente
                    BankDAO().deleteAll()
                    BankDAO().insert(with: data.banks!)
                }

                //Or if were successfully connected.
                //Delete all taxes to replace for the newest
                if data.paymentTypeLimits != nil && !(data.paymentTypeLimits?.isEmpty)! {
                    // Deletar todos
                    // Inserir todos novamente
                }

                //Or if were successfully connected.
                //Delete all taxes to replace for the newest
                if data.paymentTypeLimitsPrvid != nil && !(data.paymentTypeLimitsPrvid?.isEmpty)! {
                    // Deletar todos
                    // Inserir todos novamente
                    PaymentTypeLimitPrvIdDAO().deleteAll()
                    PaymentTypeLimitPrvIdDAO().insert(with: data.paymentTypeLimitsPrvid!)
                }

                //Or if were successfully connected.
                //Delete all taxes to replace for the newest
                if data.incommValues != nil && !(data.incommValues?.isEmpty)! {
                    
                    var pk = 0
                    for incommValue in data.incommValues! {

                        pk += 1
                        incommValue.pk = pk
                        if incommValue.minValue <= 1 {
                            incommValue.minValue = 1
                        }
                    }

                    // Deletar todos
                    // Inserir todos novamente
                    IncommValueDAO().deleteAll()
                    IncommValueDAO().insert(with: data.incommValues!)
                }

                //Or if were successfully connected.
                //Delete all taxes to replace for the newest
                if data.pinofflineValues != nil && !(data.pinofflineValues?.isEmpty)! {

                    for pinValue in data.pinofflineValues! {

                        if pinValue.value <= 1 {
                            pinValue.value = 1
                        }
                    }

                    // Deletar todos
                    // Inserir todos novamente
                    PinofflineValueDAO().deleteAll()
                    PinofflineValueDAO().insert(with: data.pinofflineValues!)
                }

                //Or if were successfully connected.
                //Delete all taxes to replace for the newest
                if data.serasaValues != nil && !(data.serasaValues?.isEmpty)! {
                    // Deletar todos
                    // Inserir todos novamente
                    SerasaValueDAO().deleteAll()
                    SerasaValueDAO().insert(with: data.serasaValues!)
                }

                //Or if were successfully connected.
                //Delete all taxes to replace for the newest
                if data.serasaAntiFraudValues != nil && !(data.serasaAntiFraudValues?.isEmpty)! {
                    // Deletar todos
                    // Inserir todos novamente
                }

                //Or if were successfully connected.
                //Delete all taxes to replace for the newest
                if data.rvValues != nil && !(data.rvValues?.isEmpty)! {

                    // Deletar todos
                    // Inserir todos novamente
                    RVDAO().deleteAll()
                    RVDAO().insert(with: data.rvValues!)
                }
                
                //Or if were successfully connected.
                //Delete all taxes to replace for the newest
                if data.produtoProdata != nil && !(data.produtoProdata?.isEmpty)! {

                    // Deletar todos
                    // Inserir todos novamente
                    ProdutoProdataDAO().deleteAll()
                    ProdutoProdataDAO().insert(with: data.produtoProdata!)
                }

                //Updates clickbus file if needed
                if data.clickbusVersion != 0 && !data.clickbusFileName.isEmpty {
                    ClickBusRN.setFileVersion(version: data.clickbusVersion, fileName: data.clickbusFileName)
                }

            } else {
                // sem conteudo no data
                // apresentar um messagem ou algo para indetificar
            }

            //If has a logged user, make a request to update local user info
            if UserRN.hasLoggedUser() {
                self.getUserInfo()
            }

            // Perguntar o motivo desse param 452
            self.sendContact(fromClass: UserRN.self, param: Param.Contact.NET_BAPTISM_RESPONSE, result: true, object: nil)
        }
    }

    static func getLoggedUserId() -> Int {
        let id = Int(userDefaults.integer(forKey: PrefsKeys.PREFS_USER_ID))

        //caso nao seja maior que 0 deve sempre retornar -1
        //parte da antiga logica retornava 0
        return id > 0 ? id : -1
    }

    static func setNeedUpdatePayments(needUpdate: Bool) {
        self.userDefaults.set(needUpdate, forKey: PrefsKeys.PREFS_NEED_UPDATE_LIMITS)
        self.userDefaults.synchronize()
    }

    static func needToUpdatePayments() -> Bool {
        return userDefaults.bool(forKey: PrefsKeys.PREFS_NEED_UPDATE_LIMITS)
    }

    static func canShowReceiptPrePago() -> Bool {
        return userDefaults.bool(forKey: PrefsKeys.PREFS_USER_CAN_SHOW_RECEIPT_PRE_PAGO)
    }

    static func getLoggedUser() -> User {

        let user = User()

        user.name = userDefaults.string(forKey: PrefsKeys.PREFS_USER_NAME) ?? ""
        user.email = userDefaults.string(forKey: PrefsKeys.PREFS_USER_EMAIL) ?? ""
        user.cpf = userDefaults.string(forKey: PrefsKeys.PREFS_USER_CPF) ?? ""
        user.cel = userDefaults.string(forKey: PrefsKeys.PREFS_USER_CEL) ?? ""
        user.picture = userDefaults.string(forKey: PrefsKeys.PREFS_USER_PICTURE) ?? ""
        user.lastLoginDate = userDefaults.string(forKey: PrefsKeys.PREFS_USER_LAST_LOGIN_DATE) ?? ""
        user.lastLoginTime = userDefaults.string(forKey: PrefsKeys.PREFS_USER_LAST_LOGIN_TIME) ?? ""
        user.isQiwiAccountactive = userDefaults.bool(forKey: PrefsKeys.PREFS_USER_IS_QIWI_ACCOUNT_ACTIVE)
        user.usaATM = userDefaults.bool(forKey: PrefsKeys.PREFS_USER_USA_ATM)
        user.isAdesaoDigital = userDefaults.bool(forKey: PrefsKeys.PREFS_USER_IS_ADESAO_DIGITAL)
        user.canShowReceiptPrePago = userDefaults.bool(forKey: PrefsKeys.PREFS_USER_CAN_SHOW_RECEIPT_PRE_PAGO)

        return user;
    }

    static func setLoggedUser(user: User) {

        //Insert on prefs
        userDefaults.set(user.name, forKey: PrefsKeys.PREFS_USER_NAME)
        userDefaults.set(user.email, forKey: PrefsKeys.PREFS_USER_EMAIL)
        userDefaults.set(user.cpf, forKey: PrefsKeys.PREFS_USER_CPF)
        userDefaults.set(user.cel, forKey: PrefsKeys.PREFS_USER_CEL)
        userDefaults.set(user.picture, forKey: PrefsKeys.PREFS_USER_PICTURE)
        userDefaults.set(user.lastLoginDate, forKey: PrefsKeys.PREFS_USER_LAST_LOGIN_DATE)
        userDefaults.set(user.lastLoginTime, forKey: PrefsKeys.PREFS_USER_LAST_LOGIN_TIME)
        userDefaults.set(user.isQiwiAccountactive, forKey: PrefsKeys.PREFS_USER_IS_QIWI_ACCOUNT_ACTIVE)
        userDefaults.set(user.usaATM, forKey: PrefsKeys.PREFS_USER_USA_ATM)
        userDefaults.set(user.isAdesaoDigital, forKey: PrefsKeys.PREFS_USER_IS_ADESAO_DIGITAL)
        userDefaults.set(user.isContaPrePaga, forKey: PrefsKeys.PREFS_USER_IS_CONTA_PRE_PAGA)
        userDefaults.set(user.canShowReceiptPrePago, forKey: PrefsKeys.PREFS_USER_CAN_SHOW_RECEIPT_PRE_PAGO)
        userDefaults.synchronize()
    }

    static func setLoggedUserId(userId: Int) {
        userDefaults.set(userId, forKey: PrefsKeys.PREFS_USER_ID)
        userDefaults.synchronize()
    }

    static func clearLoggedUser() {
        setLoggedUserId(userId: -1)
        setLoggedUser(user: User())
        TokenRN.setHasToken(hasToken: false)
    }

    // Verify if has a user logged
    static func hasLoggedUser() -> Bool {
        return getLoggedUserId() > 0
    }

    // Verify if has a user logged
    static func setCanShowAdesaoPopup(canShow: Bool) {
        UserDefaults.standard.set(canShow, forKey: PrefsKeys.PREFS_CAN_SHOW_ADESAO_POPUP)
        UserDefaults.standard.synchronize()
    }

    static func canShowAdesaoPopup() -> Bool {
        if !UserRN.hasLoggedUser() {
            return false
        }

        if (UserRN.getLoggedUser().isAdesaoDigital || !UserRN.getLoggedUser().usaATM) {
            return false
        }

        let canShow = userDefaults.bool(forKey: PrefsKeys.PREFS_CAN_SHOW_ADESAO_POPUP)
        if !canShow {
            return false
        }

        if ApplicationRN.getAppInitCount() < 4 {
            return false
        }

        ApplicationRN.resetAppInitCount()
        return true
    }

    static func setQiwiAccountActive(isActivity: Bool) {
        userDefaults.set(isActivity, forKey: PrefsKeys.PREFS_USER_IS_QIWI_ACCOUNT_ACTIVE)
        userDefaults.synchronize()
    }

    static func isQiwiAccountActive() -> Bool {
        return userDefaults.bool(forKey: PrefsKeys.PREFS_USER_IS_QIWI_ACCOUNT_ACTIVE)
    }

    static func canShowPasswordVisibilityPopup() {

    }

    /**
     * Check if has a user logged and returns its id number
     * @return User's id number or -1 if doesn't exists.
     */

    static func hasApprovedDocs() -> Bool {
        return UserDefaults.standard.bool(forKey: PrefsKeys.PREFS_SENT_DOC)
    }

    /**
     * Check if has a user logged and returns its id number
     * @return User's id number or -1 if doesn't exists.
     */

    static func needToSendDocs() -> Bool {
        return UserDefaults.standard.bool(forKey: PrefsKeys.PREFS_NEED_TO_SEND_DOC) && !UserDefaults.standard.bool(forKey: PrefsKeys.PREFS_SENT_DOC)
    }

    /**
     * Check if has a user logged and returns its id number
     * @return User's id number or -1 if doesn't exists.
     */

    static func setApprovedDocs(sent: Bool) {
        UserDefaults.standard.set(sent, forKey: PrefsKeys.PREFS_SENT_DOC)
        UserDefaults.standard.synchronize()
    }

    /**
     * Check if has a user logged and returns its id number
     * @return User's id number or -1 if doesn't exists.
     */

    static func setNeedToSendDocs(sent: Bool) {
        UserDefaults.standard.set(sent, forKey: PrefsKeys.PREFS_NEED_TO_SEND_DOC)
        UserDefaults.standard.synchronize()
    }

    /**
     * Get the current Qiwi balance. It will response throw Param.Contact.QIWI_BALANCE_RESPONSE
     */

    func getQiwiBalance() {

        var balance = -1

        // Create request
        let serviceBody = getServiceBody(EmptyObject.self, objectData: EmptyObject())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedQiwiBalance, object: serviceBody)

        callApi(QiwiBalanceResponse.self, request: request) { (qiwiBalanceResponse) in

            //If failed to get the baptism response
            if qiwiBalanceResponse.sucess {
                balance = (qiwiBalanceResponse.body?.data?.balance)!
            }

            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: UserRN.self, param: Param.Contact.QIWI_BALANCE_RESPONSE,
                             result: qiwiBalanceResponse.sucess, object: balance as AnyObject)
        }
    }

    /**
     * Get the current Qiwi balance. It will response throw Param.Contact.QIWI_BALANCE_RESPONSE
     */

    func getPrePagoBalance() {

        var balance = -1

        // Create request
        let serviceBody = getServiceBody(EmptyObject.self, objectData: EmptyObject())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedPrePagoBalance, object: serviceBody)

        callApi(QiwiBalanceResponse.self, request: request) { (qiwiBalanceResponse) in

            //If failed to get the baptism response
            if qiwiBalanceResponse.sucess {
                balance = (qiwiBalanceResponse.body?.data?.balance)!
            }

            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: UserRN.self, param: Param.Contact.PRE_PAGO_BALANCE_RESPONSE,
                             result: qiwiBalanceResponse.sucess, object: balance as AnyObject)
        }
    }

    /**
     * Updates a user preference to adesao. It will response throw Param.Contact.USER_ADESAO_RESPONSE
     */

    func serviceAdesao(type: Int) {

        // Create request
        let objectData = AdesaoBody(type: type)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData?.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedAdesao, json: serviceBody)

        callApi(request: request) { (response) in

            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: UserRN.self, param: Param.Contact.USER_ADESAO_RESPONSE,
                             result: response.sucess)
        }
    }

    /**
     * Get a instance of a baptism object with all fields filled.
     * @param location The current location
     * @return A instance of baptism object.
     */

    private func getDefaultBaptism(location: CLLocation) -> BaptismBody {
        let baptism = BaptismBody()
        baptism.b = SQiwi.gB()
        baptism.city = "São Paulo" // Pegar dados da API do mapa
        baptism.userType = 1
        return baptism
    }

    /**
     * Get a instance of a initialization object with all fields filled.
     * @param location The current location
     * @return A instance of baptism object.
     */

    static func getDefaultInitialization(location: CLLocation) -> InitializationBody {

        let initializationBody = InitializationBody()
        initializationBody.deviceToken = PushNotification.shared.showDeviceToken()
        initializationBody.city = Util.getCity(location: location)
        print("@! >>> LOCATION ", location)
        
        /// ** Get current user Location *
        /// initializationBody.latitude = location.coordinate.latitude
        /// initializationBody.longitude = location.coordinate.longitude
        
        /// ** Rio Claro * -34.9032800°, -56.1881600°
        /// initializationBody.latitude = -34.9032800
        /// initializationBody.longitude = -56.1881600
        
        /// ** Cajamar * -23.35168935226915, -46.87718937060596
        /// initializationBody.latitude = -23.35168935226915
        /// initializationBody.longitude = -46.87718937060596
        
        /// ** Franco da Rocha * -12.046618, -77.042721
        /// initializationBody.latitude = -12.046618000000000
        /// initializationBody.longitude = -77.04272100000000
        
        /// ** Caieiras *
        /// initializationBody.latitude = -23.364500000000000
        /// initializationBody.longitude = -46.74030000000000
        
        /// ** Araraquara *
        /// initializationBody.latitude = -34.603767000000000
        /// initializationBody.longitude = -58.38253600000000
        
        /// ** Osasco *
        /// initializationBody.latitude = -23.532881000000000
        /// initializationBody.longitude = -46.79200400000000
        
        /// ** Franco da Rocha *
        /// initializationBody.latitude = -23.362038000000000
        /// initializationBody.longitude = -46.746509000000000
        
        /// ** Indaiatuba *
        /// initializationBody.latitude = -23.08811770465587
        /// initializationBody.longitude = -47.20814941585173
        
        /// ** São Vicente *
        /// initializationBody.latitude = -23.96055970465587
        /// initializationBody.longitude = -46.39648341585173

        /// ** Santana de Parnaíba *
        /// initializationBody.latitude = -23.447102
        /// initializationBody.longitude = -46.975391
        
        /// ** Ribeirão Preto *
        /// initializationBody.latitude = -21.17217870465587
        /// initializationBody.longitude = -47.80957341585173
        
        /// ** Maceió - AL *
        /// initializationBody.latitude = -9.6602564
        /// initializationBody.longitude = -35.74194

        /// ** Curitiba * -25.467885, -49.298092
        /// initializationBody.latitude = -25.467885
        /// initializationBody.longitude = -49.298092
        
        /// ** Taubaté *
        /// initializationBody.latitude = -23.0426605
        /// initializationBody.longitude = -45.5651574

        if initializationBody.city.isEmpty {
            initializationBody.city = "São Paulo"
        }

        return initializationBody
    }

    /**
     * Log the user on server.<bR>
     * It will response at Param.Contact.USER_LOGIN
     * @param loginBody Login body
     */

    func login(loginBody: LoginBody) {

        let serviceBody = updateJsonWithHeader(jsonBody: loginBody.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedLogin, json: serviceBody)

        callApi(LoginResponse.self, request: request) { (response) in

            var valid = false

            if response.sucess {

                // Extract optional
                if let data = response.body?.data {

                    valid = RestHelper.setT(a: data.t, header: response.header ?? BodyHeaderResponse())

                    if valid {

                        // Verficiar o force warping
                        UserRN.setLoggedUserId(userId: data.userId)
                        DocumentsRN.setShowDocPopup(canShow: true)
                        DocumentsRN.clearRemberLaterTime()

//                        self.sendContact(fromClass: UserRN.self, param: Param.Contact.USER_LOGIN, result: response.sucess && valid, object: response)
                        self.updateUser(completion: { result in
                            valid = result

                            self.sendContact(fromClass: UserRN.self, param: Param.Contact.USER_LOGIN, result: response.sucess && valid, object: response)
                        })
                        return
                    }
                }
            }

            UserRN.clearLoggedUser()
            self.sendContact(fromClass: UserRN.self, param: Param.Contact.USER_LOGIN, result: false, object: response.body?.showMessages() as AnyObject)
        }
    }

    /**
     * Calls the get user info api to updates user info. Must be called on worker thread
     */

    func callAndUpdateUserInfo(completion: @escaping (_ result: Bool) -> Void) {
        return updateUser(completion: completion)
    }

    func updateUser(completion: @escaping (_ result: Bool) -> Void) {

        let serviceBody = getServiceBody(EmptyObject.self, objectData: EmptyObject())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedUserInfo, object: serviceBody)

        callApi(UserInfoResponse.self, request: request) { (userResponse) in

            //If it's valid, updates user info
            if userResponse.sucess {

                let creditCardTokenDAO = CreditCardTokenDAO()
                creditCardTokenDAO.deleteAll()

                // Verficiar o force warping
                if let user = userResponse.body?.data?.user {

                    UserRN.setLoggedUser(user: user)
                    UserRN.setApprovedDocs(sent: user.sentDoc)
                    creditCardTokenDAO.insert(with: (userResponse.body?.data?.cardTokens)!)

                    let dao = CouponDAO()
                    dao.deleteAll()
                    if userResponse.body?.data?.user?.coupons != nil && !(userResponse.body?.data?.user?.coupons!.isEmpty)! {
                        dao.insert(with: (userResponse.body?.data?.user?.coupons!)!)
                    }
                }

                //getDatabaseInstance().creditCardTokenDAO().insertAll(userResponse.getBody().getData().getCardTokens());
                let documentsRN = DocumentsRN(delegate: self.delegate)

                if let data = userResponse.body?.data {
                    documentsRN.setDocumentProcesses(documents: data.processes)
                }

                //getDatabaseInstance().bankRequestDAO().deleteAll();
                //--------- Update user banks ---------
                let bankDAO = BankRequestDAO()
                bankDAO.deleteAll()
                if userResponse.body?.data?.banks != nil && !(userResponse.body?.data?.banks.isEmpty)! {
                    bankDAO.insert(with: (userResponse.body?.data?.banks)!)
                }

                //--------- Update transport cards ---------
                let transportDAO = TransportCardDAO()
                transportDAO.deleteAll()
                if userResponse.body?.data?.transportCards != nil && !(userResponse.body?.data?.transportCards.isEmpty)! {
                    transportDAO.insert(with: (userResponse.body?.data?.transportCards)!)
                }

                //--------- Update contacts ---------
                let phoneContactDAO = PhoneContactDAO()
                phoneContactDAO.deleteAll()
                if userResponse.body?.data?.contacts != nil && !(userResponse.body?.data?.contacts.isEmpty)! {
                    phoneContactDAO.insert(with: (userResponse.body?.data?.contacts)!)
                }
                
                //--------- Update pix accounts ---------
                let pixDAO = PIXRequestDAO()
                pixDAO.deleteAll()
                if userResponse.body?.data?.pix != nil && !(userResponse.body?.data?.pix.isEmpty)! {
                    pixDAO.insert(with: (userResponse.body?.data?.pix)!)
                }

                //Or if were successfully connected.
                //Delete all taxes to replace for the newest
                if (userResponse.body?.data?.user?.isContaPrePaga)! &&  userResponse.body?.data?.user?.taxes != nil && !(userResponse.body?.data?.user?.taxes?.isEmpty)! {
                    // Deletar todos
                    // Inserir todos novamente
                    TaxesDAO().deleteAll()
                    TaxesDAO().insert(with: (userResponse.body?.data!.user?.taxes)!)
                }

                // ATUALIZAR BANCO LOCAL

                //Receive if user has token and save
                if let data = userResponse.body?.data {
                    TokenRN.setHasToken(hasToken: data.user?.hasToken ?? false)
                }

                //@todo testar
                if UserRN.needToUpdatePayments() && ApplicationRN.isQiwiPro() {
                    PaymentRN(delegate: self).updatePaymentLimitsForPreUser()
                    UserRN.setNeedToSendDocs(sent: false)
                }

                completion(true)
                HomeViewController.delegate?.onReceiveData(fromClass: UserRN.self, param: Param.Contact.NEED_UPDATE_DATA, result: true, object: nil)
                return
            }

            //If it's here, service call failed
            UserRN.clearLoggedUser()
            completion(false)
        }
    }

    /**
     * Log the user on server.<bR>
     * It will response at Param.Contact.USER_LOGIN
     */

    func logout() {

        let serviceBody = getServiceBody(EmptyObject.self, objectData: EmptyObject())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedLogout, object: serviceBody)

        callApi(EmptyObject.self, request: request) { (response) in

            if response.sucess {

                //Clear the logged user
                if response.body?.cod == ResponseCodes.RESPONSE_OK {
                    if let currentVC = self.currentViewController {
                        currentVC.dismiss(animated: false)
                        self.startWarningActivity(isLogout: true)
                    }
                }
            }

            self.sendContact(fromClass: UserRN.self, param: Param.Contact.USER_LOGOUT, result: response.sucess, object: response)
        }
    }
    
    func delete(deleteBody: DeleteBody) {

        let serviceBody = updateJsonWithHeader(jsonBody: deleteBody.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedDelete, json: serviceBody)

        callApi(EmptyObject.self, request: request) { (response) in

            if response.sucess {

                //Clear the logged user
                if response.body?.cod == ResponseCodes.RESPONSE_OK {
                    if let currentVC = self.currentViewController {
                        //currentVC.dismiss(animated: false)
                        self.startWarningActivity(isLogout: true)
                    }
                }
                
                self.sendContact(fromClass: UserRN.self, param: Param.Contact.USER_LOGOUT, result: response.sucess, object: response)
            }
            
            self.sendContact(fromClass: UserRN.self, param: Param.Contact.USER_LOGOUT, result: false, object: response.body?.showMessages() as AnyObject)
        }
    }

    /**
     * Get the user info from server<bR>
     * It will response at Param.Contact.USER_INFO_RESPONSE
     */

    func getUserInfo() {

        callAndUpdateUserInfo{ response in

            //Send contact
            self.sendContact(fromClass: UserRN.self, param: Param.Contact.USER_INFO_RESPONSE, result: response, object: response as AnyObject)
        }
    }

    /**
     * Get the user info from server<bR>
     * It will response at Param.Contact.USER_INFO_RESPONSE
     */

    func getUserInfoWithNoResponse() {
    }

    /**
     * Log the user on server.<bR>
     * It will response at Param.Contact.USER_LOGIN
     * @param context App context
     * @param user User to login
     */

    func loginFacebook() {
    }

    /**
     * Log the user on server.<bR>
     * It will response at Param.Contact.USER_REGISTER
     * @param registerBody User to register
     */

    func register(registerBody: RegisterBody) {

//        let serviceBody = getServiceBody(RegisterBody.self, objectData: registerBody)
//        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedRegister, object: serviceBody)

        let serviceBody = updateJsonWithHeader(jsonBody: registerBody.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedRegister, json: serviceBody)

        callApi(RegisterResponse.self, request: request) { (response) in

            if response.sucess {
                //
            }

            self.sendContact(fromClass: UserRN.self, param: Param.Contact.USER_REGISTER, result: response.sucess, object: response)
        }
    }

    /**
     * Log the user on server.<bR>
     * It will response at Param.Contact.USER_LOGIN
     * @param user User to login
     */

    func registerFacebook() {
    }

    /**
     * Changes the user password to a new one. <br><br>
     * It will response throw USER_SMS_PASSWORD_SENT.
     * @param userId The user's Id
     * @param validationCode The sms received code
     * @param newPass The new one
     */
    func changePassword<ControllerType: UIViewController>(_ type: ControllerType.Type, sender: UIViewController, userId: Int, validationCode: String, newPass: String) {

        let objRequest = ChangePasswordBody(userId: userId, password: newPass, activationCode: validationCode)
        let serviceBody = updateJsonWithHeader(jsonBody: objRequest.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedChangePassword, json: serviceBody)

        callApi(ChangePasswordResponse.self, request: request) { (response) in

            var valid = false
            if response.sucess {
                //
                valid = RestHelper.setT(a: (response.body?.data?.t)!, header: response.header ?? BodyHeaderResponse())
                if valid {
                    UserRN.setLoggedUserId(userId: (response.body?.data?.userId)!)
                    self.getUserInfo()
                } else {
                    UserRN.clearLoggedUser()
                }
            }

            self.sendContact(fromClass: UserRN.self, param: Param.Contact.USER_CHANGE_PASSWORD, result: response.sucess, object: nil)
        }
    }

    /**
     * Changes the user password to a new one. <br><br>
     * It will response throw USER_SMS_PASSWORD_SENT.
     * @param cpf The user's cpf
     * @param validationCode The sms received code
     * @param newPass The new one
     */
    func changeQiwiPassword(cpf: String, validationCode: String, newPass: String) {

        let seq = self.getNextSequencial()
        let newPass = RestHelper.getQiwiPW(pass: newPass, seq: seq)

        let objRequest = ChangeQiwiPassBody(cpf: cpf, code: validationCode, newPass: newPass)
        let serviceBody = updateJsonWithHeader(jsonBody: objRequest.generateJsonBodyAsString(), seq: seq)
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedChangeQiwiPass, json: serviceBody)

        callApi(request: request) { (response) in


            if response.sucess {

            }

            self.sendContact(fromClass: UserRN.self, param: Param.Contact.USER_CHANGE_QIWI_PASSWORD, result: response.sucess, object: nil)
        }
    }

    /**v

     * Send the instructions to user's phone to reset it's password.<br>
     * It will response throw USER_SMS_PASSWORD_SENT.
     * @param userId User's id
     */

    func sendSMSPassword(cpf: String, phone: String, userId: Int) {

        let objRequest = SendPasswordSMSBody(cpf: cpf, phone: phone, userId: userId)
        let serviceBody = updateJsonWithHeader(jsonBody: objRequest.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedSendPasswordSMS, json: serviceBody)

        callApi(SendPasswordSMSResponse.self, request: request) { (response) in

            var userId = 0
            if response.sucess {
                //
                userId = (response.body?.data?.userId)!
            }

            self.sendContact(fromClass: UserRN.self, param: Param.Contact.USER_SMS_PASSWORD_SENT, result: response.sucess, object: userId as AnyObject)
        }
    }

    /**
     * Send the qiwi password to user's phone by sms.<br>
     * It will response throw USER_FORGOT_QIWI_PASS.
     */
    func forgotQiwiPassword(cpf: String, phone: String) {

        let objRequest = ForgotQiwiPasswordRequest(cpf: cpf, phone: phone)
        let serviceBody = updateJsonWithHeader(jsonBody: objRequest.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedForgotQiwiPass, json: serviceBody)

        callApi(request: request) {(response) in

            self.sendContact(fromClass: UserRN.self, param: Param.Contact.USER_FORGOT_QIWI_PASS, result: response.sucess, object: nil)
        }
    }

    /**
     * Send a SMS to validate the register.<br>
     * It will response throw USER_SEND_SMS_QIWI_PASSWORD.
     * @param registerId User's register id
     */

    func sendSMSQiwiPassword() {

        let objectData = SendSMSQiwiPassBody(phone: UserRN.getLoggedUser().cel)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedGenerateQiwiPassCode, json: serviceBody)

        callApi(request: request) { (response) in

            if response.sucess {
                //
            }

            self.sendContact(fromClass: UserRN.self, param: Param.Contact.USER_SEND_SMS_QIWI_PASSWORD, result: response.sucess, object: response)
        }
    }

    /**
     * Send a SMS to validate the register.<br>
     * It will response throw USER_SEND_SMS.
     * @param registerId User's register id
     */

    func sendSMSRegister(registerId: Int) {

        let objectData = SendActivationSMSBody(registerId: registerId)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedSendActivationSMS, json: serviceBody)

        callApi(RegisterResponse.self, request: request) { (response) in

            if response.sucess {
                //
            }

            self.sendContact(fromClass: UserRN.self, param: Param.Contact.USER_SEND_SMS, result: response.sucess, object: response)
        }
    }

    /**
     * Send a SMS to validate the register.<br>
     * It will response throw USER_SEND_SMS.
     * @param registerId User's register id
     */

    func sendPromotionCode(code: String) {

        let objRequest = PromotionCodeBody(code: code.uppercased(), phone: userDefaults.string(forKey: PrefsKeys.PREFS_USER_CEL) ?? "")
        let serviceBody = updateJsonWithHeader(jsonBody: objRequest.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedPromotionCode, json: serviceBody)

        callApi(request: request) {(response) in

            self.sendContact(fromClass: UserRN.self, param: Param.Contact.USER_PROMO_CODE, result: response.sucess, object: nil)
        }
    }

    /**
     * Validate a SMS message.<br>
     * It will response throw USER_SMS_VALIDATION_REGISTER.
     * @param registerId The registration id that returns from register service
     * @param validationCode The validation code from sms
     */

    func validateSMSForRegister(sender: UIViewController, activationCod: String, registerId: Int) {

        let objRequest = RegisterActivationBody(activationCod: activationCod, registerId: registerId)
        let serviceBody = updateJsonWithHeader(jsonBody: objRequest.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedRegisterActivation, json: serviceBody)

        callApi(RegisterActivationResponse.self, request: request) { (response) in

            var valid = false
            if response.sucess {
                //
                valid = RestHelper.setT(a: (response.body?.data?.t)!, header: response.header ?? BodyHeaderResponse())
                if valid {
                    UserRN.setLoggedUserId(userId: (response.body?.data?.userId)!)
                    self.getUserInfo()
                } else {
                    UserRN.clearLoggedUser()
                }
            }

            self.sendContact(fromClass: UserRN.self, param: Param.Contact.USER_SMS_VALIDATION_REGISTER, result: response.sucess && valid, object: response)
        }
    }

    /**
     * Log the user on server.<bR>
     * It will response at Param.Contact.USER_LOGIN
     */

    func getCommissionList() {

        var commissionList = [Commission]()
        let serviceBody = getServiceBody(EmptyObject.self, objectData: EmptyObject())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedCommissionList, object: serviceBody)

       callApiForList(Commission.self, request: request) { (orderResponse) in

            //If failed to get the baptism response
            if orderResponse.sucess {
                commissionList = (orderResponse.body?.data)!
            }

            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: UserRN.self, param: Param.Contact.USER_COMMISSION_LIST_RESPONSE,
                             result: orderResponse.sucess, object: commissionList as AnyObject)
        }
    }

    /**
     * Delete a item from server database (bank, credit card, etc)
     */

    func insertOrUpdateItemsOnServer() {
    }

    /**
     * Delete a item from server database (bank, credit card, etc)
     */

    func insertOrUpdateItemsOnServerWithoutThread() {
    }

    /**
     * Delete a item from server database (bank, credit card, etc)
     * @param serverPk The primary key of the item
     */

    func deleteItemsFromServer(serverPk: Int) {

    }

    /**
     * Delete a item from server database (bank, credit card, etc)
     * @param serverPk The primary key of the item
     */

    func deleteItemsFromServerWithoutThread() {
    }
}

extension UserRN : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {

    }
}
