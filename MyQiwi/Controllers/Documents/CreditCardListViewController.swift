//
//  CreditCardListViewController.swift
//  MyQiwi
//
//  Created by Ailton on 23/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class CreditCardListViewController : UIBaseViewController {

    // MARK: Outlets

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbNoContent: UILabel!
    @IBOutlet weak var lbListDesc: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pendentTableView: UITableView!
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    @IBOutlet weak var heightPendentTableView: NSLayoutConstraint!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var backToHome: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtNickname: MaterialField!
    @IBOutlet weak var viewNickname: UICardView!
    @IBOutlet weak var viewCardList: UICardView!
    @IBOutlet weak var viewPendentCardList: UICardView!
    @IBOutlet weak var viewPendentCardsContainer: UIStackView!
    @IBOutlet weak var viewCreditedValue: UIStackView!
    @IBOutlet weak var lbCreditedValueTitle: UILabel!
    @IBOutlet weak var lbCreditedValueDesc: UILabel!
    @IBOutlet weak var lbCreditedValuePendentListDesc: UILabel!
    @IBOutlet weak var txtCreditedValue: MaterialField!
    @IBOutlet weak var viewBackAndContinueButtons: UIStackView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var backgroundLoading: UIActivityIndicatorView!
    
    @IBAction func sendToHome(_ sender: UIButton ) {
        self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: false, completion: nil)
    }

    var cardImage: UIImage?
    var cardNumber: String?
    var cardName: String?

    // MARK: Ciclo de Vida
    let height = CGFloat(50)
    lazy var creditCardRN = CreditCardRN(delegate: self)
    var pendentAdapter: CreditCardListAdapter?
    var cardsAdapter: CreditCardListAdapter?
    
    var pendentCardToConfirm: CreditCardToken?
    var selectedToken: CreditCardToken?
    
    var isEditingTableView = false
    var isFromPaymentView = false

    override func setupViewDidLoad() {

        self.setupUI()
        self.setupTexts()
        
        self.pendentAdapter = CreditCardListAdapter(self, delegate: self, tableView: self.pendentTableView, heighTable: heightPendentTableView, tokens: [CreditCardToken](), isPendentCard: true, isFromPayment: false)
        self.cardsAdapter = CreditCardListAdapter(self, delegate: self, tableView: self.tableView, heighTable: heightTable, tokens: [CreditCardToken](), isPendentCard: false, isFromPayment: isFromPaymentView)

        self.requestPendentCardList()
    }

    override func setupViewWillAppear() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickButtonBack(_ sender: Any) {
        self.showPendentCreditCardList()
    }
    
    @IBAction func onClickButtonContinue(_ sender: Any) {
        
        if self.validateCreditedValueInput() {
            self.confirmPendentCreditCard()
        }
    }
    
    @IBAction func onClickBack(_ sender: Any) {

        self.isEditingTableView = false

        if let buttons = self.navigationItem.rightBarButtonItems {
            if buttons.count < 2 {
                if !self.isEditingTableView {
                    self.dismissPage(sender)
                    return
                }
            }else {
                self.resetNavigation()
            }
        }
    }

    @IBAction func clickBackOnEditToken(_ sender: Any) {
        self.showCardList()
    }

    let creditCardView = CreditCardPictureViewController()

    @IBAction func btnAdd(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.Segues.READ_CREDIT_CARD, sender: nil)
    }
}

extension CreditCardListViewController {

    @IBAction func scanCard(sender: UIButton) {
        
            self.performSegue(withIdentifier: Constants.Segues.READ_CREDIT_CARD, sender: nil)
//        if UserRN.needToSendDocs() {
//            self.performSegue(withIdentifier: Constants.Segues.SEND_DOCUMENTS, sender: nil)
//        } else {
//            self.performSegue(withIdentifier: Constants.Segues.READ_CREDIT_CARD, sender: nil)
//        }
    }

    @IBAction func saveNickname(sender: UIButton) {
        let nickname = self.txtNickname.text!

        if nickname.count < 3 {
            Util.showAlertDefaultOK(self, message: "credit_card_list_invalid_nickname".localized)
            return
        }

        Util.showLoading(self)
        self.creditCardRN.editToken(cardNumber: self.selectedToken?.digits ?? 0, nickname: nickname)
    }
}

extension CreditCardListViewController {
    
    func validateCreditedValueInput() -> Bool {
        
        if self.txtCreditedValue.text!.removeAllCaractersExceptNumbers().removeAllOtherCaracters().count < 3 {
            Util.showAlertDefaultOK(self, message: "credit_card_validation_credited_value_not_completed".localized)
            return false
        }
        
        return true
    }
    
    func confirmPendentCreditCard() {
        Util.showLoading(self)
        
        let valueString = self.txtCreditedValue.text!.removeAllCaractersExceptNumbers().removeAllOtherCaracters()
        let valueInt = Int(valueString)
        CreditCardRN(delegate: self).validateCreditedValue(cardNumber: String(self.cardNumber!), value: valueInt ?? 0)
    }
}

extension CreditCardListViewController {
    
    @objc func formatCurrency() {
        self.txtCreditedValue.text = self.txtCreditedValue.text?.currencyInputFormatting()
    }
}

extension CreditCardListViewController {
    
    func requestPendentCardList() {
        Util.showLoading(self)
        
        self.viewPendentCardList.isHidden = true
        self.viewNickname.isHidden = true
        self.viewCardList.isHidden = true
        
        self.creditCardRN.getPendentCards()
    }
    
    func requestCardList() {
        UserRN(delegate: self).getUserInfo()
    }
}

extension CreditCardListViewController {
    
    func fillPendentCreditCardList() {
        self.viewPendentCardList.isHidden = true
        
        if self.pendentAdapter == nil || !self.pendentAdapter!.hasTokens() {
            return
        }

        // Mostrar a tabela com os dados
        self.showPendentCreditCardList()
    }
    
    func fillCreditCardList(result: Bool) {
        self.showCardList()

        self.tableView.isHidden = !result
        self.lbListDesc.isHidden = !result
        self.btnAdd.isHidden = false
        self.lbNoContent.isHidden = result
        self.backgroundLoading.isHidden = true
        
        // Mostrar a tabela com os dados
        if self.cardsAdapter != nil && self.cardsAdapter!.hasTokens() {
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}

extension CreditCardListViewController {

    func showCardList() {
        self.viewNickname.isHidden = true
        self.viewCardList.isHidden = false

        self.lbTitle.text = "credit_card_list_title".localized
    }

    func showEditToken() {
        self.viewCardList.isHidden = true
        self.viewNickname.isHidden = false

        self.lbTitle.text = "credit_card_list_edit_token".localized

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.txtNickname.becomeFirstResponder()
        })
    }
    
    func showConfirmCreditCard() {
        self.viewPendentCardList.isHidden = false
        self.viewPendentCardsContainer.isHidden = true
        self.viewCreditedValue.isHidden = false
        self.viewBackAndContinueButtons.isHidden = false
        
        self.txtCreditedValue.becomeFirstResponder()
    }
    
    func showPendentCreditCardList() {
        self.viewPendentCardList.isHidden = false
        self.viewPendentCardsContainer.isHidden = false
        self.viewCreditedValue.isHidden = true
        self.viewBackAndContinueButtons.isHidden = true
    }
}

extension CreditCardListViewController: SetupUI {

    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.blueButton(btnAdd)
        Theme.default.textAsListTitle(self.lbTitle)

        Theme.default.orageButton(self.btnBack)
        Theme.default.orageButton(self.btnCancel)
        Theme.default.greenButton(self.btnSave)
        Theme.default.greenButton(self.btnContinue)
        //Theme.default.textAsMessage(self.lbEmpty)

        self.viewNickname.isHidden = true
        self.backgroundLoading.isHidden = false
        
        self.txtCreditedValue.addTarget(self, action: #selector(formatCurrency), for: .editingChanged)
        
        self.lbCreditedValueTitle.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
        self.lbCreditedValueDesc.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
        self.lbCreditedValuePendentListDesc.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
    }

    func setupTexts() {
        Util.setTextBarIn(self, title: "credit_card_list_toolbar_title".localized)
        self.lbTitle.text = "credit_card_list_title".localized
        self.lbNoContent.text = "credit_card_no_cards".localized
        self.lbListDesc.text = "credit_card_list_info".localized
        self.btnAdd.text("credit_card_list_add_button".localized)
        
        self.btnBack.setText("back".localized)
        self.btnContinue.setText("confirm".localized)
        
        self.lbCreditedValueTitle.text = "credit_card_credited_value_title".localized
        self.lbCreditedValueDesc.text = "credit_card_credited_value_desc".localized
        
        self.lbCreditedValuePendentListDesc.text = "credit_card_list_pendent_desc".localized
    }
}

extension CreditCardListViewController : BaseDelegate {

    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {

        DispatchQueue.main.async {
            
            if fromClass == CreditCardListAdapter.self {
                if param == Param.Contact.LIST_CLICK {
                    let index = object as! Int
                    self.creditCardSelected(index: index)
                }
                
                if param == Param.Contact.CREDIT_CARD_CONFIRM_BUTTON_CLICKED {
                    let creditCard = object as! CreditCardToken
                    
                    self.cardNumber = String(creditCard.digits)
                    self.showConfirmCreditCard()
                }
                
                if param == Param.Contact.CREDIT_CARD_CONFIRM_BUTTON_CLICKED_FROM_PAYMENT {
                    let creditCard = object as! CreditCardToken
                    
                    var token = Token(tokenId: creditCard.tokenId)
                    QiwiOrder.checkoutBody.transition?.token = token
                    
                    self.performSegue(withIdentifier: Constants.Segues.CHECKOUT, sender: nil)
                }
            }
            
            if fromClass == UserRN.self {
                if param == Param.Contact.USER_INFO_RESPONSE {
                    //posteriormente devemos chamar o processo para verificar documentos negados
                    CreditCardRN(delegate: self).getUserCards()
                }
            }

            if fromClass == CreditCardRN.self {
                if param == Param.Contact.CREDIT_CARD_EDIT_TOKEN {
                    self.dismiss(animated: true, completion: nil)

                    if !result {
                        Util.showAlertDefaultOK(self, message: "credit_card_list_edit_failed".localized)
                        return
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        Util.showLoading(self)
                        self.requestCardList()
                    })
                }

                if param == Param.Contact.CREDIT_CARD_LIST_RESPONSE {
                    self.dismiss(animated: true, completion: nil)
                    
                    self.cardsAdapter?.setTokens(tokens: object as! [CreditCardToken])
                    self.fillPendentCreditCardList()
                    self.fillCreditCardList(result: result)
                }

                if param == Param.Contact.CREDIT_CARD_PENDENT_LIST_RESPONSE {
                    
                    if result {
                        self.pendentAdapter?.setTokens(tokens: object as! [CreditCardToken])
                    }
                    
                    self.requestCardList()
                }
                
                if param == Param.Contact.CREDIT_CARD_REMOVE_CARD_RESPONSE {
                    Util.showLoading(self)
                    UserRN(delegate: self).getUserInfo()
                }
                
                //Chamado quando o usuário confirmar o valor
                if param == Param.Contact.CREDIT_CARD_VALIDATE_CREDITED_VAUE {
                    
                    self.dismiss(animated: false)
                    
                    //In case of fail
                    if !result {
                        let response = object as! ServiceResponseDataBool
                        
                        if response.body?.cod == ResponseCodes.USER_BLOCKED {
                            Util.showAlertDefaultOK(self, message: "credit_card_confimation_desc_block".localized, completionOK: {
                                self.backToMainScreen(self)
                            })
                        } else if response.body?.cod == ResponseCodes.RESPONSE_OK {
                            self.txtCreditedValue.setErrorWith(text: "credit_card_credited_value_worng".localized)
                            
                        } else {
                            Util.showAlertDefaultOK(self, message: "credit_card_confimation_failed".localized, completionOK: {
                                self.requestPendentCardList()
                            })
                        }
                    } else {
                        Util.showAlertDefaultOK(self, message: "credit_card_confimation_desc_success".localized, completionOK: {
                            self.requestPendentCardList()
                        })
                    }
                }
            }
        }
    }
}


// MARK: Delegate Table
extension CreditCardListViewController {

    func creditCardSelected(index: Int) {
        self.isEditingTableView = true

        self.resetNavigation()
        self.setItensNavigation(index: index)

        self.selectedToken = self.cardsAdapter?.getToken(index: index) ?? CreditCardToken()
    }
}

// MARK: Actions
extension CreditCardListViewController {

    func resetNavigation() {

        Util.setTextBarIn(self, title: "credit_card_list_toolbar_title".localized)

        DispatchQueue.main.async {

            let icon = UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate)
            let btnClose = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(self.dismissPage(_:)))

            self.navigationItem.setRightBarButtonItems([btnClose], animated: true)

            if !self.isEditingTableView {
                for row in 0...self.cardsAdapter!.getCount() {
                    let indexPath = IndexPath(row: row, section: 0)
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }
            }
        }
    }

    func setItensNavigation(index: Int) {

        let btnEditCard = UIBarButtonItem(title: "toolbar_mnu_edit".localized.uppercased(), style: .plain, target: self, action: #selector(editCard(sender:)))
        btnEditCard.tag = index

        let btnRemoveCard = UIBarButtonItem(title: "toolbar_mnu_remove".localized.uppercased(), style: .plain, target: self, action: #selector(removerCard(sender:)))
        btnRemoveCard.tag = index

        self.navigationItem.title = nil
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiDark)

        DispatchQueue.main.async {

            // Set new config
            self.navigationItem.setRightBarButtonItems([btnRemoveCard,btnEditCard], animated: true)
        }
    }
}

// MARK: Selector
extension CreditCardListViewController {

    @objc func editCard(sender: UIBarButtonItem) {

        self.isEditingTableView = false

        DispatchQueue.main.async {
            self.resetNavigation()
        }

        self.showEditToken()
        self.txtNickname.text = self.selectedToken?.nickname
        self.viewNickname.isHidden = false
    }

    @objc func removerCard(sender: UIBarButtonItem) {

        self.isEditingTableView = false

        Util.showAlertYesNo(self, message: "alert_confirm_remove".localized, completionOK: {

            DispatchQueue.main.async {
                self.removeCard(index: sender.tag)
                self.resetNavigation()
            }
        })
    }
}

extension CreditCardListViewController {

    func removeCard(index: Int) {
        let card = self.cardsAdapter?.getToken(index: index) ?? CreditCardToken()
        CreditCardRN(delegate: self).removeCardAppId(token: card.tokenId)
    }
}
