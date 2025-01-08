//
//  BaseViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 15/05/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import UIKit

open class BaseViewController<View: UIView>: UIViewController {
    
    //MARK: - Internal Variables
    
    public var baseView: View {
        return view as! View
    }
    
    //MARK: - Initializers
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Override Methods
    
    override public func loadView() {
        view = View()
    }
    
    
    @objc
    private func dismissView() {
        dismiss(animated: true)
    }
    
    @objc
    private func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textViewDidEndEditing(_ textView: UITextView, completion: @escaping (() -> Void)) {
        guard let cep = textView.text?.removeAllOtherCaracters() else { return }
        if cep.count == 8 {
            Util.showLoading(self)
            completion()
        }
    }
    
    @objc
    func endEditionAndDismiss() {
        self.view.endEditing(true)
        self.dismiss(animated: false, completion: nil)
    }
}
 
extension BaseViewController {
    public func showLoading(_ sender: UIViewController, completion: (() -> Void)? = nil) {
        let viewController = LoadingMainViewController()
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        sender.present(viewController, animated: true, completion: completion)
    }
    
    func showErrorThatDismissPage(message: String = "error_some_error_occourred".localized) {
        Util.showAlertDefaultOK(self, message: message, titleOK: "Voltar", completionOK: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func setupNavigationBar(with viewTitle: String? = nil, hasBack: Bool = true) {
        title = viewTitle
        setupNavigationButtons(hasBack)
    }
    
    func setupNavigationButtons(_ hasBackAction: Bool = true) {
        let navigationItem = navigationController?.navigationBar.topItem
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        let backItem = navigationButton(icon: "ic_arrow_back", selector: nil)
        navigationItem?.leftBarButtonItem = hasBackAction ? backItem : nil
        navigationItem?.rightBarButtonItem = navigationButton(
            icon: "ic_close_white",
            selector: #selector(dismissView)
        )
    }
    
    func displayAlert(title: String, description: String) {
        let alert = UIAlertController(
            title: title,
            message: description,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func pushViewController(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func navigateToStoryboard(_ name: String, withIdentifier: String) {
        let vc = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: withIdentifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Reusable Views
extension BaseViewController {
    func displayLoader() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            let view = LoadingView()
            view.layer.opacity = 1
            self.view.addSubview(view, constraints: true)
        })
    }
    
    func displayChooseDevice(delegate fromViewController: UIViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = fromViewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(
            title: "Biblioteca de Fotos",
            style: .default,
            handler: { _ in
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        ))
        
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
    
    func displayNoticeView(
        navTitle: String? = nil,
        title: String,
        description: String,
        image: String,
        btnTitle: String,
        completion: (() -> Void)? = nil
    ) {
        let viewController = NoticeViewController(
            navigationTitle: navTitle ?? "",
            contentTitle: title,
            contentDescription: description,
            contentImage: "",
            completion: completion
        )
        viewController.baseView.contentImageView.image = UIImage(named: image)
        viewController.baseView.actionButton.setTitle(btnTitle)
        viewController.baseView.actionButton.addTarget(
            self,
            action: #selector(self.endEditionAndDismiss),
            for: .touchUpInside
        )
        
        self.pushViewController(viewController)
    }
}

// MARK: - Navigation Bar Content
private extension BaseViewController {
    func navigationButton(icon: String, selector: Selector?) -> UIBarButtonItem {
        let customButton = UIButton(type: .custom)
        let iconImage = UIImage(named: icon)?.withRenderingMode(.alwaysTemplate)
        customButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        customButton.setImage(iconImage, for: .normal)
        customButton.addTarget(self, action: selector ?? #selector(popView), for: .touchUpInside)
        let button = UIBarButtonItem(customView: customButton)
        button.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        return button
    }
}
