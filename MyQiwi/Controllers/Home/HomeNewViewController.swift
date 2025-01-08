//
//  HomeNewViewController.swift
//  MyQiwi
//
//  Created by Daniel Catini on 29/09/23.
//  Copyright © 2023 Qiwi. All rights reserved.
//

import UIKit

class HomeNewViewController: UIBaseViewController, BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        //teste
    }
    
    
    //@IBOutlet weak var txtBusca: UITextField!
    //@IBOutlet weak var menu: UICollectionView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menu: UICollectionView!
    var menus = [MenuItem]()
    var menuTitles = [MenuItem]()
    var menuList = [MenuItem]()
    var menuCategories = [MenuItem]()
    var menuItemSelected: MenuItem!
    var qtd: Int = 1
    
    
    @IBAction func onClickSearch(_ sender: Any) {
        if !UserRN.hasLoggedUser() {
            Util.showNeedLogin(self)
            return
        }
        
        OtherProductsViewController.startSearch = true
        performSegue(withIdentifier: Constants.Segues.OTHER_PRODUCTS, sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let _indexPath = IndexPath(item: 0, section: 0)
        menu.scrollToItem(at: _indexPath, at: .top, animated: animated)
        menu.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        //menu.backgroundColor = .white
        menu.dataSource = self
        menu.delegate = self
        
        self.menu.register(UINib(nibName: "TopAppsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TopAppsCollectionViewCell")
        self.menu.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionViewCell")
        
        //config menu
        menuView.layer.mask = roundedCorners(cornerRadius: 20)
        menuView.clipsToBounds = true
        
        if (OtherProductsViewController.otherServicesMenuId == 0) {
            OtherProductsViewController.otherServicesMenuId = MenuItemRN().getOtherServicesMenu().id
        }
        
        menuTitles = MenuItemRN().getFullOthersList(otherServiceId: OtherProductsViewController.otherServicesMenuId)
        
        for m in menuTitles {
            menuList = MenuItemRN().getFullOthersListTest(dadId: m.id, name: "")
            
            if (!menuList.isEmpty) {
                m.data = menuList as AnyObject
                menuCategories.append(m)
            }
        }
    }
    
    func roundedCorners(cornerRadius: Int) -> CAShapeLayer
    {
        // Specify which corners to round
        let corners = UIRectCorner(arrayLiteral: [
            UIRectCorner.topLeft,
            UIRectCorner.topRight
        ])
        
        // Determine the size of the rounded corners
        let cornerRadii = CGSize(
            width: cornerRadius,
            height: cornerRadius
        )
        
        // A mask path is a path used to determine what
        // parts of a view are drawn. UIBezier path can
        // be used to create a path where only specific
        // corners are rounded
        let maskPath = UIBezierPath(
            roundedRect: view.bounds,
            byRoundingCorners: corners,
            cornerRadii: cornerRadii
        )
        
        // Apply the mask layer to the view
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.frame = view.bounds
        
        return maskLayer
    }
}

// MARK: Modal Delegate
extension HomeNewViewController: DismisModalDelegate {
    
    func modalDismiss() {
        //self.dismiss(animated: false)
    }
}

extension HomeNewViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !ApplicationRN.isQiwiPro() && MenuItemRN.getTerminalType() == ActionFinder.TerminalType.TAUBATE
        {
            self.qtd = 2
        }
        return self.menuCategories.count + self.qtd
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch(indexPath.item) {
        case 0:
            guard let cell = menu.dequeueReusableCell(withReuseIdentifier:"TopAppsCollectionViewCell", for: indexPath) as? TopAppsCollectionViewCell else { return UICollectionViewCell() }
            cell.menus = MenuItemRN(delegate: self).getMainList()
            cell.isTopApp = true
            cell.didSelectCell = { [weak self] indexPath in
                self?.showMenu(menu: cell.menus[indexPath.item])
            }
            cell.title.text = "TOP APPS"
            cell.btnShowAll.isHidden = true
            cell.collection.reloadData()
            return cell
        default:
            if indexPath.item == 1 && !ApplicationRN.isQiwiPro() && MenuItemRN.getTerminalType() == ActionFinder.TerminalType.TAUBATE {
                
                let cell: BannerCollectionViewCell = menu.dequeueReusableCell(withReuseIdentifier:"BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
                //cell.backgroundColor = .black
                cell.bannerimg.frame.size.width = view.frame.width
                cell.bannerimg.frame.size.height = 100
                let paddingTop: CGFloat = 20
                cell.bannerimg.frame.origin.y = paddingTop
                let clickBanner = UITapGestureRecognizer(target: self, action: #selector(clickStudentForm))
                cell.bannerimg.isUserInteractionEnabled = true
                cell.bannerimg.addGestureRecognizer(clickBanner)
                return cell
            } else {
                let cell: TopAppsCollectionViewCell = menu.dequeueReusableCell(withReuseIdentifier:"TopAppsCollectionViewCell", for: indexPath) as! TopAppsCollectionViewCell
                //cell.backgroundColor = .black
                cell.menus = MenuItemRN(delegate: self).getFullOthersListTest(dadId: self.menuCategories[indexPath.item - self.qtd].id)
                print("Id: \(self.menuCategories[indexPath.item - self.qtd].id) desc: \(self.menuCategories[indexPath.item - self.qtd].desc)")
                cell.title.text = self.menuCategories[indexPath.item - self.qtd].desc
                cell.isTopApp = false
                
                cell.didSelectCell = { [weak self] indexPath in
                    self?.showMenu(menu: cell.menus[indexPath.item])
                }
                cell.btnShowAll.isHidden = false
                cell.btnShowAll.addTarget(self, action: #selector(onClickSearch), for: .touchUpInside)
                
                cell.collection.reloadData()
                return cell
            }
        }
        
    }
}


 extension HomeNewViewController: UICollectionViewDelegateFlowLayout{
     func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt sizeForItemAtinde: IndexPath) -> CGSize {
         return .init(width: view.frame.width, height: 140)
     }
     
     func collectionView(_ collectionView: UICollectionView, layout
         collectionViewLayout: UICollectionViewLayout,
                         minimumLineSpacingForSectionAt section: Int) -> CGFloat {

         return 0
     }
     
     func collectionView(_ collectionView: UICollectionView, layout
         collectionViewLayout: UICollectionViewLayout,
                         minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

         return 0
     }
 }

extension HomeNewViewController{
    
    @objc func clickStudentForm() {
        
        if !UserRN.hasLoggedUser() {
            Util.showNeedLogin(self)
            return
        }
        
        self.performSegue(withIdentifier: Constants.Segues.STUDENT_HOME, sender: nil)
    }
    
    func showMenu(position: Int) {
        
        if !UserRN.hasLoggedUser() {
            Util.showNeedLogin(self)
            return
        }
        
        let currentItem = self.menus[position-1]
        self.checkAndStartScreen(menu: currentItem)
    }
    
    func showMenu(menu: MenuItem) {
        
        if !UserRN.hasLoggedUser() {
            Util.showNeedLogin(self)
            return
        }
        
        let currentItem = menu
        self.select(menuItem: currentItem)
    }
    
    @IBAction func showMenuItem(sender: UIButton) {
        
        if !UserRN.hasLoggedUser() {
            Util.showNeedLogin(self)
            return
        }
        
        //let currentItem = menuItemDataHandler.cellForItemAtIndexPath(sender.tag)
        //self.checkAndStartScreen(menu: currentItem)
    }
    
    func select(menuItem: MenuItem) {
        QiwiOrder.clearFields()

        self.menuItemSelected = menuItem
        QiwiOrder.selectedMenu = menuItem

        //Incomm e pinoffline seguem a mesma sequencia
        if menuItem.action == ActionFinder.ACTION_INCOMM || menuItem.action == ActionFinder.ACTION_PINOFFLINE || menuItem.action == ActionFinder.ACTION_RV_SPOTIFY || menuItem.action == ActionFinder.ACTION_RV || menuItem.action == ActionFinder.ACTION_DONATION || ActionFinder.isUltragaz(action: menuItem.action) || menuItem.action == ActionFinder.ACTION_DRTERAPIA || menuItem.action == ActionFinder.ACTION_TELESENA {

            if menuItem.action == ActionFinder.ACTION_DONATION || menuItem.action == ActionFinder.ACTION_DRTERAPIA || menuItem.action == ActionFinder.ACTION_TELESENA {
                QiwiOrder.setPrvId(prvId: menuItem.prvID)
            }

            self.performSegue(withIdentifier: Constants.Segues.OTHER_INTRO, sender: nil)
        }

        else if ActionFinder.isClickBus(action: menuItem.action) {
            QiwiOrder.productName = "clickbus_product_name".localized
            QiwiOrder.setPrvId(prvId: menuItem.prvID)
            QiwiOrder.checkoutBody.requestClickbus = RequestClickbus()
            self.performSegue(withIdentifier: Constants.Segues.CLICK_BUS, sender: nil)
        }

        else if ActionFinder.isRechargeTransporCard(action: menuItem.action) {
            QiwiOrder.productName = "transport_toolbar_title_nav".localized
            QiwiOrder.setPrvId(prvId: menuItem.prvID)
            QiwiOrder.checkoutBody.requestTransport = RequestTransport()
            performSegue(withIdentifier: Constants.Segues.TRANSPORT_CARD, sender: nil)
        }

        else if ActionFinder.isRechargeTransporCardProdata(action: menuItem.action) {
            QiwiOrder.productName = "prodata_product_name".localized
            QiwiOrder.setPrvId(prvId: menuItem.prvID)
            QiwiOrder.checkoutBody.requestProdata = RequestProdata()
            performSegue(withIdentifier: Constants.Segues.TRANSPORT_CARD, sender: nil)
        }

        else if ActionFinder.isRechargeTransporCardCittaMobi(action: menuItem.action) {
            QiwiOrder.productName = "cittamobi_product_name".localized
            QiwiOrder.setPrvId(prvId: menuItem.prvID)
            QiwiOrder.checkoutBody.requestTransportCittaMobi = RequestTransportCittaMobi()
            performSegue(withIdentifier: Constants.Segues.TRANSPORT_CARD, sender: nil)
        }

        else if ActionFinder.isRechargeTransporCardUrbs(action: menuItem.action) {
            QiwiOrder.productName = "urbs_product_name".localized
            QiwiOrder.setPrvId(prvId: menuItem.prvID)
            QiwiOrder.checkoutBody.requestUrbs = RequestUrbs()
            performSegue(withIdentifier: Constants.Segues.TRANSPORT_CARD, sender: nil)
        }

        else if ActionFinder.isRechargeTransporCardMetrocard(action: menuItem.action) {
            QiwiOrder.productName = "metrocard_product_name".localized
            QiwiOrder.setPrvId(prvId: menuItem.prvID)
            QiwiOrder.checkoutBody.requestMetrocard = RequestMetrocard()
            performSegue(withIdentifier: Constants.Segues.TRANSPORT_CARD, sender: nil)
        }

        else if ActionFinder.isPhoneRecharge(action: menuItem.action) {
            QiwiOrder.productName = "phone_product_name".localized

            if ApplicationRN.isQiwiBrasil() {
                performSegue(withIdentifier: Constants.Segues.PHONE_RECHARGE, sender: nil)
            } else {
                performSegue(withIdentifier: Constants.Segues.PHONE_RECHARGE_PRO, sender: nil)
            }
        }

        else if ActionFinder.isInternationalPhoneRecharge(action: menuItem.action) {
            QiwiOrder.productName = "international_phone_title".localized
            QiwiOrder.setPrvId(prvId: menuItem.prvID)

            if ApplicationRN.isQiwiBrasil() {
                performSegue(withIdentifier: Constants.Segues.INTERNATIONAL_PHONE, sender: nil)
            } else {
                performSegue(withIdentifier: Constants.Segues.INTERNATIONAL_PHONE_PRO, sender: nil)
            }
        }
        else if ActionFinder.isParking(action: menuItem.action) {
        //            Log.print(action)
        //            performSegue(withIdentifier: Constants.Segues.BLUE_ZONE, sender: nil)
                    Util.showComingSoon(self,
                                        delegate: self,
                                        title: "content_soon_title".localized,
                                        message: "content_soon_desc".localized)
        }
        else if ActionFinder.isRechargeTransporCardVem(action: menuItem.action) {
            Util.showComingSoon(self,
                                delegate: self,
                                title: "content_soon_title".localized,
                                message: "content_soon_desc".localized)
        }
            //Se for serasa cpf ou cnpj entra no segue de consulta
        else if menuItem.action == ActionFinder.ACTION_CONSULTA_CPF || menuItem.action == ActionFinder.ACTION_CONSULTA_CNPJ {
            QiwiOrder.setPrvId(prvId: menuItem.prvID)
            QiwiOrder.checkoutBody.requestSerasaConsult = RequestSerasaConsult()
            QiwiOrder.productName = QiwiOrder.isCPFConsult() ? "cpf_consult_toolbar_title".localized : "cnpj_consult_toolbar_title".localized

            self.performSegue(withIdentifier: Constants.Segues.SERASA_CONSULT, sender: nil)
        }
        else if ActionFinder.isBillPayment(action: menuItem.action) {
            Log.print(menuItem.action)
            QiwiOrder.setPrvId(prvId: menuItem.prvID)
            QiwiOrder.productName = "bill_barcode_title_nav".localized
            QiwiOrder.factoryFebraban = FactoryFebraban()
            QiwiOrder.checkoutBody.requestBill = RequestBillPayment()
            performSegue(withIdentifier: Constants.Segues.BILL_PAYMENT, sender: nil)
            
//            QiwiOrder.factoryFebraban = FactoryFebraban()
//            QiwiOrder.factoryFebraban?.validarCodigoBarras(codigoBarras: "23792782600000015003129269000248404001581080")
        }
            //rv e office ainda não estão disponíveis
        else {
            Util.showComingSoon(self,
                                delegate: self,
                                title: "content_soon_title".localized,
                                message: "content_soon_desc".localized)
        }
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
 
extension HomeNewViewController {
    
    func instanceFromNib(name: String) -> UIView {
        return UINib(nibName: name, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func restartApp() {
        DispatchQueue.main.async {
            self.dismissPage(nil)
        }
    }
}

// MARK: Segue Idetifier
extension HomeNewViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == Constants.Segues.OTHER_INTRO {
            if let vc = segue.destination as? OtherProductIntroViewController {
                vc.menuItem = self.menuItemSelected

                QiwiOrder.productName = self.menuItemSelected.desc

                if ActionFinder.isRv(action: self.menuItemSelected.action) {
                    QiwiOrder.checkoutBody.requestRv = RequestRV()
                } else if ActionFinder.isRvSpotify(action: self.menuItemSelected.action) {
                    QiwiOrder.checkoutBody.requestRvSpotify = RequestRVSpotify()
                } else if ActionFinder.isIncomm(action: self.menuItemSelected.action) {
                    QiwiOrder.checkoutBody.requestIncomm = RequestIncomm()
                } else if ActionFinder.isPinOffline(action: self.menuItemSelected.action) {
                    QiwiOrder.checkoutBody.requestPinoffline = RequestPinoffline()
                } else if ActionFinder.isDonation(action: self.menuItemSelected.action) {
                    QiwiOrder.checkoutBody.requestDonation = RequestDonation()
                } else if ActionFinder.isUltragaz(action: self.menuItemSelected.action) {
                    QiwiOrder.setPrvId(prvId: self.menuItemSelected.prvID)
                    QiwiOrder.productName = "ultragaz_product_name".localized
                    QiwiOrder.checkoutBody.requestUltragaz = RequestUltragaz()
                } else if ActionFinder.isDrTerapia(action: self.menuItemSelected.action) {
                    QiwiOrder.checkoutBody.requestDrTerapia = RequestDrTerapia()
                    QiwiOrder.productName = "dr_terapia_product_name".localized
                } else if ActionFinder.ACTION_TELESENA == self.menuItemSelected.action {
                    QiwiOrder.checkoutBody.requestTelesena = RequestTelesena()
                    QiwiOrder.productName = "telesena_product_name".localized
                }
            }
        }
    }
}
