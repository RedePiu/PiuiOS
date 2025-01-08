//
//  ReadQrCode.swift
//  MyQiwi
//
//  Created by Thyago on 06/11/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit
import Foundation

class ReadQrCodeViewController: UIBaseViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var maskLayer: UIView!
    @IBOutlet weak var viewLineSeparator: UIView!
    @IBOutlet var views: [UIView]!
    
    var token = ""
    
    var layer: CALayer {
        return self.maskLayer.layer
    }
    
    var layerBG: CALayer {
        return background.layer
    }
    
    var captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    private var supportedCodeTypes: [AVMetadataObject.ObjectType] = [.qr]
    
    override func viewDidLoad() {
        self.setupUI()
        self.setupTexts()
        
        self.background.backgroundColor = UIColor.black
        self.background.layer.opacity = 0.5
        
        let rectangularHole = self.maskLayer.frame.integral
        setMask(with: rectangularHole, in: background!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.performSegue(withIdentifier: Constants.Segues.QTOKEN_STATUS, sender: nil)
        self.requestCamera()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
            self.token = stringValue
        }

        self.performSegue(withIdentifier: Constants.Segues.QTOKEN_STATUS, sender: nil)
        
        captureSession.stopRunning()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9){
            self.captureSession.startRunning()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension ReadQrCodeViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.QTOKEN_STATUS {
            if let vc = segue.destination as? CodeValidationViewController {
                vc.token = self.token
            }
        }
    }
}

extension ReadQrCodeViewController {
    
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
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = self.supportedCodeTypes
            
        } catch {
            self.dismiss(animated: false, completion: {
                Util.showAlertDefaultOK(self, message: "alert_error_open_camera".localized)
            })
            return
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer?.videoGravity = .resizeAspectFill
        
        guard let previewLayer = self.previewLayer else {
            return
        }
        
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.frame = self.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(previewLayer)
        
        self.views.forEach { subView in
            self.view.bringSubview(toFront: subView)
        }
        
        self.view.bringSubview(toFront: self.viewLineSeparator)
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        animation.speed = 5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        self.captureSession.startRunning()
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

//    func readingCode() {
//        captureSession = AVCaptureSession()
//
//        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
//        let videoInput: AVCaptureDeviceInput
//
//        do {
//            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
//        } catch {
//            return
//        }
//
//        if (captureSession.canAddInput(videoInput)) {
//            captureSession.addInput(videoInput)
//
//        } else {
//            failed()
//            return
//        }
//
//        let metadataOutput = AVCaptureMetadataOutput()
//        if (captureSession.canAddOutput(metadataOutput)) {
//            captureSession.addOutput(metadataOutput)
//            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            metadataOutput.metadataObjectTypes = [.qr]
//        } else {
//            failed()
//            return
//        }
//
//        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        previewLayer.frame = self.view.layer.bounds
//        previewLayer.videoGravity = .resizeAspectFill
//
//        self.view.layer.addSublayer(previewLayer)
//
//        captureSession.startRunning()
//    }
//
//    func failed() {
//        let ac = UIAlertController(title: "Ops! Ocorreu algo!", message: "Desculpe não conseguimos escanear seu QRCode.", preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
//        captureSession = nil
//    }
//
    func found(code: String) {
        print(code)
    }
}

extension ReadQrCodeViewController : SetupUI {
    func setupUI() {
        
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "token_toolbar_title".localized)
    }
}
