//
//  CrediCardPictureViewController.swift
//  MyQiwi
//
//  Created by Thyago on 20/05/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit
import Foundation

class CreditCardPictureViewController: UIBaseViewController {
    
    @IBOutlet weak var btnBarCode: UIButton!
    @IBOutlet weak var lbPositionBar: UILabel!
    @IBOutlet var views: [UIView]!
    @IBOutlet weak var maskLayer: UIView!
    @IBOutlet weak var viewBG: UIView!
    
    var layer: CALayer {
        return self.maskLayer.layer
    }
    
    var layerBG: CALayer {
        return viewBG.layer
    }
    
    var settings = AVCapturePhotoSettings()
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    private var supportedCodeTypes: [AVMetadataObject.ObjectType] = [.interleaved2of5]
    var imagePicker: UIImagePickerController!
    var imageView = UIImageView()
    var capturedImage: UIImage = UIImage()
    var cardCreditNumber: String = ""
    var focusMode: AVCaptureDevice.FocusMode!
    var creditCardDelegate: CreditCardPictureDlegate?
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        self.setupLayer()
        self.setupCaptureSession()
        self.btnBarCode.layer.cornerRadius = 40
        
        capturePhotoOutput?.capturePhoto(with:settings, delegate: self)
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput?.isHighResolutionCaptureEnabled = true
        
        let rectangularHole = self.maskLayer.frame.integral
        setMask(with: rectangularHole, in: viewBG!)
    }
    
    func setMask(with hole: CGRect, in view: UIView){
        
        let mutablePath = CGMutablePath()
        mutablePath.addRect(view.bounds)
        mutablePath.addRect(hole)
        
        let mask = CAShapeLayer()
        mask.path = mutablePath
        mask.fillRule = kCAFillRuleEvenOdd
        view.layer.mask = mask
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.requestCamera()
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupLayer() {
        
        //self.maskLayer.layer.cornerRadius = 10
        layer.backgroundColor = UIColor.clear.cgColor
        layer.opacity = 0.8
        //layer.borderColor = UIColor.white.cgColor
        //layer.borderWidth = 4
        layer.masksToBounds = true
        
        layerBG.backgroundColor = UIColor.black.cgColor
        layerBG.opacity = 0.7
        layerBG.masksToBounds = true
        
        layerBG.mask?.cornerRadius = 10
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        
        let photoSettings = AVCapturePhotoSettings()
        
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @IBAction func onBackButton(_ sender: Any?) {
        self.creditCardDelegate?.stepPictureBackward()
        
        self.view.endEditing(true)
        self.popPage()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
    }
}

extension CreditCardPictureViewController {
    
    func requestCamera() {
        
        AVCaptureDevice.requestAccess(for: .video) { authorizationStatus in

            DispatchQueue.main.async {
                
                if !authorizationStatus {
                    Util.showAlertDefaultOK(self, message: "alert_permission_denied".localized)
                    return
                }
                
                self.loadCamera()
            }
        }
    }
    
    func loadCamera() {
        
        if self.captureSession.isRunning {
            return
        }
        
        let deviceDiscoverySession = AVCaptureDevice.default(for: .video)
        
        guard let captureDevice = deviceDiscoverySession else {
            let message = "alert_camera_not_available".localized
            Util.showAlertDefaultOK(self, message: message)
            return
        }
        
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            let photoOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(photoOutput)
            photoOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            photoOutput.metadataObjectTypes = self.supportedCodeTypes
            
        } catch {
            self.dismiss(animated: false, completion: {
                Util.showAlertDefaultOK(self, message: "alert_error_open_camera".localized)
            })
            return
        }
        
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.videoPreviewLayer?.videoGravity = .resizeAspectFill
        guard let previewLayer = self.videoPreviewLayer else {
            return
        }
        
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        self.view.layer.addSublayer(previewLayer)
        
        self.views.forEach { subView in
            self.view.bringSubview(toFront: subView)
        }
        
        self.view.bringSubview(toFront: self.btnBarCode)
        self.view.bringSubview(toFront: self.lbPositionBar)
        self.view.bringSubview(toFront: self.viewBG)
        self.view.bringSubview(toFront: self.maskLayer)
        
        // Animação
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        animation.speed = 5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        guard self.captureSession.canAddOutput(capturePhotoOutput) else { return }
        self.captureSession.sessionPreset = .photo
        self.captureSession.addOutput(capturePhotoOutput)
        
        // Inicia video capture.
        self.captureSession.startRunning()
    }
}

extension CreditCardPictureViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard let metadataObj = metadataObjects.first else { return }
        guard let metadataReadableCodeObject = metadataObj as? AVMetadataMachineReadableCodeObject else { return }
        guard let metaDataReadableCodeString = metadataReadableCodeObject.stringValue else { return }
        
        self.captureSession.stopRunning()
//
//        QiwiOrder.isScan = true
//        self.performSegue(withIdentifier: Constants.Segues.BILL_INSERT_CODE_BAR, sender: nil)
    }
}

extension CreditCardPictureViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.CREDIT_CARD_PREVIEW {
            if let vc = segue.destination as? CreditCardPreview {
                vc.creditCardImage = self.capturedImage
                vc.creditCardDelegate = self.creditCardDelegate
            }
        }
    }
}

extension CreditCardPictureViewController {
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
}

extension CreditCardPictureViewController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else { return }
        
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
        if let image = capturedImage {
            // Save our captured image to photos album
            //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

            let heightInPoints = self.maskLayer.frame.size.height * 2
            let widthInPoints = self.maskLayer.frame.size.width * 2
            
            self.capturedImage = self.cropToBounds(image: image, width: Double(widthInPoints), height: Double(heightInPoints))
            self.performSegue(withIdentifier: Constants.Segues.CREDIT_CARD_PREVIEW, sender: nil)
        }
    }
}

extension CreditCardPictureViewController: SetupUI {
    func setupUI() {
        self.view.backgroundColor = UIColor.black
        self.lbPositionBar.font = FontCustom.helveticaMedium.font(16)
        self.lbPositionBar.textColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiWhite)
        Theme.default.orageButton(self.btnBarCode)
        self.btnBarCode.tintColor = .white
        self.btnBarCode.backgroundColor = Theme.default.orange
        Theme.default.backgroundCard(self)
        
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "credit_card_list_toolbar_title".localized)
        self.lbPositionBar.text = "credit_card_picture_label".localized
        //self.btnBarCode.setTitle("digitar número do cartão", for: .normal)
    }
}
