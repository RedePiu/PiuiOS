//
//  HomeViewController.swift
//  MyQiwi
//
//  Created by ailton on 14/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import UIKit
import AppTrackingTransparency
import AdSupport

class HomeViewController: UIBaseViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var viewStatusBar: UIView!
    @IBOutlet weak var lbDevmode: UILabel!
    @IBOutlet weak var lbWhatWantToDo: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewDevMode: UIView!
    @IBOutlet weak var lbPromoCode: UILabel!
    @IBOutlet weak var svPromoCode: UIStackView!
    @IBOutlet weak var svQToken: UIStackView!
    @IBOutlet weak var lbQToken: UILabel!
    @IBOutlet weak var studentFormView: StudentFormAvailableView!
    
    @IBOutlet weak var imgFirstMenu: UIImageView!
//    @IBOutlet weak var menuType: MenuTypeMain!
    @IBOutlet weak var viewMenuType1: UIView!
    @IBOutlet weak var viewMenuType2: UIView!
    @IBOutlet weak var viewMenuType3: UIView!
    
    @IBOutlet weak var imgType2Menu1: UIImageView!
    @IBOutlet weak var imgType2Menu2: UIImageView!
    @IBOutlet weak var imgType2Menu3: UIImageView!
    @IBOutlet weak var imgType2Menu4: UIImageView!
    
    //View menu sp
    @IBOutlet weak var imgType3Menu1: UIImageView!
    @IBOutlet weak var imgType3Menu2: UIImageView!
    @IBOutlet weak var imgType3Menu3: UIImageView!
    @IBOutlet weak var imgType3Menu4: UIImageView!
    @IBOutlet weak var imgType3Menu5: UIImageView!
    
    @IBOutlet weak var viewShare: UIStackView!
    @IBOutlet weak var btnShareApp: UIButton!
    
    // MARK: Propeties
    static var delegate: BaseDelegate?
    var menus = [MenuItem]()
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        HomeViewController.delegate = self
        
        self.defineTerminalMenu()
        self.setupUI()
        self.setupTexts()
    }
    
    override func setupViewWillAppear() {
        
        if UserRN.hasLoggedUser() {
            Util.removeNeedLogin(self)
        }
        
        self.changeLayout()
        self.tabBarController?.delegate = self
        
        //If has token shows the button
        self.svQToken.isHidden = !TokenRN.hasToken()
        
        if UserRN.hasLoggedUser() && !ApplicationRN.isDataPrivacyConfirmed() {
            requestPrivacyPermission()
            //Util.showController(PopupDataPrivacyViewController.self, sender: self)
        }
    }
    
    // MARK: Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func gotoClickBus(_ sender: Any) {
        
        self.performSegue(withIdentifier: "showClickbus", sender: nil)
    }
}

extension HomeViewController {
    //NEWLY ADDED PERMISSIONS FOR iOS 14
    func requestPrivacyPermission() {
        
        ApplicationRN.setDataPrivacyConfirmed()
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("Authorized")
                    // Now that we are authorized we can get the IDFA
                    //print(ASIdentifierManager.shared().advertisingIdentifier)
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            }
        }
    }
}

extension HomeViewController {
    
    func defineTerminalMenu() {
        self.menus = MenuItemRN(delegate: self).getMainList()
        
        self.studentFormView.btnSee.addTarget(self, action: #selector(clickStudentForm), for: .touchUpInside)
        
        let terminalType = MenuItemRN.getTerminalType()
        self.viewMenuType1.isHidden = true
        self.viewMenuType2.isHidden = true
        self.viewMenuType3.isHidden = true
        
        switch(terminalType) {
            
        case ActionFinder.TerminalType.RIBEIRAO_PRETO:
            
            self.imgType2Menu1.setImage(named: Util.formatImagePath(path: menus[0].imageMenu!))
            self.viewMenuType2.isHidden = false
            break
            
        case ActionFinder.TerminalType.CURITIBA:
            self.viewMenuType3.isHidden = false
            break
            
        default:
            
            self.imgType3Menu1.setImage(named: Util.formatImagePath(path: menus[0].imageMenu!))
            self.imgType3Menu2.setImage(named: Util.formatImagePath(path: menus[1].imageMenu!))
            self.imgType3Menu3.setImage(named: Util.formatImagePath(path: menus[2].imageMenu!))
            self.imgType3Menu4.setImage(named: Util.formatImagePath(path: menus[3].imageMenu!))
            self.imgType3Menu5.setImage(named: Util.formatImagePath(path: menus[4].imageMenu!))
            
            self.viewMenuType1.isHidden = false
            return
        }
    }
    
    func instanceFromNib(name: String) -> UIView {
        return UINib(nibName: name, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func showTransportStudentBannerIfAvailable() {
        self.studentFormView.isHidden = true
        if !TransportStudentRN.alreadyClickAtStudentForm() && UserRN.hasLoggedUser() && !ApplicationRN.isQiwiPro() && MenuItemRN.getTerminalType() == ActionFinder.TerminalType.TAUBATE {
            self.studentFormView.isHidden = false
        }
    }
    
    func restartApp() {
        DispatchQueue.main.async {
            self.dismissPage(nil)
        }
    }
}

extension HomeViewController {
    
    @IBAction func clickStudentForm(_ sender: Any) {
        self.studentFormView.isHidden = true
        self.performSegue(withIdentifier: Constants.Segues.STUDENT_HOME, sender: nil)
    }
    
    @IBAction func onClickShare(_ sender: Any) {
        Util.shareText(sender: self, text: "share_text".localized)
    }
    
    @objc func onClickPromoCode() {
        if UserRN.hasLoggedUser() {
            self.performSegue(withIdentifier: Constants.Segues.PROMO_CODE, sender: nil)
        } else {
            Util.showNeedLogin(self)
        }
    }
    
    @objc func onClickQToken() {
        if UserRN.hasLoggedUser() {
            
            self.performSegue(withIdentifier: Constants.Segues.QTOKEN, sender: nil)
        } else {
            Util.showNeedLogin(self)
        }
    }
}

// MARK: TabBarController

extension HomeViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if UserRN.hasLoggedUser() {
            Util.removeNeedLogin(self)
        }
    }
}

extension HomeViewController {
    
    @IBAction func OnClickSearch(_ sender: Any) {
         
        if !UserRN.hasLoggedUser() {
            Util.showNeedLogin(self)
            return
        }
        
        OtherProductsViewController.startSearch = true
        performSegue(withIdentifier: Constants.Segues.OTHER_PRODUCTS, sender: nil)
    }
 
    @IBAction func onClickMenu1() {
        self.showMenu(position: 1)
    }
    
    @IBAction func onClickMenu2() {
        self.showMenu(position: 2)
    }
    
    @IBAction func onClickMenu3() {
        self.showMenu(position: 3)
    }
    
    @IBAction func onClickMenu4() {
        self.showMenu(position: 4)
    }
    
    @IBAction func onClickMenu5() {
        self.showMenu(position: 5)
    }
    
    @IBAction func onClickMenu6() {
        self.showMenu(position: 6)
    }
}

// MARK: IBActions

extension HomeViewController {
    
    func showMenu(position: Int) {
        
        if !UserRN.hasLoggedUser() {
            Util.showNeedLogin(self)
            return
        }
        
        let currentItem = self.menus[position-1]
        self.checkAndStartScreen(menu: currentItem)
    }
    
    @IBAction func showMenuItem(sender: UIButton) {
        
        if !UserRN.hasLoggedUser() {
            Util.showNeedLogin(self)
            return
        }
        
        //let currentItem = menuItemDataHandler.cellForItemAtIndexPath(sender.tag)
        //self.checkAndStartScreen(menu: currentItem)
    }
    
    func checkAndStartScreen(menu: MenuItem) {
        
        if ApplicationRN.getNeedInitialization() {
            Util.showAlertDefaultOK(self, message: "app_need_restart".localized, titleOK: "OK", completionOK: {
                self.restartApp()
            })
            return
        }
        
        let action = menu.action
        QiwiOrder.clearFields()
        QiwiOrder.selectedMenu = menu
        
        if ActionFinder.isRechargeTransporCard(action: action) {
            Log.print(action)
            QiwiOrder.productName = "transport_toolbar_title_nav".localized
            QiwiOrder.setPrvId(prvId: menu.prvID)
            QiwiOrder.checkoutBody.requestTransport = RequestTransport()
            performSegue(withIdentifier: Constants.Segues.TRANSPORT_CARD, sender: nil)
        }
            
        else if ActionFinder.isRechargeTransporCardProdata(action: action) {
            Log.print(action)
            QiwiOrder.productName = "prodata_product_name".localized
            QiwiOrder.setPrvId(prvId: menu.prvID)
            QiwiOrder.checkoutBody.requestProdata = RequestProdata()
            performSegue(withIdentifier: Constants.Segues.TRANSPORT_CARD, sender: nil)
        }
        
        else if ActionFinder.isRechargeTransporCardCittaMobi(action: action) {
            Log.print(action)
            QiwiOrder.productName = "cittamobi_product_name".localized
            QiwiOrder.setPrvId(prvId: menu.prvID)
            QiwiOrder.checkoutBody.requestTransportCittaMobi = RequestTransportCittaMobi()
            performSegue(withIdentifier: Constants.Segues.TRANSPORT_CARD, sender: nil)
        }
            
        else if ActionFinder.isRechargeTransporCardMetrocard(action: action) {
            QiwiOrder.productName = "metrocard_product_name".localized
            QiwiOrder.setPrvId(prvId: menu.prvID)
            QiwiOrder.checkoutBody.requestMetrocard = RequestMetrocard()
            performSegue(withIdentifier: Constants.Segues.TRANSPORT_CARD, sender: nil)
        }
            
        else if ActionFinder.isRechargeTransporCardVem(action: action) {
            Util.showComingSoon(self,
                                delegate: self,
                                title: "content_soon_title".localized,
                                message: "content_soon_desc".localized)
        }
            
        else if ActionFinder.isRechargeTransporCardUrbs(action: action) {
            Log.print(action)
            QiwiOrder.productName = "urbs_product_name".localized
            QiwiOrder.setPrvId(prvId: menu.prvID)
            QiwiOrder.checkoutBody.requestUrbs = RequestUrbs()
            performSegue(withIdentifier: Constants.Segues.TRANSPORT_CARD, sender: nil)
        }
            
        else if ActionFinder.isPhoneRecharge(action: action) {
            Log.print(action)
            QiwiOrder.productName = "phone_product_name".localized
            
            if ApplicationRN.isQiwiBrasil() {
                performSegue(withIdentifier: Constants.Segues.PHONE_RECHARGE, sender: nil)
            } else {
                performSegue(withIdentifier: Constants.Segues.PHONE_RECHARGE_PRO, sender: nil)
            }
        }
        else if ActionFinder.isInternationalPhoneRecharge(action: action) {
            Log.print(action)
            QiwiOrder.setPrvId(prvId: menu.prvID)
            QiwiOrder.productName = "international_phone_title".localized
            
            if ApplicationRN.isQiwiBrasil() {
                performSegue(withIdentifier: Constants.Segues.INTERNATIONAL_PHONE, sender: nil)
            } else {
                performSegue(withIdentifier: Constants.Segues.INTERNATIONAL_PHONE_PRO, sender: nil)
            }
        }
        else if ActionFinder.isParking(action: action) {
//            Log.print(action)
//            performSegue(withIdentifier: Constants.Segues.BLUE_ZONE, sender: nil)
            Util.showComingSoon(self,
                                delegate: self,
                                title: "content_soon_title".localized,
                                message: "content_soon_desc".localized)
        }
            
        else if ActionFinder.isBillPayment(action: action) {
            Log.print(action)
            QiwiOrder.setPrvId(prvId: menu.prvID)
            QiwiOrder.productName = "bill_barcode_title_nav".localized
            QiwiOrder.factoryFebraban = FactoryFebraban()
            QiwiOrder.checkoutBody.requestBill = RequestBillPayment()
            performSegue(withIdentifier: Constants.Segues.BILL_PAYMENT, sender: nil)
            
//            QiwiOrder.factoryFebraban = FactoryFebraban()
//            QiwiOrder.factoryFebraban?.validarCodigoBarras(codigoBarras: "23792782600000015003129269000248404001581080")
        }
        else {
            Log.print(action)
            OtherProductsViewController.otherServicesMenuId = menu.id
            performSegue(withIdentifier: Constants.Segues.OTHER_PRODUCTS, sender: nil)
        }
    }
}

// MARK: Flow Layout

// MARK: Modal Delegate
extension HomeViewController: DismisModalDelegate {
    
    func modalDismiss() {
        //self.dismiss(animated: false)
    }
}

// MARK: SetupUI

extension HomeViewController: SetupUI {
    
    func changeLayout() {
        self.navigationController?.isNavigationBarHidden = true
        
        // Ativar view mod dev
        //self.lbDevmode.superview?.isHidden = false
        
        self.viewStatusBar.constraints.forEach { (constraint) in
            
            if constraint.firstAttribute == .height {
                constraint.constant = UIApplication.shared.statusBarFrame.height
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func setupUI() {
        Theme.Home.textAsModeDev(self.lbDevmode)
        Theme.Home.textAsWhatWantToDo(self.lbWhatWantToDo)
        self.viewStatusBar.backgroundColor = Theme.default.blue
        
        if ApplicationRN.isQiwiBrasil() {
            self.svPromoCode.isHidden = false
            let fGuesture = UITapGestureRecognizer(target: self, action: #selector(self.onClickPromoCode))
            self.svPromoCode.addGestureRecognizer(fGuesture)
        } else {
            self.svPromoCode.isHidden = true
        }
        
        let QTokenGuesture = UITapGestureRecognizer(target: self, action: #selector(self.onClickQToken))
        self.svQToken.addGestureRecognizer(QTokenGuesture)
        
        Theme.default.blueButton(self.btnShareApp, radius: 14)
        
        self.showTransportStudentBannerIfAvailable()
        
        if UserRN.hasLoggedUser() {
            TransportStudentRN.setAlreadyClickAtStudentForm(clicked: true)
        }
    }
    
    func setupTexts() {
        self.lbDevmode.text = "development_mode".localized
        self.lbWhatWantToDo.text = "home_choose_what_want_to_do".localized
        //self.lbPromoCode.text = "home_promo_code".localized
        
        self.btnShareApp.setTitle("share".localized)
    }
}

// MARK: Delegate Base
extension HomeViewController: BaseDelegate {
   
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.async {
            //If its telling to finish
            if (fromClass == MenuTypeBaseView.self) {
                if param == Param.Contact.MENU_CLICK {
                    self.checkAndStartScreen(menu: object as! MenuItem)
                }
            }
            
            if (fromClass == UserRN.self) {
                if param == Param.Contact.NEED_UPDATE_DATA {
                    //If has token shows the button
                    self.svQToken.isHidden = !TokenRN.hasToken()
                }
            }
        }
    }
}
