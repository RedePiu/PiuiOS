//
//  OtherProductsAdapter.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 23/11/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class OtherProductsAdapter : NSObject {
    
    var viewController: OtherProductsViewController
    var heightCollection: NSLayoutConstraint?
    var menus: [MenuItem]
    var collectionView: UICollectionView
    
    init(_ sender: OtherProductsViewController, collectionView: UICollectionView, heightCollection: NSLayoutConstraint?, menus: [MenuItem]) {

        self.viewController = sender
        self.collectionView = collectionView
        self.heightCollection = heightCollection
        self.menus = menus
        
        super.init()
        
        self.setupCollectionView()
    }
}

// MARK: Observer Height Collection
extension OtherProductsAdapter {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(UICollectionView.contentSize) {
            if let _ = object as? UICollectionView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.heightCollection!.constant = size.height
                    return
                }
            }
        }
    }
}

extension OtherProductsAdapter {
    
    func setupCollectionView() {
            
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        //  Cell custom
        self.collectionView.register(OtherProductListCell.nib(), forCellWithReuseIdentifier: "Cell")
        self.collectionView.layer.masksToBounds = true
        
        //self.collectionView.reloadData()
        if menus.isEmpty {
            return
        }
        
        if self.heightCollection != nil {
            self.collectionView.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [.new], context: nil)
        }
    }
    
    func updateList(menus: [MenuItem]) {
        
        self.menus = menus
        self.collectionView.reloadData()
    }
}

// Data Collection
extension OtherProductsAdapter: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! OtherProductListCell

        let currentItem = self.menus[indexPath.row]
        cell.displayContent(delegate: self.viewController, menu: currentItem)
        
        return cell
    }
}

// MARK: Layout Collection
extension OtherProductsAdapter: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        // Layout custom
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
        }

        let size = CGSize(width: self.collectionView.frame.width, height: CGFloat(128))
        return size
    }
}
