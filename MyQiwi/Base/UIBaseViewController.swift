//
//  UIBaseView.swift
//  MyQiwi
//
//  Created by ailton on 20/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import UIKit

/**
 * All functions of this extension should be overriden whenever you need. Do not override
 * the official lifecycle function, unless they aren`t implemented below.
 *
 */
class UIBaseViewController: UIViewController {

    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(), name: NSNotification.Name(rawValue: "NO_CONNECTION"), object: nil)
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(connection), userInfo: nil, repeats: true)
    }
    
    @objc func connection() {
        Util.showConnection(sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.timer?.invalidate()
    }
    
    func setupViewDidLoad() {
    }
    
    func setupViewWillAppear() {
        
    }
    
    @IBAction func popPage(_ sender: Any? = nil) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func dismissPageAfter(after: Double) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + after, execute: {
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func dismissPage(_ sender: Any? = nil) {
        self.view.endEditing(true)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func backToMainScreen(_ sender: Any?) {
        //Nessas fechamos somente uma vez
        if QiwiOrder.isQiwiTransferToPrePago() || QiwiOrder.isQiwiRecharge() || QiwiOrder.isPhoneRecharge() {
            self.dismiss(animated: false)
            return
        }
        
        self.view.endEditing(true)
        self.view.window?.rootViewController!.dismiss(animated: false)
        //self.navigationController?.popViewController( animated: false)
        self.dismiss(animated: false, completion: nil )
        //
    }
    
    @IBAction func backToHome(_ sender: Any? ) {
        //Nessas fechamos somente uma vez
        if QiwiOrder.isQiwiTransferToPrePago() || QiwiOrder.isQiwiRecharge() || QiwiOrder.isPhoneRecharge() {
            self.dismiss(animated: false)
            return
        }
        
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil )
    }
    
    @IBAction func btnTransfer(sender: Any? = nil) {
        let storyboard: UIStoryboard = UIStoryboard(name: "CreditTransfer", bundle: nil )
        let creditTransferViewController = storyboard.instantiateViewController(withIdentifier:"creditTransferViewController") as! CreditTransferViewController
        self.present(creditTransferViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnClose(_ sender: Any? ) {
        
        //Nessas fechamos somente uma vez
        if QiwiOrder.isQiwiTransferToPrePago() || QiwiOrder.isQiwiRecharge() || QiwiOrder.isPhoneRecharge() {
            self.dismiss(animated: false)
            return
        }
        
        self.view.endEditing(true)
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        self.dismiss(animated: false)
    }
    
    func btnClose() {
        self.view.endEditing(true)
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        self.dismiss(animated: false)
    }
    
    @objc
    func dismissView() {
        self.navigationController?.dismiss(animated: true)
    }
}

extension UIBaseViewController {
    func pushViewController(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushSegueViewController(withIdentifier: String, name: String) {
        let vc = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: withIdentifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError(message: String = "error_some_error_occourred".localized) {
        Util.showAlertDefaultOK(self, message: message)
    }
    
    func showErrorThatDismissPage(message: String = "error_some_error_occourred".localized) {
        Util.showAlertDefaultOK(self, message: message, titleOK: "OK", completionOK: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func doActionAfter(after: Double, completion: (() -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after, execute: {
            completion?()
        })
    }
    
    func displayAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(
            title: "OK",
            style: .cancel,
            handler: { _ in
//                self.dismissPage()
                completion?()
            }
        )
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func displayChooseDevice(delegate fromViewController: UIViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = fromViewController as? any UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(
            title: "Biblioteca de Fotos",
            style: .default,
            handler: { _ in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        alertController.addAction(UIAlertAction(
            title: "Câmera",
            style: .default,
            handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                print("Câmera não disponível")
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    public func showLoading(_ sender: UIViewController, completion: (() -> Void)? = nil) {
        let viewController = LoadingMainViewController()
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        sender.present(viewController, animated: true, completion: completion)
    }
}
