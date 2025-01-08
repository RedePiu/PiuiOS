//
//  OtherProductsViewController.swift
//  MyQiwi
//
//  Created by Douglas on 15/05/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class OtherProductsViewController: UIBaseViewController {

    // MARK: Outlets
    @IBOutlet weak var categoriesHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionCategories: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Variables

    static var startSearch = false
    static var otherServicesMenuId = 0
    var menuTitles = [MenuItem]()
    var menuOthers = [MenuItem]()
    var menuItemSelected: MenuItem!
    var adapter: OtherProductsAdapter!
    var searching = false

    // MARK: Ciclo de vida

    override func setupViewDidLoad() {
        self.searchBar.delegate = self
        
        if (OtherProductsViewController.otherServicesMenuId == 0) {
            OtherProductsViewController.otherServicesMenuId = MenuItemRN().getOtherServicesMenu().id
        }
        
        menuTitles = MenuItemRN().getFullOthersList(otherServiceId: OtherProductsViewController.otherServicesMenuId)
        menuOthers = MenuItemRN().getFullTopOthersList(otherServiceId: OtherProductsViewController.otherServicesMenuId)

        self.updateProductList()
        
        self.setupUI()
        self.setupTexts()
        self.setupCollectionView()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func setupViewWillAppear() {
        Util.setLogoBarIn(self)
        
        if (OtherProductsViewController.startSearch) {
            OtherProductsViewController.startSearch = false
                            
            self.searchBar.becomeFirstResponder()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension OtherProductsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //self.cities = self.cities.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        
        self.searching = true
        self.updateProductList(name: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searching = false
        self.searchBar.text = ""
        self.adapter.collectionView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.searching = false
        self.searchBar.text = ""
        self.adapter.collectionView.reloadData()
    }
}

extension OtherProductsViewController {
 
    func updateProductList(name: String = "") {
        var menuList = [MenuItem]()
        var menuCategories = [MenuItem]()
        for m in menuTitles {
            menuList = MenuItemRN().getFullOthersListTest(dadId: m.id, name: name)
            
            if (!menuList.isEmpty) {
                m.data = menuList as AnyObject
                menuCategories.append(m)
            }
        }
        
        if (self.adapter == nil) {
            self.adapter = OtherProductsAdapter(self, collectionView: collectionCategories, heightCollection: categoriesHeight, menus: menuCategories)
        } else {
            self.adapter.updateList(menus: menuCategories)
        }
    }
}

// MARK: Segue Idetifier
extension OtherProductsViewController {

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

// MARK: Segue Idetifier
extension OtherProductsViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        if (fromClass == OtherProductListCell.self && param == Param.Contact.LIST_CLICK) {
            self.select(menuItem: object as! MenuItem)
        }
    }
}

// MARK: SetupUI
extension OtherProductsViewController {

    func setupUI() {
        Theme.default.backgroundCard(self)
    }

    func setupTexts() {
    }
}

// MARK: Data Collection
extension OtherProductsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menuOthers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cellFavorite = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? OtherGenericCollectionViewCell {

            let menuItem = self.menuOthers[indexPath.row]
            cellFavorite.imgMenu = Util.formatImagePath(path: menuItem.imageMenu ?? "")

            cellFavorite.layer.masksToBounds = false
            cellFavorite.contentView.backgroundColor = UIColor.white
            cellFavorite.contentView.setupViewCard()

            return cellFavorite
        }

        return UICollectionViewCell.init(frame: .zero)
    }
}

// MARK: Delegate Collection Favorite
extension OtherProductsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // Colleção com os favoritos no topo, somente row
        let menuItemSelected = self.menuOthers[indexPath.row]
        self.select(menuItem: menuItemSelected)
    }
}

extension OtherProductsViewController: SelectOthersDelegate {

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
            //rv e office ainda não estão disponíveis
        else {
            Util.showComingSoon(self,
                                delegate: self,
                                title: "content_soon_title".localized,
                                message: "content_soon_desc".localized)
        }
    }
}

// MARK: Modal Delegate
extension OtherProductsViewController: DismisModalDelegate {

    func modalDismiss() {
        self.dismiss(animated: false)
    }
}

extension OtherProductsViewController {



    func setupCollectionView() {

        self.collectionView.register(OtherGenericCollectionViewCell.nib(), forCellWithReuseIdentifier: "Cell")

        // Layout Custom
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 100, height: 100)
            flowLayout.minimumLineSpacing = 20
            flowLayout.minimumInteritemSpacing = 20
        }
    }
}
