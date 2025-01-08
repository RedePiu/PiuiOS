//
//  DividaBarcode.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 13/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class DividaBarcodeViewController: UIBaseViewController {
    
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblCopy: UILabel!
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var lblBarcode: UILabel!
    @IBOutlet weak var imgCopy: UIImageView!
    @IBOutlet weak var imgShare: UIImageView!
    
    let documentInteractionController = UIDocumentInteractionController()
    var barcode = ""//3792.37403 55896.485459 67008.410002 4 79170000064385"
    var idDivida = 0
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        
        colorButtons()
        barcodePush()
        
        let gestureCopy = UITapGestureRecognizer(target: self, action: #selector(copyCode(_ :)))
        imgCopy.isUserInteractionEnabled = true
        imgCopy.addGestureRecognizer(gestureCopy)
        
        let gestureShare = UITapGestureRecognizer(target: self, action: #selector(shareCode))
        imgShare.isUserInteractionEnabled = true
        imgShare.addGestureRecognizer(gestureShare)
        
        self.requestBarcode()
    }
}

extension DividaBarcodeViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.async {
         
            if fromClass == DividaRN.self {
                if param == Param.Contact.DIVIDA_BOLETO_RESPONSE {
                    self.dismiss(animated: true, completion: nil)
                    
                    if result {
                        self.barcode = object as! String
                    }
                    
                    self.lblBarcode.text = self.barcode
                }
            }
        }
    }
}

extension DividaBarcodeViewController {

    func requestBarcode() {
        Util.showLoading(self)
        DividaRN(delegate: self).getBoleto(idDivida: self.idDivida)
    }
}

extension DividaBarcodeViewController {
    
    func colorButtons() {
        let imgCopy = UIImage(named: "ic_copy")
        let imgShare = UIImage(named: "ic_share")
        let tintedCopy = imgCopy?.withRenderingMode(.alwaysTemplate)
        let tintedShare = imgShare?.withRenderingMode(.alwaysTemplate)
    }
    
    func barcodePush() {
        
        self.lblBarcode.text = "\(barcode)"
    }
    
    func pickCode() {
        
        UIPasteboard.general.string = "\(barcode)"
    }
    
    @objc func copyCode(_ sender: Any) {
        
        pickCode()
        
        //let title = "Código Copiado"
        let message = "Seu código de barras foi copiado pra área de transferência. Agora é só colar na leitora"
        
        Util.showAlertDefaultOK(self, message: message)
    }
    
    @objc func shareCode(_ sender: Any) {
        
        let codeToShare = [barcode]
        let activityViewController = UIActivityViewController(activityItems: codeToShare, applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.copyToPasteboard ]
        self.present(activityViewController, animated: true, completion: nil)
        
    }
}

extension DividaBarcodeViewController: SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.textAsMessage(self.lblText)
        Theme.default.textAsMessage(self.lblCopy)
        Theme.default.textAsMessage(self.lblShare)
        
        self.lblBarcode.tintColor = Theme.default.orange
        self.lblCopy.tintColor = Theme.default.primary
        self.lblShare.tintColor = Theme.default.primary
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "payments_bill_title".localized)
    }
}

