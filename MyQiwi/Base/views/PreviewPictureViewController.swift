//
//  PreviewPictureViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 06/11/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class PreviewPictureViewController: UIViewController {

    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var viewBackground: UIView!
    
    private var imagePreview: UIImage?
    
    init(image: UIImage?) {
        super.init(nibName: "PreviewPictureViewController", bundle: Bundle.main)
        
        self.imagePreview = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgPicture.image = self.imagePreview
        self.imgPicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close(sender:))))
        self.viewBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close(sender:))))
    }
}

extension PreviewPictureViewController {
    
    @objc func close(sender: Any) {
        self.dismiss(animated: false)
    }
}
