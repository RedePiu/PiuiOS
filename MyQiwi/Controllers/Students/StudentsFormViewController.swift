//
//  StudentsFormViewController.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 25/08/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import UIKit

class StudentsFormViewController : UIBaseViewController {
    
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var viewLoading: UIStackView!
    @IBOutlet weak var viewAlreadySent: UIStackView!
    @IBOutlet weak var viewAlreadyPendent: UIStackView!
    @IBOutlet weak var viewStudentOrTeacher: UIStackView!
    @IBOutlet weak var viewCardOwner: UIStackView!
    @IBOutlet weak var viewStudent: UIStackView!
    @IBOutlet weak var viewDependent: UICardView!
    @IBOutlet weak var viewAddress: UIStackView!
    @IBOutlet weak var viewSchool: UIStackView!
    @IBOutlet weak var viewSchoolList: UIStackView!
    @IBOutlet weak var viewDayTime: UIStackView!
    @IBOutlet weak var viewSent: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var btBack: UIButton!
    @IBOutlet weak var btContinue: UIButton!
    
    @IBOutlet weak var ivSent: UIImageView!
    @IBOutlet weak var lbSentTitle: UILabel!
    @IBOutlet weak var lbSentDesc: UILabel!
    
    @IBOutlet weak var lbAlreadySentTitle: UILabel!
    @IBOutlet weak var lbAlreadySentDesc: UILabel!
    @IBOutlet weak var lbAlreadyPendentTitle: UILabel!
    @IBOutlet weak var lbAlreadyPendentDesc: UILabel!
    
    @IBOutlet weak var btAddSchool: UIButton!
    @IBOutlet weak var btOptionStudent: UIButton!
    @IBOutlet weak var btOptionTeacher: UIButton!
    @IBOutlet weak var btIamStudent: UIButton!
    @IBOutlet weak var btOtherStudent: UIButton!
    
    @IBOutlet weak var txtOwnName: MaterialField!
    @IBOutlet weak var txtOwnCPF: MaterialField!
    @IBOutlet weak var txtOwnRG: MaterialField!
    @IBOutlet weak var txtOwnBirthDate: MaterialField!
    @IBOutlet weak var txtOwnFather: MaterialField!
    @IBOutlet weak var txtOwnMother: MaterialField!
    @IBOutlet weak var avOwnDocument: ViewAnexo!
    @IBOutlet weak var avOwnSelfie: ViewAnexo!
    
    @IBOutlet weak var lbDependentTitle: UILabel!
    @IBOutlet weak var txtDependentName: MaterialField!
    @IBOutlet weak var txtDependentCPF: MaterialField!
    @IBOutlet weak var txtDependentRG: MaterialField!
    @IBOutlet weak var txtDependentBirthday: MaterialField!
    @IBOutlet weak var txtDependentFather: MaterialField!
    @IBOutlet weak var txtDependentMother: MaterialField!
    @IBOutlet weak var txtDependentParent: MaterialField!
    @IBOutlet weak var ivDependentAgreement: UIImageView!
    @IBOutlet weak var avDependentDocument: ViewAnexo!
    @IBOutlet weak var avDependentSelfie: ViewAnexo!
    
    @IBOutlet weak var txtCEP: MaterialField!
    @IBOutlet weak var txtStreet: MaterialField!
    @IBOutlet weak var txtNumber: MaterialField!
    @IBOutlet weak var txtComplement: MaterialField!
    @IBOutlet weak var txtDistrict: MaterialField!
    @IBOutlet weak var txtCity: MaterialField!
    @IBOutlet weak var txtState: MaterialField!
    @IBOutlet weak var avAddress: ViewAnexo!
    
    @IBOutlet weak var lbSchoolAndCoursesTitle: UILabel!
    @IBOutlet weak var lbSchoolAndCoursesDesc: UILabel!
    @IBOutlet weak var txtSchoolName: StudentsSchoolSearchView!
    @IBOutlet weak var txtCourse: MaterialField!
    @IBOutlet weak var txtSemester: MaterialField!
    @IBOutlet weak var txtRA: MaterialField!
    @IBOutlet weak var txtClass: MaterialField!
    
    @IBOutlet weak var cvSchoolList: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var txtTimeEnter1: MaterialField!
    @IBOutlet weak var txtTimeExit1: MaterialField!
    @IBOutlet weak var txtTimeEnter2: MaterialField!
    @IBOutlet weak var txtTimeExit2: MaterialField!
    @IBOutlet weak var txtTimeSaturdayEnter1: MaterialField!
    @IBOutlet weak var txtTimeSaturdayExit1: MaterialField!
    @IBOutlet weak var txtTimeDesportivaEnter1: MaterialField!
    @IBOutlet weak var txtTimeDesportivaExit1: MaterialField!
    @IBOutlet weak var txtTimeDesportivaEnter2: MaterialField!
    @IBOutlet weak var txtTimeDesportivaExit2: MaterialField!
    
    @IBOutlet weak var ivSegunda: UIImageView!
    @IBOutlet weak var ivTerca: UIImageView!
    @IBOutlet weak var ivQuarta: UIImageView!
    @IBOutlet weak var ivQuinta: UIImageView!
    @IBOutlet weak var ivSexta: UIImageView!
    
    @IBOutlet weak var txtLine1: MaterialField!
    @IBOutlet weak var txtLine2: MaterialField!
    @IBOutlet weak var txtLine3: MaterialField!
    @IBOutlet weak var txtLine4: MaterialField!
    @IBOutlet weak var avEMTU: ViewAnexo!
    
    @IBOutlet weak var studentPickupAddress: StudentPickupCardAddressView!
    @IBOutlet weak var studentPickupAddress2: StudentPickupCardAddressView!
    
    /***** VARIABLES *****/
    lazy var transportStudentRN = TransportStudentRN(delegate: self)
    var studentForm = StudentForm()
    var isOtherStudent = false
    var isTeacher = false
    var schools = [School]()
    var busLines = [BusLine]()
    var isPopulatingFields = false
    var isConsultingOwnCPF = false
    var selectedTxtLine: MaterialField?
    
    //MOCKED EMISSOR
    static var MOCKED_EMISSOR = 69
    static var cpf: String?
    
    override func setupViewDidLoad() {

        self.studentPickupAddress.viewController = self
        self.studentPickupAddress2.viewController = self
        
        self.setupUI()
        self.setupCollectionView()
        self.setupFields()
        self.setupTexts()
        
        self.showPageLoading()
        self.transportStudentRN.getSchoolsAndBusLines(idEmissor: StudentsFormViewController.MOCKED_EMISSOR)
    }
}

extension StudentsFormViewController {
    
    @IBAction func onChangeCEP(_ sender: Any) {
        if self.isPopulatingFields {
            return
        }
        
       let cep = self.txtCEP.text?.removeAllOtherCaracters() ?? ""
        if (cep.count == 8) {
            Util.showLoading(self)
            AddressRN(delegate: self).consultCEP(cep: cep)
            return
        }
    }
    
    @IBAction func onEditDependentCPF(_ sender: Any) {
        if self.isPopulatingFields {
            return
        }
        
        let cpf = self.txtDependentCPF.text?.removeAllOtherCaracters() ?? ""
        
        if cpf.count != 11 {
            return
        }
        
        self.onInputStudentCPF()
    }
}

extension StudentsFormViewController {
    
    @IBAction func onClickSegunda(_ sender: Any) {
        self.setCheckbox(self.ivSegunda, checked: self.ivSegunda.tag == 0)
    }
    
    @IBAction func onClickTerca(_ sender: Any) {
        self.setCheckbox(self.ivTerca, checked: self.ivTerca.tag == 0)
    }
    
    @IBAction func onClickQuarta(_ sender: Any) {
        self.setCheckbox(self.ivQuarta, checked: self.ivQuarta.tag == 0)
    }
    
    @IBAction func onClickQuinta(_ sender: Any) {
        self.setCheckbox(self.ivQuinta, checked: self.ivQuinta.tag == 0)
    }
    
    @IBAction func onClickSexta(_ sender: Any) {
        self.setCheckbox(self.ivSexta, checked: self.ivSexta.tag == 0)
    }
    
    @IBAction func onClickAcceptDependent(_ sender: Any) {
        self.setCheckbox(self.ivDependentAgreement, checked: self.ivDependentAgreement.tag == 0)
    }
    
    @IBAction func onClickSelectLine(_ sender: Any) {
        self.selectedTxtLine = sender as? MaterialField
    }
    
    @IBAction func onClickAddSchool(_ sender: Any) {
        self.clearSchoolFields()
        self.showSchoolView()
    }
    
    @IBAction func onClickWhatsAppTransport(_ sender: Any) {
        Util.openWhatsApp(number: "551236215300", msg: "transport_students_whatsapp_msg".localized.replacingOccurrences(of: "{NAME}", with: UserRN.getLoggedUser().name))
    }
    
    @IBAction func onClickWhatsAppQiwi(_ sender: Any) {
        Util.openWhatsApp(number: "5511976487787", msg: "attendance_whatsapp_msg".localized.replacingOccurrences(of: "{NAME}", with: UserRN.getLoggedUser().name))
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        
        if !self.viewStudent.isHidden {
            self.showCardOwnerView()
            return
        }
        
        if !self.viewAddress.isHidden {
            self.showStudentInfoView()
            return
        }
        
        if !self.viewSchool.isHidden {
            if self.studentForm.schoolList == nil || self.studentForm.schoolList!.isEmpty {
                self.showAddressView()
            } else {
                self.showSchoolListView()
            }
            return
        }
        
        if !self.viewSchoolList.isHidden {
            self.showAddressView()
            return
        }
        
        if !self.viewDayTime.isHidden {
            self.showSchoolListView()
            return
        }
    }
    
    @IBAction func onClickContinue(_ sender: Any) {
        
        if !self.viewStudent.isHidden && self.validateStudentView() {
            self.showAddressView()
            return;
        }
        
        if !self.viewAddress.isHidden && self.validateAddressView() {
            
            if self.studentForm.schoolList != nil && !self.studentForm.schoolList!.isEmpty {
                self.showSchoolListView()
                return
            }
            
            self.showSchoolView()
            return
        }
        
        if !self.viewSchool.isHidden && self.validateSchoolView() {
            self.showSchoolListView()
            return
        }
        
        if !self.viewSchoolList.isHidden {
            self.showTimeDayView()
            return
        }
        
        if !self.viewDayTime.isHidden && self.validateTimeDayView() {
            self.sendFilesToAmazon()
            return
        }
        
        if !self.viewSent.isHidden || !self.viewAlreadySent.isHidden || !self.viewAlreadyPendent.isHidden {
            self.dismissPage(true)
        }
    }
    
    @IBAction func onClickClearTime(_ sender: Any) {
        
        self.txtTimeEnter1.text = ""
        self.txtTimeEnter2.text = ""
        self.txtTimeExit1.text = ""
        self.txtTimeExit2.text = ""
    }
    
    @IBAction func onClickClearSaturdayTime(_ sender: Any) {
        
        self.txtTimeSaturdayEnter1.text = ""
        self.txtTimeSaturdayExit1.text = ""
    }
    
    @IBAction func onClickClearDesportivaTime(_ sender: Any) {
        self.txtTimeDesportivaEnter1.text = ""
        self.txtTimeDesportivaEnter2.text = ""
        self.txtTimeDesportivaExit1.text = ""
        self.txtTimeDesportivaExit2.text = ""
    }
    
    @IBAction func onClickOptionStudent(_ sender: Any) {
        self.isTeacher = false
        self.studentForm.idTipoParticipante = 1
        self.showCardOwnerView()
    }
    
    @IBAction func onClickOptionTeacher(_ sender: Any) {
        self.isTeacher = true
        self.isOtherStudent = false
        self.isConsultingOwnCPF = true
        self.studentForm.idTipoParticipante = 2
        
        self.showPageLoading()
        self.transportStudentRN.consultFormStatus(cpf: "")
    }
    
    @IBAction func onClickIamStudent(_ sender: Any) {
        self.isOtherStudent = false
        self.isConsultingOwnCPF = true
        
        self.showPageLoading()
        self.transportStudentRN.consultFormStatus(cpf: "")
    }
    
    @IBAction func onClickOtherStudent(_ sender: Any) {
        self.isOtherStudent = true
        self.showStudentInfoView();
    }
}

extension StudentsFormViewController {
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        self.txtLine1.inputView = pickerView
        self.txtLine2.inputView = pickerView
        self.txtLine3.inputView = pickerView
        self.txtLine4.inputView = pickerView
    }
    
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
       let button = UIBarButtonItem(title: "Pronto", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
        self.txtLine1.inputAccessoryView = toolBar
        self.txtLine2.inputAccessoryView = toolBar
        self.txtLine3.inputAccessoryView = toolBar
        self.txtLine4.inputAccessoryView = toolBar
    }
    
    @objc func action() {
        view.endEditing(true)
    }
}

extension StudentsFormViewController : UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.busLines.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.busLines[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.selectedTxtLine == nil {
            return
        }
        
        if row == 0 {
            self.selectedTxtLine?.text = ""
            self.selectedTxtLine?.tag = 0
        } else {
            self.selectedTxtLine?.text = self.busLines[row].name
            self.selectedTxtLine?.tag = self.busLines[row].idLine
        }
    }
}

extension StudentsFormViewController {
    
    func onInputStudentCPF() {
        Util.showLoading(self)
        self.transportStudentRN.consultFormStatus(cpf: txtDependentCPF.text?.removeAllOtherCaracters() ?? "")
    }
    
    func onConsultCPF(response: StudentFormStatusResponse?) {
        
        if response == nil {
            if self.isConsultingOwnCPF {
                self.showStudentInfoView()
            } else {
                self.dismissPage(self)
            }
            
            self.isConsultingOwnCPF = false
            return
        }
        
        if response!.idStatus == StudentFormStatusResponse.STATUS_APPROVED {
            if !self.isConsultingOwnCPF {
                self.dismissPage(self)
            }
            self.showCardAlreadyValidView()
            return
        }
        
        if response!.idStatus == StudentFormStatusResponse.STATUS_PENDENT {
            if !self.isConsultingOwnCPF {
                self.dismissPage(self)
            }
            self.showCardAlreadyPendentView()
            return
        }
        
        if response!.idStatus == StudentFormStatusResponse.STATUS_RETURN {
            if !self.isConsultingOwnCPF {
                self.dismissPage(self)
            }
            self.showStudentInfoView()
            return
        }
        
        self.transportStudentRN.getFormResponses(cpf: self.isOtherStudent ? txtOwnCPF.text ?? "" : txtDependentCPF.text ?? "")
    }
    
    func onReceiveSchoolsAndLines(lines: [BusLine], school: [School]) {
        
        if school.isEmpty {
            Util.showAlertDefaultOK(self, message: "transport_students_form_school_list_failed".localized, titleOK: "ok".localized, completionOK: {
                self.dismissPageAfter(after: 0.8)
            })
            return
        }
        
        if lines.isEmpty {
            Util.showAlertDefaultOK(self, message: "transport_students_form_bus_line_list_failed".localized, titleOK: "ok".localized, completionOK: {
                self.dismissPageAfter(after: 0.8)
            })
            return
        }

        self.fillSchoolList(schools: school)
        self.fillBusLineList(lines: lines)
        
        if StudentsFormViewController.cpf != nil {
            self.isConsultingOwnCPF = true
            self.transportStudentRN.getFormResponses(cpf: StudentsFormViewController.cpf!)
            StudentsFormViewController.cpf = nil
            return
        }
        
        StudentsFormViewController.cpf = nil
        self.studentForm = StudentForm()
        self.showStudentOrTeacherView()
    }
}

extension StudentsFormViewController {
    
    func sendForm() {
        self.studentForm.idEmissor = StudentsFormViewController.MOCKED_EMISSOR
        self.transportStudentRN.sendOrUpdateForm(form: self.studentForm)
    }
    
    func sendFilesToAmazon() {
        Util.showLoading(self)
        
        if self.studentForm.documentList == nil {
            self.studentForm.documentList = [DocumentImage]()
        }
        
        var anexosToSent = [Anexo]()
        
        if !self.studentForm.hasDocument(imageType: ActionFinder.Documents.Types.STUDENT_OWN_DOCUMENT) {
            anexosToSent.insert(contentsOf: self.avOwnDocument.anexos, at: 0)
        }

        if !self.studentForm.hasDocument(imageType: ActionFinder.Documents.Types.STUDENT_DEPENDENT_DOCUMENT) {
            anexosToSent.insert(contentsOf: self.avDependentDocument.anexos, at: 0)
        }

        if !self.studentForm.hasDocument(imageType: ActionFinder.Documents.Types.ADDRESS) {
            anexosToSent.insert(contentsOf: self.avAddress.anexos, at: 0)
        }

        if !self.studentForm.hasDocument(imageType: ActionFinder.Documents.Types.SELFIE) {
            anexosToSent.insert(contentsOf: self.isOtherStudent ? self.avDependentSelfie.anexos : self.avOwnSelfie.anexos, at: 0)
        }
        
        if !self.studentForm.hasDocument(imageType: ActionFinder.Documents.Types.FORMULARIO_EMTU) && avEMTU.hasFiles() {
            anexosToSent.insert(contentsOf: self.avEMTU.anexos, at: 0)
        }
        
        if anexosToSent.isEmpty {
            self.sendForm()
            return
        }
        
        AmazonRN(delegate: self).sendDocument(anexos: anexosToSent)
    }
}

extension StudentsFormViewController {
    
    func hideAll() {
        self.lbTitle.isHidden = true
        self.viewAlreadySent.isHidden = true
        self.viewAlreadyPendent.isHidden = true
        self.viewCardOwner.isHidden = true
        self.viewStudent.isHidden = true
        self.viewAddress.isHidden = true
        self.viewSchoolList.isHidden = true
        self.viewSchool.isHidden = true
        self.viewSent.isHidden = true
        self.viewDependent.isHidden = true
        self.viewDayTime.isHidden = true
        self.viewStudentOrTeacher.isHidden = true
        self.viewLoading.isHidden = true
        self.view.endEditing(true)
    }
    
    func showBackAndContinueButtons() {
        self.btBack.isHidden = false
        self.btContinue.isHidden = false
    }
    
    func showOnlyBackButton() {
        self.btBack.isHidden = false
        self.btContinue.isHidden = true
    }
    
    func showOnlyContinueButton() {
        self.btBack.isHidden = true
        self.btContinue.isHidden = false
    }
    
    func showPageLoading() {
        self.hideAll()
        self.viewLoading.isHidden = false
    }
    
    func showTimerPicker() {
        
    }
    
    func setCheckbox(_ imageView: UIImageView, checked: Bool) {
        
        imageView.tag = checked ? 1 : 0
        imageView.setImage(named: checked ? "ic_check_box" : "ic_check_box_disable")
    }
    
    func populateViews() {
        
        self.isPopulatingFields = true
        
        self.txtOwnName.text = self.studentForm.name
        self.txtOwnCPF.text = self.studentForm.cpf
        self.txtOwnRG.text = self.studentForm.rg
        self.txtOwnBirthDate.text = self.studentForm.birthDate
        self.txtOwnFather.text = self.studentForm.father
        self.txtOwnMother.text = self.studentForm.mother
        
        self.avOwnDocument.isHidden = self.studentForm.hasDocument(imageType: ActionFinder.Documents.Types.STUDENT_OWN_DOCUMENT)
        self.avOwnSelfie.isHidden = self.studentForm.hasDocument(imageType: ActionFinder.Documents.Types.SELFIE)

        if self.studentForm.dependent != nil {
            self.txtDependentName.text = self.studentForm.dependent!.name
            self.txtDependentRG.text = self.studentForm.dependent!.rg
            self.txtDependentCPF.text = self.studentForm.dependent!.cpf
            self.txtDependentBirthday.text = self.studentForm.dependent!.birthDate
            self.txtDependentFather.text = self.studentForm.dependent!.father
            self.txtDependentMother.text = self.studentForm.dependent!.mother
            self.txtDependentParent.text = self.studentForm.dependent!.parent
            
            self.setCheckbox(ivDependentAgreement, checked: true)
            
            self.avOwnSelfie.isHidden = true
            self.avDependentDocument.isHidden = self.studentForm.hasDocument(imageType: ActionFinder.Documents.Types.STUDENT_DEPENDENT_DOCUMENT)
            self.avDependentSelfie.isHidden = self.studentForm.hasDocument(imageType: ActionFinder.Documents.Types.SELFIE)
        }

        self.txtCEP.text = self.studentForm.cep
        self.txtStreet.text = self.studentForm.street
        self.txtNumber.text = self.studentForm.number
        self.txtComplement.text = self.studentForm.complement
        self.txtDistrict.text = self.studentForm.district
        self.txtCity.text = self.studentForm.city
        self.txtState.text = self.studentForm.state
        
        self.avAddress.isHidden = self.studentForm.hasDocument(imageType: ActionFinder.Documents.Types.ADDRESS)

        if self.studentForm.schoolList != nil && !self.studentForm.schoolList!.isEmpty {
            for sf in self.studentForm.schoolList! {
                for school in self.schools {
                    if sf.idSchool == school.idSchool {
                        sf.nome = school.name
                    }
                }
            }
            
            self.updateStudentSchoolList()
        }

        var classTime = self.studentForm.findClassTime(id: StudentForm.ID_CLASSTIME_NORMAL)
        if (classTime != nil) {
            self.txtTimeEnter1.text = classTime?.startTimeMorning
            self.txtTimeEnter2.text = classTime?.startTimeAfternoon
            self.txtTimeExit1.text = classTime?.endTimeMorning
            self.txtTimeExit2.text = classTime?.endTimeAfternoon
            
            if self.txtTimeEnter1.text == "00:00" && self.txtTimeExit1.text == "00:00" {
                self.txtTimeEnter1.text = ""
                self.txtTimeExit1.text = ""
            }
            if self.txtTimeEnter2.text == "00:00" && self.txtTimeExit2.text == "00:00" {
                self.txtTimeEnter2.text = ""
                self.txtTimeExit2.text = ""
            }
        }
        
        classTime = self.studentForm.findClassTime(id: StudentForm.ID_CLASSTIME_SATURDAY)
        if (classTime != nil) {
            self.txtTimeSaturdayEnter1.text = classTime?.startTimeMorning
            self.txtTimeSaturdayExit1.text = classTime?.endTimeMorning
            
            if self.txtTimeSaturdayEnter1.text == "00:00" && self.txtTimeSaturdayExit1.text == "00:00" {
                self.txtTimeSaturdayEnter1.text = ""
                self.txtTimeSaturdayExit1.text = ""
            }
        }

        classTime = self.studentForm.findClassTime(id: StudentForm.ID_CLASSTIME_DESPORTIVA)
        if (classTime != nil) {
            self.txtTimeDesportivaEnter1.text = classTime?.startTimeMorning
            self.txtTimeDesportivaEnter2.text = classTime?.startTimeAfternoon
            self.txtTimeDesportivaExit1.text = classTime?.endTimeMorning
            self.txtTimeDesportivaExit2.text = classTime?.endTimeAfternoon
            
            if self.txtTimeDesportivaEnter1.text == "00:00" && self.txtTimeDesportivaExit1.text == "00:00" {
                self.txtTimeDesportivaEnter1.text = ""
                self.txtTimeDesportivaExit1.text = ""
            }
            
            if self.txtTimeDesportivaEnter2.text == "00:00" && self.txtTimeDesportivaExit2.text == "00:00" {
                self.txtTimeDesportivaEnter2.text = ""
                self.txtTimeDesportivaExit2.text = ""
            }
        }
        
        if self.studentForm.dayList != nil {
            self.setCheckbox(ivSegunda, checked: self.studentForm.dayList!.contains(1))
            self.setCheckbox(ivTerca, checked: self.studentForm.dayList!.contains(2))
            self.setCheckbox(ivQuarta, checked: self.studentForm.dayList!.contains(3))
            self.setCheckbox(ivQuinta, checked: self.studentForm.dayList!.contains(4))
            self.setCheckbox(ivSexta, checked: self.studentForm.dayList!.contains(5))
        }
        
        self.txtLine1.text = ""
        self.txtLine2.text = ""
        self.txtLine3.text = ""
        self.txtLine4.text = ""

        self.txtLine1.tag = 0
        self.txtLine2.tag = 0
        self.txtLine3.tag = 0
        self.txtLine4.tag = 0
        
        var lineId : Int = 0
        if self.studentForm.lineList != nil && !self.studentForm.lineList!.isEmpty {
            for i in 0..<self.studentForm.lineList!.count {
                
                lineId = self.studentForm.lineList![i]
                
                if i == 0 {
                    self.txtLine1.text = self.getBusLineById(id: lineId)?.name
                    self.txtLine1.tag = lineId
                }
                
                else if i == 1 {
                    self.txtLine2.text = self.getBusLineById(id: lineId)?.name
                    self.txtLine2.tag = lineId
                }
                
                else if i == 2 {
                    self.txtLine3.text = self.getBusLineById(id: lineId)?.name
                    self.txtLine3.tag = lineId
                }
                
                else if i == 3 {
                    self.txtLine4.text = self.getBusLineById(id: lineId)?.name
                    self.txtLine4.tag = lineId
                }
            }
        }
        
        self.avEMTU.isHidden = self.studentForm.hasDocument(imageType: ActionFinder.Documents.Types.FORMULARIO_EMTU)
        self.isPopulatingFields = false
    }
    
    func getBusLineById(id: Int) -> BusLine? {
        if self.busLines.isEmpty {
            return nil
        }
        
        for line in self.busLines {
            if line.idLine == id {
                return line
            }
        }
        
        return nil
    }
    
    func showSentView(result: Bool) {
        self.hideAll()
        self.showOnlyContinueButton()
        self.dismissPage(nil) //Fechar loading
        
        if result {
            self.ivSent.setImage(named: "img_student3")
            self.lbSentTitle.text = "transport_students_form_sent_success_title".localized
            self.lbSentDesc.text = "transport_students_form_sent_success_desc".localized
        } else {
            self.ivSent.setImage(named: "ic_robot")
            self.lbSentTitle.text = "transport_students_form_sent_failed_title".localized
            self.lbSentDesc.text = "transport_students_form_sent_failed_title".localized
        }

        self.viewSent.isHidden = false
        self.lbTitle.isHidden = true
        
        Theme.default.greenButton(self.btContinue)
        self.btContinue.setTitle("finish".localized)
        
        self.scrollView.scrollToTop(animated: true)
    }
    
    func showCardAlreadyValidView() {
        self.hideAll()
        self.viewButtons.isHidden = false
        self.showOnlyContinueButton()
        
        self.lbTitle.isHidden = true
        self.lbAlreadySentTitle.text = "transport_students_form_already_valid_title".localized
        self.lbAlreadySentDesc.text = "transport_students_form_already_valid_desc".localized
        
        self.viewAlreadySent.isHidden = false
        Theme.default.greenButton(self.btContinue)
        self.btContinue.setTitle("finish".localized)
        
        self.scrollView.scrollToTop(animated: true)
    }
    
    func showCardAlreadyPendentView() {
        self.hideAll()
        self.viewButtons.isHidden = false
        self.showOnlyContinueButton()
        
        self.lbTitle.isHidden = true
        self.lbAlreadyPendentTitle.text = "transport_students_form_already_valid_title".localized
        self.lbAlreadyPendentDesc.text = "transport_students_form_already_pendent_desc".localized
        
        self.viewAlreadyPendent.isHidden = false
        Theme.default.greenButton(self.btContinue)
        self.btContinue.setTitle("finish".localized)
        
        self.scrollView.scrollToTop(animated: true)
    }
    
    func showStudentOrTeacherView() {
        self.hideAll()
        
        self.lbTitle.isHidden = false
        self.lbTitle.text = "transport_students_form_student_or_teacher_title".localized
        
        self.viewStudentOrTeacher.isHidden = false
        self.viewButtons.isHidden = true
        
        self.scrollView.scrollToTop(animated: true)
    }
    
    func showCardOwnerView() {
        self.hideAll()
        
        self.lbTitle.isHidden = false
        self.lbTitle.text = "transport_students_form_title_owner".localized
        self.btIamStudent.setTitle("transport_students_form_owner_me".localized.replacingOccurrences(of: "{NAME}", with: UserRN.getLoggedUser().name))
        
        self.viewCardOwner.isHidden = false
        self.viewButtons.isHidden = true
        
        self.scrollView.scrollToTop(animated: true)
    }
    
    func showStudentInfoView() {
        self.hideAll()
        
        self.lbTitle.isHidden = false
        self.lbTitle.text = "transport_students_form_title_user".localized
        
        Theme.default.blueButton(self.btContinue)
        self.btContinue.setTitle("continue_label".localized)
        
        self.viewButtons.isHidden = false
        self.viewStudent.isHidden = false
        
        self.lbDependentTitle.isHidden = !self.isOtherStudent
        self.viewDependent.isHidden = !self.isOtherStudent
        
        if self.studentForm.hasDocument(imageType: ActionFinder.Documents.Types.SELFIE) {
            self.avOwnSelfie.isHidden = true
            self.avDependentSelfie.isHidden = true
        } else {
            self.avOwnSelfie.isHidden = self.isOtherStudent
            self.avDependentSelfie.isHidden = !self.isOtherStudent
        }
        
        self.scrollView.scrollToTop(animated: true)
    }
    
    func showAddressView() {
        self.hideAll()
        
        self.lbTitle.isHidden = false
        self.lbTitle.text = "transport_students_form_title_cep".localized
        
        Theme.default.blueButton(self.btContinue)
        self.btContinue.setTitle("continue_label".localized)
        
        self.viewButtons.isHidden = false
        self.viewAddress.isHidden = false
        
        self.scrollView.scrollToTop(animated: true)
    }
    
    func showSchoolView() {
        self.hideAll()
        
        self.lbTitle.isHidden = false
        self.lbTitle.text = "transport_students_form_title_school".localized
        
        Theme.default.blueButton(self.btContinue)
        self.btContinue.setTitle("continue_label".localized)
        
        self.viewButtons.isHidden = false
        self.viewSchool.isHidden = false
        
        self.scrollView.scrollToTop(animated: true)
    }
    
    func showSchoolListView() {
        self.hideAll()
        self.lbTitle.isHidden = true
   
        self.updateStudentSchoolList()
        
        Theme.default.blueButton(self.btContinue)
        self.btContinue.setTitle("continue_label".localized)
        
        self.viewButtons.isHidden = false
        self.viewSchoolList.isHidden = false
        
        self.scrollView.scrollToTop(animated: true)
    }
    
    func showTimeDayView() {
        self.hideAll()
        
        self.lbTitle.isHidden = false
        self.lbTitle.text = "transport_students_form_transport_title".localized
        
        Theme.default.greenButton(self.btContinue)
        self.btContinue.setTitle("finish".localized)
        
        self.viewButtons.isHidden = false
        self.viewDayTime.isHidden = false
        
        self.scrollView.scrollToTop(animated: true)
    }
}

extension StudentsFormViewController {
    
    func validateStudentView() -> Bool {
        
        let name = self.txtOwnName.text
        if name == nil || !name!.contains(" ") || name!.count < 4 {
            self.txtOwnName.setErrorWith(text: "")
            self.txtOwnName.becomeFirstResponder()
            return false
        }
        
        let cpf = self.txtOwnCPF.text ?? ""
        if !Util.validadeCPF(cpf) {
            self.txtOwnCPF.setErrorWith(text: "")
            self.txtOwnCPF.becomeFirstResponder()
            return false
        }
        
        let rg = self.txtOwnRG.text
        if rg == nil || rg!.count < 6 {
            self.txtOwnRG.setErrorWith(text: "")
            self.txtOwnRG.becomeFirstResponder()
            return false
        }
        
        let birthDate = self.txtOwnBirthDate.text
        if birthDate == nil || birthDate!.count < 10 {
            self.txtOwnBirthDate.setErrorWith(text: "")
            self.txtOwnBirthDate.becomeFirstResponder()
            return false
        }
        
        let father = self.txtOwnFather.text
//        if father == nil || !father!.contains(" ") || father!.count < 4 {
//            self.txtOwnFather.setErrorWith(text: "")
//            self.txtOwnFather.becomeFirstResponder()
//            return false
//        }
        
        let mother = self.txtOwnMother.text
        if mother == nil || !mother!.contains(" ") || mother!.count < 4 {
            self.txtOwnMother.setErrorWith(text: "")
            self.txtOwnMother.becomeFirstResponder()
            return false
        }
        
        if !self.avOwnSelfie.isHidden && !self.isOtherStudent && !self.avOwnSelfie.hasFiles() {
            self.avOwnSelfie.setError("transport_students_field_needed".localized)
            self.avOwnSelfie.becomeFirstResponder()
            return false
        }
        
        if  !self.avOwnDocument.isHidden && !self.avOwnDocument.hasFiles() {
            self.avOwnDocument.setError("transport_students_field_needed".localized)
            self.avOwnDocument.becomeFirstResponder()
            return false
        }
        
        self.studentForm.name = name!
        self.studentForm.cpf = cpf.removeAllOtherCaracters()
        self.studentForm.rg = rg!
        self.studentForm.birthDate = birthDate!
        self.studentForm.father = father!
        self.studentForm.mother = mother!
        
        if self.isOtherStudent {
            
            let name = self.txtDependentName.text
            if name == nil || !name!.contains(" ") || name!.count < 4 {
                self.txtDependentName.setErrorWith(text: "")
                self.txtDependentName.becomeFirstResponder()
                return false
            }
            
            let cpf = self.txtDependentCPF.text ?? ""
            if !Util.validadeCPF(cpf) {
                self.txtDependentCPF.setErrorWith(text: "")
                self.txtDependentCPF.becomeFirstResponder()
                return false
            }
            
            let rg = self.txtDependentRG.text
            if rg == nil || rg!.count < 6 {
                self.txtDependentRG.setErrorWith(text: "")
                self.txtDependentRG.becomeFirstResponder()
                return false
            }
            
            let birthDate = self.txtDependentBirthday.text
            if birthDate == nil || birthDate!.count < 10 {
                self.txtDependentBirthday.setErrorWith(text: "")
                self.txtDependentBirthday.becomeFirstResponder()
                return false
            }
            
            let father = self.txtDependentFather.text
//            if father == nil || !father!.contains(" ") || father!.count < 4 {
//                self.txtDependentFather.setErrorWith(text: "")
//                self.txtDependentFather.becomeFirstResponder()
//                return false
//            }
            
            let mother = self.txtDependentMother.text
            if mother == nil || !mother!.contains(" ") || mother!.count < 4 {
                self.txtDependentMother.setErrorWith(text: "")
                self.txtDependentMother.becomeFirstResponder()
                return false
            }
            
            if  !self.avDependentSelfie.isHidden && !self.avDependentSelfie.hasFiles() {
                self.avDependentSelfie.setError("transport_students_field_needed".localized)
                self.avDependentSelfie.becomeFirstResponder()
                return false
            }
            
            if  !self.avDependentDocument.isHidden && !self.avDependentDocument.hasFiles() {
                self.avDependentDocument.setError("transport_students_field_needed".localized)
                self.avDependentDocument.becomeFirstResponder()
                return false
            }
            
            self.studentForm.dependent = DependentStudent()
            self.studentForm.dependent!.name = name!
            self.studentForm.dependent!.cpf = cpf.removeAllOtherCaracters()
            self.studentForm.dependent!.rg = rg!
            self.studentForm.dependent!.birthDate = birthDate!
            self.studentForm.dependent!.father = father!
            self.studentForm.dependent!.mother = mother!
        }
        
        return true
    }
    
    func validateAddressView() -> Bool {
        
        let cep = self.txtCEP.text
        if cep == nil || cep!.count < 9 {
            self.txtCEP.setErrorWith(text: "")
            self.txtCEP.becomeFirstResponder()
            return false
        }
        
        let street = self.txtStreet.text
        if street == nil || street!.isEmpty {
            self.txtStreet.setErrorWith(text: "")
            self.txtStreet.becomeFirstResponder()
            return false
        }
        
        let number = self.txtNumber.text
        if number == nil || number!.isEmpty {
            self.txtNumber.setErrorWith(text: "")
            self.txtNumber.becomeFirstResponder()
            return false
        }
        
        let district = self.txtDistrict.text
        if district == nil || district!.isEmpty {
            self.txtDistrict.setErrorWith(text: "")
            self.txtDistrict.becomeFirstResponder()
            return false
        }
        
        let city = self.txtCity.text
        if city == nil || city!.isEmpty {
            self.txtCity.setErrorWith(text: "")
            self.txtCity.becomeFirstResponder()
            return false
        }
        
        let state = self.txtState.text
        if state == nil || state!.isEmpty {
            self.txtState.setErrorWith(text: "")
            self.txtState.becomeFirstResponder()
            return false
        }
        
        if  !self.avAddress.isHidden && !self.avAddress.hasFiles() {
            self.avAddress.setError("transport_students_field_needed".localized)
            self.avAddress.becomeFirstResponder()
            return false
        }
        
        self.studentForm.cep = cep!.removeAllOtherCaracters()
        self.studentForm.street = street!
        self.studentForm.district = district!
        self.studentForm.number = number!
        self.studentForm.complement = self.txtComplement.text ?? ""
        self.studentForm.city = city!
        self.studentForm.state = state!
        
        return true
    }
    
    func validateSchoolView() -> Bool {
        
        if self.txtSchoolName.selectedSchool == nil {
            self.txtSchoolName.setErrorWith(text: "")
            self.txtSchoolName.becomeFirstResponder()
            return false
        }
        
        let course = self.txtCourse.text
        if course == nil || course!.isEmpty {
            self.txtCourse.setErrorWith(text: "")
            self.txtCourse.becomeFirstResponder()
            return false
        }
        
        let semester = self.txtSemester.text
        if semester == nil || semester!.isEmpty {
            self.txtSemester.setErrorWith(text: "")
            self.txtSemester.becomeFirstResponder()
            return false
        }
        
        let schoolForm = SchoolForm()
        schoolForm.idSchool = self.txtSchoolName.selectedSchool!.idSchool
        schoolForm.course = course!
        schoolForm.nome = self.txtSchoolName.selectedSchool!.name
        schoolForm.serie = semester!
        
        let ra = self.txtRA.text
        if ra != nil {
            schoolForm.ra = ra!
        }
        
        let schoolClass = self.txtClass.text
        if schoolClass != nil {
            schoolForm.schoolClass = schoolClass!
        }
        
        if self.studentForm.schoolList != nil && !self.studentForm.schoolList!.isEmpty {
            
            for i in 0..<self.studentForm.schoolList!.count {
                if schoolForm.idSchool == self.studentForm.schoolList![i].idSchool {
                    self.studentForm.schoolList?.remove(at: i)
                    break
                }
            }
            
            self.studentForm.schoolList!.append(schoolForm)
        } else if self.studentForm.schoolList == nil {
            self.studentForm.schoolList = [SchoolForm]()
            self.studentForm.schoolList?.append(schoolForm)
        } else {
            self.studentForm.schoolList?.append(schoolForm)
        }
        
        return true
    }
    
    func validateTimeDayView() -> Bool {
        //Validate number
        
        let timeEntrance1 = self.txtTimeEnter1.text ?? ""
        if timeEntrance1.isEmpty {
            self.txtTimeEnter1.setErrorWith(text: "")
            self.txtTimeEnter1.becomeFirstResponder()
            return false
        }
        
        let timeExit1 = self.txtTimeExit1.text ?? ""
        if timeExit1.isEmpty {
            self.txtTimeExit1.setErrorWith(text: "")
            self.txtTimeExit1.becomeFirstResponder()
            return false
        }
         
        let timeEntrance2 = self.txtTimeEnter2.text ?? ""
        let timeExit2 = self.txtTimeExit2.text ?? ""
        if !timeEntrance2.isEmpty && timeExit2.isEmpty {
            self.txtTimeExit2.setErrorWith(text: "")
            self.txtTimeExit2.becomeFirstResponder()
            return false
        }
        
        if !timeExit2.isEmpty && timeEntrance2.isEmpty {
            self.txtTimeEnter2.setErrorWith(text: "")
            self.txtTimeEnter2.becomeFirstResponder()
            return false
        }
        
        let timeEntranceSaturday = self.txtTimeSaturdayEnter1.text ?? ""
        let timeExitSaturday = self.txtTimeSaturdayExit1.text ?? ""
        if !timeEntranceSaturday.isEmpty && timeExitSaturday.isEmpty {
            self.txtTimeSaturdayExit1.setErrorWith(text: "")
            self.txtTimeSaturdayExit1.becomeFirstResponder()
            return false
        }
        
        if !timeExitSaturday.isEmpty && timeEntranceSaturday.isEmpty {
            self.txtTimeSaturdayEnter1.setErrorWith(text: "")
            self.txtTimeSaturdayEnter1.becomeFirstResponder()
            return false
        }
        
        let timeEntranceDes1 = self.txtTimeDesportivaEnter1.text ?? ""
        let timeExitDes1 = self.txtTimeDesportivaExit1.text ?? ""
        if !timeEntranceDes1.isEmpty && timeExitDes1.isEmpty {
            self.txtTimeDesportivaExit1.setErrorWith(text: "")
            self.txtTimeDesportivaExit1.becomeFirstResponder()
            return false
        }
        
        if !timeExitDes1.isEmpty && timeEntranceDes1.isEmpty {
            self.txtTimeDesportivaEnter1.setErrorWith(text: "")
            self.txtTimeDesportivaEnter1.becomeFirstResponder()
            return false
        }
        
        let timeEntranceDes2 = self.txtTimeDesportivaEnter2.text ?? ""
        let timeExitDes2 = self.txtTimeDesportivaExit2.text ?? ""
        if !timeEntranceDes2.isEmpty && timeExitDes2.isEmpty {
            self.txtTimeDesportivaExit2.setErrorWith(text: "")
            self.txtTimeDesportivaExit2.becomeFirstResponder()
            return false
        }
        
        if !timeExitDes2.isEmpty && timeEntranceDes2.isEmpty {
            self.txtTimeDesportivaEnter2.setErrorWith(text: "")
            self.txtTimeDesportivaEnter2.becomeFirstResponder()
            return false
        }
        
        if self.txtLine1.tag == 0 {
            self.txtLine1.setErrorWith(text: "")
            self.txtLine1.becomeFirstResponder()
            return false
        }

        if self.studentForm.classTimeList == nil {
            self.studentForm.classTimeList = [ClassTime]()
        }
        
        //Remove da lista primeiro
        self.studentForm.classTimeList = self.studentForm.classTimeList!.filter() {$0.idTimeType != StudentForm.ID_CLASSTIME_NORMAL}
        var classTime = self.studentForm.findClassTime(id: StudentForm.ID_CLASSTIME_NORMAL)
        if classTime == nil {
            classTime = ClassTime()
            classTime?.idTimeType = StudentForm.ID_CLASSTIME_NORMAL
        }
        
        classTime?.startTimeMorning = timeEntrance1
        classTime?.endTimeMorning = timeExit1
        classTime?.startTimeAfternoon = timeEntrance2
        classTime?.endTimeAfternoon = timeExit2
        //adiciona novamente
        self.studentForm.classTimeList?.append(classTime!)
        
        //Remove da lista primeiro
        self.studentForm.classTimeList = self.studentForm.classTimeList!.filter() {$0.idTimeType != StudentForm.ID_CLASSTIME_SATURDAY}
        var saturdayTime = self.studentForm.findClassTime(id: StudentForm.ID_CLASSTIME_SATURDAY)
        
        //Se houver horario, adiciona novamente
        if !timeEntranceSaturday.isEmpty && !timeExitSaturday.isEmpty {
            
            if saturdayTime == nil {
                saturdayTime = ClassTime()
                saturdayTime?.idTimeType = StudentForm.ID_CLASSTIME_SATURDAY
            }
            
            saturdayTime?.startTimeMorning = timeEntranceSaturday
            saturdayTime?.endTimeMorning = timeExitSaturday
            
            self.studentForm.classTimeList?.append(saturdayTime!)
        }
        
        //Remove da lista primeiro
        self.studentForm.classTimeList = self.studentForm.classTimeList!.filter() {$0.idTimeType != StudentForm.ID_CLASSTIME_DESPORTIVA}
        var desTime = self.studentForm.findClassTime(id: StudentForm.ID_CLASSTIME_DESPORTIVA)
        
        //Se houver horario, adiciona novamente
        if (!timeEntranceDes1.isEmpty && !timeExitDes1.isEmpty) || (!timeEntranceDes2.isEmpty && !timeExitDes2.isEmpty) {
            
            if desTime == nil {
                desTime = ClassTime()
                desTime?.idTimeType = StudentForm.ID_CLASSTIME_DESPORTIVA
            }
            
            desTime?.startTimeMorning = timeEntranceDes1
            desTime?.endTimeMorning = timeExitDes1
            desTime?.startTimeAfternoon = timeEntranceDes2
            desTime?.endTimeAfternoon = timeExitDes2
            
            self.studentForm.classTimeList?.append(desTime!)
        }
        
        self.studentForm.dayList = [Int]()
        if self.ivSegunda.tag == 1 {
            self.studentForm.dayList?.append(1)
        }
        
        if self.ivTerca.tag == 1 {
            self.studentForm.dayList?.append(2)
        }
        
        if self.ivQuarta.tag == 1 {
            self.studentForm.dayList?.append(3)
        }
        
        if self.ivQuinta.tag == 1 {
            self.studentForm.dayList?.append(4)
        }
        
        if self.ivSexta.tag == 1 {
            self.studentForm.dayList?.append(5)
        }

        self.studentForm.lineList = [Int]()
        self.studentForm.lineList?.append(self.txtLine1.tag)
        
        if self.txtLine2.tag != 0 {
            self.studentForm.lineList?.append(self.txtLine2.tag)
        }
        
        if self.txtLine3.tag != 0 {
            self.studentForm.lineList?.append(self.txtLine3.tag)
        }
        
        if self.txtLine4.tag != 0 {
            self.studentForm.lineList?.append(self.txtLine4.tag)
        }

        return true
    }
}

extension StudentsFormViewController {
    
    func findSchoolWithName(name: String) -> School? {
        if self.schools.isEmpty || name.isEmpty {
            return nil
        }
        
        for s in self.schools {
            if s.name.lowercased() == name.lowercased() {
                return s
            }
        }
        
        return nil
    }
    
    func clearSchoolFields() {
        self.txtSchoolName.text = ""
        self.txtCourse.text = ""
        self.txtSemester.text = ""
        self.txtRA.text = ""
        self.txtClass.text = ""
    }
    
    func populateSchoolViews(form: SchoolForm) {
        
        self.txtSchoolName.text = form.nome
        self.txtCourse.text = form.course
        self.txtSemester.text = form.serie
        self.txtRA.text = form.ra
        self.txtClass.text = form.schoolClass
    }
    
    func removeSchoolFromList(school: SchoolForm) {
        if self.studentForm.schoolList == nil || self.studentForm.schoolList!.isEmpty {
            return
        }
        
        var s : SchoolForm
        for i in 0..<self.studentForm.schoolList!.count {
            s = self.studentForm.schoolList![i]
            
            if s.idSchool == school.idSchool {
                self.studentForm.schoolList!.remove(at: i)
                break
            }
        }
    }
    
    func updateStudentSchoolList() {
        self.cvSchoolList.reloadData()
    }
    
    func fillSchoolList(schools: [School]) {
        self.schools = schools
        self.txtSchoolName.setSchoolList(schoolList: schools)
    }
}

extension StudentsFormViewController {
    
    func fillAddress(response: CEPConsultResponse) {
        
        self.txtStreet.text = response.street
        self.txtDistrict.text = response.neighborhood
        self.txtCity.text = response.city
        self.txtState.text = response.uf
    }
    
    func fillBusLineList(lines: [BusLine]) {
        self.busLines = lines
        
        let aux = BusLine()
        aux.name = "Nenhum"
        self.busLines.insert(aux, at: 0)
    }
}

// MARK: Observer Height Collection
extension StudentsFormViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(UICollectionView.contentSize) {
            if let _ = object as? UICollectionView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.collectionHeight!.constant = size.height
                    return
                }
            }
        }
    }
}

// MARK: Delegate Collection - CLICK EVENT
extension StudentsFormViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        //let charade = self.charades[indexPath.row]
        let school = self.studentForm.schoolList![indexPath.row]
        
        self.populateSchoolViews(form: school)
        self.showSchoolView()
    }
}

// Data Collection
extension StudentsFormViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.studentForm.schoolList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! StudentSchoolCell
        let school = self.studentForm.schoolList?[indexPath.row] ?? SchoolForm()
        cell.displayContent(controller: self, delegate: self, school: school)
        
        return cell
    }
}

// MARK: Layout Collection
extension StudentsFormViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: collectionView.frame.width, height: 60)
        return size
    }
}


extension StudentsFormViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.async {
            if param == Param.Contact.DOC_SENT {
                if result {
                    self.studentForm.documentList = object as! [DocumentImage]
                    
                    self.sendForm()
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
                Util.showAlertDefaultOK(self, message: "transport_students_form_sent_amazon_failed".localized)
                return
            }
            
            if param == Param.Contact.STUDENT_ADD_OR_EDIT_FORM_RESPONSE {
                self.showSentView(result: result)
                return
            }
            
            if param == Param.Contact.ADDRESS_CONSULT_CEP_RESPONSE {
                self.dismissPage(nil)
                if result {
                    self.fillAddress(response: object as! CEPConsultResponse)
                }
            }
            
            if param == Param.Contact.STUDENT_SCHOOL_LIST_UPDATE_REQUIRED {
                self.removeSchoolFromList(school: object as! SchoolForm)
                self.updateStudentSchoolList()
                
                if self.studentForm.schoolList!.isEmpty {
                    self.clearSchoolFields()
                    self.showSchoolView()
                }
                return
            }
            
            if param == Param.Contact.STUDENT_BUS_LINE_LIST_RESPONSE {
                let objs = object as! [AnyObject]
                self.onReceiveSchoolsAndLines(lines: objs[1] as! [BusLine], school: objs[0] as! [School])
            }
            
            if param == Param.Contact.STUDENT_FORM_CONSULT_RESPONSE {
                self.onConsultCPF(response: object as? StudentFormStatusResponse)
            }
            
            else if param == Param.Contact.STUDENT_GET_FORM_RESPONSE {
                if result {
                    self.studentForm = object as! StudentForm
                    self.populateViews()
                }
                
                if self.isConsultingOwnCPF {
                    self.showStudentInfoView()
                } else {
                    self.showStudentInfoView()
                    self.dismissPage(nil)
                }
            }
        }
    }
}

extension StudentsFormViewController : SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.textAsListTitle(self.lbSchoolAndCoursesTitle)
        
        Theme.default.textAsListTitle(self.lbSentTitle)
        Theme.default.textAsListTitle(self.lbDependentTitle)
        Theme.default.textAsListTitle(self.lbAlreadySentTitle)
        Theme.default.textAsListTitle(self.lbAlreadyPendentTitle)
        
        Theme.default.textAsMessage(self.lbAlreadySentDesc)
        Theme.default.textAsMessage(self.lbAlreadyPendentDesc)
        Theme.default.textAsMessage(self.lbSchoolAndCoursesDesc)
        Theme.default.textAsMessage(self.lbSentDesc)
        
        Theme.default.orageButton(self.btAddSchool)
        Theme.default.orageButton(self.btBack)
        Theme.default.blueButton(self.btContinue)
        Theme.default.blueButton(self.btIamStudent)
        Theme.default.blueButton(self.btOtherStudent)
        Theme.default.blueButton(self.btOptionTeacher)
        Theme.default.blueButton(self.btOptionStudent)
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "transport_students_toolbar".localized)
        
        self.btBack.setTitle("back".localized)
        self.btContinue.setTitle("continue_label".localized)

        self.avOwnDocument.setName(name: "transport_students_form_user_document".localized)
        self.avOwnSelfie.setName(name: "transport_students_form_user_selfie".localized)
        self.avOwnSelfie.setDesc(desc: "transport_students_form_user_selfie_own_desc".localized)
        
        self.avDependentDocument.setName(name: "transport_students_form_user_document".localized)
        self.avDependentSelfie.setName(name: "transport_students_form_user_selfie".localized)
        self.avDependentSelfie.setDesc(desc: "transport_students_form_user_selfie_dependent_desc".localized)
        
        self.avAddress.setName(name: "transport_students_form_address_document".localized)
        self.avAddress.setDesc(desc: "transport_students_form_address_document_desc".localized)
        self.avEMTU.setName(name: "transport_students_form_emtu_form".localized)
        self.avEMTU.setDesc(desc: "transport_students_form_emtu_form_desc".localized)
    }
    
    
    func setupCollectionView() {
        
        self.cvSchoolList.delegate = self
        self.cvSchoolList.dataSource = self
        
        //  Cell custom
        self.cvSchoolList.register(StudentSchoolCell.nib(), forCellWithReuseIdentifier: "Cell")
        self.cvSchoolList.layer.masksToBounds = true
        
        self.cvSchoolList.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [.new], context: nil)
        self.cvSchoolList.reloadData()
    }
    
    func setupFields() {
        
        self.createPickerView()
        
        self.avOwnDocument.controller = self
        self.avOwnSelfie.controller = self
        self.avDependentDocument.controller = self
        self.avDependentSelfie.controller = self
        self.avAddress.controller = self
        self.avEMTU.controller = self
        
        self.avOwnDocument.tipoAnexo = ActionFinder.Documents.Types.STUDENT_OWN_DOCUMENT
        self.avOwnSelfie.tipoAnexo = ActionFinder.Documents.Types.SELFIE
        self.avDependentDocument.tipoAnexo = ActionFinder.Documents.Types.STUDENT_DEPENDENT_DOCUMENT
        self.avDependentSelfie.tipoAnexo = ActionFinder.Documents.Types.SELFIE
        self.avAddress.tipoAnexo = ActionFinder.Documents.Types.ADDRESS
        self.avEMTU.tipoAnexo = ActionFinder.Documents.Types.FORMULARIO_EMTU
        
        self.txtCEP.formatPattern = "#####-###"
        self.txtOwnCPF.formatPattern = Constants.FormatPattern.Default.CPF.rawValue
        self.txtDependentCPF.formatPattern = Constants.FormatPattern.Default.CPF.rawValue
        self.txtOwnBirthDate.formatPattern = "##/##/####"
        self.txtDependentBirthday.formatPattern = "##/##/####"
        self.txtTimeEnter1.formatPattern = "##:##"
        self.txtTimeEnter2.formatPattern = "##:##"
        self.txtTimeExit1.formatPattern = "##:##"
        self.txtTimeExit2.formatPattern = "##:##"
        self.txtTimeSaturdayEnter1.formatPattern = "##:##"
        self.txtTimeSaturdayExit1.formatPattern = "##:##"
        self.txtTimeDesportivaEnter1.formatPattern = "##:##"
        self.txtTimeDesportivaEnter2.formatPattern = "##:##"
        self.txtTimeDesportivaExit1.formatPattern = "##:##"
        self.txtTimeDesportivaExit2.formatPattern = "##:##"
    }
}
