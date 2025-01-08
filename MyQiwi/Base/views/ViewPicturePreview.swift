//
//  ViewPicturePreview.swift
//  MyQiwi
//
//  Created by Ailton on 05/11/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation
import UIKit

class ViewPicturePreview: LoadBaseView {
    
    // MARK: Views
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var imgPlaceholder: UIImageView!
    @IBOutlet weak var lbPlaceholder: UILabel!
    
    // MARK: Variables
    var viewController: UIViewController?
    var delegate: BaseDelegate?
    var hasImage = false
    
    // MARK: Init
    
    override func initCoder() {
        self.loadNib(name: "ViewPicturePreview")
        self.setupView()
        self.addTapsActions()
    }
}

extension ViewPicturePreview {
    
    func setupView() {
        
        imgPlaceholder.image = UIImage(named: "ic_cam")?.withRenderingMode(.alwaysTemplate)
        imgPlaceholder.tintColor = Theme.default.white
        
        btnRemove.isHidden = true
    }
}

extension ViewPicturePreview {
    
    func addTapsActions() {
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setImg)))
        btnRemove.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeImg)))
    }
}

extension ViewPicturePreview {
    
    
    @objc func setImg() {
        
        // Tem imagem, abre o preview
        if hasImage {
         
            let previewViewController = PreviewPictureViewController(image: self.imgPicture.image)
            previewViewController.modalPresentationStyle = .overFullScreen
            self.viewController?.present(previewViewController, animated: false)
            return
        }
        
        Util.selectTakePhoto(self.viewController!) { (image) in
            self.imgPicture.image = image
            self.hasImage = true
            self.btnRemove.isHidden = false
            
            self.imgPlaceholder.image = UIImage(named: "ic_search")?.withRenderingMode(.alwaysTemplate)
            self.imgPlaceholder.tintColor = Theme.default.white
            
            self.delegate?.onReceiveData(fromClass: ViewPicturePreview.self, param: Param.Contact.PHOTO_ADDED, result: true, object: nil)
        }
    }
    
    @objc func removeImg() {
        self.imgPicture.image = nil
        self.hasImage = false
        self.btnRemove.isHidden = true
        
        imgPlaceholder.image = UIImage(named: "ic_cam")?.withRenderingMode(.alwaysTemplate)
        imgPlaceholder.tintColor = Theme.default.white
        
        self.delegate?.onReceiveData(fromClass: ViewPicturePreview.self, param: Param.Contact.PHOTO_ADDED, result: true, object: nil)
    }
}
