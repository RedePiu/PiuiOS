//
//  PathKindViewController.swift
//  MyQiwi
//
//  Created by Thyago on 07/08/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ClickBusViewController : ClickBusBaseViewController {
    
    // MARK : OUTLETS
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollection: NSLayoutConstraint!
    @IBOutlet weak var imgIda: UIImageView!
    @IBOutlet weak var imgIdaeVolta: UIImageView!
    @IBOutlet weak var imgVolta: UIImageView!
    @IBOutlet weak var btnIda: UIButton!
    @IBOutlet weak var btnIdaeVolta: UIButton!
    @IBOutlet weak var btnVolta: UIButton!
    
    // MARK : VARIABLES
    var menuItensOthers: [MenuItem] = []
    var mUserRN: UserRN?
    var mMenuItemRN: MenuItemRN?
    
    override func setupViewDidLoad() {
        
        self.mMenuItemRN = MenuItemRN(delegate: self)
        
        self.setupUI()
        self.setupTexts()
        self.setupCollectionView()
        
        self.collectionView.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [.new], context: nil)
        
        self.btnIda.addTarget(self, action: #selector(onClickIda), for: .touchDown)
        self.btnIdaeVolta.addTarget(self, action: #selector(onClickIdaEVolta), for: .touchDown)
        self.btnVolta.addTarget(self, action: #selector(onClickIda), for: .touchDown)
        
        if ClickBusRN.isUpdateNeeded() || !ClickBusRN().hasCitiesInDB() {
            Util.showLoading(self, message: "clickbus_downloading_cities".localized)
            ClickBusRN(delegate: self).downloadCitiesFile()
        }
    }
}

extension ClickBusViewController {
    
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
extension ClickBusViewController: BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            if fromClass == UserRN.self {
                
                if param == Param.Contact.USER_LOGOUT {
                    self.dismissPage(nil)
                    return
                }
            }
            
            if fromClass == MenuItemRN.self {
                
                if param == Param.Contact.MENU_MORE_SERVICES {
                    if let items = object as? [MenuItem] {
                        self.fillServiceList(menuItems: items)
                    }
                }
            }
            
            if fromClass == ClickBusRN.self {
                if param == Param.Contact.CLICKBUS_DOWNLOAD_CITIES_RESPONSE {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

// Data Collection
extension ClickBusViewController: UICollectionViewDataSource {
    
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
extension ClickBusViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Layout custom
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 20
            flowLayout.minimumInteritemSpacing = 20
        }
        
        let size = CGSize(width: (self.collectionView.frame.width - (CGFloat(2) * 10)) / 2, height: 130)
        return size
    }
}

// MARK: Delegate Collection
extension ClickBusViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let menuItem = self.menuItensOthers[indexPath.row]
        
    }
}


extension ClickBusViewController {
    
    func fillServiceList(menuItems: [MenuItem]) {
        
        menuItensOthers = menuItems
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setupCollectionView() {
        
        self.collectionView.register(ImageWithTextCell.nib(), forCellWithReuseIdentifier: "Cell")
        self.collectionView.layer.masksToBounds = false
    }
    
    @objc func onClickIda() {
        
        QiwiOrder.productName = "clickbus_product_name".localized
        QiwiOrder.clickBusCharge = BusTicketCharge()
        QiwiOrder.clickBusCharge?.isOnlyGo = true
        ClickBusBaseViewController.currentStepIda = .DEPARTURE
        ClickBusBaseViewController.currentStepIdaVolta = .NO_STEP
        
        self.performSegue(withIdentifier: Constants.Segues.CLICK_BUS_SELECT_CITY, sender: nil)
    }
    
    @objc func onClickIdaEVolta() {
        
        QiwiOrder.productName = "clickbus_product_name".localized
        QiwiOrder.clickBusCharge = BusTicketCharge()
        QiwiOrder.clickBusCharge?.isOnlyGo = false
        ClickBusBaseViewController.currentStepIda = .NO_STEP
        ClickBusBaseViewController.currentStepIdaVolta = .DEPARTURE
        
        self.performSegue(withIdentifier: Constants.Segues.CLICK_BUS_SELECT_CITY, sender: nil)
    }
}

extension ClickBusViewController :SetupUI {
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.txtTitle)
        
        self.imgIda.image = UIImage(named: "ic_bus_go")!.withRenderingMode(.alwaysTemplate)
        self.imgIda.tintColor = UIColor(hexString: Constants.Colors.Hex.colorPrimary)
        self.imgIdaeVolta.image = UIImage(named: "ic_bus_both")!.withRenderingMode(.alwaysTemplate)
        self.imgIdaeVolta.tintColor = UIColor(hexString: Constants.Colors.Hex.colorPrimary)
        self.imgVolta.image = UIImage(named: "ic_bus_back")!.withRenderingMode(.alwaysTemplate)
        self.imgVolta.tintColor = UIColor(hexString: Constants.Colors.Hex.colorPrimary)
    }
    
    func setupTexts() {
        
        Util.setTextBarIn(self, title: "clickbus_title_nav".localized)
        self.txtTitle.text = "clickbus_title_travel".localized
    }
}
