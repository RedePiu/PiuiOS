//
//  TopAppsCollectionViewCell.swift
//  MyQiwi
//
//  Created by Daniel Catini on 01/10/23.
//  Copyright © 2023 Qiwi. All rights reserved.
//
//
import UIKit

class TopAppsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var btnShowAll: UIButton!
    
    // MARK: Propeties
    var menus = [MenuItem]()
    var isTopApp = false
    var didSelectCell: ((IndexPath) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collection.register(ItemTopApps.nib(), forCellWithReuseIdentifier: "Cell")
        collection.dataSource = self
        collection.delegate = self
        collection.showsHorizontalScrollIndicator = false
        collection.frame.size.width = UIScreen.main.bounds.width - 34
        collection.frame.size.height = 100
    
        if let layout = self.collection.collectionViewLayout as? UICollectionViewFlowLayout {
            let cellWidth = self.collection.bounds.width / 4
            layout.itemSize = CGSize(width: cellWidth, height: self.collection.bounds.height)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
    }
}

// MARK: Data Collection
extension TopAppsCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isTopApp ? self.menus.count - 1 : self.menus.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cellFavorite = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ItemTopApps {
            cellFavorite.imgMenu = Util.formatImagePath(path: self.menus[indexPath.item].imageMenu! + "_new")
            cellFavorite.layer.masksToBounds = false
            cellFavorite.contentView.backgroundColor = UIColor.white
            return cellFavorite
        }

        return UICollectionViewCell.init(frame: .zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Log.print(indexPath.item)
        didSelectCell?(indexPath)
    }
}

// MARK: - Base Delegate
extension TopAppsCollectionViewCell: BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            //If its telling to finish
            if (fromClass == MenuTypeBaseView.self) {
                if param == Param.Contact.MENU_CLICK {
                    //self.checkAndStartScreen(menu: object as! MenuItem)
                }
            }
            
            if (fromClass == UserRN.self) {
                if param == Param.Contact.NEED_UPDATE_DATA {
                    //If has token shows the button
                    //self.svQToken.isHidden = !TokenRN.hasToken()
                }
            }
        }
    }
}
