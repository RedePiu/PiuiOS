//
//  TransportCardSelectViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 20/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

protocol TransportCardDelegate {

    func input(with card: TransportCard, isSaveCard: Bool)
}

class TransportCardListViewController: UIBaseViewController {

    // MARK: Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    @IBOutlet weak var lbHelpCard: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnAddTransportCard: UIButton!

    
    @IBOutlet weak var cvComumForm: UICardView!
    @IBOutlet weak var cvStudentForm: UICardView!
    @IBOutlet weak var lbStudentFormTitle: UILabel!
    @IBOutlet weak var lbStudentFormDesc: UILabel!
    @IBOutlet weak var btnStudentForm: UIButton!
    
    @IBOutlet weak var btnEmmitCard: UIButton!
    @IBOutlet weak var btnVerifySituation: UIButton!
    
    
    // MARK: Variables

    var alreadyAccessAddCard = false
    var isEditingTableView = false
    var addedCard = false
    var saveCard = false
    var sentToConsulting = false
    let height = CGFloat(50)
    var transportCardSelected: TransportCard?

    var transportCards = [TransportCard]()
    lazy var transportCardRN = TransportCardRN(delegate: self)

    // MARK: Ciclo de vida

    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupNib()

        self.tableView.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: [.new], context: nil)
        QiwiOrder.instructionsViewIsHidden = false
    }

    override func setupViewWillAppear() {
        self.loadList()

        if self.sentToConsulting {
            self.dismiss(animated: true, completion: nil)
        }

        if self.addedCard {
            if ApplicationRN.isQiwiBrasil() {
                Util.showLoading(self) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.addedCard = false
                        self.transportCardRN.saveCardOrUpdate(transportCard: self.transportCardSelected!)
                    })
                }
            }

            //Se estiver usando QiwiPRO
            self.updateOrderAndContinue()
        }

        // Sem cartões, vai para adicionar pelo um.
        if self.transportCards.isEmpty {
            if alreadyAccessAddCard {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.alreadyAccessAddCard = true
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.resetNavigation()
    }
}

extension TransportCardListViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {

        DispatchQueue.main.async {
            
            if fromClass == MetrocardRN.self {
                if param == Param.Contact.METROCARD_PRODUCTS_RESPONSE {
                    self.dismissPage(nil)
                    
                    if !result {
                        return
                    }
                    
                    let resp = object as! MetrocardProductsResponse
                    
                    //If has no userId == Card not found
                    if resp.userId == 0 {
                        Util.showAlertDefaultOK(self, message: "metrocard_card_not_found".localized)
                        return
                    }
                    
                    //If has no product == User can't recharge
                    if resp.product?.productId == 0 {
                        Util.showAlertDefaultOK(self, message: "metrocard_cant_recharge".localized)
                        return
                    }
                    
                    QiwiOrder.checkoutBody.requestMetrocard?.userId = resp.userId
                    QiwiOrder.checkoutBody.requestMetrocard?.productId = resp.product?.productId ?? 0
                    QiwiOrder.checkoutBody.requestMetrocard?.unitValue = resp.product?.unitValue ?? 0
                    
                    QiwiOrder.minValue = resp.product?.minValue ?? 0
                    QiwiOrder.maxValue = resp.product?.maxValue ?? 0
                    
                    //ListGenericViewController.stepListGeneric = .SELECT_VALUE
                    self.performSegue(withIdentifier: Constants.Segues.BALANCE_METROCARD, sender: nil)
                    return
                }
            }
            
            if param == Param.Contact.TRANSPORT_CARD_SAVED {
                self.dismiss(animated: true, completion: nil)

                if !result {
                    Util.showAlertDefaultOK(self, message: "transport_save_error".localized, titleOK: "OK", completionOK: {
                            self.updateOrderAndContinue()
                        })
                    return
                }

                self.updateOrderAndContinue()
            }

            if param == Param.Contact.TRANSPORT_CARD_REMOVED {
                self.dismiss(animated: true, completion: nil)
                self.loadList()
            }
        }
    }
}

// MARK: Observer Height Collection
extension TransportCardListViewController {

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == #keyPath(UITableView.contentSize) {
            if let _ = object as? UITableView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.heightTable.constant = size.height + 20

                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    }
                    return
                }
            }
        }

        self.setupHeightTable()
    }
}

// MARK: Segue Identifier
extension TransportCardListViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // Adicionar
        if segue.identifier == Constants.Segues.CARD_ADD {

            // Passa cartão selecionado
            if let cardAddViewController = segue.destination as? TransportCardViewController {
                cardAddViewController.transportCardEdit = self.transportCardSelected
                cardAddViewController.delegateAddTransportCard = self
            }
        }

        if segue.identifier == Constants.Segues.BALANCE_URBS {
            if let vc = segue.destination as? UrbsBalanceListViewController {
                vc.transportCard = self.transportCardSelected!
            }
        }
        
        if segue.identifier == Constants.Segues.BALANCE_METROCARD {
            if let vc = segue.destination as? MetrocardBalanceViewController {
                vc.transportCard = self.transportCardSelected!
            }
        }
        
        if segue.identifier == Constants.Segues.URBS_STATEMENTS {
            if let vc = segue.destination as? UrbsStatementViewController {
                vc.transportCard = self.transportCardSelected!
            }
        }
    }
}

// MARK: Delegate Add TransportCard
extension TransportCardListViewController: TransportCardDelegate {

    func input(with card: TransportCard, isSaveCard: Bool) {

        self.transportCardSelected = card

        if isSaveCard {
            self.addedCard = true
            return
        }

        self.updateOrderAndContinue()
    }
}

// MARK: IBActions
extension TransportCardListViewController {
    @IBAction func btnEmitirClick(_ sender: Any) {
        Constants.fl_verifica_form = false
        self.performSegue(withIdentifier: Constants.Segues.TAXA_HOME, sender: nil)
    }
    
    @IBAction func btnVerificaClick(_ sender: Any) {
        Constants.fl_verifica_form = true
        pushSegueViewController(withIdentifier: "SelectPersonView", name: "TaxaCard")
    }

    @IBAction func onClickSendForm(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segues.STUDENT_HOME, sender: nil)
    }
    
    @IBAction func clickBack(sender: UIButton) {
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

    @IBAction func clickAddTransportCard(sender: UIButton) {
        self.transportCardSelected = nil
        performSegue(withIdentifier: Constants.Segues.CARD_ADD, sender: nil)
    }
}

// MARK: Data Table
extension TransportCardListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transportCards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TransportCardCell

        let index = indexPath.row
        let item = self.transportCards[index]
        cell.item = item

        cell.btnCharge.tag = index
        cell.btnCharge.addTarget(self, action: #selector(rechargeCard(sender:)), for: .touchUpInside)
        cell.btSaldo.addTarget(self, action: #selector(rechargeUrbs(sender:)), for: .touchUpInside)
        cell.btExtrato.addTarget(self, action: #selector(statementClick(sender:)), for: .touchUpInside)

        self.setupHeightTable()

        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        //return self.height
        return 60
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}


// MARK: Delegate Table
extension TransportCardListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isEditingTableView = true
        self.resetNavigation()
        self.setItensNavigation(indexPath: indexPath)
    }
}

// MARK: Selector
extension TransportCardListViewController {
    @objc func rechargeCard(sender: UIButton) {
        self.transportCardSelected = self.transportCards[sender.tag]
        self.updateOrderAndContinue()
    }

    @objc func rechargeUrbs(sender: UIButton) {
        self.transportCardSelected = self.transportCards[sender.tag]
        let segue = QiwiOrder.isUrbsCharge() ? Constants.Segues.BALANCE_URBS : Constants.Segues.BALANCE_METROCARD
        performSegue(withIdentifier: segue, sender: nil)
    }

    @objc func statementClick(sender: UIButton) {
        self.transportCardSelected = self.transportCards[sender.tag]
        performSegue(withIdentifier: Constants.Segues.URBS_STATEMENTS, sender: nil)
    }

    @objc func editCard(sender: UIBarButtonItem) {
        self.isEditingTableView = false
        self.transportCardSelected = self.transportCards[sender.tag]
        performSegue(withIdentifier: Constants.Segues.CARD_ADD, sender: nil)
    }

    @objc func removerCard(sender: UIBarButtonItem) {

        self.isEditingTableView = false

        Util.showAlertYesNo(self, message: "alert_confirm_remove".localized, completionOK: {

            DispatchQueue.main.async {
                self.removeCard(index: sender.tag)
                self.resetNavigation()

                // Sem cartões, vai para adicionar pelo um.
                if self.transportCards.isEmpty {
                    self.transportCardSelected = nil
                    self.performSegue(withIdentifier: Constants.Segues.CARD_ADD, sender: nil)
                }
            }
        })
    }
}

// MARK: Actions
extension TransportCardListViewController {
    func resetNavigation() {
        Util.setTextBarIn(self, title: "transport_toolbar_title_nav".localized)

        DispatchQueue.main.async {
            let icon = UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate)
            let btnClose = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(self.dismissPage(_:)))
            self.navigationItem.setRightBarButtonItems([btnClose], animated: true)

            if !self.isEditingTableView {
                for row in 0...self.transportCards.count {
                    let indexPath = IndexPath(row: row, section: 0)
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }
            }
        }
    }

    func setItensNavigation(indexPath: IndexPath) {

        let btnEditCard = UIBarButtonItem(title: "toolbar_mnu_edit".localized.uppercased(), style: .plain, target: self, action: #selector(editCard(sender:)))
        btnEditCard.tag = indexPath.row

        let btnRemoveCard = UIBarButtonItem(title: "toolbar_mnu_remove".localized.uppercased(), style: .plain, target: self, action: #selector(removerCard(sender:)))
        btnRemoveCard.tag = indexPath.row

        self.navigationItem.title = nil
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiDark)

        DispatchQueue.main.async {
            // Set new config
            self.navigationItem.setRightBarButtonItems([btnRemoveCard,btnEditCard], animated: true)
        }
    }
}

// MARK: SetupUI
extension TransportCardListViewController: SetupUI {

    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.blueButton(self.btnAddTransportCard)
        Theme.default.blueButton(self.btnStudentForm)
        Theme.default.blueButton(self.btnEmmitCard)
        Theme.default.blueButton(self.btnVerifySituation)
        Theme.default.textAsListTitle(self.lbTitle)
        self.lbHelpCard.setupMessageNormal()
        self.lbStudentFormDesc.setupMessageNormal()
        
        self.cvStudentForm.isHidden = ApplicationRN.isQiwiPro() || QiwiOrder.selectedMenu.prvID != ActionFinder.Transport.Prodata.RapidoTaubate.CIDADAO
        self.cvComumForm.isHidden = ApplicationRN.isQiwiPro() || QiwiOrder.selectedMenu.prvID != ActionFinder.Transport.Prodata.Caieiras.COMUM || QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.SantanadeParnaiba.COMUM || QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.SantanadeParnaiba.ESCOLAR
        
        showCardCopyView()
    }
    
    private func showCardCopyView() {
        switch QiwiOrder.selectedMenu.prvID {
        case ActionFinder.Transport.Prodata.Caieiras.COMUM,
             ActionFinder.Transport.Prodata.Caieiras.ESCOLAR,
             ActionFinder.Transport.Prodata.Osasco.COMUM,
             ActionFinder.Transport.Prodata.Osasco.ESCOLAR,
             ActionFinder.Transport.Prodata.Cajamar.ESCOLAR,
             ActionFinder.Transport.Prodata.Cajamar.COMUM,
             ActionFinder.Transport.Prodata.FrancodaRocha.ESCOLAR,
             ActionFinder.Transport.Prodata.FrancodaRocha.COMUM,
            ActionFinder.Transport.Prodata.SantanadeParnaiba.ESCOLAR,
            ActionFinder.Transport.Prodata.SantanadeParnaiba.COMUM:
            self.cvComumForm.isHidden = false
        default: break
        }
    }

    func setupTexts() {
        self.lbTitle.text = "transport_choose_card".localized
        self.lbHelpCard.text = "transport_card_touch_to_edit".localized
        self.btnAddTransportCard.setTitle("transport_recharge_another".localized, for: .normal)

        self.lbStudentFormTitle.text = "transport_students_cardlist_title".localized
        self.lbStudentFormDesc.text = "transport_students_cardlist_desc".localized
        
        self.btnEmmitCard.setTitle("transport_card_btn_emit_card_title".localized, for: .normal)
        self.btnVerifySituation.setTitle("transport_card_btn_verify_situation_title".localized, for: .normal)
        
        Util.setTextBarIn(self, title: QiwiOrder.selectedMenu.desc)
    }

    func setupNib() {
        self.tableView.register(TransportCardCell.nib(), forCellReuseIdentifier: "Cell")
    }

    func setupHeightTable() {
        self.heightTable.constant = self.tableView.contentSize.height + 20
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension TransportCardListViewController {

    func updateOrderAndContinue() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            if QiwiOrder.isTransportRecharge() {
                QiwiOrder.checkoutBody.requestTransport?.cardNumber = Int(self.transportCardSelected!.number)
                ListGenericViewController.stepListGeneric = .SELECT_TRANSPORT_RECHARGE_TYPE
            }
            else if QiwiOrder.isTransportCittaMobiRecharge() {
                QiwiOrder.checkoutBody.requestTransportCittaMobi?.cardNumber =  Int(self.transportCardSelected!.number)
                ListGenericViewController.stepListGeneric = .SELECT_TRANSPORT_CITTAMOBI_RECHARGE_TYPE
            }
            else if QiwiOrder.isTransportProdataRecharge() {
                QiwiOrder.checkoutBody.requestProdata?.cardNumber = Int(self.transportCardSelected!.number)
                ListGenericViewController.stepListGeneric = .SELECT_TRANSPORT_PRODATA_RECHARGE_TYPE
            }
            else if QiwiOrder.isUrbsCharge() {
                QiwiOrder.checkoutBody.requestUrbs?.cardNumber = self.transportCardSelected!.number
                ListGenericViewController.stepListGeneric = .SELECT_TRANSPORT_URBS_RECHARGE_TYPE
            }
            //Metrocard has to be consulted before send to list
            else if QiwiOrder.isMetrocardRecharge() {
                QiwiOrder.checkoutBody.requestMetrocard?.card = self.transportCardSelected!.number
                QiwiOrder.checkoutBody.requestMetrocard?.cpf = self.transportCardSelected!.cpf
                
                self.requestMetrocardConsult()
                return
            }

            self.sentToConsulting = true
            self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
        }
    }

    func removeCard(index: Int) {
        Util.showLoading(self) {
            self.transportCardRN.removeCard(transportCard: self.transportCards[index])
        }
    }
    
    func requestMetrocardConsult() {
        Util.showLoading(self)
        MetrocardRN(delegate: self).consultCard(cpf: self.transportCardSelected!.cpf, card: self.transportCardSelected!.number)
    }

    func loadList() {
        let type = QiwiOrder.getTransportCardtype()
        self.transportCards = self.transportCardRN.getSavedCards(type: type)
        self.tableView.reloadData()
    }
}
