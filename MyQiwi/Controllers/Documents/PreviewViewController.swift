//
//  PreviewViewController.swift
//  MyQiwi
//
//  Created by Thyago on 04/06/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import AVFoundation
import AVKit
import UIKit

class PreviewViewController: UIBaseViewController {


    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var containerButtons: UIView!
    @IBOutlet weak var btnRecordAgain: UIButton!
    @IBOutlet weak var btnUseVideo: UIButton!
    @IBOutlet weak var btnCloseModal: UIButton!

    let playerViewController = AVPlayerViewController()
    var playerView: AVPlayer?
    var videoURL: URL?
    var videoDelegate: VideoAgreementDlegate?

    var videoPath: URL?
    lazy var mDocumentsRN = DocumentsRN(delegate: self)

    var url: URL?

    var passDataVC: VideoAgreementViewController = VideoAgreementViewController(nibName: nil, bundle: nil)

    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()

        videoView.frame = view.bounds

        containerButtons.layer.cornerRadius = 5
        containerButtons.bringSubview(toFront: containerButtons)
        containerButtons.backgroundColor = Theme.default.orange

        btnRecordAgain.addTarget(self, action: #selector(onBackButton), for: .touchUpInside)
        btnUseVideo.addTarget(self, action: #selector(useVideo), for: .touchDown)

        btnCloseModal.backgroundColor = .black
        self.btnCloseModal.clipsToBounds = true
        self.btnCloseModal.layer.roundCorners(radius: 20)
        if #available(iOS 11.0, *) {
            self.btnCloseModal.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }


        self.roundedButton()
    }

    func roundedButton(){
        let maskPath1 = UIBezierPath(
            roundedRect: btnCloseModal.bounds,
            byRoundingCorners: [.topLeft , .bottomLeft],
            cornerRadii: CGSize(width: 8, height: 8))

        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = btnCloseModal.bounds
        maskLayer1.path = maskPath1.cgPath
        btnCloseModal.layer.mask = maskLayer1
    }

    func goBackToOneButtonTapped() {

    }
}

extension PreviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @objc func onBackButton(_ sender: Any?) {
        self.videoDelegate?.stepVideoBackward()

        self.view.endEditing(true)
        self.popPage()

        self.dismiss(animated: true, completion: nil)
    }

    @objc func popOutPage() {
        //self.dismiss(animated: true)
        //self.popPage()




    }

    func dimissMainPage() {



        let mainPage = PreviewViewController()
        self.dismissPage(mainPage)
    }

    func dismissNextPage() {

        let nextPage = VideoAgreementViewController()

        self.view.endEditing(true)
        self.dismissPage(nextPage)
        self.dismiss(animated: true, completion: nil)
    }

    @objc func useVideo() {
        let title = !((self.videoPath?.absoluteString.isEmpty)!) ? "Tudo OK!" : "Ah, não... :("
        let message = !((self.videoPath?.absoluteString.isEmpty)!) ? "Vídeo salvo com sucesso!" : "Falha ao salvar arquivo"

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: {
            action in

            self.videoDelegate?.passVideo(videoPath: self.videoPath!)

            DispatchQueue.main.async {

                self.performSegue(withIdentifier: Constants.Segues.BACK_TO_CREDIT, sender: nil)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.view.endEditing(true)
                    self.dismissNextPage()
                    self.popPage()


                }
            }
        }))

        present(alert, animated: true, completion: nil)
    }

    @objc func video(error: Error?, contextInfo info: AnyObject) {

        let title = (error == nil) ? "Tudo OK!" : "Ah, não... :("
        let message = (error == nil) ? "Vídeo Enviado" : "Falha ao enviar arquivo"

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: {
            action in

            self.videoDelegate?.passVideo(videoPath: self.videoPath!)

            
            
            self.dimissMainPage()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                //self.popOutPage()
            }
        }))

        present(alert, animated: true, completion: nil)
    }
}

extension PreviewViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {

            if fromClass == DocumentsRN.self {
                if param == Param.Contact.DOC_SENT {

                    if !result {
                        self.dismiss(animated: true, completion: nil)
                        return
                    }

                    return
                }

                if param == Param.Contact.DOCS_SEND_VIDEO_RESPONSE {

                    //self.dismiss(animated: true, completion: nil)
                    //self.updateStatus(result: result)
                }
            }
        }
    }
}

extension PreviewViewController: SetupUI {

    func setupUI() {
        Theme.default.backgroundCard(self)
    }

    func setupTexts() {
        Util.setTextBarIn(self, title: "Pré-Visualização do Vídeo")
    }
}
