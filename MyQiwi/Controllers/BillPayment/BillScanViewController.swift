//
//  BillPaymentViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit
import AVFoundation

class BillScanViewController: UIBaseViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var btnBarCode: UIButton!
    @IBOutlet weak var lbPositionBar: UILabel!
    @IBOutlet weak var viewLineSeparator: UIView!
    @IBOutlet var views: [UIView]!
    
    // MARK: Variables
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var supportedCodeTypes: [AVMetadataObject.ObjectType] = [.interleaved2of5]
    var barcode = ""
    var mTriesCount = 0
    
    /***** CONSTANTS *****/
    let TRIES_LIMIT = 5

    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupViews()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
        //AppDelegate.AppUtility.
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
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Prepare For Segue

extension BillScanViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.BILL_INSERT_CODE_BAR {
            if let vc = segue.destination as? BillCodeBarViewController {
                vc.barcode = self.barcode
            }
        }
    }
}

// MARK: IBActions
extension BillScanViewController {
    
    @IBAction func clickBack(sender: UIButton) {
        self.viewWillDisappear(false)
        self.dismissPage(sender)
    }
    
    @IBAction func clickDigitBarcode(sender: UIButton) {
        QiwiOrder.isScan = false
        performSegue(withIdentifier: Constants.Segues.BILL_INSERT_CODE_BAR, sender: nil)
    }
}

// MARK: SetupUI
extension BillScanViewController: SetupUI {
    
    func setupUI() {

        self.view.backgroundColor = UIColor.black
        self.lbPositionBar.font = FontCustom.helveticaMedium.font(16)
        self.lbPositionBar.textColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiWhite)
        Theme.default.orageButton(self.btnBarCode)
    }
    
    func setupTexts() {
        
        self.lbPositionBar.text = "scan_positionate".localized
        self.btnBarCode.setTitle("scan_tape_code".localized, for: .normal)
        Util.setTextBarIn(self, title: "payments_toolbar_title".localized)
    }
    
    func setupViews() {
        self.viewLineSeparator.backgroundColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiBlue)
    }
}

// MARK: Permission / Load Camera
extension BillScanViewController {
    
    func requestCamera() {
        
        AVCaptureDevice.requestAccess(for: .video) { authorizationStatus in
            
            // Sucesso abrir camera
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
            
            // Obter uma instância da classe AVCaptureDeviceInput usando o objeto anterior do dispositivo.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // dispositivo de entrada na sessão de captura.
            captureSession.addInput(input)
            
            // Inicializar um objeto AVCaptureMetadataOutput
            let captureMetadataOutput = AVCaptureMetadataOutput()
            
            // dispositivo de saída para a sessão de captura.
            captureSession.addOutput(captureMetadataOutput)
            
            // Delegate e Thread principal
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Informar quais tipos são suportados: "Interleaved2of5" Boleto
            captureMetadataOutput.metadataObjectTypes = self.supportedCodeTypes
            
        } catch {
            self.dismiss(animated: false, completion: {
                Util.showAlertDefaultOK(self, message: "alert_error_open_camera".localized)
            })
            return
        }
        
        // Inicializa a camada de visualização do vídeo e adiciona como uma subcamada à camada da vista viewPreview.
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.videoPreviewLayer?.videoGravity = .resizeAspectFill
        
        guard let previewLayer = self.videoPreviewLayer else {
            return
        }
        
        previewLayer.connection?.videoOrientation = .landscapeRight
        previewLayer.frame = self.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(previewLayer)
        
        // Todas as views acima da Preview Layer
        self.views.forEach { subView in
            self.view.bringSubview(toFront: subView)
        }
        
        self.view.bringSubview(toFront: self.btnBarCode)
        self.view.bringSubview(toFront: self.viewLineSeparator)
        self.view.bringSubview(toFront: self.lbPositionBar)
        
        // Animação
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        animation.speed = 5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        self.viewLineSeparator.layer.add(animation, forKey: "opacity")
        
        // Inicia video capture.
        self.captureSession.startRunning()
    }
}

// MARK: Delegate AVCapture

extension BillScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // Capturar o primeiro objeto lido.
        guard let metadataObj = metadataObjects.first else {
            return
        }
        
        guard let metadataReadableCodeObject = metadataObj as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        guard let metaDataReadableCodeString = metadataReadableCodeObject.stringValue else {
            return
        }
        
        // Refatorar para unica regra
        // Total de digitos do boleto
//        guard metaDataReadableCodeString.count == 44 else { return }
//
        let result = QiwiOrder.factoryFebraban?.validarCodigoBarras(codigoBarras: metaDataReadableCodeString)
        
        //Se foi validade com sucesso e ainda nao atingiu o limite de tentativas
        if !result! || mTriesCount < TRIES_LIMIT {
            mTriesCount = mTriesCount + 1
            return
        }
        //Ou se nao foi validado mas ja passou o numero de tentativas
        else if mTriesCount >= TRIES_LIMIT {
            QiwiOrder.isScan = false
            self.performSegue(withIdentifier: Constants.Segues.BILL_INSERT_CODE_BAR, sender: nil)
        }
        
        self.captureSession.stopRunning()
        self.barcode = QiwiOrder.factoryFebraban?.getBoleto().getLinhaDigitavel() ?? ""
        
        //Caso seja scaneado com sucesso, muda o status
        QiwiOrder.isScan = true
        self.performSegue(withIdentifier: Constants.Segues.BILL_INSERT_CODE_BAR, sender: nil)
    }
}
