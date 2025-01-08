//
//  UrbsExtractViewController.swift
//  MyQiwi
//
//  Created by Thyago on 27/06/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class UrbsBalanceViewController: UIBaseViewController {
    
    @IBOutlet weak var lbNameCard: UILabel!
    @IBOutlet weak var lbNumberCard: UILabel!
    @IBOutlet weak var lbExtractQty: UILabel!
    @IBOutlet weak var lbConsultDate: UILabel!
    @IBOutlet weak var lbNoContent: UILabel!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var viewNoContent: UIView!
    @IBOutlet weak var viewBalance: UIView!
    @IBOutlet weak var ivRefresh: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnRecharge: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    var transportCard = TransportCard()
    lazy var transportUrbsRN = TransportCardUrbsRN(delegate: self)
    var balances = [UrbsBalance]()
    var selectedPosition = 0
    let date = Date()
    let time = ""
    let balance = 0
    
    lazy var refresher: UIRefreshControl = {
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = Theme.default.blue
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupNib()
        
        self.requestData()
    }
    
    func setupNib() {
        self.collectionView.register(UrbsCreditTypeCell.nib(), forCellWithReuseIdentifier: UrbsCreditTypeCell.Identifier())
    }
}

extension UrbsBalanceViewController {
    
    @IBAction func onClickBack(_ sender: Any) {
        self.popPage()
    }
    
    @IBAction func onClickRecharge(_ sender: Any) {
        QiwiOrder.checkoutBody.requestUrbs?.cardNumber = self.transportCard.number
        ListGenericViewController.stepListGeneric = .SELECT_TRANSPORT_URBS_RECHARGE_TYPE
        self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
    }
}

extension UrbsBalanceViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.balances.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UrbsCreditTypeCell.Identifier(), for: indexPath) as! UrbsCreditTypeCell
        
        let currentItem = self.balances[indexPath.row]
        //cell.displayContent(balance: currentItem, selected: indexPath.row == self.selectedPosition)
        
        return cell
    }
}

// MARK: Delegate UrbsBalanceViewController
extension UrbsBalanceViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedPosition = indexPath.row
        self.collectionView.reloadData()
        
        self.printBalance(balance: self.balances[self.selectedPosition])
    }
}

extension UrbsBalanceViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80, height: 80)
    }
}

extension UrbsBalanceViewController : BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.async {
            if (param == Param.Contact.TRANSPORT_CARD_URBS_CONSULT_RESPONSE) {
                
                if result {
                    let response = object as! UrbsConsultResponse
                    self.balances = response.balances
                    
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.collectionView.reloadData()
                    
                    self.printBalance(balance: response.balances[0])
                    return
                }
                
                self.showNoContent()
            }
        }
    }
}

extension UrbsBalanceViewController {
 
    func printBalance(balance: UrbsBalance) {
        self.updateBalance(balance: balance.balance)
        
        let formattedDate = DateFormatterQiwi.formatDate(balance.balanceDate, currentFormat: DateFormatterQiwi.defaultDatePattern, toFormat: DateFormatterQiwi.dateAndHour)
        let date = "transport_urbs_balance_date".localized.replacingOccurrences(of: "{date}", with: formattedDate)
        
        self.lbExtractQty.text = Util.formatCoin(value: balance.balance)
        self.lbConsultDate.text = date
        
        self.showBalance()
    }
}

extension UrbsBalanceViewController {
 
    func hideAll() {
        self.viewBalance.isHidden = true
        self.viewLoading.isHidden = true
        self.viewNoContent.isHidden = true
    }
    
    func showLoading() {
        self.hideAll()
        self.viewLoading.isHidden = false
    }
    
    func showBalance() {
        self.hideAll()
        self.viewBalance.isHidden = false
    }
    
    func showNoContent() {
        self.hideAll()
        self.viewNoContent.isHidden = false
    }
}

extension UrbsBalanceViewController {
    
    @objc func goToRecharge(sender: UIButton) {
        
        performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
    }

    @objc func requestData() {
        self.showLoading()
        self.transportUrbsRN.consultCard(cardNumber: self.transportCard.number)
    }
    
    func updateBalance(balance: Double) {
        
        if balance > 0 {
            
            self.lbExtractQty.text = Util.formatCoin(value: balance)
            self.lbExtractQty.tintColor = Theme.default.green
        }
        else if balance <= 0 {
            
            self.lbExtractQty.textColor = Theme.default.red
            self.lbExtractQty.text = Util.formatCoin(value: balance)
        }
    }
    
    func disableAll() {
        
    }
}

extension UrbsBalanceViewController: SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.orageButton(self.btnBack)
        Theme.default.greenButton(self.btnRecharge)
        Theme.default.textAsListTitle(self.lbNameCard)
        Theme.default.textAsListTitle(self.lbNumberCard)
        Theme.default.textAsMessage(self.lbConsultDate)
        
        self.ivRefresh.image = UIImage(named: "ic_refresh")?.withRenderingMode(.alwaysTemplate)
        self.ivRefresh.tintColor = UIColor(hexString: Constants.Colors.Hex.colorGrey4)
        
        self.lbExtractQty.textColor = Theme.default.green
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "transport_balance_title_nav".localized)
        
        self.lbNameCard.text = !self.transportCard.name.isEmpty ? self.transportCard.name : "Cartão URBS"
        self.lbNumberCard.text = String(self.transportCard.number)
        
        self.lbNoContent.text = "transport_urbs_balance_error".localized
    }
}
