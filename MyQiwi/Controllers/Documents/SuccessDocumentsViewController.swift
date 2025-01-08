//
//  SuccessDocumentsViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 24/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit
import AWSMobileClient
import AVFoundation

class SuccessDocumentsViewController: UIBaseViewController, AVCaptureVideoDataOutputSampleBufferDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbStatusDesc: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var viewInstructions: UIStackView!
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var viewPreview: UIView!
    @IBOutlet weak var btnEnviar: UIButton!
    @IBOutlet weak var btnNovaCaptura: UIButton!
    @IBOutlet weak var lblWatch: UILabel!
    @IBOutlet weak var imgVideoSelected: UIImageView!
    @IBOutlet weak var lbIntro: UILabel!
    
    
    var returnedPic: Bool?
    
    var captureSession = AVCaptureSession()
    var videoCaptured = AVCaptureVideoDataOutput()
    var videoPath: String = ""
    lazy var mDocumentsRN = DocumentsRN(delegate: self)
    var mDoctype: Int!
    var viewRGFrente: ViewPicturePreview!
    var viewRGVerso: ViewPicturePreview!
    var viewCPFFrente: ViewPicturePreview!
    var cardImage: UIImage?
    var cardNumber: String?
    var cardName: String?

    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        
        self.updateRecordedStatus(result: false)
        
        self.viewStatus.isHidden = true
        self.viewPreview.isHidden = true
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        if !self.viewInstructions.isHidden {
            self.popPage()
            return
        }
        
        if !self.viewPreview.isHidden {
            self.viewPreview.isHidden = true
            self.viewStatus.isHidden = true
            self.viewInstructions.isHidden = false
            Theme.default.backgroundBlue(self)
            
            return
        }
        
        if !self.viewStatus.isHidden {
            self.dismiss(animated: true, completion: nil)
            return
        }
    }
    
    @IBAction func openCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
            self.returnedPic = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.viewInstructions.isHidden = true
            self.viewPreview.isHidden = false
            Theme.default.backgroundCard(self)
        }
    }
    
    var availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
    
    @objc func imagePickerController(){
        do {
            if let captureDevice = availableDevices.devices.first {
                let captureDeviceInput = try! AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(captureDeviceInput)
            }
        }   //catch {
            //print(error.localizedDescription)
            //}
        
        let captureOutput = AVCaptureVideoDataOutput()
        captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(captureOutput)
        captureSession.startRunning()
        
        print("video gravado com sucesso, dois!")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        self.updateRecordedStatus(result: false)
    }
    
    @objc func imageError(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        if error != nil {
            let alert = UIAlertController(title: "Arquivo selecionado", message: "Falha ao enviar arquivo", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        self.updateRecordedStatus(result: false)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        guard let mediaType = info[UIImagePickerControllerMediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerControllerMediaURL] as? URL,
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
            else { return }
        
        if picker.sourceType == UIImagePickerControllerSourceType.photoLibrary {
            //let tempImageURL = info[UIImagePickerControllerReferenceURL] as! NSURL antigo
            let tempImageURL = info[UIImagePickerControllerMediaURL] as! NSURL
            self.videoPath = tempImageURL.absoluteString!
        } else {
            let tempImageURL = info[UIImagePickerControllerMediaURL] as! NSURL
            self.videoPath = tempImageURL.absoluteString!
        }
        
        self.updateRecordedStatus(result: !self.videoPath.isEmpty)
        //UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
    }
}

extension SuccessDocumentsViewController {
    
    @IBAction func onClickContinue(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickSendCard(_ sender: Any) {
//        if let cardIoController = CardIOPaymentViewController(paymentDelegate: self) {
//            cardIoController.detectionMode = .cardImageAndNumber
//            cardIoController.collectExpiry = false
//            cardIoController.collectCVV = false
//            cardIoController.disableManualEntryButtons = false
//            cardIoController.hideCardIOLogo = true
//            cardIoController.modalPresentationStyle = .overFullScreen
//            present(cardIoController, animated: true)
//        }
    }
}

extension SuccessDocumentsViewController: BaseDelegate{
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            
            if fromClass == DocumentsRN.self {
                if param == Param.Contact.DOC_SENT {
                    
                    if !result {
                        self.dismiss(animated: true, completion: nil)
                        return
                    }
                    
                    self.sendVideo()
                    return
                }
                
                if param == Param.Contact.DOCS_SEND_VIDEO_RESPONSE {

                    self.dismiss(animated: true, completion: nil)
                    self.updateStatus(result: result)
                }
            }
        }
    }
}

// MARK: Write delegate methods to receive the card info or a cancellation
//extension SuccessDocumentsViewController: CardIOPaymentViewControllerDelegate {
//    
//    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
//        paymentViewController.dismiss(animated: true)
//    }
//    
//    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
//        
//        print(cardInfo.cardImage)
//        print(cardInfo.cardholderName)
//        print(cardInfo.cardNumber)
//        
//        // Salvar informações
//        self.cardImage = cardInfo.cardImage
//        self.cardNumber = cardInfo.cardNumber
//        self.cardName = cardInfo.cardholderName
//        
//        // Fechar Controller do Card.IO
//        paymentViewController.dismiss(animated: true, completion: {
//            DispatchQueue.main.async {
//                if self.cardImage == nil {
//                    //Se tiver nulo, abre a captura de cartão manual
//                    self.performSegue(withIdentifier: Constants.Segues.CREDIT_CARD_PICTURE, sender: nil)
//                } else {
//                    //Se não, continua parar inserir os dados
//                    self.performSegue(withIdentifier: Constants.Segues.READ_CREDIT_CARD, sender: nil)
//                }
//            }
//        })
//    }
//}

extension SuccessDocumentsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.Segues.READ_CREDIT_CARD {
            
            // Passar informações
            if let vc = segue.destination as? ReadCreditCardViewController {
                
                vc.creditCard.cardNumber = self.cardNumber!
                vc.creditCard.image = self.cardImage ?? nil
                
                print(self.cardNumber as Any)
            }
        }
        
        if segue.identifier == Constants.Segues.CREDIT_CARD_PICTURE {
            if let vc = segue.destination as? CreditCardPictureViewController {
                
                vc.cardCreditNumber = self.cardNumber!
                
                print(self.cardNumber as Any)
            }
        }
    }
}

extension SuccessDocumentsViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard let data = NSData(contentsOf: outputFileURL as URL) else {
            return
        }
        
        print("Arquivo antes da compressão: \(Double(data.length / 1048576)) mb")
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".m4v")
        compressVideo(inputURL: outputFileURL as URL, outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }
            
            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }
                
                print("Arquivo depois da compressão: \(Double(compressedData.length / 1048576)) mb")
            case .failed:
                break
            case .cancelled:
                break
            }
        }
    }
    
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset640x480 ) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}

extension SuccessDocumentsViewController {
    
    func sendVideo() {
        //self.mDocumentsRN.sendDocumentVideo(path: self.videoPath)
    }
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let title = (error == nil) ? "Sucesso" : "Erro"
        let message = (error == nil) ? "Video salvo na galeria" : "Falha ao salvar video"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func sendDocs(sender: UIButton) {
        // Mostra loading
        Util.showLoading(self) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                
                switch (self.mDoctype) {
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
                    return
                    //self.lbRGTile.text = ActionFinder.Documents.Names.RG
                }
            })
        }
    }
    
    func updateStatus(result: Bool) {
        self.viewPreview.isHidden = true
        self.viewStatus.isHidden = false
        
        self.imgStatus.image = UIImage(named: result ? "ic_green_done" : "ic_red_error")
        self.lbStatus.text = result ? "docs_sent_success".localized : "docs_sent_failed".localized
        self.lbStatusDesc.text = result ? "docs_sent_success_desc".localized : "docs_sent_failed_desc".localized
        self.btnStatus.setTitle(result ? "docs_send_card".localized : "docs_send_try_again".localized)
        
        self.btnStatus.removeTarget(self, action: nil, for: .allEvents)
        
        if result {
            self.btnStatus.addTarget(self, action: #selector(onClickSendCard(_:)), for: .touchUpInside)
        } else {
            self.btnStatus.addTarget(self, action: #selector(onClickContinue(_:)), for: .touchUpInside)
        }
    }
    
    func updateRecordedStatus(result: Bool) {
        self.viewPreview.isHidden = false
        self.viewStatus.isHidden = true
        
        self.imgVideoSelected.image = UIImage(named: result ? "ic_green_done" : "ic_red_error")
        self.lblWatch.text = result ? "docs_video_success".localized : "docs_video_fail".localized
        
        self.btnEnviar.removeTarget(self, action: nil, for: .allEvents)
        if result {
            Theme.default.greenButton(self.btnEnviar)
            self.btnEnviar.setTitle("docs_video_send_button".localized, for: .normal)
            self.btnEnviar.addTarget(self, action: #selector(sendDocs(sender:)), for: .touchUpInside)
        } else {
            Theme.default.redButton(self.btnEnviar)
            self.btnEnviar.setTitle("docs_video_cancel_button".localized, for: .normal)
            self.btnEnviar.addTarget(self, action: #selector(onClickContinue(_:)), for: .touchUpInside)
        }
    }
}

extension SuccessDocumentsViewController: SetupUI {
    
    func setupUI() {
        Theme.default.textAsListTitle(self.lbStatus)
        Theme.default.textAsListTitle(self.lblWatch)
//        Theme.default.textAsDefault(self.lbStatusDesc)
        
        Theme.default.greenButton(self.btnStatus)
        Theme.default.greenButton(self.btnRecord)
        Theme.default.greenButton(self.btnEnviar)
        Theme.default.orageButton(self.btnNovaCaptura)
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "app_name".localized)
        
        self.btnStatus.setTitle("docs_send_card".localized, for: .normal)
        
        self.lbIntro.text = "docs_video_intro".localized.replacingOccurrences(of: "{user_name}", with: UserRN.getLoggedUser().getFirstName())
    }
}
