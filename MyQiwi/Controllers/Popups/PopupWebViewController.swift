//
//  PopupWebViewController.swift
//  MyQiwi
//
//  Created by Douglas on 04/05/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit
import WebKit

class PopupWebViewController: UIBaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: Variables
    
    // MARK: Init
    
    init() {
        super.init(nibName: "PopupWebViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Ciclo de Vida
    
    override func setupViewDidLoad() {
        self.btnAccept.isHidden = true
        self.webView.navigationDelegate = self
        self.webView.isHidden = true
    }
    
    override func setupViewWillAppear() {
        
        guard let url = URL(string: Constants.url_terms) else {
            self.dismiss(animated: true)
            return
        }
        
        let urlRequest = URLRequest(url: url)
        self.webView.load(urlRequest)
    }
}

// MARK: Delegate
extension PopupWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        self.webView.isHidden = false
        self.loading.isHidden = true
    }
}

// MARK: IBActions
extension PopupWebViewController {
    
    @IBAction func openBack(sender: UIButton) {
        self.dismiss(animated: false)
    }
}

// MARK: SetupUI
extension PopupWebViewController: SetupUI {
    
    func setupUI() {
        self.btnClose.titleLabel?.font = FontCustom.helveticaBold.font(18)
    }
    
    func setupTexts() {
        self.btnClose.setTitle("close".localized, for: .normal)
        self.btnAccept.setTitle("accept".localized, for: .normal)
    }
}
