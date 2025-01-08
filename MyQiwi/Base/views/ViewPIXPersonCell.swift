//
//  ViewPIXPersonCell.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 15/02/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import Foundation
import UIKit

class ViewPIXPersonCell : UIBaseCollectionViewCell {
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCPF: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    
    var delegate: BaseDelegate?
    var pixRequest = PIXRequest()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupViewWithoutCard()
        
        Theme.TransportInstructions.textAsTitle(self.lbName)
        Theme.TransportInstructions.textAsDesc(self.lbCPF)
        Theme.default.greenButton(self.btnSelect)
    }
    
    func displayeContent(pixRequest: PIXRequest, delegate: BaseDelegate) {
        self.pixRequest = pixRequest
        self.delegate = delegate
        
        self.lbName.text = pixRequest.name
        let cpf = pixRequest.document.contains("*") ? pixRequest.document : replaceDocument(document: pixRequest.document)
        self.lbCPF.text = cpf
    }
    
    private func replaceDocument(document: String) -> String {
        if document.count == 11 {
            return "\(document.substring(0, 2))*.***.***-\(document.substring(9, document.count))"
        }
        return "\(document.substring(0, 2)).***.***/****-\(document.substring(12, document.count))"
    }
    
    @IBAction func onClickSelect(_ sender: Any) {
        delegate?.onReceiveData(fromClass: ViewPIXPersonCell.self, param: Param.Contact.LIST_CLICK, result: true, object: self.pixRequest as AnyObject)
    }
}
