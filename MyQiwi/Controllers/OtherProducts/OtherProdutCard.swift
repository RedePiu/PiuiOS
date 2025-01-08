//
//  OtherProdutCard.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 19/12/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

// MARK: UITableViewCell com UICollectionViewCell
class OtherProdutCard: UITableViewCell {

    @IBOutlet weak var collection: UICollectionView!
    
    var selectMenuDelegate: SelectOthersDelegate?
    
    // Variables
    var menuItems: [MenuItem]! {
        didSet {
            self.configure()
            self.collection.reloadData()
        }
    }
}

extension OtherProdutCard {
    
    func configure() {
        self.setupCollectionView()
    }
    
    func setupCollectionView() {
        
        // Layout Custom
        if let flowLayout = self.collection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 100, height: 100)
            flowLayout.minimumLineSpacing = 20
            flowLayout.minimumInteritemSpacing = 20
        }
    }
}

// MARK: Data Collection
extension OtherProdutCard: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cellProductCard = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ProductCardMenu {
            
            let menuItem = self.menuItems[indexPath.row]
            cellProductCard.imageMenu = Util.formatImagePath(path: menuItem.imageMenu ?? "")
            
            cellProductCard.layer.masksToBounds = false
            
            return cellProductCard
        }
        
        return UICollectionViewCell.init(frame: .zero)
    }
}

// MARK: Delegate Collection
extension OtherProdutCard: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Colleção com produtos diversos
        let menuItemSelected = self.menuItems[indexPath.row]
        self.selectMenuDelegate?.select(menuItem: menuItemSelected)
    }
}
