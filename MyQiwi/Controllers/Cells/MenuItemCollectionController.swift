//
//  MenuItemCollectionController.swift
//  MyQiwi
//
//  Created by ailton on 01/01/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import UIKit

public class MenuItemCollectionController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellMenu = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuItemViewCell", for: indexPath) as! MenuItemViewCell
        return cellMenu
    }
}
