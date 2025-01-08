//
//  UltragazProductListViewController.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 02/09/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class UltragazProductListViewController: UIBaseViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbPriceLabel: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var viewNoContent: UIStackView!
    @IBOutlet weak var viewPrice: UICardView!
    
    var posEnabled = -1
    var PRODUCT_LIMIT = 5
    var products = [UltragazProduct]()
    var productAmount = [Int]()
    var totalSelected = 0
    var totalPrice: Double = 0
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        self.requestProducts()
    }
    
    @IBAction func onClickContinue(_ sender: Any) {
        
        let p = self.products[posEnabled]
        
        QiwiOrder.checkoutBody.requestUltragaz!.amount = self.totalSelected
        QiwiOrder.checkoutBody.requestUltragaz!.value = Util.doubleToInt(p.value)
        QiwiOrder.checkoutBody.requestUltragaz!.productCode = p.id
        QiwiOrder.checkoutBody.requestUltragaz!.productName = p.name
        QiwiOrder.productName = p.name
        
        QiwiOrder.setTransitionAndValue(value: Util.doubleToInt(totalPrice))
        
        ListGenericViewController.stepListGeneric = .SELECT_PAYMENT
        self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
    }
}

extension UltragazProductListViewController {
    
    func hideAll() {
        self.viewNoContent.isHidden = true
        self.collectionView.isHidden = true
        self.viewPrice.isHidden = true
    }
    
    func requestProducts() {
        Util.showLoading(self)
        UltragazRN(delegate: self).consultValues(lat: QiwiOrder.checkoutBody.requestUltragaz!.latitude, long: QiwiOrder.checkoutBody.requestUltragaz!.longitude)
    }
    
    func fillProductList(products: [UltragazProduct]) {
        self.hideAll()
        
        if (products.isEmpty) {
            self.viewNoContent.isHidden = false
            return
        }
        
        self.products = products
        
        self.productAmount = [Int]()
        for p in products {
            self.productAmount.append(0)
        }
        
        self.viewPrice.isHidden = false
        self.collectionView.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [.new], context: nil)
        self.collectionView.reloadData()
        self.collectionView.isHidden = false
    }
    
    func updateContinueButton() {
        self.btnContinue.isHidden = self.totalSelected == 0
    }
    
    func disableAllExcept(pos: Int) {
        posEnabled = pos
        collectionView.reloadData()
    }
    
    func enableAll() {
        posEnabled = -1
        collectionView.reloadData()
    }
    
    func addToPrice(product: UltragazProduct, pos: Int, amount: Int) {
        
        if totalSelected >= 5 {
            return
        }
        
        totalSelected += 1
        totalPrice += product.value
        self.lbPrice.text = Util.formatCoin(value: totalPrice)
        
        self.productAmount[pos] = amount
        
        if posEnabled == -1 {
            self.disableAllExcept(pos: pos)
        }
    }
    
    func removeFromPrice(product: UltragazProduct, pos: Int, amount: Int) {
        
        if totalSelected <= 0 {
            return
        }
        
        totalSelected -= 1
        totalPrice -= product.value
        
        if totalPrice < 1 {
            totalPrice = 0
        }
        
        self.lbPrice.text = Util.formatCoin(value: totalPrice)
        
        self.productAmount[pos] = amount
        
        if totalSelected < 1 && posEnabled != -1 {
            self.enableAll()
        }
    }
}

// MARK: Observer Height Collection
extension UltragazProductListViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(UICollectionView.contentSize) {
            if let _ = object as? UICollectionView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.collectionHeight!.constant = size.height
                    return
                }
            }
        }
    }
}

extension UltragazProductListViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.async {
            if fromClass == UltragazRN.self {
                if param == Param.Contact.ULTRAGAZ_VALUES_RESPONSE {
                    self.dismissPage(self)
                    self.fillProductList(products: object as! [UltragazProduct])
                }
            }
        }
    }
}

// Data Collection
extension UltragazProductListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UltragazProductPriceCell

        let currentItem = self.products[indexPath.row]
        cell.displayValue(self, pos: indexPath.row, product: currentItem, amount: self.productAmount[indexPath.row], enabled: posEnabled == indexPath.row || posEnabled == -1)
        
        return cell
    }
}

// MARK: Layout Collection
extension UltragazProductListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collectionView.frame.width, height: 120)
    }
}

extension UltragazProductListViewController: SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lbTitle)
        
        Theme.default.orageButton(self.btnBack)
        Theme.default.greenButton(self.btnContinue)
        
        self.collectionView.register(UltragazProductPriceCell.nib(), forCellWithReuseIdentifier: "Cell")
        
        self.lbPrice.text = Util.formatCoin(value: 0)
        
        self.btnContinue.isHidden = true
        self.hideAll()
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: QiwiOrder.productName)
        self.lbTitle.text = "ultragaz_product_list_title".localized
        self.lbPriceLabel.text = "ultragaz_product_total_price".localized
        self.lbDesc.text = "ultragaz_product_price_desc".localized
        
        
        self.btnBack.setTitle("back".localized, for: .normal)
        self.btnContinue.setTitle("continue_label".localized, for: .normal)
    }
}
