//
//  StudentsFormStatusViewController.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 25/08/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import UIKit

class StudentsFormStatusViewController : UIBaseViewController {
    
    @IBOutlet weak var viewStatus: UIStackView!
    @IBOutlet weak var viewOtherStudent: UIStackView!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var viewReason: UIStackView!
    @IBOutlet weak var lbReason: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbStatusDesc: UILabel!
    @IBOutlet weak var ivStatus: UIImageView!
    @IBOutlet weak var lbWhatWantToDo: UILabel!
    @IBOutlet weak var btDone: UIButton!
    @IBOutlet weak var btEdit: UIButton!
    @IBOutlet weak var btNewForm: UIButton!
    @IBOutlet weak var btOtherStudent: UIButton!
    @IBOutlet weak var lbOtherStudentTitle: UILabel!
    @IBOutlet weak var lbOtherStudentDesc: UILabel!
    @IBOutlet weak var txtCPF: MaterialField!
    @IBOutlet weak var studentPickCardView: StudentPickupCardAddressView!
    
    override func setupViewDidLoad() {

        self.studentPickCardView.viewController = self
        self.setupUI()
        self.setupTexts()
        self.consult(cpf: "")
    }
}

extension StudentsFormStatusViewController {
    
    @IBAction func onClickDone(_ sender: Any) {
        
        if !self.viewStatus.isHidden {
            self.dismissPage(nil)
            return
        }
        
        let cpf = txtCPF.text ?? ""
        if (!Util.validadeCPF(cpf)) {
            Util.showAlertDefaultOK(self, message: "transport_students_form_status_cpf_wrong".localized)
            return
        }
        
        self.consult(cpf: cpf)
    }
    
    @IBAction func onClickEditForm(_ sender: Any) {
        StudentsFormViewController.cpf = self.txtCPF.text ?? ""
        self.performSegue(withIdentifier: Constants.Segues.STUDENT_FORM, sender: nil)
    }
    
    @IBAction func onClickNewForm(_ sender: Any) {
        StudentsFormViewController.cpf = nil
        self.performSegue(withIdentifier: Constants.Segues.STUDENT_FORM, sender: nil)
    }
    
    @IBAction func onClickOtherStudent(_ sender: Any) {
        self.showOtherStudentView()
    }
}

extension StudentsFormStatusViewController {
    
    func consult(cpf: String) {
        self.showLoading()
        TransportStudentRN(delegate: self).consultFormStatus(cpf: cpf)
    }
}

extension StudentsFormStatusViewController {
    
    func hideAll() {
        self.viewStatus.isHidden = true
        self.viewLoading.isHidden = true
        self.viewReason.isHidden = true
        self.viewOtherStudent.isHidden = true
        self.view.endEditing(true)
    }
    
    func showLoading() {
        self.hideAll()
        self.viewLoading.isHidden = false
    }
    
    func showOtherStudentView() {
        self.hideAll()
        self.txtCPF.text = ""
        self.viewOtherStudent.isHidden = false
        self.btDone.setTitle("search".localized)
    }
    
    func showStatusView(response: StudentFormStatusResponse?) {
        self.hideAll()
        
        self.viewStatus.isHidden = false
        self.studentPickCardView.isHidden = true
        btDone.setTitle("done".localized)
        if (response == nil || response!.idStatus == StudentFormStatusResponse.STATUS_NOT_FOUND) {
            ivStatus.setImage(named: "img_student3")
            lbStatus.text = "transport_students_form_status_not_found_title".localized
            lbStatusDesc.text = "transport_students_form_status_not_found_desc".localized
            
            lbWhatWantToDo.isHidden = false
            btEdit.isHidden = true
            btNewForm.isHidden = false
            btOtherStudent.isHidden = false
            return
        }
        
        if (response!.idStatus == StudentFormStatusResponse.STATUS_APPROVED) {
        
            ivStatus.setImage(named: "ic_green_done")
            lbStatus.text = "transport_students_form_status_valid_title".localized
            lbStatusDesc.text = "transport_students_form_status_valid_desc".localized
            
            lbWhatWantToDo.isHidden = true
            btEdit.isHidden = true
            btNewForm.isHidden = true
            btOtherStudent.isHidden = false
            self.studentPickCardView.isHidden = false
        }
        else if (response!.idStatus == StudentFormStatusResponse.STATUS_PENDENT) {

            ivStatus.setImage(named: "ic_pending")
            lbStatus.text = "transport_students_form_status_pendent_title".localized
            lbStatusDesc.text = "transport_students_form_status_pendent_desc".localized
            
            lbWhatWantToDo.isHidden = true
            btEdit.isHidden = true
            btNewForm.isHidden = true
            btOtherStudent.isHidden = false
        }
        else if (response!.idStatus == StudentFormStatusResponse.STATUS_RETURN) {

            ivStatus.setImage(named: "ic_pending")
            lbStatus.text = "transport_students_form_status_expired_title".localized
            lbStatusDesc.text = "transport_students_form_status_expired_desc".localized
            
            lbWhatWantToDo.isHidden = false
            btEdit.isHidden = true
            btNewForm.isHidden = false
            btOtherStudent.isHidden = false
        }
        else if (response!.idStatus == StudentFormStatusResponse.STATUS_REFUSED) {
            
            ivStatus.setImage(named: "ic_red_error")
            lbStatus.text = "transport_students_form_status_refused_title".localized
            lbStatusDesc.text = "transport_students_form_status_refused_desc".localized
            
            viewReason.isHidden = false
            lbReason.text = response!.reason
            
            lbWhatWantToDo.isHidden = false
            btEdit.isHidden = false
            btNewForm.isHidden = false
            btOtherStudent.isHidden = false
        }
    }
}

extension StudentsFormStatusViewController : BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.async {
            
            if param == Param.Contact.STUDENT_FORM_CONSULT_RESPONSE {
                self.showStatusView(response: object as? StudentFormStatusResponse)
            }
        }
    }
}

extension StudentsFormStatusViewController : SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        
        lbStatus.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
    }
    
    func setupTexts() {
        
        Util.setTextBarIn(self, title: "transport_students_toolbar".localized)
        
        lbOtherStudentTitle.text = "transport_students_form_status_send_other_title".localized
        lbOtherStudentDesc.text = "transport_students_form_status_send_other_desc".localized
        
        lbWhatWantToDo.text = "transport_students_form_status_what_wanna_do".localized
        txtCPF.placeholder = "transport_students_form_user_cpf_student".localized
        self.txtCPF.formatPattern = Constants.FormatPattern.Default.CPF.rawValue
    }
}
