//
//  SelectOperatorViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 10/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

protocol SelectOperatorDelegate {
    
    func didSelect(operadora: Operator)
}

class SelectOperatorViewController: UIBaseViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    
    @IBOutlet weak var viewList: UIView!
    @IBOutlet weak var viewLoading: UIView!
    
    // MARK: Variables
    
    var operators: [Operator] = []
    var delegateSelectOperator: SelectOperatorDelegate?
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        self.setupCollectionView()
        
        PhoneRechargeRN(delegate: self).getOperatorList()
        self.collectionView.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [.new], context: nil)
    }
    
    override func setupViewWillAppear() {
        
        // Loading...
        self.hideAll()
        self.viewLoading.isHidden = false
        
        // Time
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            // Lista
            self.hideAll()
            self.viewList.isHidden = false
        }
    }
}

// MARK: Delegate Base
extension SelectOperatorViewController: BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            //If its telling to finish
            if (fromClass == PhoneRechargeRN.self) {
                if param == Param.Contact.PHONE_RECHARGE_OP_LIST_RESPONSE {
                    if (result) {
                        if let operators = object as? [Operator] {
                            self.operators = operators
                            self.collectionView.reloadData()
                        }
                    }
                    return
                }
            }
        }
    }
}

// MARK: Observer
extension SelectOperatorViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(UICollectionView.contentSize) {
            if let _ = object as? UICollectionView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.heightCollectionView.constant = size.height
                    return
                }
            }
        }
        
        self.heightCollectionView.constant = self.collectionView.contentSize.height
    }
}

// MARK: Register Nib
extension SelectOperatorViewController {
    
    func setupCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        let size = (self.collectionView.frame.width - (CGFloat(2) * 10)) / 2
        flowLayout.itemSize = CGSize(width: size, height: 120)
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 20
        
        self.collectionView?.collectionViewLayout = flowLayout
        self.collectionView?.register(BigImageCell.nib(), forCellWithReuseIdentifier: BigImageCell.Identifier())
        self.collectionView.layer.masksToBounds = false
    }
    
    func animateViews() {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: Data Collection
extension SelectOperatorViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return operators.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigImageCell.Identifier(), for: indexPath) as? BigImageCell else {
            return UICollectionViewCell()
        }
        
        let menu = operators[indexPath.row]
        cell.displayContent(image: menu.imagePath)
        
        return cell
    }
}

// MARK: Delegate Collection
extension SelectOperatorViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.dismiss(animated: true) {
            let menu = self.operators[indexPath.row]
            self.delegateSelectOperator?.didSelect(operadora: menu)
            QiwiOrder.checkoutBody.requestPhone?.operatorId = menu.id
            QiwiOrder.setPrvId(prvId: menu.prvId)
        }
    }
}

// MARK: Control UI
extension SelectOperatorViewController {
    
    func hideAll() {
        self.viewList.isHidden = true
        self.viewLoading.isHidden = true
    }
}

// MARK: Setup UI
extension SelectOperatorViewController: SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "phone_select_operator_toolbar".localized)
    }
}
