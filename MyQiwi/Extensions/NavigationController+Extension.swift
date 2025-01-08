//
//  NavigationController+Extension.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 06/04/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

extension UINavigationController {
  func replaceTopViewController(with viewController: UIViewController, animated: Bool) {
    var vcs = viewControllers
    vcs[vcs.count - 1] = viewController
    setViewControllers(vcs, animated: animated)
  }
}
