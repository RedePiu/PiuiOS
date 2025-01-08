//
//  DividaTransferenciaViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 10/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class DividaTransferenciaViewController : UIBaseViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollection: NSLayoutConstraint!
    @IBOutlet weak var lbTitleCaixa: UILabel!
    
    @IBOutlet weak var viewBankTransfer: ViewBankTransfer!
    @IBOutlet weak var viewBankAccountInfo: ViewBankInfo!
    @IBOutlet weak var viewStatus: UICardView!
    @IBOutlet weak var viewCaixa: ViewCaixaEconomica!
    
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lbStatusTitle: UILabel!
    @IBOutlet weak var lbStatusDesc: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    
    var banks = [MenuItem]()
    var selectedBank = Bank()
    var selectedDivida = Divida()
    var bankRequest = BankRequest()
    var canExit = false
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupCollectionView()
        
        //Para não usar objetos do pedido
        self.viewBankTransfer.setIsQiwiOrder(isOrder: false)
        self.viewBankTransfer.viewController = self
        self.viewBankTransfer.delegate = self
        
        let allBanks = BankDAO().getAll()
        for bank in allBanks {
            self.banks.append(MenuItem(description: bank.bankName, image: String(bank.id), action: bank.id, id: bank.id, data: bank))
        }
        
        self.collectionView.reloadData()
        self.collectionView.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [.new], context: nil)
        
        self.changeStep(step: .SELECT_BANK)
    }
    
    var currentStep = DividaTransferenciaViewController.Steps.SELECT_BANK
    enum Steps: Int {
        case SELECT_BANK = 1
        case INPUT_BANK_ACC
        case SHOW_QIWI_BANK_AND_STATUS
    }
}

extension DividaTransferenciaViewController {
    
    func requestDividaPayment() {
        Util.showLoading(self)
        DividaRN(delegate: self).payWithTransferencia(bankRequest: self.bankRequest, divida: self.selectedDivida, receipts: [DividaReceipt]())
    }
    
    func setStatus(success: Bool) {
        self.changeStep(step: .SHOW_QIWI_BANK_AND_STATUS)
        self.imgStatus.image = UIImage(named: success ? "ic_clock" : "ic_red_error")?.withRenderingMode(.alwaysTemplate)
        
        self.btnStatus.removeTarget(nil, action: nil, for: .allEvents)
        self.canExit = true
        
        if success {
            self.imgStatus.tintColor = Theme.default.yellow
            self.lbStatusTitle.text = "dividas_status_title_success".localized
            self.lbStatusDesc.text = "dividas_status_desc_success".localized
            
            Theme.default.yellowButton(self.btnStatus)
            
            self.viewBankAccountInfo.isHidden = false
            
            self.btnStatus.addTarget(self, action: #selector(onClickFinishSuccess), for: .touchUpInside)
        }
        else {
            //self.imgStatus.tintColor = Theme.default.red
            self.lbStatusTitle.text = "dividas_status_title_failed".localized
            self.lbStatusDesc.text = "dividas_status_desc_failed".localized
            
            Theme.default.redButton(self.btnStatus)
            
            self.viewBankAccountInfo.isHidden = true
            
            self.btnStatus.addTarget(self, action: #selector(onClickFinishFailed), for: .touchUpInside)
        }
        
//        cell.btnPay.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
    }
}

extension DividaTransferenciaViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.DIVIDA_PIX {
                    
            // controller que sera apresentada
            if let navVC = segue.destination as? DividaPIXViewController {
                // passa o pedido de order pra frente
                navVC.selectedDivida = self.selectedDivida
            }
        }
    }
}

extension DividaTransferenciaViewController {
    
    @IBAction func backButton(_ sender: Any? = nil) {
        
        if self.currentStep == .SHOW_QIWI_BANK_AND_STATUS {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onClickFinishSuccess(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onClickFinishFailed(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DividaTransferenciaViewController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedBank = self.banks[indexPath.row].data as! Bank
        
        if self.selectedBank.id == ActionFinder.Bank.BRADESCO || self.selectedBank.id == ActionFinder.Bank.CAIXA {
            
            self.performSegue(withIdentifier: Constants.Segues.DIVIDA_PIX, sender: nil)
            return
        }
        
        self.viewBankTransfer.setBank(bank: self.selectedBank)
        self.viewBankAccountInfo.setBankInfo(bank: self.selectedBank, value: DividaDetailViewController.getValueToPay(), isDivida: true, isDeposito: false)
        
        self.stepForward()
    }
}

extension DividaTransferenciaViewController {
    
    func stepForward() {
        let nextStep = self.currentStep.rawValue + 1
        if let newStep = DividaTransferenciaViewController.Steps(rawValue: nextStep) {
            self.changeStep(step: newStep)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func stepBackward() {
        let backStep = self.currentStep.rawValue - 1
        if let newStep = DividaTransferenciaViewController.Steps(rawValue: backStep) {
            self.changeStep(step: newStep)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func hideAll() {
        self.lbTitle.isHidden = true
        self.lbTitleCaixa.isHidden = true
        self.collectionView.isHidden = true
        self.viewBankTransfer.isHidden = true
        self.viewBankAccountInfo.isHidden = true
        self.viewStatus.isHidden = true
        self.viewCaixa.isHidden = true
    }
    
    func changeStep(step: DividaTransferenciaViewController.Steps) {
        self.currentStep = step
        self.hideAll()
        
        switch (self.currentStep) {
            
            case .SELECT_BANK:
                self.lbTitle.text = "dividas_transferencia_step_select_bank".localized
                self.lbTitle.isHidden = false
                self.collectionView.isHidden = false
                break
                
            case .INPUT_BANK_ACC:
                self.lbTitle.text = "dividas_transferencia_step_select_account".localized
                self.lbTitle.isHidden = false
                self.viewBankTransfer.setBank(bank: self.selectedBank)
                self.viewBankTransfer.isHidden = false
                break
                
            case .SHOW_QIWI_BANK_AND_STATUS:
                
                self.viewStatus.isHidden = false
                break
        }
    }
}

// MARK: Observer Height Collection
extension DividaTransferenciaViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(UICollectionView.contentSize) {
            if let _ = object as? UICollectionView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.heightCollection.constant = size.height
                    return
                }
            }
        }
    }
}

// Data Collection
extension DividaTransferenciaViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.banks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BigImageCell

        let currentItem = self.banks[indexPath.row]
        cell.displayContent(image: currentItem.imageMenu ?? "")
        
        return cell
    }
}

// MARK: Layout Collection
extension DividaTransferenciaViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.collectionView.frame.width - (CGFloat(2) * 10)) / 2, height: 130)
    }
}

extension DividaTransferenciaViewController : BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.async {
            if fromClass == ViewBankTransfer.self {
                if param == Param.Contact.BANK_SELECTED || param == Param.Contact.BANK_INPUT_SELECTED {
                    self.bankRequest = object as! BankRequest
                    self.requestDividaPayment()
                }
            }
            
            if fromClass == DividaRN.self {
                if param == Param.Contact.DIVIDA_PAY {
                    self.dismissPageAfter(after: 0.8)
                    self.setStatus(success: result)
                }
            }
        }
    }
}

extension DividaTransferenciaViewController : SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.textAsListTitle(self.lbTitleCaixa)
        Theme.default.yellowButton(self.btnStatus)
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "dividas_toolbar_title".localized)
    }
    
    func setupCollectionView() {
        
        //  Cell custom
        self.collectionView.register(BigImageCell.nib(), forCellWithReuseIdentifier: "Cell")
        self.collectionView.layer.masksToBounds = false
    }
}
