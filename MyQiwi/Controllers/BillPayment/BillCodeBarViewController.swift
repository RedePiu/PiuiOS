//
//  BillInserCodeBarViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 22/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class BillCodeBarViewController: UIBaseViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var btContinue: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var txtBarcode: UITextView!

    // MARK: Variables
    
    var barcode = ""
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupTextView(enable: false)
    }
    
    override func setupViewWillAppear() {
        
        if !barcode.isEmpty {
            self.txtBarcode.text = Util.masCodeBar(text: self.barcode)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.txtBarcode.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Segue Idetifier
extension BillCodeBarViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.Segues.BILL_DETAILS {
            if let vc = segue.destination as? BillDetailsViewController {
//                let jsonBoleto = Boletos.getValuesBoletoLidos(CodigoBarras: self.barcode.removeAllOtherCaracters())
//                vc.dueDate = jsonBoleto["datavencimento"] as? String ?? ""
//                vc.price = jsonBoleto["valor"] as? String ?? ""
                
                vc.price = QiwiOrder.factoryFebraban?.getBoleto().getValorBoleto() ?? 0
                vc.dueDate = QiwiOrder.factoryFebraban?.getBoleto().getDataVencimento() ?? ""
                
                //atualiza o prv id e o tipo de boleto
                BillRN(delegate: self).verifyPaymentType()
            }
        }
    }
}

extension BillCodeBarViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
    }
}

// MARK: Delegate TextView
extension BillCodeBarViewController: UITextViewDelegate {
    
    func setupTextView(enable: Bool) {
        
        self.txtBarcode.font = FontCustom.helveticaRegular.font(18)
        self.txtBarcode.layer.cornerRadius = 5
        self.txtBarcode.layer.borderWidth = 1
        
        if enable {
            self.txtBarcode.layer.borderColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiOrange).cgColor
        }else {
            self.txtBarcode.layer.borderColor = UIColor.lightGray.cgColor.copy(alpha: 0.8)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.setupTextView(enable: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.setupTextView(enable: false)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        textView.text = Util.masCodeBar(text: textView.text ?? "")
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//        let textMask = Util.maskBarCodeTextView(textView, shouldChangeTextIn: range, replacementText: text)
//
//        if let newText = textMask {
//            return Util.limitTextView(text: newText)
//        }else {
//            Log.print("vazio texto")
//            return true
//        }
//    }
}

// MARK: IBActions
extension BillCodeBarViewController {
    
    @IBAction func clickContinue(sender: UIButton) {
        
        if let barcode = self.txtBarcode.text {
            
            let result = QiwiOrder.factoryFebraban?.validarCodigoBarras(codigoBarras: barcode)
            if !result! || barcode.isEmpty || barcode.count < 44{
                Util.showAlertDefaultOK(self, message: "bill_barcode_incomplet".localized)
                self.txtBarcode.becomeFirstResponder()
                return
            }
            
            self.barcode = barcode
            performSegue(withIdentifier: Constants.Segues.BILL_DETAILS, sender: nil)
        }
    }
}

// MARK: SetupUI
extension BillCodeBarViewController: SetupUI {
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.greenButton(self.btContinue)

        self.txtBarcode.delegate = self
    }
    
    func setupTexts() {
        self.btContinue.setTitle("continue_label".localized, for: .normal)
        self.lbTitle.text = "bill_barcode_title".localized
        Util.setTextBarIn(self, title: "bill_barcode_title_nav".localized)
    }
    
    func setupTextView() {
        
        
    }
}
