//
//  MoreViewController.swift
//  MyQiwi
//
//  Created by ailton on 20/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import UIKit
import ObjectMapper

class MoreViewController: UIBaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbInfoLogin: UILabel!
    @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lbOtherProducts: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollection: NSLayoutConstraint!
    
    @IBOutlet weak var lbExpand: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!
    
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var tableViewOptions: UITableView!
    
    @IBOutlet weak var viewButtonsLogin: UIView!
    @IBOutlet weak var viewButtonsLogout: UIView!
    
    // MARK: Variables
    var needReload = true
    var menuItensOptions: [MenuItem] = []
    var menuItensOthers: [MenuItem] = []
    var isExpand: Bool = false
    var mUserRN: UserRN?
    var mMenuItemRN: MenuItemRN?
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
    
        self.mMenuItemRN = MenuItemRN(delegate: self)
        self.mUserRN = UserRN(delegate: self)
        self.mUserRN?.currentViewController = self
        
        if let serviceList = mMenuItemRN?.getFullServiceList() {
            self.menuItensOthers = serviceList
        }
        
        if let accountServiceList = mMenuItemRN?.getAccountServiceList() {
            self.menuItensOptions = accountServiceList
        }
        
        self.setupUI()
        self.setupTexts()
        self.setupTableView()
        self.setupCollectionView()
        
        self.collectionView.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [.new], context: nil)
    }
    
    override func setupViewWillAppear() {
        
        Util.setLogoBarIn(self)
        self.tabBarController?.delegate = self
        
        if UserRN.hasLoggedUser() {
            
            // com login
            
            self.lbName.text = UserRN.getLoggedUser().getFirstName()
            self.lbInfoLogin.text = "account_welcome".localized
                .replacingOccurrences(of: "{num}", with: UserRN.getLoggedUser().getCensoredCel())
            
            self.viewButtonsLogout.isHidden = false
            self.viewButtonsLogin.isHidden = true
            self.lbExpand.superview?.isHidden = false
            self.lbName.isHidden = false
            
        }else {
            
            // Sem login
            self.lbInfoLogin.text = "login_must_login".localized
            self.viewButtonsLogout.isHidden = true
            self.viewButtonsLogin.isHidden = false
            self.lbExpand.superview?.isHidden = true
            self.lbName.isHidden = true
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: Observer Height Collection
extension MoreViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(UICollectionView.contentSize) {
            if let _ = object as? UICollectionView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.heightCollection.constant = size.height
                    return
                }
            }
        }
    }
}

// MARK: Base Delegate
extension MoreViewController: BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        if fromClass == UserRN.self {
            
            if param == Param.Contact.USER_LOGOUT {
                DispatchQueue.main.async {
                    self.dismissPage(nil)
                }
                return
            }
        }
        
        if fromClass == MenuItemRN.self {
            
            if param == Param.Contact.MENU_ACCOUNT_OPTIONS {
                if let items = object as? [MenuItem] {
                    fillAccountServiceList(menuItems: items)
                }
            }
            
            if param == Param.Contact.MENU_MORE_SERVICES {
                if let items = object as? [MenuItem] {
                    fillServiceList(menuItems: items)
                }
            }
        }
    }
}

// MARK: TabBar Delegate
extension MoreViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if UserRN.hasLoggedUser() {
            //mUserRN?.getUserInfo()
            Util.removeNeedLogin(self)
        }
    }
}

// MARK: IBActions
extension MoreViewController {
    
    @IBAction func openCardAcount() {
        
        self.isExpand = !self.isExpand
        
        self.btnExpand.titleLabel?.textAlignment = .center
        
        if self.isExpand {
            self.btnExpand.titleLabel?.text = "account_hide_more".localized
            self.lbExpand.text = "account_hide_more".localized
            self.imgArrow.image = UIImage(named: "ic_expand_less")!
            self.heightTableView.constant = self.tableViewOptions.contentSize.height
        }else {
            self.btnExpand.titleLabel?.text = "account_see_more".localized
            self.lbExpand.text = "account_see_more".localized
            self.imgArrow.image = UIImage(named: "ic_expand_more")!
            self.heightTableView.constant = 0
        }
        
        self.imgArrow.tintColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiDark)
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func openCamera() {
        
        // Abrir camera
        Util.selectTakePhoto(self) { (img) in
            self.imgUser.image = img
            self.imgUser.layer.cornerRadius = self.imgUser.frame.height / 2
            self.imgUser.clipsToBounds = true
        }
    }
    
    @IBAction func openTerms() {
        
        // Termos de uso
        Util.showPopupWebView(self)
    }
    
    @IBAction func openAppStore() {
        
        // Avaliar o app
        Util.openAppleStore()
    }
    
    @IBAction func openRegister(sender: UIButton) {
        self.performSegue(withIdentifier: Constants.Segues.REGISTER, sender: nil)
    }
    
    @IBAction func openLogin(sender: UIButton) {
        self.performSegue(withIdentifier: Constants.Segues.LOGIN, sender: nil)
    }
    
    @IBAction func openLogout(sender: UIButton) {
        self.showWarning()
        
    }
}

extension MoreViewController {
    
    func fillAccountServiceList(menuItems: [MenuItem]) {
        
        if !UserRN.hasLoggedUser() {
            return
        }
        
        menuItensOptions = menuItems
        
        DispatchQueue.main.async {
            self.tableViewOptions.reloadData()
        }
    }
    
    func fillServiceList(menuItems: [MenuItem]) {
        
        menuItensOthers = menuItems
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showWarning() {
        
        Util.showController(WarningViewController.self, sender: self, completion: { controller in
            //controller.btnContinue.addTarget(self, action: #selector(self.restartApp), for: .touchUpInside)
            controller.getLogoutIntent()
        })
        UserRN.clearLoggedUser()
    }
    
    @objc func restartApp() {
        
        mUserRN?.logout()
        //self.backToMainScreen(nil)
    }
}

// MARK: SetupUI
extension MoreViewController {
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        Theme.default.greenButton(self.btnLogin)
        Theme.default.redButton(self.btnLogout)
        Theme.default.orageButton(self.btnRegister)
        Theme.default.blueButton(self.btnExpand)
        
        Theme.default.textAsListTitle(self.lbOtherProducts)
        Theme.default.textAsMessage(self.lbInfoLogin)
        Theme.More.textAsExpand(self.lbExpand)
        Theme.More.textAsUserName(self.lbName)
        
        self.imgArrow.image = UIImage(named: "ic_expand_more")!.withRenderingMode(.alwaysTemplate)
        self.imgArrow.tintColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiDark)
    }
    
    func setupTexts() {
        
        self.lbName.text = "Usuário"
        self.btnExpand.setTitle("account_see_more".localized, for: .normal)
        self.btnLogout.setTitle("login_logut".localized, for: .normal)
        self.btnRegister.setTitle("login_logon".localized, for: .normal)
        self.btnLogin.setTitle("login_enter_button".localized, for: .normal)
        self.lbExpand.text = "account_see_more".localized
        self.lbOtherProducts.text = "more_other_services_available".localized
    }
}

// MARK: Data TableView
extension MoreViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItensOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! OptionCell
        
        let optionMenu = self.menuItensOptions[indexPath.row]
        cell.item = optionMenu
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
}

// MARK: Delegate Table
extension MoreViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let optionMenu = self.menuItensOptions[indexPath.row]
        
        if optionMenu.action == ActionFinder.Account.EDIT_PICTURE {
            
            self.openCamera()
            
        }else if optionMenu.action == ActionFinder.Account.CHANGE_PASSWORD {
            ForgotPasswordViewController.isChangeAccountPassword = true
            self.performSegue(withIdentifier: Constants.Segues.FORGOT_PASSWORD, sender: nil)
            
        } else if optionMenu.action == ActionFinder.Account.QIWI_PASS {
            //ForgotPasswordViewController.isChangeAccountPassword = false
            //self.performSegue(withIdentifier: Constants.Segues.FORGOT_PASSWORD, sender: nil)
            self.performSegue(withIdentifier: Constants.Segues.FORGOT_QIWI_PASSWORD, sender: nil)
            
        } else if optionMenu.action == ActionFinder.Account.TERMS {
            
            //AmazonRN(delegate: self).readFile(key: "clickbus_cidades.json")
            
           self.openTerms()
            //self.performSegue(withIdentifier: Constants.Segues.CREATE_QIWI_PASS, sender: nil)
        } else if optionMenu.action == ActionFinder.Account.RATE_APP {
            //Util.showController(PopupPasswordVisibility.self, sender: self)
            self.openAppStore()
            
//            let push = PushResponse()
//            push.date = DateFormatterQiwi.currentDate()
//            push.message = "Voce ganhou 10 reais da Qiwi!"
//            push.userId = UserRN.getLoggedUserId()
//            NotificationRN().insertNotification(notification: push)
            
            //self.performSegue(withIdentifier: Constants.Segues.CARD_ADD, sender: nil)
        }
    }
}

// Data Collection
extension MoreViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menuItensOthers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageWithTextCell

        let currentItem = self.menuItensOthers[indexPath.row]
        cell.displayContent(menu: currentItem)
        
        return cell
    }
}

// MARK: Layout Collection
extension MoreViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Layout custom
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 20
            flowLayout.minimumInteritemSpacing = 20
        }
        
//        let currentItem = self.menuItensOthers[indexPath.row]
//        let width = (self.collectionView.frame.width - (CGFloat(2) * 10)) / 2
//        let image = UIImage(named: currentItem.imageMenu) ?? UIImage()
//        let size = Util.estimateSizeWith(width: width, text: currentItem.description, image: image)
        
        let size = CGSize(width: (self.collectionView.frame.width - (CGFloat(2) * 10)) / 2, height: 130)
        return size
    }
}

// MARK: Delegate Collection
extension MoreViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let menuItem = self.menuItensOthers[indexPath.row]
    
        //========== NOTIFICAÇOES ==========
        if menuItem.action == ActionFinder.ID_NOTIFICATION {
            
            if !UserRN.hasLoggedUser() {
                Util.showNeedLogin(self)
                return
            }
            
//            var menu = MenuItem()
//            menu.id = 595
//            menu.desc = "ClickBus - Passagem rodoviara"
//            menu.action = 44
//            menu.imageMenu = "menus/menu_produto_clickbus"
//            menu.imageLogo = "clickbus"
//            menu.prvID = 100115
//
//            QiwiOrder.clearFields()
//            QiwiOrder.setPrvId(prvId: menu.prvID)
//            QiwiOrder.selectedMenu = menu
//            QiwiOrder.checkoutBody.requestClickbus = RequestClickbus()
//            self.performSegue(withIdentifier: Constants.Segues.CLICK_BUS, sender: nil)
            
            self.performSegue(withIdentifier: Constants.Segues.NOTIFICATION, sender: nil)
        }
        //========== ESTUDANTES ==========
        else if menuItem.action == ActionFinder.ID_STUDENT_FORM {
            self.performSegue(withIdentifier: Constants.Segues.STUDENT_HOME, sender: nil)
        }
        //========== DIVIDAS ==========
        else if menuItem.action == ActionFinder.ID_APP_DIVIDA {
            self.performSegue(withIdentifier: Constants.Segues.DIVIDAS, sender: nil)
        }
        //========== QTOKEN ==========
        else if menuItem.action == ActionFinder.ID_APP_TOKEN_VALIDATION {
            
            if !UserRN.hasLoggedUser() {
                Util.showNeedLogin(self)
                return
            }
            
            self.performSegue(withIdentifier: Constants.Segues.QTOKEN, sender: nil)
            
        }
        //========== ADD CREDITO QIWI ==========
        else if menuItem.action == ActionFinder.QIWI_BALANCE_RECHARGE_PRVID {
            
            if !UserRN.hasLoggedUser() {
                Util.showNeedLogin(self)
                return
            }
            
            if !UserRN.getLoggedUser().isQiwiAccountactive {
                self.performSegue(withIdentifier: Constants.Segues.CREATE_QIWI_PASS, sender: nil)
                return
            }
            
            QiwiOrder.startQiwiChargeOrder()
            ListGenericViewController.stepListGeneric = .SELECT_VALUE
            self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
            
        }
        //========== ADESAO DIGITAL ==========
        else if menuItem.action == ActionFinder.ID_ADESAO_DIGITAL {
            Util.showController(PopupAdesaoDigital.self, sender: self)
        }
        //========== APP INFO ==========
        else if menuItem.action == ActionFinder.ID_APP_INFO {
            
            //PIX teste ailton
            //let pixList = PIXRequestDAO().getAll()
            //PaymentRN(delegate: self).removePIXRequestFromServer(pixRequest: pixList[0])
            
            self.performSegue(withIdentifier: Constants.Segues.INFO_APP, sender: nil)
        }
        //========== EXCLUDE USER ==========
        else if menuItem.action == ActionFinder.ID_EXCLUDE_USER {
            let alerta = UIAlertController(title: "Exclusão de Conta", message: "Tem certeza que deseja prosseguir? Esta ação apagara sua conta definitivamente.",  preferredStyle: UIAlertControllerStyle.alert)
            
            let botaoOK = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){
                (UIAlertAction) in
                self.performSegue(withIdentifier: Constants.Segues.DELETEACCOUNT, sender: nil)
                //self.mUserRN?.delete()
            }
            let botaoCancelar = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default){
                (UIAlertAction) in
                //Não faz nada aqui
            }
            alerta.addAction(botaoOK)
            alerta.addAction(botaoCancelar)
            
            self.present(alerta, animated: true, completion: nil)
        }
        //========== SHARE APP ======================
        else if menuItem.action == ActionFinder.ID_SHARE_APP
        {
            Util.shareText(sender: self, text: "share_text".localized)
        }
        //========== ADD CARTAO DE CREDITO ==========
        else if menuItem.action == ActionFinder.ID_ADD_CREDIT_CARD {
            
            if !UserRN.hasLoggedUser() {
                Util.showNeedLogin(self)
                return
            }
            
            self.performSegue(withIdentifier: Constants.Segues.DOCUMENTS, sender: nil)
            
        }
        //========== EDITAR METODOS DE PAGAMENTO ==========
        else if menuItem.action == ActionFinder.ID_EDIT_PAYMENT_METHODS {
            
            if !UserRN.hasLoggedUser() {
                Util.showNeedLogin(self)
                return
            }
            
            self.performSegue(withIdentifier: Constants.Segues.EDIT_PAYMENT_METHODS, sender: nil)
            
        }
        //========== ALTERAR SENHA ==========
        else if menuItem.action == ActionFinder.Account.CHANGE_PASSWORD {
            
            if !UserRN.hasLoggedUser() {
                Util.showNeedLogin(self)
                return
            }
            
            ForgotPasswordViewController.isChangeAccountPassword = true
            self.performSegue(withIdentifier: Constants.Segues.FORGOT_PASSWORD, sender: nil)
            
        }
        //========== ALTERAR SENHA CONTA QIWI ==========
        else if menuItem.action == ActionFinder.Account.QIWI_PASS {
            
            if !UserRN.hasLoggedUser() {
                Util.showNeedLogin(self)
                return
            }
            
            self.performSegue(withIdentifier: Constants.Segues.FORGOT_QIWI_PASSWORD, sender: nil)
            
        }
        //========== COMISSAO ==========
        else if menuItem.action == ActionFinder.Account.COMMISSION {
            
            self.performSegue(withIdentifier: Constants.Segues.COMISSION, sender: nil)
            
        }
    }
}

// MARK: Setup Collection / Table
extension MoreViewController {
    
    func setupTableView() {
 
        self.tableViewOptions.register(OptionCell.nib(), forCellReuseIdentifier: "Cell")
        self.heightTableView.constant = 0
    }
    
    func setupCollectionView() {
        
        //  Cell custom
        self.collectionView.register(ImageWithTextCell.nib(), forCellWithReuseIdentifier: "Cell")
        self.collectionView.layer.masksToBounds = false
    }
}

