//
//  CreditCardPreview.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 22/05/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class CreditCardPreview: UIBaseViewController {
    

    @IBOutlet weak var imgPreview: UIImageView!
    @IBOutlet weak var lbPreview: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    var creditCardImage: UIImage?
    var creditCardDelegate: CreditCardPictureDlegate?
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupViews()
    }
    
    override func setupViewWillAppear() {
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        self.popPage()
    }
    
    @IBAction func onClickContinue(_ sender: UIButton) {
        self.creditCardDelegate!.passImage(image: self.creditCardImage!)
        
        //self.view.endEditing(true)
        self.performSegue(withIdentifier: Constants.Segues.BACK_TO_CREDIT, sender: nil)
        
        //self.dismiss(animated: true, completion: nil)
    }
}

extension CreditCardPreview {
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        //Abrir tela para capturar cartão
    }
    
    @IBAction func onBackButton(_ sender: Any?) {
        
        self.view.endEditing(true)
        self.popPage()
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension CreditCardPreview {
    
    func setupUI() {
//        Theme.default.backgroundCard(self)

        Theme.default.orageButton(self.btnBack)
        Theme.default.greenButton(self.btnContinue)
    }
    
    func setupViews() {
        self.imgPreview.image = self.creditCardImage
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        self.imgPreview.isUserInteractionEnabled = true
//        self.imgPreview.addGestureRecognizer(tapGestureRecognizer)
        
//        self.viewContinue.btnBack.addTarget(self, action: #selector(onClickBack(sender:)), for: .touchUpInside)
//        self.viewContinue.btnContinue.addTarget(self, action: #selector(onClickContinue(sender:)), for: .touchUpInside)
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "Confirmação")
        
        self.lbPreview.text = "credit_card_preview_label".localized
    }
}
