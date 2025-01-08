//
//  ComprovanteDepositoAdapter.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 18/06/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import Foundation

import UIKit

class ComprovanteDepositoAdapter : NSObject {
    
    // MARK: VARIABLES
    var receipts: [DividaReceipt]
    var collectionView: UICollectionView
    var viewController: UIBaseViewController
    
    init(_ sender: UIBaseViewController, collectionView: UICollectionView, receipts: [DividaReceipt] = [DividaReceipt]()) {

        self.viewController = sender
        self.collectionView = collectionView
        self.receipts = receipts
        
        super.init()
        
        self.setupCollectionView()
    }
}

// MARK: Setup Collection / Table
extension ComprovanteDepositoAdapter {
    
    func setupCollectionView() {
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        //  Cell custom
        self.collectionView.register(ComprovanteDepositoCell.nib(), forCellWithReuseIdentifier: "Cell")
        self.collectionView.layer.masksToBounds = false
        
        self.collectionView.reloadData()
    }
    
    func addComprovante(receipt: DividaReceipt) {
        self.receipts.append(receipt)
        self.collectionView.reloadData()
    }
}

// MARK: Delegate Collection - CLICK EVENT
extension ComprovanteDepositoAdapter: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// Data Collection
extension ComprovanteDepositoAdapter: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.receipts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ComprovanteDepositoCell

        let currentItem = self.receipts[indexPath.row]
        cell.displayContent(receipt: currentItem, position: indexPath.row, delegate: self)
        
        return cell
    }
}

extension ComprovanteDepositoAdapter: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        self.receipts.remove(at: object as! Int)
        self.collectionView.reloadData()
        
        if self.receipts.isEmpty {
            let delegate = self.viewController as! BaseDelegate
            delegate.onReceiveData(fromClass: ComprovanteDepositoAdapter.self, param: Param.Contact.LIST_REMOVE_ITEM, result: true, object: nil)
        }
    }
}

// MARK: Layout Collection
extension ComprovanteDepositoAdapter: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        // Layout custom
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 20
            flowLayout.minimumInteritemSpacing = 20
        }

        let size = CGSize(width: 100, height: 200)
        return size
    }
}
