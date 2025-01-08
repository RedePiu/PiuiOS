//
//  CommisingTaxViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 14/06/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class CommissionTaxViewController: UIBaseViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    
    var commissionList = [Commission]()
    let height = CGFloat(50)
    
    init() {
        super.init(nibName: "CommissionTaxViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func requestCommission() {
        Util.showLoading(self)
        UserRN(delegate: self).getCommissionList()
    }
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupNib()
    }
    
    override func setupViewWillAppear() {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.requestCommission()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CommissionTaxViewController {
    @objc func onClickContinue() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CommissionTaxViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.async {
            if fromClass == UserRN.self {
                if param == Param.Contact.USER_COMMISSION_LIST_RESPONSE {
                    self.dismiss(animated: true, completion: nil)
                    
                    if result {
                        self.commissionList = object as! [Commission]
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

// MARK: Observer Height Collection
extension CommissionTaxViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(UITableView.contentSize) {
            if let _ = object as? UITableView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.heightTable.constant = size.height + 20
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    }
                    return
                }
            }
        }
        
        self.setupHeightTable()
    }
}

// MARK: Data Table
extension CommissionTaxViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commissionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CommissionCell
        
        let index = indexPath.row
        let item = self.commissionList[index]
        cell.item = item

        self.setupHeightTable()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension CommissionTaxViewController: SetupUI {
    
    func setupUI() {

        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.greenButton(self.btnContinue)
    }
    
    func setupTexts() {
        
        btnContinue.addTarget(self, action: #selector(self.onClickContinue), for: .touchUpInside)
    }
    
    func setupNib() {
        self.tableView.register(CommissionCell.nib(), forCellReuseIdentifier: "Cell")
    }
    
    func setupHeightTable() {
//        self.heightTable.constant = self.tableView.contentSize.height + 20
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
    }
}
