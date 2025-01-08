//
//  OtherProductListCell.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 23/11/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class OtherProductListCell : UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    
    var delegate: BaseDelegate!
    var menu: MenuItem!
    var menuItems = [MenuItem]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.title.textColor = UIColor(hexString: Constants.Colors.Hex.colorPrimary)
    }
    
    func displayContent(delegate: BaseDelegate, menu: MenuItem) {
        //img.image = UIImage(named: image)
        
        self.delegate = delegate
        self.title.text = menu.desc
        
        self.menuItems = menu.data as? [MenuItem] ?? [MenuItem]()
        
        self.configure()
        self.collection.reloadData()
    }

}

extension OtherProductListCell {
    
    func configure() {
        self.setupCollectionView()
    }
    
    func setupCollectionView() {
        
        self.collection.register(OtherGenericCollectionViewCell.nib(), forCellWithReuseIdentifier: "Cell")
        
        self.collection.delegate = self
        self.collection.dataSource = self
        
        // Layout Custom
        if let flowLayout = self.collection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 100, height: 100)
            flowLayout.minimumLineSpacing = 20
            flowLayout.minimumInteritemSpacing = 20
        }
    }
}

// MARK: Data Collection
extension OtherProductListCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menuItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cellFavorite = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? OtherGenericCollectionViewCell {

            let menuItem = self.menuItems[indexPath.row]
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
extension OtherProductListCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // Colleção com os favoritos no topo, somente row
        let menuItemSelected = self.menuItems[indexPath.row]
        self.delegate.onReceiveData(fromClass: OtherProductListCell.self, param: Param.Contact.LIST_CLICK, result: true, object: menuItemSelected as AnyObject)
        //self.select(menuItem: menuItemSelected)
    }
}

