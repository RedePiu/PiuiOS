//
//  ListGenericViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 11/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

protocol IPopupStatus {
    func popupClosed()
}

class ListGenericViewController: UIBaseViewController, IPopupStatus {

    // MARK: Outlets

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!

    @IBOutlet weak var viewList: UIView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewInserValue: UIView!

    @IBOutlet weak var txtPrice: MaterialField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lbInfoLimitPrice: UILabel!
    @IBOutlet weak var imgHelpIcon: UIImageView!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollection: NSLayoutConstraint!

    @IBOutlet weak var viewNoContent: UIStackView!
    @IBOutlet weak var lbNoContent: UILabel!

    // Loading
    @IBOutlet weak var viewLoading: UIView!

    // MARK: Variables
    public static var stepListGeneric: Constants.StepListGeneric = .SELECT_OPERATOR
    var balance: Int = 0
    var prePagoBalance: Int = -2
    var transportType: String = ""
    var minValue: Int = 0
    var maxValue: Int = 0
    var needBack = false
    var alreadyInCheckout = false
    var mapPointType = 0

    lazy var menuItemDataHandler = MenuItemDataHandler(delegate: self)
    lazy var operatorValuesDataHandler = OperatorValuesDataHandler(delegate: self)

    // MARK: Ciclo de vida

    override func setupViewDidLoad() {

        self.setupUI()
        self.setupTexts()
        self.setupTextFields()
        self.setupCollectionView()
        self.changeLayout()
        self.collectionView.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [.new], context: nil)
    }

    override func setupViewWillAppear() {

        if self.alreadyInCheckout {
            self.clickBackFunc()
        }
    }

    func popupClosed() {
        if self.needBack {
            self.needBack = false

            self.dismissPageAfter(after: 0.8)
        }
    }
}

// MARK: Observer Height Collection
extension ListGenericViewController {

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == #keyPath(UICollectionView.contentSize) {
            if let _ = object as? UICollectionView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.heightCollection.constant = size.height
                    return
                }
            }
        }

        self.heightCollection.constant = self.collectionView.contentSize.height
    }
}

// MARK: IBActions
extension ListGenericViewController {


    @IBAction func clickBack(sender: UIButton) {
        clickBackFunc()
    }

    @IBAction func closeScreen(sender: UIButton ) {
        self.view.endEditing(true)
        self.dismiss(animated: false)
        self.navigationController?.presentingViewController?.dismiss(animated: false)
    }

    func clickBackFunc() {
        switch ListGenericViewController.stepListGeneric {
        case .SELECT_OPERATOR:
            self.dismissPage(nil)
            break
        case .SELECT_OPERATOR_VALUE:
            if QiwiOrder.phoneContactSelected != nil && QiwiOrder.phoneContactSelected?.serverpk != 0 && !(QiwiOrder.phoneContactSelected?.op!.isEmpty)! {
                self.dismissPage(nil)
            } else {
                self.selectStep(step: .SELECT_OPERATOR)
            }

            break
        case .SELECT_TRANSPORT_URBS_RECHARGE_TYPE: fallthrough
        case .SELECT_TRANSPORT_CITTAMOBI_RECHARGE_TYPE: fallthrough
        case .SELECT_TRANSPORT_PRODATA_RECHARGE_TYPE: fallthrough
        case .SELECT_TRANSPORT_RECHARGE_TYPE:
            self.dismissPage(nil)
            //self.backToMainScreen(nil)
            break
        case .SELECT_TRANSPORT_WHERE_WILL_USE:
            self.selectStep(step: .SELECT_TRANSPORT_RECHARGE_TYPE)
            break
        case .SELECT_VALUE:
            if QiwiOrder.isTransportRecharge() {
                self.selectStep(step: .SELECT_TRANSPORT_RECHARGE_TYPE)
            }
            else {
                self.dismissPage(nil)
            }
            break
        case .SELECT_BANK:
            self.selectStep(step: .SELECT_PAYMENT)
            break

            //Caso seleciono metodos de pagamento
        //Devemos verificar qual recarga estamos fazendo para voltar a lista certa (se houver)
        case .SELECT_PAYMENT:
            //Se for recarga de telefone, devemos voltar para a lista de valores das operadoras
            if QiwiOrder.isPhoneRecharge() {
                self.selectStep(step: .SELECT_OPERATOR_VALUE)
            }
            else if QiwiOrder.isTransportRecharge() && !QiwiOrder.isBilheteUnicoComum() {
                dismiss(animated: true, completion: nil)
            }
            else if QiwiOrder.isTransportRecharge() {
                self.selectStep(step: .SELECT_VALUE)
            }
            else if (QiwiOrder.isClickBus()) {
                ClickBusBaseViewController.backwardStep()
                self.dismissPage(nil)
            }else {
                self.dismissPage(nil)
            }
            break
        }
    }

    @IBAction func clickContinue(sender: UIButton) {

        let textPrice = self.txtPrice.text?.removeAllCaractersExceptNumbers().removeAllOtherCaracters()
        let value = Int(textPrice!)

        if value! < self.minValue || value! > self.maxValue {
            showError(message: "select_value_out_of_limit".localized)
            return
        }

        QiwiOrder.setTransitionAndValue(value: value!)
        //Se for qiwi transfer, nao existe método de pagamento
        if QiwiOrder.isQiwiTransfer() || QiwiOrder.isQiwiTransferToPrePago() {
            self.validateLimitAndCallUpdateQiwiBalance()
            return
        }

        self.selectStep(step: .SELECT_PAYMENT)
    }

    func validateLimitAndCallUpdateQiwiBalance() {
        let limit = PaymentRN(delegate: self).getPaymentLimit(prvid: QiwiOrder.getPrvID(), paymentMethod: ActionFinder.Payments.QIWI_BALANCE)
        let value = QiwiOrder.checkoutBody.transition?.value

        if (value ?? 0 < limit.minValue || value ?? 0 > limit.maxValue) {
            Util.showAlertDefaultOK(self, message: "credit_qiwi_out_of_limit".localized
                .replacingOccurrences(of: "{min}", with: Util.formatCoin(value: limit.minValue))
                .replacingOccurrences(of: "{max}", with: Util.formatCoin(value: limit.maxValue)))
            return
        }

        // Mostra loading e obtem o saldo qiwi
        Util.showController(LoadingViewController.self, sender: self) { (controller) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                UserRN(delegate: self).getQiwiBalance()
            })
        }
    }
}

// MARK: Data CollectionView
extension ListGenericViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfItemsInSection()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.setCollectionViewCell(collectionView, indexPath: indexPath)
    }
}

extension ListGenericViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        switch ListGenericViewController.stepListGeneric {

        case .SELECT_TRANSPORT_CITTAMOBI_RECHARGE_TYPE: fallthrough
        case .SELECT_TRANSPORT_PRODATA_RECHARGE_TYPE: fallthrough
        case .SELECT_TRANSPORT_RECHARGE_TYPE: fallthrough
        case .SELECT_TRANSPORT_URBS_RECHARGE_TYPE: fallthrough
        case .SELECT_TRANSPORT_WHERE_WILL_USE: fallthrough
        case .SELECT_OPERATOR:

            return CGSize(width: (self.collectionView.frame.width - (CGFloat(2) * 10)) / 2, height: 120)

        case .SELECT_OPERATOR_VALUE: fallthrough
        case .SELECT_VALUE:

            var height = 60
            if QiwiOrder.isInternationalPhoneRecharge() {
                height = 120
            }
            else if QiwiOrder.isDrTerapia() {
                height = 80
            }

            return CGSize(width: (self.collectionView.frame.width - (CGFloat(2) * 10)) / 2, height: CGFloat(height))

        case .SELECT_PAYMENT: fallthrough
        case .SELECT_BANK:

            return CGSize(width: (self.collectionView.frame.width - (CGFloat(2) * 10)) / 2, height: 130)

        }
    }
}

// MARK: Delegate CollectionView
extension ListGenericViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelect(didSelectItemAt: indexPath)
    }
}

// MARK: SetupUI
extension ListGenericViewController: SetupUI {

    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.orageButton(self.btnBack)
        Theme.default.greenButton(self.btnContinue)
        Theme.default.textAsListTitle(self.lbTitle)

        self.lbInfoLimitPrice.setupMessageMedium()

        self.imgHelpIcon.image = UIImage(named: "ic_shopping")!.withRenderingMode(.alwaysTemplate)
        self.imgHelpIcon.tintColor = UIColor(hexString: Constants.Colors.Hex.colorPrimary)

        self.viewNoContent.isHidden = true
    }

    func setupTexts() {
        self.btnBack.setTitle("back".localized, for: .normal)
        self.btnContinue.setTitle("continue_label".localized, for: .normal)
        self.txtPrice.placeholder = "select_value_hint_add_value".localized

        if QiwiOrder.isPhoneRecharge() {
            Util.setTextBarIn(self, title: "phone_title_recharge".localized)
        }
        else if QiwiOrder.isTransportRecharge() {
            Util.setTextBarIn(self, title: "transport_toolbar_title".localized)
        }
        else if QiwiOrder.isMetrocardRecharge() {
            Util.setTextBarIn(self, title: "metrocard_toolbar".localized)
        }
        else if QiwiOrder.isQiwiCharge() {
            Util.setTextBarIn(self, title: "qiwi_recharge_toolbar_title".localized)
        }
        else if QiwiOrder.isQiwiTransfer() {
            Util.setTextBarIn(self, title: "credit_qiwi_toolbar_title".localized)
        }
        else if QiwiOrder.isQiwiTransferToPrePago() {
            Util.setTextBarIn(self, title: "qiwi_transfer_prepago_toolbar_title".localized)
        }
        else if QiwiOrder.isIncommCharge() || QiwiOrder.isPinofflineCharge() || QiwiOrder.isRvCharge() || QiwiOrder.isRvSpotifyCharge() {
            Util.setTextBarIn(self, title: "app_name".localized)
        }
        else {
            Util.setTextBarIn(self, title: "Adquirir serviço")
        }
    }

    func setupTextFields() {
        self.txtPrice.addTarget(self, action: #selector(formatCurrency), for: .editingChanged)
    }

    @objc func formatCurrency() {
        self.txtPrice.text = self.txtPrice.text?.currencyInputFormatting()

        if let value = self.txtPrice.text {
            self.btnContinue.isHidden = value.isEmpty ? true : false
        }
    }

    func setupCollectionView() {

        // Registro de cell custom
        self.collectionView.register(BigImageCell.nib(), forCellWithReuseIdentifier: BigImageCell.Identifier())
        self.collectionView.register(ImageWithTextCell.nib(), forCellWithReuseIdentifier: ImageWithTextCell.Identifier())
        self.collectionView.register(ValueCell.nib(), forCellWithReuseIdentifier: ValueCell.Identifier())

        self.collectionView.layer.masksToBounds = false
    }
}

// MARK: Custom List
extension ListGenericViewController {

    func numberOfItemsInSection() -> Int {

        var count = 0

        switch ListGenericViewController.stepListGeneric {

        case .SELECT_PAYMENT:
            fallthrough
        case .SELECT_OPERATOR: fallthrough
        case .SELECT_BANK: fallthrough
        case .SELECT_TRANSPORT_URBS_RECHARGE_TYPE: fallthrough
        case .SELECT_TRANSPORT_CITTAMOBI_RECHARGE_TYPE: fallthrough
        case .SELECT_TRANSPORT_PRODATA_RECHARGE_TYPE: fallthrough
        case .SELECT_TRANSPORT_RECHARGE_TYPE: fallthrough
        case .SELECT_TRANSPORT_WHERE_WILL_USE: fallthrough
        case .SELECT_VALUE:
            count = menuItemDataHandler.numberOfItemsInSection()
            break
        case .SELECT_OPERATOR_VALUE:
            count = operatorValuesDataHandler.numberOfItemsInSection()
            break
        }

        return count
    }

    func setCollectionViewCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {

        switch ListGenericViewController.stepListGeneric {

        case .SELECT_OPERATOR: fallthrough
        case .SELECT_BANK:

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigImageCell.Identifier(), for: indexPath) as! BigImageCell
            //            cell.widthCollection = collectionView.frame.width

            let currentItem = menuItemDataHandler.cellForItemAtIndexPath(indexPath.row)
            cell.displayContent(image: currentItem.imageMenu ?? "")

            return cell

        case .SELECT_OPERATOR_VALUE:

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ValueCell.Identifier(), for: indexPath) as! ValueCell
            //            cell.widthCollection = collectionView.frame.width

            let currentItem = operatorValuesDataHandler.cellForItemAtIndexPath(indexPath.row)
            cell.displayValue(value: currentItem.maxValue)

            return cell

        case .SELECT_VALUE:

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ValueCell.Identifier(), for: indexPath) as! ValueCell
            //            cell.widthCollection = collectionView.frame.width

            let currentItem = menuItemDataHandler.cellForItemAtIndexPath(indexPath.row)

            //INCOMM E PINNOFFLINE POSSUEM O VALOR NA DESCRICAO
            if QiwiOrder.isIncommCharge() || QiwiOrder.isPinofflineCharge() || QiwiOrder.isRvCharge() || QiwiOrder.isRvSpotifyCharge() || QiwiOrder.isDrTerapia() {

                if QiwiOrder.selectedMenu.prvID == ActionFinder.PLAYSTATION_PLUS_PRVID || QiwiOrder.isDrTerapia() {
                    cell.displayValue(desc: currentItem.desc, aux: currentItem.descAux)
                } else {
                    cell.displayValue(desc: currentItem.desc)
                }
            }
            else if QiwiOrder.isInternationalPhoneRecharge() {
                let inValue = currentItem.data as! InternationalValue
                cell.displayValue(desc: currentItem.desc, aux: "Custo (Cost)", aux2: Util.formatCoin(value: inValue.value))
            }
            else if QiwiOrder.isUltragaz() {
                let gasProduct = currentItem.data as! UltragazProduct
                cell.displayValue(desc: currentItem.desc, aux: gasProduct.name)
            }
            else {
                cell.displayValue(value: currentItem.data as! Int)
            }

            return cell

        case .SELECT_PAYMENT: fallthrough
        case .SELECT_TRANSPORT_URBS_RECHARGE_TYPE: fallthrough
        case .SELECT_TRANSPORT_PRODATA_RECHARGE_TYPE: fallthrough
        case .SELECT_TRANSPORT_CITTAMOBI_RECHARGE_TYPE: fallthrough
        case .SELECT_TRANSPORT_RECHARGE_TYPE: fallthrough
        case .SELECT_TRANSPORT_WHERE_WILL_USE:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageWithTextCell.Identifier(), for: indexPath) as! ImageWithTextCell

            // Put the image on menu
            let currentItem = menuItemDataHandler.cellForItemAtIndexPath(indexPath.row)
            cell.displayContent(menu: currentItem)

            return cell
        }
    }

    func didSelect(didSelectItemAt indexPath: IndexPath) {
        //----------------- USER ESTÁ NOS VALORES GENERICOS -----------------
        if ListGenericViewController.stepListGeneric == .SELECT_VALUE {
            let currentItem = self.menuItemDataHandler.cellForItemAtIndexPath(indexPath.row)

            //Se for rv, incomm ou pinoffline, a logica é diferente
            if QiwiOrder.isRvCharge() || QiwiOrder.isRvSpotifyCharge() {
                let rvValue = currentItem.data as! RvValue
                
                QiwiOrder.setPrvId(prvId: rvValue.prvid)
                QiwiOrder.setTransitionAndValue(value: rvValue.maxValue)
                
                if QiwiOrder.isRvCharge() {
                    QiwiOrder.checkoutBody.requestRv?.cdProduct = rvValue.prodCod
                } else {
                    QiwiOrder.checkoutBody.requestRvSpotify?.cdProduct = rvValue.prodCod
                }
                
                if rvValue.minValue != rvValue.maxValue {

                    DispatchQueue.main.async {
                        self.viewInserValue.isHidden = false
                        self.txtPrice.becomeFirstResponder()
                    }
                    return
                }
            }
            else if QiwiOrder.isIncommCharge() {
                let incommValue = currentItem.data as! IncommValue
                QiwiOrder.setPrvId(prvId: incommValue.prvId)
                QiwiOrder.checkoutBody.requestIncomm?.id = incommValue.id
                QiwiOrder.setTransitionAndValue(value: incommValue.maxValue)
                
                if incommValue.minValue != incommValue.maxValue {
                    DispatchQueue.main.async {
                        self.viewInserValue.isHidden = false
                        self.txtPrice.becomeFirstResponder()
                    }
                    return
                }
             }
            else if QiwiOrder.isPinofflineCharge() {
                let pinofflineValue = currentItem.data as! PinofflineValue
                QiwiOrder.setPrvId(prvId: pinofflineValue.prvId)
                QiwiOrder.setTransitionAndValue(value: pinofflineValue.value)
                QiwiOrder.checkoutBody.requestPinoffline?.id = pinofflineValue.id
            }
            else if QiwiOrder.isDrTerapia() {
                let drTerapiaValue = currentItem.data as! DrTerapiaValue
                QiwiOrder.productDesc = currentItem.descAux;
                QiwiOrder.checkoutBody.requestDrTerapia?.id = drTerapiaValue.id
                QiwiOrder.checkoutBody.requestDrTerapia?.desc = drTerapiaValue.desc
                QiwiOrder.setTransitionAndValue(value: drTerapiaValue.value)
            }
            else if QiwiOrder.isInternationalPhoneRecharge() {
                let internationalValue = currentItem.data as! InternationalValue

                QiwiOrder.setTransitionAndValue(value: Int(internationalValue.value*100))
                QiwiOrder.checkoutBody.requestInternationalPhone?.productId = String(internationalValue.id)
            }
            else if QiwiOrder.isUltragaz() {
                let gasProduct = currentItem.data as! UltragazProduct

                //let stringValue = String(gasProduct.value).removeAllOtherCaracters()

                let intValue = Int(round(gasProduct.value*100))
                QiwiOrder.setTransitionAndValue(value: intValue)
                QiwiOrder.checkoutBody.requestUltragaz?.productCode = gasProduct.id

                if ApplicationRN.isQiwiPro() {
                    self.performSegue(withIdentifier: Constants.Segues.ULTRAGAZ_USER, sender: nil)
                    return
                }
            }
            else {
                let value = currentItem.data as! Int

                //-------- normal transation -----
                if value == -1 {

                    DispatchQueue.main.async {
                        self.viewInserValue.isHidden = false
                        self.txtPrice.becomeFirstResponder()
                    }
                    return
                }

                QiwiOrder.setTransitionAndValue(value: value)

                //Se for qiwi transfer, nao existe método de pagamento
                if QiwiOrder.isQiwiTransfer() || QiwiOrder.isQiwiTransferToPrePago() {
                    self.validateLimitAndCallUpdateQiwiBalance()
                    return
                }
            }

            self.selectStep(step: .SELECT_PAYMENT)
            return
        }

        //----------------- USER ESTÁ NOS VALORES DA OPERADORAS -----------------
        if ListGenericViewController.stepListGeneric == .SELECT_OPERATOR_VALUE {
            let currentItem = self.operatorValuesDataHandler.cellForItemAtIndexPath(indexPath.row)
            if currentItem.maxValue == -1 {

                DispatchQueue.main.async {
                    self.viewInserValue.isHidden = false
                    self.txtPrice.becomeFirstResponder()
                }
                return
            }
            if QiwiOrder.isPhoneRecharge() {
                QiwiOrder.checkoutBody.requestPhone?.categoryId = currentItem.categoryId
            }
            QiwiOrder.setTransitionAndValue(value: currentItem.maxValue)
            self.selectStep(step: .SELECT_PAYMENT)
            return
        }

        //----------------- USER ESTÁ NA LISTA DE OPERADORAS -----------------
        if ListGenericViewController.stepListGeneric == .SELECT_OPERATOR {
            let currentItem = self.menuItemDataHandler.cellForItemAtIndexPath(indexPath.row)
            QiwiOrder.checkoutBody.requestPhone?.operatorId = currentItem.id
            QiwiOrder.setPrvId(prvId: currentItem.prvID)

            //Se for QIWI Brasil, salva o contato
            if ApplicationRN.isQiwiBrasil() {
                let op = currentItem.data as! Operator
                QiwiOrder.phoneContactSelected?.op = op.getSampleName()

                Util.showLoading(self) {
                    ContactsRN(delegate: self).saveCardOrUpdate(phoneContact: QiwiOrder.phoneContactSelected!)
                }

                return
            }

            //Se for pro, não existe contato pra salvar, então avançamos direto
            self.selectStep(step: .SELECT_OPERATOR_VALUE)
            return
        }

        if ListGenericViewController.stepListGeneric == .SELECT_TRANSPORT_URBS_RECHARGE_TYPE {
            let currentItem = self.menuItemDataHandler.cellForItemAtIndexPath(indexPath.row)
            let urbsBalance = currentItem.data as! UrbsBalance

            if !urbsBalance.canRecharge {
                Util.showAlertDefaultOK(self, message: "transport_urbs_cant_recharge".localized)
                return
            }

            QiwiOrder.checkoutBody.requestUrbs?.cardType = urbsBalance.cardTypeCode
            QiwiOrder.urbsBalanceSelected = urbsBalance

            self.selectStep(step: .SELECT_VALUE)
        }
        
        //----------------- USER ESTA SELECIONANDO O TIPO DE RECARGA DO PRO (COMUM, ESTUDANTE, ETC) -----------------
        if ListGenericViewController.stepListGeneric == .SELECT_TRANSPORT_CITTAMOBI_RECHARGE_TYPE {
            let currentItem = self.menuItemDataHandler.cellForItemAtIndexPath(indexPath.row)
            let transportType = currentItem.data as! TransportCittaMobiTypeResponse
            QiwiOrder.transportTypeCittaMobiSelected = transportType
            QiwiOrder.setPrvId(prvId: currentItem.prvID)

            self.selectStep(step: .SELECT_VALUE)
            return
        }
        
         //----------------- USER ESTA SELECIONANDO O TIPO DE RECARGA DO PRO (COMUM, ESTUDANTE, ETC) -----------------
        else if ListGenericViewController.stepListGeneric == .SELECT_TRANSPORT_PRODATA_RECHARGE_TYPE {
            let currentItem = self.menuItemDataHandler.cellForItemAtIndexPath(indexPath.row)
            
            if currentItem.action == ActionFinder.ID_STUDENT_FORM {
                self.performSegue(withIdentifier: Constants.Segues.STUDENT_HOME, sender: nil)
                return
            }
            
            let transportType = currentItem.data as! TransportProdataProduct
            
            QiwiOrder.checkoutBody.requestProdata?.prodCode = transportType.productCode
            QiwiOrder.setPrvId(prvId: currentItem.prvID)
            QiwiOrder.transportProdataProduct = transportType
            
            self.selectStep(step: .SELECT_VALUE)
            return
        }

        //----------------- USER ESTA SELECIONANDO O TIPO DE RECARGA (COMUM, ESTUDANTE, ETC) -----------------
        if ListGenericViewController.stepListGeneric == .SELECT_TRANSPORT_RECHARGE_TYPE {
            let currentItem = self.menuItemDataHandler.cellForItemAtIndexPath(indexPath.row)
            let transportType = currentItem.data as! TransportTypeResponse
            self.menuItemDataHandler.menuType = currentItem.id
            QiwiOrder.transportTypeSelected = transportType

            QiwiOrder.checkoutBody.requestTransport?.rechargeType = transportType.code
            QiwiOrder.checkoutBody.requestTransport?.desc = transportType.desc
            QiwiOrder.type = currentItem.desc

            QiwiOrder.checkoutBody.requestTransport?.creditType = ActionFinder.isBilheteUnicoEstudante(id: currentItem.id) ? 2 : 1

            if currentItem.id == ActionFinder.Transport.MenuType.COMUM ||
                currentItem.id == ActionFinder.Transport.MenuType.ESTUDANTE {
                QiwiOrder.checkoutBody.requestTransport?.amount = 1
                self.selectStep(step: .SELECT_VALUE)
            }
            //Taxa de beneficio do estudante
            else if currentItem.id == ActionFinder.Transport.MenuType.BENEFICIO {
                QiwiOrder.checkoutBody.requestTransport?.amount = 1
                QiwiOrder.setTransitionAndValue(value: transportType.unitValue)

                self.performSegue(withIdentifier: Constants.Segues.STUDANT_TAX, sender: nil)
            }
            //Cotas
            else {
                self.selectStep(step: .SELECT_TRANSPORT_WHERE_WILL_USE)
            }

            return
        }

        //----------------- USER ESTÁ SELECIONANDO ONDE VA USAR A RECARGA (METRO, BUS, ETC) -----------------
        if ListGenericViewController.stepListGeneric == .SELECT_TRANSPORT_WHERE_WILL_USE {
            let currentItem = self.menuItemDataHandler.cellForItemAtIndexPath(indexPath.row)
            let transportType = currentItem.data as! TransportTypeResponse
            QiwiOrder.transportTypeSelected = transportType
            QiwiOrder.checkoutBody.requestTransport?.rechargeType = transportType.code
            QiwiOrder.checkoutBody.requestTransport?.desc = transportType.desc

            self.transportType = currentItem.desc
            self.performSegue(withIdentifier: Constants.Segues.TRANSPORT_QUOTE, sender: nil)
            return
        }

        //----------------- USER ESTÁ NOS METODOS DE PAGAMENTOS -----------------
        if ListGenericViewController.stepListGeneric == .SELECT_PAYMENT {
            QiwiOrder.clearPaymentMethods()

            let currentItem = self.menuItemDataHandler.cellForItemAtIndexPath(indexPath.row)

            if currentItem.id != ActionFinder.Payments.MONEY && currentItem.id != ActionFinder.Payments.CREDIT_CARD_ATM  && currentItem.id != ActionFinder.Payments.BILL && currentItem.id != ActionFinder.Payments.PROMO_CODE {
                //Have to check if payment is allowed first
                let limit = PaymentRN(delegate: self).getPaymentLimit(prvid: QiwiOrder.checkoutBody.transition?.prvId ?? 0, paymentMethod: currentItem.id)
                if limit.prvId != 0 {
                    if currentItem.notAvailable {
                        //iniciar tela de limits
                        self.startPaymentLimitPopup(paymentType: currentItem.id )
                        return
                    }
                } else {
                    //iniciar tela de limits
                    self.startPaymentLimitPopup(paymentType: currentItem.id )
                    return
                }
            }

            //Have to check if payment is allowed first
            if currentItem.id == ActionFinder.Payments.CREDIT_CARD {
                self.performSegue(withIdentifier: Constants.Segues.DOCUMENTS, sender: nil)
                return
            }

            if currentItem.id == ActionFinder.Payments.QIWI_BALANCE {

                if !UserRN.isQiwiAccountActive() {
                    self.performSegue(withIdentifier: Constants.Segues.CREATE_QIWI_PASS, sender: nil)
                    return
                }

                // Mostra loading e obtem o saldo qiwi
                Util.showController(LoadingViewController.self, sender: self) { (controller) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        UserRN(delegate: self).getQiwiBalance()
                    })
                }
                return
            }

            if currentItem.id == ActionFinder.Payments.BILL {
                self.performSegue(withIdentifier: Constants.Segues.WRITE_BILL, sender: nil)
                return
            }

            if currentItem.id == ActionFinder.Payments.BANK_TRANSFER {
                self.selectStep(step: .SELECT_BANK)
                return
            }
            
            if currentItem.id == ActionFinder.Payments.PIX {
                if currentItem.action == ActionFinder.Payments.PIXV2 {
                    QiwiOrder.checkoutBody.transition?.pix_v2 = PIXV2Request()
                } else {
                    QiwiOrder.checkoutBody.transition?.pix = PIXRequest()
                }
                self.performSegue(withIdentifier: Constants.Segues.CHECKOUT, sender: nil)
                return
            }
            
            if currentItem.id == ActionFinder.Payments.PROMO_CODE {
                QiwiOrder.checkoutBody.transition?.coupons = [RequestCoupons]()
                self.performSegue(withIdentifier: Constants.Segues.PROMO_CODE, sender: nil)
                return
            }

            if currentItem.id == ActionFinder.Payments.MONEY  {

                self.mapPointType = ActionFinder.QiwiPoints.TYPE_MONEY
                self.performSegue(withIdentifier: Constants.Segues.PAYMENT_MONEY, sender: nil)
                return
            }

            if currentItem.id == ActionFinder.Payments.CREDIT_CARD_ATM {

                self.mapPointType = ActionFinder.QiwiPoints.TYPE_CREDIT_CARD_ATM
                self.performSegue(withIdentifier: Constants.Segues.PAYMENT_MONEY, sender: nil)
                return
            }
        }

        //----------------- USER ESTÁ NA LISTA DE BANCOS -----------------
        if ListGenericViewController.stepListGeneric == .SELECT_BANK {
            let currentItem = self.menuItemDataHandler.cellForItemAtIndexPath(indexPath.row)

            if currentItem.id == ActionFinder.Bank.NO_BANK {
                onClickOtherBanks()
                return
            }
            
            if (currentItem.id == ActionFinder.Bank.BRADESCO || currentItem.id == ActionFinder.Bank.CAIXA) {
                QiwiOrder.checkoutBody.transition?.pix = PIXRequest()
                self.performSegue(withIdentifier: Constants.Segues.CHECKOUT, sender: nil)
                return;
            }

            QiwiOrder.checkoutBody.transition?.bankRequest = BankRequest()
            QiwiOrder.checkoutBody.transition?.bankRequest?.bankId = currentItem.id
            self.performSegue(withIdentifier: Constants.Segues.CHECKOUT, sender: nil)
        }
    }

    func onClickOtherBanks() {
        Util.showComingSoon(self,
        delegate: self,
        title: "content_soon_title".localized,
        message: "content_soon_desc".localized)
    }
}

// MARK: Modal Delegate
extension ListGenericViewController: DismisModalDelegate {

    func modalDismiss() {
        //self.dismiss(animated: false)
    }
}

extension ListGenericViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == Constants.Segues.NO_BALANCE {

            // controller que sera apresentada
            if let navVC = segue.destination as? PaymentNoBalanceViewController {
                navVC.balance = self.balance
                return
            }
        }

        if segue.identifier == Constants.Segues.TRANSPORT_QUOTE {

            // controller que sera apresentada
            if let navVC = segue.destination as? TransportQuoteViewController {
                // passa o pedido de order pra frente
                navVC.mType = self.transportType
                navVC.transportQuoteDelegate = self
                return
            }
        }

        if segue.identifier == Constants.Segues.DOCUMENTS {

            // controller que sera apresentada
            if let navVC = segue.destination as? CreditCardListViewController {
                // passa o pedido de order pra frente
                navVC.isFromPaymentView = true
                return
            }
        }

        if segue.identifier == Constants.Segues.PAYMENT_MONEY {

            // controller que sera apresentada
            if let navVC = segue.destination as? CashPaymentViewController {
                // passa o pedido de order pra frente

                navVC.typeOfPoint = self.mapPointType
                return
            }
        }

        if segue.identifier == Constants.Segues.CHECKOUT {
            // passa o pedido de order pra frente
            self.alreadyInCheckout = true
            if (QiwiOrder.isClickBus()) {
                ClickBusBaseViewController.forwardStep()
            }
        }

        if segue.identifier == Constants.Segues.PROMO_CODE {
            self.alreadyInCheckout = true
            if (QiwiOrder.isClickBus()) {
                ClickBusBaseViewController.forwardStep()
            }
            if let vc = segue.destination as? PromoCodeViewController {
                vc.comingFrom = .PAYMENT_METHODS
            }
        }
    }
}

extension ListGenericViewController: TransportQuoteDelegate {

    func showList(step: Constants.StepListGeneric) {
        ListGenericViewController.stepListGeneric = step
        self.changeLayout()
    }
}

extension ListGenericViewController {

    func findValueList() {

        if QiwiOrder.isTransportRecharge() {
            self.menuItemDataHandler.fillTransportValues()
        } else if QiwiOrder.isTransportCittaMobiRecharge() {
            self.menuItemDataHandler.fillTransportCittaMobiValues()
        }  else if QiwiOrder.isTransportProdataRecharge() {
            self.menuItemDataHandler.fillTransportProdataValues()
        } else if QiwiOrder.isUrbsCharge() {
            self.menuItemDataHandler.fillTransportUrbsValues()
        } else if QiwiOrder.isMetrocardRecharge() {
            self.menuItemDataHandler.fillMetrocardValueList()
        } else if QiwiOrder.isQiwiCharge() {
            self.menuItemDataHandler.fillQiwiChargeValues()
        } else if QiwiOrder.isPinofflineCharge() {
            self.menuItemDataHandler.fillPinofflineValueList(prvId: QiwiOrder.selectedMenu.prvID)
        } else if QiwiOrder.isRvCharge() || QiwiOrder.isRvSpotifyCharge() {
            self.menuItemDataHandler.fillRvValueList(prvId: QiwiOrder.selectedMenu.prvID)
        }  else if QiwiOrder.isIncommCharge() {
            self.menuItemDataHandler.fillIncommValueList(prvId: QiwiOrder.selectedMenu.prvID)
        } else if QiwiOrder.isQiwiTransfer() || QiwiOrder.isQiwiTransferToPrePago() {
            self.menuItemDataHandler.fillQiwiTransferValues()
        } else if QiwiOrder.isInternationalPhoneRecharge() {
            self.menuItemDataHandler.fillInternationalPhoneList()
        } else if QiwiOrder.isDonation() {
            self.menuItemDataHandler.fillDonationList()
        } else if QiwiOrder.isUltragaz() {
            Util.showLoading(self)
            self.showOnlyLoading()
            self.menuItemDataHandler.fillUltragazValues()
            return;
        } else if QiwiOrder.isDrTerapia() {
            self.menuItemDataHandler.fillDrTerapiaValueList()
            return
        }

        self.reloadList()
    }

    func findNoContentMessage() {

        switch ListGenericViewController.stepListGeneric {
        case .SELECT_PAYMENT:
            self.lbNoContent.text = "list_generic_no_content_payment_methods".localized
            break

        case .SELECT_OPERATOR_VALUE: fallthrough
        case .SELECT_VALUE:
            self.lbNoContent.text = "list_generic_no_content_values".localized
            break
        default:
            self.lbNoContent.text = "list_generic_no_content_all".localized
        }
    }
}

extension ListGenericViewController {

    func hideAll() {
        self.viewLoading.isHidden = true
        self.lbTitle.isHidden = true
        self.collectionView.superview?.isHidden = true
        self.btnContinue.isHidden = true
        self.viewInserValue.isHidden = true
        //self.viewBack.isHidden = true
    }

    func selectStep(step: Constants.StepListGeneric) {
        ListGenericViewController.stepListGeneric = step
        self.changeLayout()
    }

    func reloadList() {
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.reloadData()

        self.lbTitle.isHidden = false
        self.viewLoading.isHidden = true

        if self.menuItemDataHandler.arrItems.isEmpty && self.operatorValuesDataHandler.arrItems.isEmpty {
            self.findNoContentMessage()
            self.viewNoContent.isHidden = false
            self.collectionView.superview?.isHidden = true
            return
        }

        self.collectionView.superview?.isHidden = false
        self.viewNoContent.isHidden = true
        self.viewBack.isHidden = false
    }

    func showOnlyLoading() {

        self.hideAll()
        self.lbTitle.isHidden = false
        self.viewLoading.isHidden = false
    }

    func changeLayout() {

        DispatchQueue.main.async {

            self.hideAll()
            self.viewNoContent.isHidden = true
            self.viewLoading.isHidden = false

            // Time
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {

                switch ListGenericViewController.stepListGeneric {
                case .SELECT_OPERATOR:

                    // Texto referente
                    self.lbTitle.text = "phone_select_operator".localized
                    self.menuItemDataHandler.fillOperatorList()

                    //Operator list result will be shown at onReceiveData
                    return
                case .SELECT_OPERATOR_VALUE:

                    self.lbTitle.text = "select_value_choose_value".localized
                    let ddd = QiwiOrder.checkoutBody.requestPhone?.ddd;
                    let operatorId = QiwiOrder.checkoutBody.requestPhone?.operatorId;
                    self.operatorValuesDataHandler.fillPhoneRechargeValues(ddd: ddd!, operatorId: operatorId!)

                    //Values list result will be shown at onReceiveData
                    return
                case .SELECT_VALUE:

                    self.lbTitle.text = "select_value_choose_value".localized
                    self.findValueList()

                    self.txtPrice.text = "0,00"
                    if QiwiOrder.isTransportRecharge() {
                        let minTransportValue = Int((QiwiOrder.transportTypeSelected?.minAmount)! * 100)

                        self.minValue = minTransportValue > 100 ? minTransportValue : 100
                        self.maxValue = Int((QiwiOrder.transportTypeSelected?.maxAmount)! * 100)
                    }
                        //NOSSO
                    else if QiwiOrder.isTransportCittaMobiRecharge() {
                        let minCittaMobiValue = QiwiOrder.transportTypeCittaMobiSelected?.minValue ?? 100

                        self.minValue = minCittaMobiValue > 100 ? minCittaMobiValue : 100
                        self.maxValue = QiwiOrder.transportTypeCittaMobiSelected?.maxValue ?? 420
                    }
                    
                    else if QiwiOrder.isTransportProdataRecharge() {
                        
                        if QiwiOrder.transportProdataProduct!.isQuota {
                            self.minValue = QiwiOrder.transportProdataProduct!.minValue
                            self.maxValue = QiwiOrder.transportProdataProduct!.maxValue
                        } else {
                            self.minValue = PaymentRN.getMinValueForProduct(prvid: QiwiOrder.getPrvID())
                            self.maxValue = PaymentRN.getMaxValueForProduct(prvid: QiwiOrder.getPrvID())
                        }
                    }
                        //URBS
                    else if QiwiOrder.isUrbsCharge() {

                        let maxValue = QiwiOrder.urbsBalanceSelected!.maxRechargeValue > 0 ? QiwiOrder.urbsBalanceSelected?.maxRechargeValue : PaymentRN.getMaxValueForProduct(prvid: QiwiOrder.getPrvID())

                        self.minValue = PaymentRN.getMinValueForProduct(prvid: QiwiOrder.getPrvID())
                        self.maxValue = maxValue! * 100
                    }
                        //Donation
                    else if QiwiOrder.isDonation() {

                        self.minValue = PaymentRN.getMinValueForProduct(prvid: QiwiOrder.getPrvID())
                        self.maxValue = PaymentRN.getMaxValueForProduct(prvid: QiwiOrder.getPrvID())
                    }
                    //TRANSFERENCIA QIWI
                    else if QiwiOrder.isQiwiTransfer() {
//                        self.minValue = CreditQiwiTransferRN.getMinValue()
//                        self.maxValue = CreditQiwiTransferRN.getMaxValue()

                        let limit = PaymentRN(delegate: self).getPaymentLimit(prvid: QiwiOrder.getPrvID(), paymentMethod: ActionFinder.Payments.QIWI_BALANCE)

                        self.minValue = limit.minValue
                        self.maxValue = limit.maxValue
                    }
                    else if QiwiOrder.isQiwiTransferToPrePago() {
                        let limit = PaymentRN(delegate: self).getPaymentLimit(prvid: QiwiOrder.getPrvID(), paymentMethod: ActionFinder.Payments.QIWI_BALANCE)

                        self.minValue = limit.minValue
                        self.maxValue = limit.maxValue
                    }
                    //Recarga qiwi
                    else if QiwiOrder.isQiwiCharge() {
                        let limit = PaymentRN(delegate: self).getPaymentLimit(prvid: QiwiOrder.getPrvID(), paymentMethod: ActionFinder.Payments.BANK_TRANSFER)

                        self.minValue = limit.minValue
                        self.maxValue = limit.maxValue
                    }
                    //Metrocard
                    else if QiwiOrder.isMetrocardRecharge() {

                        self.minValue = QiwiOrder.minValue
                        self.maxValue = QiwiOrder.maxValue
                    }
                    else if QiwiOrder.isUltragaz() && !QiwiOrder.adressName.isEmpty  {

                        self.lbTitle.text = "ultragaz_select_value_title".localized + QiwiOrder.adressName
                    }
                    else  {
                        self.minValue = QiwiOrder.minValue
                        self.maxValue = QiwiOrder.maxValue
                    }

                    let labelDesc = QiwiOrder.isQiwiTransfer() ? "select_value_add_value_limit_transfer_desc".localized : "select_value_add_value_limit_desc".localized
                    self.lbInfoLimitPrice.text = labelDesc
                        .replacingOccurrences(of: "{min}", with: Util.formatCoin(value: self.minValue))
                        .replacingOccurrences(of: "{max}", with: Util.formatCoin(value: self.maxValue))
                    //Values list result will be shown at onReceiveData
                    return

                case .SELECT_PAYMENT:

                    self.lbTitle.text = "payments_title".localized
                    //Pre pago (prepago) - Se for, verifica saldo e vai pro checkout
                    if ApplicationRN.isQiwiPro() && !QiwiOrder.isQiwiCharge() && !QiwiOrder.isQiwiTransferToPrePago() {

                        let isAvailable = PaymentRN(delegate: self).valueIsAvailable(paymentType: 4)

                        if !isAvailable {
                            self.needBack = true
                            self.startPaymentLimitPopup(paymentType: 4)
                            return
                        }

                        Util.showLoading(self)
                        UserRN(delegate: self).getPrePagoBalance()
                        return
                    }

                    self.menuItemDataHandler.fillPaymentList()

                    break
                case .SELECT_BANK:

                    self.lbTitle.text = "payments_gbank_transfer_title".localized
                    self.menuItemDataHandler.fillBankList()

                    break

                case .SELECT_TRANSPORT_URBS_RECHARGE_TYPE:
                    //Values list result will be shown at onReceiveData
                    self.lbTitle.text = "select_value_recharge_type".localized

                    Util.showLoading(self) {
                        self.menuItemDataHandler.fillTransportCardUrbsOptions()
                    }

                    return

                case .SELECT_TRANSPORT_CITTAMOBI_RECHARGE_TYPE:
                    //Values list result will be shown at onReceiveData
                    self.lbTitle.text = "select_value_recharge_type".localized

                    Util.showLoading(self) {

                        self.menuItemDataHandler.fillTransportCardCittaMobiOptions()
                    }

                    return
                    
                case .SELECT_TRANSPORT_PRODATA_RECHARGE_TYPE:
                    //Values list result will be shown at onReceiveData
                    self.lbTitle.text = "select_value_recharge_type".localized

                    Util.showLoading(self) {

                        self.menuItemDataHandler.fillTransportCardProdataOptions()
                    }

                    return

                case .SELECT_TRANSPORT_RECHARGE_TYPE:
                    //Values list result will be shown at onReceiveData
                    self.lbTitle.text = "select_value_recharge_type".localized

                    Util.showLoading(self) {
                        self.menuItemDataHandler.fillTransportCardOptions()
                    }

                    return

                case .SELECT_TRANSPORT_WHERE_WILL_USE:

                    self.lbTitle.text = "transport_where_will_use".localized
                        .replacingOccurrences(of: "{type}", with: QiwiOrder.type)
                    self.menuItemDataHandler.fillTransportCardWhereWillUse()

                    break
                }

                self.reloadList()
            })
        }
    }
}

extension ListGenericViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {

            if param == Param.Contact.PRE_PAGO_BALANCE_RESPONSE {
                self.dismissPage(self)

                let balance = object as! Int

                if !result || balance == -1 {
                    Util.showAlertDefaultOK(self, message: "payments_prepago_get_balance_error".localized, titleOK: "OK", completionOK: {
                        self.clickBackFunc()
                    })
                    return
                }

                //Não tem saldo suficiente
                if balance == -1 || balance < QiwiOrder.getValue() {

                    let msg = "payments_prepago_no_balance".localized.replacingOccurrences(of: "{value}", with: Util.formatCoin(value: QiwiOrder.getValue()))
                        .replacingOccurrences(of: "{balance}", with: Util.formatCoin(value: balance))

                    Util.showAlertDefaultOK(self, message: msg, titleOK: "OK", completionOK: {
                        self.clickBackFunc()
                    })
                    return
                }

                self.prePagoBalance = balance
                QiwiOrder.checkoutBody.transition?.prePago = QiwiBalanceRequest()
                //Tem saldo suficiente
                self.performSegue(withIdentifier: Constants.Segues.CHECKOUT, sender: nil)

                return
            }

            if fromClass == PaymentRN.self {
                if param == Param.Contact.DRTERAPIA_VALUES_RESPONSE {
                    self.reloadList()
                }
            }

            if param == Param.Contact.NET_REQUEST_ERROR {
                if ListGenericViewController.stepListGeneric == .SELECT_TRANSPORT_CITTAMOBI_RECHARGE_TYPE || ListGenericViewController.stepListGeneric == .SELECT_TRANSPORT_RECHARGE_TYPE || ListGenericViewController.stepListGeneric == .SELECT_TRANSPORT_PRODATA_RECHARGE_TYPE {
                    self.dismiss(animated: true, completion: nil)
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showErrorThatDismissPage()
                }
                return
            }

            //If its telling to finish
            if param == Param.Contact.PHONE_RECHARGE_OP_LIST_AS_MENU_RESPONSE || param == Param.Contact.PHONE_RECHARGE_AVAILABLE_VALUES_RESPONSE {
                 self.reloadList()
                return
            }

            if param == Param.Contact.QIWI_BALANCE_RESPONSE {
                self.dismissPage(self)
                //self.backToMainScreen(self)
                if result {
                    self.balance = object as! Int

                    if QiwiOrder.isQiwiTransfer() || QiwiOrder.isQiwiTransferToPrePago() {

                        let value = QiwiOrder.checkoutBody.transition?.value

                        if (self.balance >= value ?? 0) {
                            self.performSegue(withIdentifier: Constants.Segues.CHECKOUT, sender: nil)
                        } else {
                            Util.showAlertDefaultOK(self, message: "credit_qiwi_no_balance".localized.replacingOccurrences(of: "{value}", with: Util.formatCoin(value: self.balance)))
                        }
                    }
                    else {
                        if (self.balance >= QiwiOrder.getValue() || !CouponRN(delegate: self).getAvailableCouponsForPrvAndValue(prvid: QiwiOrder.getPrvID(), value: QiwiOrder.getValue()).isEmpty) {
                            QiwiOrder.checkoutBody.transition?.qiwiBalance = QiwiBalanceRequest()
                            self.performSegue(withIdentifier: Constants.Segues.CHECKOUT, sender: nil)
                        } else {
                            self.performSegue(withIdentifier: Constants.Segues.NO_BALANCE, sender: nil)
                        }
                    }

                } else {
                    self.showError()
                }
            }

            if param == Param.Contact.TRANSPORT_CARD_CONSULT_RESPONSE || param == Param.Contact.TRANSPORT_CARD_CITTAMOBI_CONSULT_RESPONSE || param == Param.Contact.TRANSPORT_CARD_PRODATA_CONSULT_RESPONSE  || param == Param.Contact.TRANSPORT_CARD_URBS_AVAILABLE_CARDS_RESPONSE {
                //Tira o loading
                self.dismiss(animated: true, completion: nil)
                //Monta a lista
                self.reloadList()
            }

            if param == Param.Contact.PHONE_RECHARGE_INSERT_PHONE_RESPONSE {
                self.dismiss(animated: true, completion: nil)
                self.selectStep(step: .SELECT_OPERATOR_VALUE)
            }

            if param == Param.Contact.ULTRAGAZ_VALUES_RESPONSE {
                self.dismissPageAfter(after: 0.6)
                self.viewLoading.isHidden = true

                if self.menuItemDataHandler.arrItems.isEmpty {
                    self.viewList.isHidden = true
                    self.viewNoContent.isHidden = false
                } else {
                    self.viewNoContent.isHidden = true
                    self.viewList.isHidden = false
                    self.reloadList()
                }
            }
        }
    }

}

extension ListGenericViewController {

    func startPaymentLimitPopup(paymentType: Int) {
        PaymentLimitsViewController.paymentType = paymentType
        Util.showController(PaymentLimitsViewController.self, sender: self, completion: { controller in controller.popupDelegate = self })
    }
}
