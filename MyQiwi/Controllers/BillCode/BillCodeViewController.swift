//
//  BillCodeViewController.swift
//  MyQiwi
//
//  Created by Thyago on 18/06/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class BillCodeViewController: UIBaseViewController {
    
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblCopy: UILabel!
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var btnCopy: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblBarcode: UILabel!
    
    let documentInteractionController = UIDocumentInteractionController()
    let barcode = "3792.37403 55896.485459 67008.410002 4 79170000064385"
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        
        colorButtons()
        barcodePush()
        
        btnCopy.addTarget(self, action: #selector(copyCode(_:)), for: .touchDown)
        btnShare.addTarget(self, action: #selector(shareCode(_:)), for: .touchDown)
    }
}

extension BillCodeViewController {
    
    func colorButtons() {
        let imgCopy = UIImage(named: "ic_copy")
        let imgShare = UIImage(named: "ic_share")
        let tintedCopy = imgCopy?.withRenderingMode(.alwaysTemplate)
        let tintedShare = imgShare?.withRenderingMode(.alwaysTemplate)
        
        btnCopy.setImage(tintedCopy, for: .normal)
        btnCopy.tintColor = Theme.default.primary
        
        btnShare.setImage(tintedShare, for: .normal)
        btnShare.tintColor = Theme.default.primary
    }
    
    func barcodePush() {
        
        self.lblBarcode.text = "\(barcode)"
    }
    
    func pickCode() {
        
        UIPasteboard.general.string = "\(barcode)"
    }
    
    @objc func copyCode(_ sender: Any) {
        
        pickCode()
        
        let title = "Código Copiado"
        let message = "Seu código de barras foi copiado pra área de transferência. Agora é só colar na leitora"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: {
            action in
            self.dismissPage(self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func shareCode(_ sender: Any) {
        
        let codeToShare = [barcode]
        let activityViewController = UIActivityViewController(activityItems: codeToShare, applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.copyToPasteboard ]
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
}

extension BillCodeViewController: SetupUI {
    
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
