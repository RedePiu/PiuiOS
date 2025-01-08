//
//  VideoAgreementViewController.swift
//  MyQiwi
//
//  Created by Thyago on 28/05/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import AVKit
import UIKit
import AVFoundation
import MobileCoreServices
import CoreMedia
import Photos

class VideoAgreementViewController: UIBaseViewController {
    
    @IBOutlet weak var lbTextRead: UILabel!
    @IBOutlet weak var txtContainer: UIView!
    @IBOutlet weak var viewOpacity: UIView!
    @IBOutlet weak var btnSwitch: UIButton!
    @IBOutlet weak var containerBtnRecord: UIView!
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var containerVideoLength: UIView!
    @IBOutlet weak fileprivate var videoLength: UILabel!
    
    var videoDelegate: VideoAgreementDlegate?
    var finalCard: String = ""
    var videoPath: String = ""
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var videoFileOutput:AVCaptureMovieFileOutput?
    var audioFileOutput: AVCaptureAudioDataOutput?
    
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var audioCapture: AVCaptureDevice?
    
    var isRecording = false
    
    let maxDuration: CMTime = CMTimeMakeWithSeconds(10, 1)
    var outputPath = NSTemporaryDirectory() + "output.mov"
    var outputPathURL: URL?
    
    var timeMin = 0
    var timeSec = 0
    
    let preset = AVAssetExportPresetMediumQuality
    let outputFileType = AVFileType.mp4
    
    let audioSettings = [
        AVFormatIDKey : kAudioFormatAppleIMA4,
        AVNumberOfChannelsKey : 1,
        AVSampleRateKey : 16000.0
        ] as [String : Any]
    
    let videoSettings = [
        AVVideoCodecKey : AVVideoCodecH264,
        AVVideoWidthKey : UIScreen.main.bounds.width,
        AVVideoHeightKey : UIScreen.main.bounds.width
        ] as [String : Any]
    
    
    private var supportedCodeTypes: [AVMetadataObject.ObjectType] = [.code128]
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        outputPathURL = paths[0].appendingPathComponent("output.mov")
        try? FileManager.default.removeItem(at: outputPathURL!)
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        
        self.btnSwitch.addTarget(self, action: #selector(toggleCamera), for: .touchUpInside)
        self.btnRecord.addTarget(self, action: #selector(capture), for: .touchUpInside)
        
        viewOpacity.layer.cornerRadius = 5
        
        btnSwitch.layer.cornerRadius = 35
        
        containerBtnRecord.layer.borderColor = UIColor.white.cgColor
        containerBtnRecord.layer.backgroundColor = UIColor.clear.cgColor
        containerBtnRecord.layer.borderWidth = 4
        containerBtnRecord.layer.cornerRadius = 45
        
        btnRecord.layer.cornerRadius = 39
        
        containerVideoLength.layer.cornerRadius = 5
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        
        self.videoLength.text = String(format: "%02d" + "s", timeSec)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        resetTimerToZero()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onBackButton(_ sender: Any?) {
        self.videoDelegate?.stepVideoBackward()
        
        self.view.endEditing(true)
        self.popPage()
        //self.dismiss(animated: false, completion: nil)
    }
    
    
}

extension VideoAgreementViewController {
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.medium
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let device = deviceDiscoverySession.devices
        
        for device in device {
            
            if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            } else if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            }
            
            if device.hasMediaType(AVMediaType.audio) {
                
                audioCapture = device
            }
        }
        currentCamera = frontCamera
    }
    
    func setupInputOutput() {
        
        guard let audioDevice = AVCaptureDevice.default(for: .audio) else { return }
        
        do {
            
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            
            self.captureSession.addInput(captureDeviceInput)
            self.captureSession.addInput(audioInput)
            
            videoFileOutput = AVCaptureMovieFileOutput()
            videoFileOutput?.maxRecordedDuration = maxDuration

            let connection = videoFileOutput?.connection(with: .video)
            if #available(iOS 11.0, *) {
                if (videoFileOutput?.availableVideoCodecTypes.contains(.h264))! {
                    // Use the H.264 codec to encode the video.
                    videoFileOutput?.setOutputSettings([AVVideoCodecKey: AVVideoCodecType.h264], for: connection!)
                }
            } else {
                // Fallback on earlier versions
            }
            
            captureSession.addOutput(videoFileOutput!)
            

            //try self.captureSession.addInput(AVCaptureDeviceInput(device: audioDevice   ))
            //self.captureSession.removeInput(captureDeviceInput)
            
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        videoPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(videoPreviewLayer!, at: 0)
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
}

extension VideoAgreementViewController: AVCaptureFileOutputRecordingDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc private func toggleCamera() {
        
        captureSession.beginConfiguration()
        
        
        let newDevice = (currentCamera?.position == .front) ? backCamera : frontCamera
        
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        
        let cameraInput: AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice!)
        } catch let error {
            print(error)
            return
        }
        
        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        }
        
        currentCamera = newDevice
        captureSession.commitConfiguration()
    }
    
    fileprivate func startTimer() {
        
        let timeNow = String(format: "%02d" + "s", timeSec)
        self.videoLength.text = timeNow
        
        let endTime = 10.0
        
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            [weak self] _ in
            
            self?.timerTick()
            
            if self!.timeSec >= Int(endTime) {
                
                self!.stopTimer()
                self!.videoFileOutput?.stopRecording()
                self!.btnRecord.layer.removeAllAnimations()
                //self!.resetTimerToZero()
            }
        }
    }
    
    fileprivate func timerTick() {
        
        timeSec += 1
        
        if timeSec == 60 {
            
            timeSec = 0
            timeMin += 1
        }
        
        let timeNow = String(format: "%02d" + "s", timeSec)
        
        self.videoLength.text = timeNow
        
    }
    
    @objc fileprivate func resetTimerToZero() {
        timeSec = 0
        timeMin = 0
        stopTimer()
    }
    
    @objc fileprivate func resetTimerAndLabel() {
        
        resetTimerToZero()
        self.videoLength.text = String(format: "%02d" + "s", timeSec)
    }
    
    @objc fileprivate func stopTimer() {
            
        timer?.invalidate()
    }
    
    @objc fileprivate func capture() {

        startTimer()
        
        if !isRecording {
            
            isRecording = true
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: { () -> Void in
                self.btnRecord.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            }, completion: nil)
            
            let outputFileURL = URL(fileURLWithPath: outputPath)
            //videoFileOutput?.startRecording(to: outputFileURL, recordingDelegate: self)
            videoFileOutput?.startRecording(to: outputPathURL!, recordingDelegate: self)
        } else {
            
            isRecording = false
            
            UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: { () -> Void in
                self.btnRecord.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
            
            stopTimer()
            btnRecord.layer.removeAllAnimations()
            videoFileOutput?.stopRecording()
            resetTimerToZero()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error != nil {
            print(error as Any)
            return
        }
        
        self.outputPath = outputFileURL.path
        UISaveVideoAtPathToSavedPhotosAlbum(outputPathURL!.path, nil, nil, nil)
        performSegue(withIdentifier: "SHOW_PREVIEW", sender: outputFileURL)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SHOW_PREVIEW" {
            
            let playerVC = segue.destination as! PreviewViewController
            let videoFileURL = sender as! URL

            playerVC.playerView = AVPlayer(url: videoFileURL)
            playerVC.playerViewController.player = playerVC.playerView
            playerVC.view.frame = playerVC.videoView.bounds
            self.addChildViewController(playerVC.playerViewController)
            playerVC.videoView.addSubview(playerVC.playerViewController.view)
            playerVC.playerViewController.didMove(toParentViewController: self)
            
            playerVC.videoPath = videoFileURL
            playerVC.videoDelegate = self.videoDelegate
            
        } else {
            
            return
        }
    }
}

extension VideoAgreementViewController: SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.textAsDefault(self.lbTextRead)
        self.lbTextRead.textColor = .white
    }
    func setupTexts() {
        Util.setTextBarIn(self, title: "credit_card_list_toolbar_title".localized)

        
        let textToRead = "credit_card_video_text_to_read".localized
            .replacingOccurrences(of: "{name}", with: UserRN.getLoggedUser().getFirstName())
            .replacingOccurrences(of: "{final}", with: self.finalCard)
        self.lbTextRead.text = textToRead
    }
}
