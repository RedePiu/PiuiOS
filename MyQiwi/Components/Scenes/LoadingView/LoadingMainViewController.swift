//
//  LoadingViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 07/06/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import Foundation

final class LoadingMainViewController: BaseViewController<LoadingView> {
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        baseView.showLoader()
    }
}
