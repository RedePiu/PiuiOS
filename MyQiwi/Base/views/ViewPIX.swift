//
//  ViewPIX.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 15/02/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import UIKit

class ViewPIX: LoadBaseView {
    
    // MARK: Init
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbWhoWillPIX: UILabel!
    @IBOutlet weak var lbWhoWillPixDesc: UILabel!
    @IBOutlet weak var lbOr: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var txtCPF: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var heightCollection: NSLayoutConstraint!
    @IBOutlet weak var checkBox: ViewCheckbox!
    @IBOutlet weak var btnOtherPerson: UIButton!
    
    var delegate: BaseDelegate?
    var savedAccounts = [PIXRequest]()
    let MAX_PIX_PERSON = 2;
    
    override func initCoder() {
        self.loadNib(name: "ViewPIX")
        self.setupViewWithoutCard()
        self.setupView()
    }

}

extension ViewPIX {
    @IBAction func onClickOtherPerson(_ sender: Any) {
        self.collectionView.isHidden = true
        self.lbOr.isHidden = true
        self.btnOtherPerson.isHidden = true
        self.txtName.isHidden = false
        self.txtCPF.isHidden = false
        self.checkBox.isHidden = false
    }
}

// MARK: Observer Height Collection
extension ViewPIX {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(UICollectionView.contentSize) {
            if let _ = object as? UICollectionView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.heightCollection!.constant = size.height
                    return
                }
            }
        }
    }
}

extension ViewPIX {
    
    func findSavedAccounts() {
        
        savedAccounts = [PIXRequest]()
        
        //If its a normal user, adds a bank with user cpf
        let c = PIXRequest()
        c.document = UserRN.getLoggedUser().cpf
        c.name = UserRN.getLoggedUser().name
        savedAccounts.append(c)
        savedAccounts.append(contentsOf: PaymentRN(delegate: self).GetSavedPixRequests())
        
        self.setupCollectionView()
        self.collectionView.isHidden = false
        
        self.setupInitialView()
    }
    
    func setupInitialView() {
        
        self.collectionView.isHidden = false
        
        if (ApplicationRN.isQiwiBrasil() && savedAccounts.count >= MAX_PIX_PERSON) {
            self.lbOr.isHidden = true
            self.btnOtherPerson.isHidden = true
            self.txtName.isHidden = true
            self.txtCPF.isHidden = true
            self.checkBox.isHidden = true
            return
        }
        
        self.lbOr.isHidden = false
        self.btnOtherPerson.isHidden = false
        self.txtName.isHidden = true
        self.txtCPF.isHidden = true
        self.checkBox.isHidden = true
    }
    
    func setupCollectionView() {
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        //  Cell custom
        self.collectionView.register(ViewPIXPersonCell.nib(), forCellWithReuseIdentifier: "Cell")
        self.collectionView.layer.masksToBounds = true
        
        self.collectionView.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [.new], context: nil)
        self.collectionView.reloadData()
    }
    
    func getInputRequest() -> PIXRequest? {
        
        let name = txtName.text ?? ""
        let doc = txtCPF.text ?? ""
        
        if name.count < 3 {
            return nil
        }
        
        if !Util.validadeCNPJ(doc) && !Util.validadeCPF(doc) {
            return nil
        }
        
        return PIXRequest(name: name, document: doc.removeAllOtherCaracters(), save: self.checkBox.isChecked)
    }
}

extension ViewPIX : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
    }
}

extension ViewPIX {
    
    @objc func hideList(_ textField: UITextField) {

        DispatchQueue.main.async {
            
//            if (mContact == null) {
//                                return;
//                            }
//
//                            if (!etName.getText().toString().isEmpty() && !etDoc.getText().toString().isEmpty()) {
//                                mContact.contactComponent(PixView.class, Param.Contact.SHOW_BACK_AND_CONTINUE_BUTTON, true);
//                                return;
//                            }
//
//                            mContact.contactComponent(PixView.class, Param.Contact.SHOW_ONLY_BACK_BUTTON, true);
//                        }
            
            if !self.txtName.text!.isEmpty && !self.txtCPF.text!.isEmpty {
                self.delegate?.onReceiveData(fromClass: ViewPIX.self, param: Param.Contact.SHOW_BACK_AND_CONTINUE_BUTTON, result: true, object: nil)
                return
            }
            
            self.delegate?.onReceiveData(fromClass: ViewPIX.self, param: Param.Contact.SHOW_ONLY_BACK_BUTTON, result: true, object: nil)
        }
    }
}


extension ViewPIX {
    
    func setupView() {
        
        Theme.TransportInstructions.textAsTitle(self.lbTitle)
        Theme.TransportInstructions.textAsTitle(self.lbWhoWillPIX)
        Theme.TransportInstructions.textAsTitle(self.lbOr)
        Theme.TransportInstructions.textAsDesc(self.lbDesc)
        Theme.TransportInstructions.textAsDesc(self.lbWhoWillPixDesc)
        
        Theme.default.greenButton(self.btnOtherPerson)
        
        self.lbTitle.text = "pix_view_title".localized
        self.lbDesc.text = "pix_view_desc".localized
        self.lbWhoWillPIX.text = "pix_view_select_who_will_pay".localized
        self.lbWhoWillPixDesc.text = "pix_view_select_who_will_pay_desc".localized
        self.txtName.placeholder = "pix_view_name_placeholder".localized
        self.txtCPF.placeholder = "pix_view_document_placeholder".localized
        
        self.txtCPF.addTarget(self, action: #selector(hideList(_:)), for: .editingChanged)
        self.txtName.addTarget(self, action: #selector(hideList(_:)), for: .editingChanged)
        
        self.checkBox.lbText.text = "pix_save_document".localized
        self.checkBox.setChecked(checked: true)

        //self.txtCPF.formatPattern = Constants.FormatPattern.Bank.AGENCY.rawValue
        self.findSavedAccounts()
    }
}

// MARK: Delegate Collection - CLICK EVENT
extension ViewPIX: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        //let charade = self.charades[indexPath.row]
    }
}

// Data Collection
extension ViewPIX: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.savedAccounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ViewPIXPersonCell
        let account = self.savedAccounts[indexPath.row]
        cell.displayeContent(pixRequest: account, delegate: delegate!)
        
        return cell
    }
}

// MARK: Layout Collection
extension ViewPIX: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: self.collectionView.frame.width, height: 80)
        return size
    }
}
