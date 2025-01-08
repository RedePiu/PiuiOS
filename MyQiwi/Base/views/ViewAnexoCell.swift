//
//  ViewAnexoCell.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 13/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class ViewAnexoCell: UIBaseCollectionViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var btnRemove: UIButton!
    
    @IBOutlet weak var widthLayout: NSLayoutConstraint?
    
    // MARK: Variables
    
    var widthCollection: CGFloat = 80 {
        didSet {
            //self.setCellWidth((widthCollection - (CGFloat(2) * 10)) / 2)
        }
    }
    
    // MARK: Methods
    
    func setCellWidth(_ width: CGFloat) {
        widthLayout?.constant = width
    }
    
    func displayContent(anexo: Anexo) {
        //        let url = URL(string: Params.Net.URL + image)
        //        menuIcon.kf.setImage(with: url)

        //self.icon.image = load(fileName: anexo.path)
        self.icon.image = UIImage.init(contentsOfFile: anexo.path)
    }
    
    private func load(fileName: String) -> UIImage? {
        do {
            let url = URL(fileURLWithPath: fileName)
            let imageData = try Data(contentsOf: url)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
}
