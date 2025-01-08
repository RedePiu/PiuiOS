//
//  OrderSwipeViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 08/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit
import SwipeViewController

class OrderSwipeViewController : SwipeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Button with image example
        //let buttonOne = SwipeButtonWithImage(image: UIImage(named: "Hearts"), selectedImage: UIImage(named: "YellowHearts"), size: CGSize(width: 40, height: 40))
        //setButtonsWithImages([buttonOne, buttonOne, buttonOne])
        
//        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(push))
        //setNavigationWithItem(UIColor.white, leftItem: barButtonItem, rightItem: nil)
        
//        let stb = UIStoryboard(name: "Orders", bundle: nil)
//        let page_one = stb.instantiateViewController(withIdentifier: "sbOrders") as UIViewController
//        let page_two = stb.instantiateViewController(withIdentifier: "sbReceipts") as UIViewController
//
//        page_one.title = "Pedidos"
//        page_two.title = "Recibods"
//
//        setViewControllerArray([page_one, page_two])
    }
}

// MARK: SetupUI

extension OrderSwipeViewController {
    
    func setupUI() {
        
    }
    
    func setupTexts() {
        
    }
}
