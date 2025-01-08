//
//  TelesenaProductsViewController.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 24/09/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class TelesenaProductsViewController: UIBaseViewController {
    
    // MARK : VIEWS
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var viewNoContent: UIStackView!
    
    // MARK : VARIABLES
    var products = [TelesenaProduct]()
    
    // MARK : INIT
    override func setupViewDidLoad() {
        super.setupViewDidLoad()
        
        self.setupUI()
        self.setupTexts()
        self.requestProducts()
    }
}

extension TelesenaProductsViewController {
    
    func hideAll() {
        self.viewNoContent.isHidden = true
        self.collectionView.isHidden = true
    }
    
    func requestProducts() {
        Util.showLoading(self)
        TelesenaRN(delegate: self).getProductList()
    }
    
    func fillProductList(products: [TelesenaProduct]) {
        self.hideAll()
        
        if (products.isEmpty) {
            self.viewNoContent.isHidden = false
            return
        }
        
        self.products = products
        
        self.collectionView.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [.new], context: nil)
        self.collectionView.reloadData()
        self.collectionView.isHidden = false
    }
}

// MARK: Observer Height Collection
extension TelesenaProductsViewController {
    
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

extension TelesenaProductsViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.async {
            if fromClass == TelesenaRN.self {
                if param == Param.Contact.TELESENA_PRODUCTS_RESPONSE {
                    self.dismissPage(self)
                    self.fillProductList(products: object as! [TelesenaProduct])
                }
            }
            
            if fromClass == TelesenaProductCell.self {
                if param == Param.Contact.ITEM_CLICK {
                    self.onSelectProduct(product: object as! TelesenaProduct)
                }
            }
        }
    }
}



extension TelesenaProductsViewController {
    
    @IBAction func onClickBack(_ sender: Any) {
        self.popPage()
    }
    
    func onSelectProduct(product: TelesenaProduct) {
        
        QiwiOrder.checkoutBody.requestTelesena?.edition = product.edition
        QiwiOrder.checkoutBody.requestTelesena?.value = product.value
        QiwiOrder.setTransitionAndValue(value: product.value)
        
        if ApplicationRN.isQiwiPro() {
            self.performSegue(withIdentifier: Constants.Segues.TELESENA_PREPAGO, sender: nil)
            return
        }
        
        ListGenericViewController.stepListGeneric = .SELECT_PAYMENT
        self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
    }
}

// Data Collection
extension TelesenaProductsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TelesenaProductCell

        let currentItem = self.products[indexPath.row]
        cell.displayValue(self, product: currentItem)
        
        return cell
    }
}

// MARK: Layout Collection
extension TelesenaProductsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collectionView.frame.width, height: 250)
    }
}

extension TelesenaProductsViewController: SetupUI {
    
    func setupUI() {
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.orageButton(self.btnBack)
        
        self.collectionView.register(TelesenaProductCell.nib(), forCellWithReuseIdentifier: "Cell")
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: QiwiOrder.productName)
        self.lbTitle.text = "telesena_products_title".localized

        self.btnBack.setTitle("back".localized, for: .normal)
    }
}
