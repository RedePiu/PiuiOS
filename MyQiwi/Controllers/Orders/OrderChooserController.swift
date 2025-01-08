//
//  OrderChooser.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 09/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class OrderChooserController : UINavigationController {
    
    func presentationController(controller: UIPresentationController!, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController!
    {
      let presented = controller.presentedViewController
      return UINavigationController(rootViewController: MoreViewController())
    }
}
