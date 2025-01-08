//
//  StudentSchoolCell.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 31/08/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import UIKit

class StudentSchoolCell : UIBaseCollectionViewCell {
    
    @IBOutlet weak var lbSchoolName: UILabel!
    @IBOutlet weak var lbCourse: UILabel!
    
    var controller: UIViewController?
    var delegate: BaseDelegate?
    var school: SchoolForm?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func onClickDelete(_ sender: Any) {
        if controller == nil || delegate == nil {
            return
        }
        
        Util.showAlertYesNo(controller!, message: "transport_students_form_school_list_confirm_delete".localized, completionOK: {
            self.delegate?.onReceiveData(fromClass: StudentSchoolCell.self, param: Param.Contact.STUDENT_SCHOOL_LIST_UPDATE_REQUIRED, result: true, object: self.school as AnyObject)
        })
    }
    
    func displayContent(controller: UIViewController, delegate: BaseDelegate, school: SchoolForm) {
        self.delegate = delegate
        self.controller = controller
        self.school = school
        
        self.lbSchoolName.text = school.nome
        self.lbCourse.text = "\(school.course) - \(school.serie)"
    }
}
