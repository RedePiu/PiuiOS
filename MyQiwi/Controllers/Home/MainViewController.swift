//
//  MainViewController.swift
//  MyQiwi
//
//  Created by ailton on 14/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    // MARK: Variables
    
    static var isUpdate = false
    
    // MARK: Ciclo de vida
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViewWillAppear()
    }
}

// MARK: Setup UI
extension MainViewController {
    
    fileprivate func setupViewDidLoad() {
        
        // Cores para a tab bar

        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Theme.default.primary
            
            let bgColor = Theme.default.background.withAlphaComponent(0.8)
            appearance.compactInlineLayoutAppearance.normal.iconColor = bgColor
            appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : bgColor]
            
            appearance.inlineLayoutAppearance.normal.iconColor = bgColor
            appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : bgColor]
            
            appearance.stackedLayoutAppearance.normal.iconColor = bgColor
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : bgColor]
            
            self.tabBar.standardAppearance = appearance
            self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance
        } else {
            self.tabBar.barTintColor = Theme.default.primary
            self.tabBar.unselectedItemTintColor = Theme.default.background.withAlphaComponent(0.95)
        }
        
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = UIColor.white

        // Font
        let attrsStateDefault = [
            NSAttributedStringKey.font: FontCustom.helveticaRegular.font(18) ]
        self.tabBar.selectedItem?.setTitleTextAttributes(attrsStateDefault, for: .normal)
        
        // Font para o selecionado
        let attrsStateSelected = [
            NSAttributedStringKey.font: FontCustom.helveticaBold.font(18) ]
        self.tabBar.selectedItem?.setTitleTextAttributes(attrsStateSelected, for: .selected)
        
//        //Se está logado
        if UserRN.canShowAdesaoPopup() {
            Util.showController(PopupAdesaoDigital.self, sender: self)
        }
    }
    
    fileprivate func setupViewWillAppear() {
        
        if MainViewController.isUpdate {
            let updateNeededController = UpdateNeededViewController()
            self.present(updateNeededController, animated: true)
        }
    }
}
