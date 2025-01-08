//
//  DocTakePictureViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 31/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class DocTakePictureViewController: UIBaseViewController {
    
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbStatusDesc: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var lbRGTile: UILabel!
    @IBOutlet weak var lbCPFTile: UILabel!
    @IBOutlet weak var viewSend1: UICardView!
    
//    @IBOutlet weak var imgStatus: UIImageView!
//    @IBOutlet weak var lbStatus: UILabel!
//    @IBOutlet weak var lbStatusDesc: UILabel!
//    @IBOutlet weak var btnStatus: UIButton!
    
    @IBOutlet weak var viewRGFrente: ViewPicturePreview!
    @IBOutlet weak var viewRGVerso: ViewPicturePreview!
    @IBOutlet weak var viewCPFFrente: ViewPicturePreview!
    
    @IBOutlet weak var viewContinue: ViewContinue!
    @IBOutlet weak var cardCPF: UICardView!

    // MARK: Variables
    
    lazy var mDocumentsRN = DocumentsRN(delegate: self)
    var mDocType = 0
    var cardImage: UIImage?
    var cardNumber: String?
    var cardName: String?
    var videoSend: AVCaptureSession?
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupViews()
    }
    
    override func setupViewWillAppear() {
    }
}

extension DocTakePictureViewController {
    
    @IBAction func back(sender: Any) {
        if self.viewStatus.isHidden {
            self.popPage()
            self.view.endEditing(true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
//        self.navigationController?.dismiss(animated: true, completion: nil)
//        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onClickFailed() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onClickSuccess() {
        self.performSegue(withIdentifier: Constants.Segues.READ_CREDIT_CARD, sender: nil)
    }
    
    @objc func onClickContinue() {
        self.sendDocs()
    }
}

extension DocTakePictureViewController {
    
    func setupUI() {
        Theme.default.textAsListTitle(self.lbRGTile)
        Theme.default.textAsListTitle(self.lbCPFTile)
        Theme.default.backgroundCard(self)
        
        self.viewStatus.isHidden = true
        
        viewRGVerso.lbPlaceholder.text = "VERSO"
        viewRGFrente.lbPlaceholder.text = "FRENTE"
        viewCPFFrente.lbPlaceholder.text = "FRENTE"
    }
    
    func setupViews() {
        viewRGVerso.viewController = self
        viewRGFrente.viewController = self
        viewCPFFrente.viewController = self
        
        viewRGVerso.delegate = self
        viewRGFrente.delegate = self
        viewCPFFrente.delegate = self
        
        self.viewContinue.btnBack.addTarget(self, action: #selector(back(sender:)), for: .touchUpInside)
        self.viewContinue.btnContinue.addTarget(self, action: #selector(onClickContinue), for: .touchUpInside)
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "app_name".localized)
        self.setTitle()
    }
    
    func setTitle() {
        self.viewContinue.showOnlyBackButton()
        self.lbCPFTile.isHidden = true
        self.cardCPF.isHidden = true
        
        switch (self.mDocType) {
        case ActionFinder.Documents.Types.RNE:
            self.lbRGTile.text = ActionFinder.Documents.Names.RNE
            break
            
        case ActionFinder.Documents.Types.CNH:
            self.lbRGTile.text = ActionFinder.Documents.Names.CNH
            self.viewRGVerso.isHidden = true
            break
            
        case ActionFinder.Documents.Types.CPF:
            self.lbRGTile.text = ActionFinder.Documents.Names.RG
            self.lbCPFTile.isHidden = false
            self.cardCPF.isHidden = false
            break
            
        case ActionFinder.Documents.Types.RG:
            self.lbRGTile.text = ActionFinder.Documents.Names.RG
            break
            
        default:
            self.lbRGTile.text = ActionFinder.Documents.Names.RG
        }
    }
    
    func verifyPictures() {
        self.viewContinue.showOnlyBackButton()
        
        if !self.viewRGFrente.isHidden {
            if !self.viewRGFrente.hasImage {
                return
            }
        }
        
        if !self.viewRGVerso.isHidden {
            if !self.viewRGVerso.hasImage {
                return
            }
        }
        
        if !self.cardCPF.isHidden {
            if !self.viewCPFFrente.hasImage {
                return
            }
        }
        
        self.viewContinue.showBackAndContinueButtons()
    }
    
    func sendDocs() {
        // Mostra loading
        Util.showLoading(self)
        
        switch (self.mDocType) {
        case ActionFinder.Documents.Types.CNH:
            self.mDocumentsRN.sendDocument(imageType: ActionFinder.Documents.Types.CNH, images: self.viewRGFrente.imgPicture.image!)
            break
            
        case ActionFinder.Documents.Types.RNE:
            self.mDocumentsRN.sendDocument(imageType: ActionFinder.Documents.Types.RNE, images: self.viewRGFrente.imgPicture.image!, self.viewRGVerso.imgPicture.image!)
            break
            
        case ActionFinder.Documents.Types.RG:
            self.mDocumentsRN.sendDocument(imageType: ActionFinder.Documents.Types.RG, images: self.viewRGFrente.imgPicture.image!, self.viewRGVerso.imgPicture.image!)
            break
            
        case ActionFinder.Documents.Types.CPF:
            let types = [ActionFinder.Documents.Types.RG, ActionFinder.Documents.Types.RG, ActionFinder.Documents.Types.CPF]
            let images = [self.viewRGFrente.imgPicture.image!, self.viewRGVerso.imgPicture.image!, self.viewCPFFrente.imgPicture.image!]
            
            self.mDocumentsRN.sendRGAndCPF(imageType: types, images: images)
            break
            
        default:
            self.lbRGTile.text = ActionFinder.Documents.Names.RG
        }
    }
}

extension DocTakePictureViewController: BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            if fromClass == ViewPicturePreview.self && param == Param.Contact.PHOTO_ADDED {
                self.verifyPictures()
            }
            
            if fromClass == DocumentsRN.self {
                if param == Param.Contact.DOC_SENT {

                    self.dismiss(animated: true, completion: nil)
                    self.updateStatus(result: result)
                }
            }
        }
    }
}

extension DocTakePictureViewController {
    
//    func updateStatus(result: Bool) {
//        self.lbRGTile.isHidden = true
//        self.lbCPFTile.isHidden = true
//        self.viewSend1.isHidden = true
//        self.cardCPF.isHidden = true
//        self.viewContinue.isHidden = true
//
//    }
    
    func updateStatus(result: Bool) {
        self.viewStatus.isHidden = false
        self.viewSend1.isHidden = true
        self.viewContinue.isHidden = true
        self.lbCPFTile.isHidden = true
        self.lbRGTile.isHidden = true
        self.cardCPF.isHidden = true
        
        self.imgStatus.image = UIImage(named: result ? "ic_green_done" : "ic_red_error")
        self.lbStatus.text = result ? "docs_sent_success".localized : "docs_sent_failed".localized
        self.lbStatusDesc.text = result ? "docs_sent_success_desc".localized : "docs_sent_failed_desc".localized
        self.btnStatus.setTitle(result ? "docs_send_card".localized : "docs_send_try_again".localized)
        
        self.btnStatus.removeTarget(self, action: nil, for: .allEvents)
        
        if result {
            self.btnStatus.addTarget(self, action: #selector(onClickSuccess), for: .touchUpInside)
        } else {
            self.btnStatus.addTarget(self, action: #selector(onClickFailed), for: .touchUpInside)
        }
    }
}

extension DocTakePictureViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "INSTRUCT_VIDEO" {
            if let controller = segue.destination as? SuccessDocumentsViewController {
                controller.mDoctype = self.mDocType
                
                controller.viewRGFrente = self.viewRGFrente
                controller.viewRGVerso = self.viewRGFrente
                controller.viewCPFFrente = self.viewCPFFrente
                
                //controller.captureSession = self.videoSend!
            }
        }
    }
}
