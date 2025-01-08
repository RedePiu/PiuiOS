//
//  ConfirmTransferViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 23/01/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ConfirmTransferViewController: UIBaseViewController {

    @IBOutlet weak var lbLabelTitle: UILabel!
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tablelView: UICardView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var viewList: UIView!
    
    @IBOutlet weak var presentationCard: PresentationCardCell!
    @IBOutlet var btnContinue: UIButton!
    @IBOutlet weak var btnVoltar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTableView()
        self.setupTexts()
    }

}

extension ConfirmTransferViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension ConfirmTransferViewController: SetupUI{
    
    func setupTableView() {
        //self.tableView.tableFooterView = UIView()
        //self.tableView.layer.masksToBounds = false
        //self.tableView.register(PhoneContactCell.nib(), forCellReuseIdentifier: "Cell")
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "confirm_transfer_tooblar_title".localized)
    }
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        Theme.default.blueButton(self.btnContinue)
        Theme.default.orageButton(self.btnVoltar)
    }
}

extension ConfirmTransferViewController {
    @IBAction func btnVoltar( sender: UIButton! ){
        
    }
    @IBAction func btnContinue( sender: UIButton! ) {
        
    }
}
