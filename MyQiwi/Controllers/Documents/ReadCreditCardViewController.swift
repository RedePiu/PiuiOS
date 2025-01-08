//
//  ReadCreditCardViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 24/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit
import CreditCardForm
import IQKeyboardManagerSwift

protocol CreditCardPictureDlegate {
    
    func passImage(image: UIImage)
    func stepPictureForward()
    func stepPictureBackward()
}

protocol VideoAgreementDlegate {
    
    func passVideo(videoPath: URL)
    func stepVideoForward()
    func stepVideoBackward()
}

class ReadCreditCardViewController: UIBaseViewController {
    
    @IBOutlet weak var viewScroll: UIScrollView!
    @IBOutlet weak var viewList: UIView!
    @IBOutlet weak var viewCreditCardForm: UIView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewNumber: UICardView!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewExpiry: UIView!
    @IBOutlet weak var viewCode: UIView!
    @IBOutlet weak var viewNickname: UICardView!
    @IBOutlet weak var viewCreditedValue: UICardView!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var stackButtons: UIStackView!
    @IBOutlet weak var collectionCard: UICollectionView!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbStatusDesc: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var txtNumber: MaterialField!
    @IBOutlet weak var txtNameCard: MaterialField!
    @IBOutlet weak var txtExpiryCard: MaterialField!
    @IBOutlet weak var txtCodeCard: MaterialField!
    @IBOutlet weak var txtNickname: MaterialField!
    @IBOutlet weak var creditCardView: CreditCardFormView!
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbCreditedValueTitle: UILabel!
    @IBOutlet weak var lbCreditedValueDesc: UILabel!
    @IBOutlet weak var lbCreditedValueDevolution: UILabel!
    @IBOutlet weak var txtCreditedValue: MaterialField!
    
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    var availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
    var videoCaptured = AVCaptureVideoDataOutput()
    var captureSession = AVCaptureSession()
    
    var typeCards: [CreditCard] = [CreditCard(brand: ActionFinder.CreditCard.BRAND_VISA, cardNumber: ""),
                                   CreditCard(brand: ActionFinder.CreditCard.BRAND_MASTER, cardNumber: ""),
                                   CreditCard(brand: ActionFinder.CreditCard.BRAND_ELO, cardNumber: "")]
    
    var stepCreditCard = Constants.StepReadCreditCard.LIST
    var creditCard = CreditCard()
    var cardNumber: String?
    var keyboardFrame: CGRect?
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        self.editActionsTextFieds()
        
        // Nib
        self.collectionCard.register(BigImageCell.nib(), forCellWithReuseIdentifier: BigImageCell.Identifier())
        
        // ContentSize TableView
        self.collectionCard.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [.new], context: nil)
        self.collectionCard.layer.masksToBounds = false
        
        //
        creditCardView.cardHolderString = self.creditCard.ownerName
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
        self.changeLayout()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func setupViewWillAppear() {
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Reset default
        IQKeyboardManager.shared.keyboardDistanceFromTextField = Constants.keyboardDistanceFromTextField
        self.resetNavigation()
    }
    
    func updateCardInfo() {
        self.creditCardView.paymentCardTextFieldDidChange(cardNumber: self.creditCard.cardNumber, expirationYear: UInt(self.creditCard.getCardExpiryYear()), expirationMonth: UInt(self.creditCard.getCardExpiryMonth()), cvc: self.creditCard.cvv)
    }
    
    @IBAction func unwindToReadCreditCard(_ sender: UIStoryboardSegue) {
        
    }
}

extension ReadCreditCardViewController {
    
    func sendCreditCard() {
        
        self.btnBack.isHidden = true
        self.btnContinue.isEnabled = false
        
        Util.showLoading(self)
        CreditCardRN(delegate: self).sendCreditCard(creditCard: self.creditCard)
    }
    
    func sendCreditedValue() {
        
        Util.showLoading(self)
        
        let valueInt = Int(self.txtCreditedValue.text!.removeAllCaractersExceptNumbers().removeAllOtherCaracters())
        CreditCardRN(delegate: self).validateCreditedValue(cardNumber: String(self.cardNumber!), value: valueInt ?? 0)
    }
}

// MARK: Observer Height Collection
extension ReadCreditCardViewController {
    
    
    func resetNavigation() {
        
        Util.setTextBarIn(self, title: "credit_card_add_title".localized)
        DispatchQueue.main.async {
            
            let icon = UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate)
            let btnClose = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(self.dismissPage(_:)))
            
            self.navigationItem.setRightBarButtonItems([btnClose], animated: true)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(UICollectionView.contentSize) {
            if let _ = object as? UICollectionView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.height.constant = size.height
                    return
                }
            }
        }
        
        self.height.constant = self.collectionCard.contentSize.height
    }
}

extension ReadCreditCardViewController {
    
    @IBAction func clickBack(sender: UIButton) {
        
        // Para edição da textField
        self.view.endEditing(true)
        
        if self.stepCreditCard == .LIST || self.stepCreditCard == .CREDITED_VALUE {
            self.popPage()
            return
        }
        
        //Se tiver no vídeo, volta dois. Não volta direto para a câmera.
        self.stepBackward()
    }
    
    @IBAction func clickContinue(sender: UIButton) {
        
        // Para edição da textField
        self.view.endEditing(true)
        
        if !self.viewLoading.isHidden {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        if !self.validateLayout() {
            return
        }
        
        if self.stepCreditCard == .NICKNAME {
            self.sendCreditCard()
            return
        }
        
        if self.stepCreditCard == .CREDITED_VALUE {
            self.sendCreditedValue()
            return
        }
        
        //Se já tiver imagem, pulamos o passo da câmera.
        self.stepForward()
    }
    
    func stepForward() {
        let continueCount = self.stepCreditCard == .NICKNAME && self.creditCard.image != nil ? 2 : 1
        let nextStep = self.stepCreditCard.rawValue + continueCount
        if let newStep = Constants.StepReadCreditCard(rawValue: nextStep) {
            self.selectStep(step: newStep)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func stepBackward() {
        let backCount = 1
        let backStep = self.stepCreditCard.rawValue - backCount
        if let newStep = Constants.StepReadCreditCard(rawValue: backStep) {
            self.selectStep(step: newStep)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

//extension ReadCreditCardViewController: STPPaymentCardTextFieldDelegate {
//    
//    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
//        creditCardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: textField.expirationYear, expirationMonth: textField.expirationMonth, cvc: textField.cvc)
//    }
//    
//    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
//        creditCardView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: textField.expirationYear)
//    }
//    
//    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
//        creditCardView.paymentCardTextFieldDidBeginEditingCVC()
//    }
//    
//    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
//        creditCardView.paymentCardTextFieldDidEndEditingCVC()
//    }
//}

extension ReadCreditCardViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionCard.frame.width - (CGFloat(2) * 10)) / 2, height: 130)
    }
}

extension ReadCreditCardViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return typeCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigImageCell.Identifier(), for: indexPath) as? BigImageCell else {
            return UICollectionViewCell.init(frame: .zero)
        }
        
        let creditCard = typeCards[indexPath.row]
        var imageString = ""
        
        if creditCard.brand == ActionFinder.CreditCard.BRAND_VISA {
            imageString = "ic_visa_blue"
        }else if creditCard.brand == ActionFinder.CreditCard.BRAND_MASTER {
            imageString = "ic_billing_mastercard_logo"
        }else if creditCard.brand == ActionFinder.CreditCard.BRAND_ELO {
            imageString = "ic_elo"
        }
        
        cell.displayContent(image: imageString)
        
        return cell
    }
}

extension ReadCreditCardViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.creditCard.setBrand(brand: self.typeCards[indexPath.row].brand)
        
        // Aplicar textos no credit card view
        self.updateCardInfo()
        
        // Avançar step
        self.selectStep(step: .NUMBER)
    }
}

extension ReadCreditCardViewController {
    
    func editActionsTextFieds() {
        self.txtNumber.addTarget(self, action: #selector(changeNumber(_:)), for: .editingChanged)
        self.txtNameCard.addTarget(self, action: #selector(changeName(_:)), for: .editingChanged)
        self.txtNickname.addTarget(self, action: #selector(changeNickname(_:)), for: .editingChanged)
        self.txtCodeCard.addTarget(self, action: #selector(changeCode(_:)), for: .editingChanged)
        self.txtExpiryCard.addTarget(self, action: #selector(changeExpiry(_:)), for: .editingChanged)
        self.txtCreditedValue.addTarget(self, action: #selector(formatCurrency), for: .editingChanged)
    }
    
    @objc func formatCurrency() {
        self.txtCreditedValue.text = self.txtCreditedValue.text?.currencyInputFormatting()
    }
    
    @objc func changeNumber(_ textField: UITextField) {
        
        self.creditCard.cardNumber = textField.text?.removeAllOtherCaracters() ?? ""
        
        DispatchQueue.main.async {
            self.updateCardInfo()
        }
    }
    
    @objc func changeName(_ textField: UITextField) {
        
        self.creditCard.ownerName = textField.text ?? ""
        
        DispatchQueue.main.async {
            self.creditCardView.cardHolderString = self.creditCard.ownerName
        }
    }
    
    @objc func changeNickname(_ textField: UITextField) {
        
        self.creditCard.nickname = textField.text ?? ""
    }
    
    @objc func changeExpiry(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        let split = text.split(separator: "/")
        if split.isEmpty { return }
        
        let newDate = split.first! + "/20" + split.last!
        self.creditCard.validate = String(newDate)
        
        DispatchQueue.main.async {
            self.updateCardInfo()
        }
    }
    
    @objc func changeCode(_ textField: UITextField) {
        
        self.creditCard.cvv = textField.text ?? ""
        
        // Ativar edição do CVC
        DispatchQueue.main.async {
            self.updateCardInfo()
        }
    }
}

// MARK: Selectors
extension ReadCreditCardViewController {
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        if #available(iOS 11, *) {
            self.bottomLayoutConstraint.constant = keyboardFrame.height - self.view.safeAreaInsets.bottom
        } else {
            self.bottomLayoutConstraint.constant = keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.bottomLayoutConstraint.constant = 0
    }
}

extension ReadCreditCardViewController: SetupUI {
    
    func setupUI() {
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.backgroundCard(self)
        Theme.default.orageButton(self.btnBack)
        Theme.default.blueButton(self.btnContinue)
        
        self.lbStatus.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
        self.lbStatusDesc.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
        self.lbCreditedValueTitle.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
        
        self.lbCreditedValueDesc.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
        self.lbCreditedValueDevolution.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
    }
    
    func setupTexts() {
        self.txtNameCard.placeholder = "credit_card_name_title_hint".localized
        self.txtExpiryCard.placeholder = "credit_card_validate_hint".localized
        self.txtCodeCard.placeholder = "credit_card_cvv_hint".localized
        self.txtNickname.placeholder = "credit_nickname_hint".localized
        
        self.txtNumber.formatPattern = Constants.FormatPattern.CreditCard.NUMBER.rawValue
        self.txtExpiryCard.formatPattern = Constants.FormatPattern.CreditCard.EXPIRY.rawValue
        self.txtCodeCard.formatPattern = Constants.FormatPattern.CreditCard.CVV.rawValue
        
        self.txtNumber.setLenght(19)
        self.txtExpiryCard.setLenght(5)
        self.txtCodeCard.setLenght(4)
        
        self.lbCreditedValueTitle.text = "credit_card_credited_value_title".localized
        self.lbCreditedValueDevolution.text = "credit_card_confimation_devolution".localized
        self.txtCreditedValue.placeholder = "credit_card_credited_value".localized
        
        Util.setTextBarIn(self, title: "credit_card_add_title".localized)
    }
}

extension ReadCreditCardViewController {
    
    func hideAll() {
        self.lbTitle.isHidden = true
        self.viewList.isHidden = true
        self.viewCreditCardForm.isHidden = true
        self.viewBack.isHidden = true
        self.viewNumber.isHidden = true
        self.viewName.isHidden = true
        self.viewExpiry.isHidden = true
        self.viewCode.isHidden = true
        self.viewNickname.isHidden = true
        self.viewLoading.isHidden = true
        self.viewCreditedValue.isHidden = true
        
        self.stackButtons.isHidden = true
    }
    
    func selectStep(step: Constants.StepReadCreditCard) {
        self.stepCreditCard = step
        self.changeLayout()
    }
    
    func validateLayout() -> Bool {
        
        var text = ""
        
        switch self.stepCreditCard {
            
        case .NUMBER:
            text = self.txtNumber.text!.removeAllOtherCaracters()
            
            if text.count < 16 {
                Util.showAlertDefaultOK(self, message: "credit_card_validation_card_number_not_completed".localized)
                return false
            }
            
        case .NAME:
            text = self.txtNameCard.text!
            
            if !text.containsSpace() || text.count < 6 {
                Util.showAlertDefaultOK(self, message: "credit_card_validation_owner_name_not_completed".localized)
                return false
            }
            
        case .EXPIRY:
            text = self.txtExpiryCard.text!.removeAllOtherCaracters()
            
            if text.count < 4 {
                Util.showAlertDefaultOK(self, message: "credit_card_validation_validate_not_completed".localized)
                return false
            }
            
        case .CVC:
            text = self.txtCodeCard.text!
            
            if text.count < 3 {
                Util.showAlertDefaultOK(self, message: "credit_card_validation_cvv_not_completed".localized)
                return false
            }
            
        case .CREDITED_VALUE:
            text = self.txtCreditedValue.text!.removeAllCaractersExceptNumbers().removeAllOtherCaracters()
            
            if text.count < 3 {
                Util.showAlertDefaultOK(self, message: "credit_card_validation_credited_value_not_completed".localized)
                return false
            }
            
        default:
            return true
        }
        
        return true
    }
    
    func changeLayout() {
        
        DispatchQueue.main.async {
            
            self.hideAll()
            
            switch self.stepCreditCard {
            case .LIST:
                self.lbTitle.isHidden = false
                self.viewList.isHidden = false
                self.viewBack.isHidden = false
                
            case .NUMBER:
                
                self.stackButtons.isHidden = false
                
                Theme.default.blueButton(self.btnContinue)
                
                self.viewCreditCardForm.isHidden = false
                self.viewNumber.isHidden = false
                self.txtNumber.becomeFirstResponder()
                
            case .NAME:
                
                self.stackButtons.isHidden = false
                
                Theme.default.blueButton(self.btnContinue)
                
                self.viewCreditCardForm.isHidden = false
                self.viewName.isHidden = false
                self.txtNameCard.becomeFirstResponder()
                
            case .EXPIRY:
                
                self.stackButtons.isHidden = false
                self.creditCardView.paymentCardTextFieldDidEndEditingCVC()
                
                Theme.default.blueButton(self.btnContinue)
                
                self.viewCreditCardForm.isHidden = false
                self.viewExpiry.isHidden = false
                self.txtExpiryCard.becomeFirstResponder()
                
            case .CVC:
                
                self.stackButtons.isHidden = false
                
                Theme.default.blueButton(self.btnContinue)
                
                self.viewCreditCardForm.isHidden = false
                self.viewCode.isHidden = false
                self.txtCodeCard.becomeFirstResponder()
                
                // Ativar edição do CVC
                DispatchQueue.main.async {
                    self.creditCardView.paymentCardTextFieldDidBeginEditingCVC()
                    self.updateCardInfo()
                }
                
            case .NICKNAME:
                self.stackButtons.isHidden = false
                self.creditCardView.paymentCardTextFieldDidEndEditingCVC()
                
                Theme.default.blueButton(self.btnContinue)
                
                self.viewCreditCardForm.isHidden = false
                self.viewNickname.isHidden = false
                self.txtNickname.becomeFirstResponder()
                
            case .CREDITED_VALUE:
                self.stackButtons.isHidden = false
                
                self.viewCreditCardForm.isHidden = false
                self.viewCreditedValue.isHidden = false
                self.btnBack.isHidden = true
                
                self.txtCreditedValue.becomeFirstResponder()
                
                Theme.default.greenButton(self.btnContinue)
            }
        }
    }
}

extension ReadCreditCardViewController {
    
    func setupStatusView() {
        // Config inicial
        self.stackButtons.isHidden = false
        
        self.viewCreditCardForm.isHidden = false
        self.viewLoading.isHidden = false
        self.btnBack.isHidden = true
        self.btnContinue.isEnabled = true
        
        Theme.default.greenButton(self.btnContinue)
    }
    
    func showAddedFailed() {
        //Hide views an setup the status view before change texts
        self.hideAll()
        self.setupStatusView()
        
        self.imgStatus.image = UIImage(named: "ic_red_error")
        
        self.lbStatus.text = "credit_card_confimation_failed".localized
        self.lbStatusDesc.text = "credit_card_confimation_desc_failed".localized
    }
    
    func showAddedBlocked() {
        //Hide views an setup the status view before change texts
        self.hideAll()
        self.setupStatusView()
        
        self.imgStatus.image = UIImage(named: "ic_red_error")
        
        self.lbStatus.text = "credit_card_confimation_failed".localized
        self.lbStatusDesc.text = "credit_card_confimation_desc_block".localized
    }
    
    func showAddedSuccess() {
        //Hide views an setup the status view before change texts
        self.hideAll()
        self.setupStatusView()
        
        self.imgStatus.image = UIImage(named: "ic_green_done")
        
        self.lbStatus.text = "credit_card_confimation_success".localized
        self.lbStatusDesc.text = "credit_card_confimation_desc_success".localized
    }
}

extension ReadCreditCardViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension ReadCreditCardViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            
            //Chamado após cadastrar o cartão
            if param == Param.Contact.CREDIT_SEND_CREDITCARD_RESPONSE {

                self.dismiss(animated: true)
                self.btnContinue.isEnabled = true
                
                if result {
                    self.cardNumber = String(object as! Int)
                    self.selectStep(step: .CREDITED_VALUE)
                } else {
                    self.showAddedFailed()
                }
            }
            
            //Chamado quando o usuário confirmar o valor
            if param == Param.Contact.CREDIT_CARD_VALIDATE_CREDITED_VAUE {
                
                self.dismiss(animated: false)
                
                //In case of fail
                if !result {
                    let response = object as! ServiceResponseDataBool
                    
                    if response.body?.cod == ResponseCodes.USER_BLOCKED {
                        self.showAddedBlocked()
                    } else if response.body?.cod == ResponseCodes.RESPONSE_OK {
                        self.txtCreditedValue.setErrorWith(text: "credit_card_credited_value_worng".localized)
                    } else {
                        self.showAddedFailed()
                    }
                } else {
                    self.showAddedSuccess()
                }
            }
        }
        )}
}
