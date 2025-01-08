//
//  MenuItemRN.swift
//  MyQiwi
//
//  Created by ailton on 01/01/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import Foundation

class MenuItemRN: BaseRN {

    init() {
        super.init(delegate: nil)
    }

    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }

    static func tempTerminalDefinition(menus: [MenuItem]) {
        var mainMenus = 0

        for menu in menus {
            if menu.dadId == 0 {
                mainMenus = mainMenus + 1
                
                if menu.desc.lowercased().contains("taubate") {
                    MenuItemRN.setTerminalType(terminalType: ActionFinder.TerminalType.TAUBATE)
                    return
                }
                
                /* comentado pois o menu de prodata também são 5 itens
                if menu.desc.lowercased().contains("nosso") ||
                    menu.desc.lowercased().contains("sao vicente") {
                    MenuItemRN.setTerminalType(terminalType: ActionFinder.TerminalType.RIBEIRAO_PRETO)
                    return
                }
                */
            }
        }

        //Curitiba tem 6
        if mainMenus == 6 {
            MenuItemRN.setTerminalType(terminalType: ActionFinder.TerminalType.CURITIBA)
        }
        //SP tem 5
        else {

            //Sao paulo e ribeirao sao iguais na versao atual
            //O primeiro item da lista será bilhete único se for sp
            MenuItemRN.setTerminalType(terminalType: ActionFinder.TerminalType.SAO_PAULO)
        }
    }

    static func setTerminalType(terminalType: Int) {
         UserDefaults.standard.set(terminalType, forKey: PrefsKeys.PREFS_TERMINAL_TYPE)
    }

    static func getTerminalType() -> Int {
        return UserDefaults.standard.integer(forKey: PrefsKeys.PREFS_TERMINAL_TYPE)
    }

    func getMainList() -> [MenuItem] {

        //var mainMenu = MenuItemDAO().getAllFromDad(dadId: 0)
//        var items = [MenuItem]()

//        items.append(MenuItem(description: "Bilhete ÚNICO", action: ActionFinder.ACTION_TRANSPORT_CARD_CITTAMOBI, imageMenu: "Content/img/menu/menu_main_bilheteunico.png", prvid: 100058))
//        items.append(MenuItem(description: "Recarga Telefone", action: ActionFinder.ACTION_CEL_RECHARGE, imageMenu: "Content/img/menu/menu_main_telefonia.png"))
//        items.append(MenuItem(description: "Zona Azul", action: ActionFinder.ACTION_PARKING, imageMenu: "Content/img/menu/menu_main_cet.png"))
//        items.append(MenuItem(description: "Pagamento de contas", action: ActionFinder.ACTION_BILL_PAYMENT, imageMenu: "Content/img/menu/menu_main_pagamentos.png"))
//        items.append(MenuItem(description: "Outros Produtos", action: ActionFinder.MENUID_OTHERS, imageMenu: "Content/img/menu/menu_main_outros.png"))

        let items = MenuItemDAO().getAllFromDad(dadId: 0)
        return items
    }

    func getAccountServiceList() -> [MenuItem] {

        var menuItens = [MenuItem]()

        menuItens.append(MenuItem(description: "more_menu_change_picture".localized, action: ActionFinder.Account.EDIT_PICTURE, imageMenu: "ic_side_camera"))
        menuItens.append(MenuItem(description: "more_menu_change_pass".localized, action: ActionFinder.Account.CHANGE_PASSWORD, imageMenu: "ic_side_password"))
        menuItens.append(MenuItem(description: "more_menu_change_piu_pass".localized, action: ActionFinder.Account.QIWI_PASS, imageMenu: "ic_side_qiwi_pass"))
        menuItens.append(MenuItem(description: "more_menu_terms".localized, action: ActionFinder.Account.TERMS, imageMenu: "ic_side_contract"))
        menuItens.append(MenuItem(description: "more_menu_rate".localized, action: ActionFinder.Account.RATE_APP, imageMenu: "ic_side_rate"))

        return menuItens
    }

    func getFullServiceList() -> [MenuItem] {

        var menuItens: [MenuItem] = []

        menuItens.append(MenuItem(description: "more_menu_qtoken".localized, action: ActionFinder.ID_APP_TOKEN_VALIDATION, imageMenu: "ic_token_secure"))
        menuItens.append(MenuItem(description: "notification_toolbar_title".localized.lowercased(), action: ActionFinder.ID_NOTIFICATION, imageMenu: "ic_world"))
        
        let terminalType = MenuItemRN.getTerminalType()
        if !ApplicationRN.isQiwiPro() && terminalType == ActionFinder.TerminalType.TAUBATE {
            
            menuItens.append(MenuItem(description: "more_menu_student_form".localized, action: ActionFinder.ID_STUDENT_FORM, imageMenu: "ic_studant"))
        }

//        menuItens.append(MenuItem(description: "editar métodos de pagamento",  action: ActionFinder.ID_EDIT_PAYMENT_METHODS, imageMenu: "ic_payment_methods"))

        if UserRN.hasLoggedUser() {

            menuItens.append(MenuItem(description: "more_menu_add_piu_credit".localized, action: ActionFinder.QIWI_BALANCE_RECHARGE_PRVID, imageMenu: "ic_logo_piu_rounded_no_padding"))

            if ApplicationRN.isQiwiPro() {
                menuItens.append(MenuItem(description: "more_menu_pay_debts".localized, action: ActionFinder.ID_APP_DIVIDA, imageMenu: "ic_divida"))

                menuItens.append(MenuItem(description: "more_menu_commi".localized, action: ActionFinder.Account.COMMISSION, imageMenu: "ic_menu_info"))
            }


            if ApplicationRN.isQiwiBrasil() {
                menuItens.append(MenuItem(description: "more_menu_credit_card".localized, action: ActionFinder.ID_ADD_CREDIT_CARD, imageMenu: "ic_creditcard"))
            }

            menuItens.append(MenuItem(description: "more_menu_change_pass".localized, action: ActionFinder.Account.CHANGE_PASSWORD, imageMenu: "ic_side_password"))
            menuItens.append(MenuItem(description: "more_menu_change_piu_pass".localized, action: ActionFinder.Account.QIWI_PASS, imageMenu: "ic_side_qiwi_pass"))

            let user = UserRN.getLoggedUser()
            if !user.isAdesaoDigital && user.usaATM {
                menuItens.append(MenuItem(description: "more_menu_adesao".localized, action: ActionFinder.ID_ADESAO_DIGITAL, imageMenu: "ic_menu_adesao"))
            }
        }

        menuItens.append(MenuItem(description: "app_info_toolbar_title".localized.lowercased(), action: ActionFinder.ID_APP_INFO, imageMenu: "ic_side_rate"))
        
        //adiciona botão para compartilhar App
        menuItens.append(MenuItem(description: "share_app".localized.uppercased(), action: ActionFinder.ID_SHARE_APP, imageMenu: "ic_share"))
        
        if UserRN.hasLoggedUser() {
            //adicionar botão para excluir conta
            //exclude_user
            menuItens.append(MenuItem(description: "exclude_user".localized, action: ActionFinder.ID_EXCLUDE_USER, imageMenu: "ic_close"))
        }

        return menuItens
    }

    func getAttendanceList() -> [MenuItem] {

        var menuItens: [MenuItem] = []

//      menuItens.append(MenuItem(description: "atendimento online", order: ActionFinder.Attendance.ID_CHAT, imageMenu: "ic_menu_chat"))
        menuItens.append(MenuItem(description: "attendance_message_contact".localized, order: 0, imageMenu: "ic_menu_question"))

        return menuItens
    }
    
    func getOtherServicesMenu() -> MenuItem {
        return MenuItemDAO().getMenu(action: ActionFinder.ACTION_OTHERSERVICES)
    }

    func getFullOthersList(otherServiceId: Int) -> [MenuItem] {

        let menuItens = MenuItemDAO().getAllFromDad(dadId: otherServiceId)

        var filteredMenus = [MenuItem]()
        let dao = MenuItemDAO()

        for menu in menuItens {
            if !dao.getAllFromDad(dadId: menu.id).isEmpty {
                filteredMenus.append(menu)
            }
        }

        return filteredMenus
    }

    func getFullTopOthersList(otherServiceId: Int) -> [MenuItem] {

        let menuItens = MenuItemDAO().getAllFromDadTop(dadId: otherServiceId)
        return menuItens
    }

    func getFullOthersListTest(dadId: Int, name: String = "") -> [MenuItem] {

        var menuItens = MenuItemDAO().getAllFromDad(dadId: dadId, name: name)

//        let menu = MenuItem(description: "", image: "menus/menu_produto_drterapia", action: ActionFinder.ACTION_DRTERAPIA, id: 0, data: nil)
//        menu.prvID = 100220
//        menuItens.append(menu)
//        var menuItens = [MenuItem]()
//        menuItens.append(MenuItem(description: "menu_produto_googleplay", order: -100, imageMenu: "menu_produto_googleplay"))
//        menuItens.append(MenuItem(description: "menu_produto_lol", order: -98, imageMenu: "menu_produto_lol"))
//        menuItens.append(MenuItem(description: "menu_produto_netflix", order: 0, imageMenu: "menu_produto_netflix"))

        return menuItens
    }
}
