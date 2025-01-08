
//
//  ApplicationRN.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 28/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class ApplicationRN: BaseRN {
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    func initT() -> Bool {
        
        let sqr = SQiwi.iT()
        
        //If it's different from 0, should finish the app
        if sqr != 0 {
            sendContact(fromClass: ApplicationRN.self, param: Param.Contact.FINISH_ACTIVITY, result: false, object: nil)
            return false
        }
        
        return true
    }
    
    static func isDev() -> Bool {
        return BaseURL.CURRENT_URL != BaseURL.URL_PROD
    }
    
    static func isProd() -> Bool {
        return BaseURL.CURRENT_URL == BaseURL.URL_PROD
    }
    
    static func isQiwiBrasil() -> Bool {
        //return false
        return !UserDefaults.standard.bool(forKey: PrefsKeys.PREFS_USER_IS_CONTA_PRE_PAGA)
    }
    
    static func isQiwiPro() -> Bool {
        //return true
        return UserDefaults.standard.bool(forKey: PrefsKeys.PREFS_USER_IS_CONTA_PRE_PAGA)
    }
    
    static func setNeedInitialization(need: Bool) {
        UserDefaults.standard.set(need, forKey: PrefsKeys.PREFS_NEED_INITIALIZATION)
        UserDefaults.standard.synchronize()
    }
    
    static func getNeedInitialization() -> Bool {
        //return true
        return UserDefaults.standard.bool(forKey: PrefsKeys.PREFS_NEED_INITIALIZATION)
    }
    
    func getCommissionList() -> [Commission] {
        var commissions = [Commission]()
        commissions.append(Commission("Bilhete Único", "0.7%"))
        commissions.append(Commission("Telefonia", "2.5%"))
        commissions.append(Commission("Consumo Geral", "1.5%"))
        commissions.append(Commission("Boleto Bancário", "2.5%"))
        commissions.append(Commission("Google Play", "1%"))
        commissions.append(Commission("League of Legends", "2%"))
        commissions.append(Commission("Consulta CNPJ ","20%"))
        commissions.append(Commission("Consulta CPF","20%"))
        commissions.append(Commission("Me Proteja Mensal","15%"))
        commissions.append(Commission("Norton","10%"))
        commissions.append(Commission("LevelUp","10%"))
        commissions.append(Commission("CET Zona Azul", "10%"))
        commissions.append(Commission("Office","5%"))
        commissions.append(Commission("Project Cars 2","4%"))
        commissions.append(Commission("Grow Games","4%"))
        commissions.append(Commission("DragonBall Xenoverse 2","4%"))
        commissions.append(Commission("Rainbowsix Siege","4%"))
        commissions.append(Commission("Tekken 7","4%"))
        commissions.append(Commission("Rixty OFFLINE","4%"))
        commissions.append(Commission("E-PREPAG","4%"))
        commissions.append(Commission("IMVU","4%"))
        commissions.append(Commission("Xbox Credits","4%"))
        commissions.append(Commission("Xbox Geoblocked","4%"))
        commissions.append(Commission("NeoPets","4%"))
        commissions.append(Commission("Xbox Game Pass","4%"))
        commissions.append(Commission("Netflix","2%"))
        commissions.append(Commission("Blizzard","2%"));
        commissions.append(Commission("Sony Playstation","2%"))
        commissions.append(Commission("Sky TV","2%"))
        commissions.append(Commission("Counter Strike Global Offensive","2%"))
        commissions.append(Commission("Google Play DDP","1%"))
        commissions.append(Commission("Uber","1%"))
        commissions.append(Commission("Steam","1%"))
        commissions.append(Commission("Nosso Expresso","1%"))
        commissions.append(Commission("Nosso Estudante","1%"))
        commissions.append(Commission("Spotify","1%"))
        
        return commissions
    }
    
    func incrementReinitializeCount() {
        setReinitializeCount(count: getReinitializeCount() + 1)
    }
    
    func clearReinitializeCount() {
        setReinitializeCount(count: 0)
    }
    
    func setReinitializeCount(count: Int) {
        self.userDefaults.set(count, forKey: PrefsKeys.PREFS_REINITIALIZE_COUNT)
        self.userDefaults.synchronize()
    }
    
    func getReinitializeCount() -> Int {
        return userDefaults.integer(forKey: PrefsKeys.PREFS_REINITIALIZE_COUNT)
    }
    
    static func incrementAppInitCount() {
        let initCount = UserDefaults.standard.integer(forKey: PrefsKeys.PREFS_INITIALIZATION_COUNT)
        UserDefaults.standard.set(initCount + 1, forKey: PrefsKeys.PREFS_INITIALIZATION_COUNT)
        UserDefaults.standard.synchronize()
    }
    
    static func resetAppInitCount() {
        UserDefaults.standard.set(0, forKey: PrefsKeys.PREFS_INITIALIZATION_COUNT)
        UserDefaults.standard.synchronize()
    }
    
    static func getAppInitCount() -> Int {
        return UserDefaults.standard.integer(forKey: PrefsKeys.PREFS_INITIALIZATION_COUNT)
    }
    
    static func setDataPrivacyConfirmed() {
        UserDefaults.standard.set(true, forKey: PrefsKeys.PREFS_PRIVACY_CONFIRMATION)
        UserDefaults.standard.synchronize()
    }
    
    static func isDataPrivacyConfirmed() -> Bool {
        return UserDefaults.standard.bool(forKey: PrefsKeys.PREFS_PRIVACY_CONFIRMATION)
    }
}
