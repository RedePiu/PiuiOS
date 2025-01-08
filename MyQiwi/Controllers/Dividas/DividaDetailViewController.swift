//
//  DividaDetailViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class DividaDetailViewController : UIBaseViewController {
    
    @IBOutlet weak var svScroll: UIScrollView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var btnTransitions: UIButton!
    
    @IBOutlet weak var lbComissionLabel: UILabel!
    @IBOutlet weak var lbComissionValue: UILabel!
    @IBOutlet weak var lbJurosLabel: UILabel!
    @IBOutlet weak var lbJurosValue: UILabel!
    @IBOutlet weak var lbMultaLabel: UILabel!
    @IBOutlet weak var lbMultaValue: UILabel!
    @IBOutlet weak var lbSaldoLabel: UILabel!
    @IBOutlet weak var lbSaldoValue: UILabel!
    @IBOutlet weak var lbTotalAPagarLabel: UILabel!
    @IBOutlet weak var lbTotalAPagarValue: UILabel!
    @IBOutlet weak var lbVencimentoLabel: UILabel!
    @IBOutlet weak var lbVencimentoValue: UILabel!
    @IBOutlet weak var lbPagamentoLabel: UILabel!
    @IBOutlet weak var lbPagamentoValue: UILabel!
    @IBOutlet weak var viewPagamento: UIStackView!
    @IBOutlet weak var viewValidade: UIStackView!
    
    @IBOutlet weak var viewStatus: UICardView!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lbStatusTitle: UILabel!
    @IBOutlet weak var lbStatusDesc: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    
    @IBOutlet weak var lbCaixaTitle: UILabel!
    @IBOutlet weak var viewCaixa: ViewCaixaEconomica!
    
    @IBOutlet weak var lbSelectPayment: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollection: NSLayoutConstraint!
    
    @IBOutlet weak var viewPartialPendent: UICardView!
    @IBOutlet weak var viewPartialValue: UICardView!
    @IBOutlet weak var btnPartialFullValue: UIButton!
    @IBOutlet weak var btnPartialRemoveJuros: UIButton!
    @IBOutlet weak var btnPartialChangeValue: UIButton!
    @IBOutlet weak var viewPartialOptions: UIStackView!
    @IBOutlet weak var txtPartialValue: MaterialField!
    @IBOutlet weak var txtPartialReason: MaterialField!
    @IBOutlet weak var anexoPartial: ViewAnexo!
    @IBOutlet weak var btnPartialContinue: UIButton!
    
    @IBOutlet weak var lbPartialPaymentTitle: UILabel!
    @IBOutlet weak var lbPartialPaymentSubtitle: UILabel!
    
    var menus = [MenuItem]()
    lazy var dividaRN = DividaRN(delegate: self)
    var selectedDivida = Divida()
    var isPartialFullValueSelected = false
    var isPartialRemoveJurosSelected = false
    var isPartialValueSelected = false
    
    static var partialTypeId: Int = 0
    static var partialValue: Double = 0
    static var partialReason: String = ""
    static var partialAnexos: [Anexo] = [Anexo]()
    static var totalValue: Double = 0
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupCollectionView()
        self.verifyIfIsExpiredAndHasPartialPayment()
        
        self.collectionView.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [.new], context: nil)
    }
}

extension DividaDetailViewController {
    
    @IBAction func onClickTransacoes(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segues.DIVIDA_TRANSACOES, sender: nil)
    }
    
    @objc func onClickFinishSuccess(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickPartialFullValue(_ sender: Any) {
        self.selectPartialOption(partialOption: 0)
    }
    
    @IBAction func onClickPartialRemoveJuros(_ sender: Any) {
        self.selectPartialOption(partialOption: 1)
    }
    
    @IBAction func onClickPartialValue(_ sender: Any) {
        self.selectPartialOption(partialOption: 2)
    }
    
    @IBAction func onClickPartialContinue(_ sender: Any) {
        self.continueAndRequestPartialPayment()
    }
}

extension DividaDetailViewController {
    
    func checkButton(btn: UIButton) {
        self.changeCheck(btn: self.btnPartialFullValue, status: false)
        self.changeCheck(btn: self.btnPartialRemoveJuros, status: false)
        self.changeCheck(btn: self.btnPartialChangeValue, status: false)
        
        self.changeCheck(btn: btn, status: true)
    }
    
    func changeCheck(btn: UIButton, status: Bool) {
        
        switch btn {
            case btnPartialFullValue:
                self.isPartialFullValueSelected = status
            break
            
            case btnPartialRemoveJuros:
                self.isPartialRemoveJurosSelected = status
            break
            
            case btnPartialChangeValue:
                self.isPartialValueSelected = status
            break
            
            default:
                return
        }
        
        if !status {
            btn.setImage(Constants.Image.Button.CHECK_BOX_DISABLED, for: .normal)
            btn.imageView?.tintColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
            return
        }
        
        btn.setImage(Constants.Image.Button.CHECK_BOX_ENABLE, for: .normal)
        btn.imageView?.tintColor = UIColor(hexString: Constants.Colors.Hex.colorAccent)
    }
}

//partial options
extension DividaDetailViewController {
    
    func verifyIfIsExpiredAndHasPartialPayment() {
        self.viewPartialPendent.isHidden = true
        self.viewPartialValue.isHidden = true
        self.anexoPartial.controller = self
        
        if !selectedDivida.canShowPartialView() {
            return
        }
        
        self.viewPartialValue.isHidden = false
        self.btnPartialRemoveJuros.isHidden = !self.selectedDivida.isVencido()
        self.selectPartialOption(partialOption: 0)
    }
    
    func selectPartialOption(partialOption: Int) {
        DividaDetailViewController.partialTypeId = partialOption
        
        //Sem pagamento parcial
        if (partialOption == 0) {
            self.checkButton(btn: btnPartialFullValue)
            self.viewPartialOptions.isHidden = true
            self.txtPartialValue.isHidden = true
        }
        //Isencao de juros e multas
        else if (partialOption == 1) {
            self.checkButton(btn: btnPartialRemoveJuros)
            self.viewPartialOptions.isHidden = false
            self.txtPartialValue.isHidden = true
        }
        //valor parcial solicitado
        else if (partialOption == 2) {
            self.checkButton(btn: btnPartialChangeValue)
            self.viewPartialOptions.isHidden = false
            self.txtPartialValue.isHidden = false
        }
    }
    
    func continueAndRequestPartialPayment() {
        
        if DividaDetailViewController.partialTypeId == 2 {
            
            //Verifica o valor parcial
            let textPrice = self.txtPartialValue.text?.removeAllCaractersExceptNumbers().removeAllOtherCaracters()
            let value = Int(textPrice!)

            if value! <= 0 || value! > Util.doubleToInt(self.selectedDivida.valueDivida) {
                showError(message: "debt_expired_new_value_input_error".localized)
                return
            }
            
            DividaDetailViewController.partialValue = Double(value!/100)
        }
        //remover juros e multa
        else if DividaDetailViewController.partialTypeId == 1 {
            DividaDetailViewController.partialValue = self.selectedDivida.valueDivida
            - self.selectedDivida.valueJuros - self.selectedDivida.valueMulta
        }
        
        let reason = self.txtPartialReason.text ?? ""
        if reason.count < 10 {
            showError(message: "debt_expired_reason_input_error".localized)
            return
        }
        
        DividaDetailViewController.partialReason = reason
        
        if anexoPartial.hasFiles() {
            Util.showLoading(self)
            AmazonRN(delegate: self).sendDocument(anexos: anexoPartial.anexos)
            return
        }
        
        DividaDetailViewController.partialAnexos = [Anexo]()
        onPartialPaymentApplied();
    }
    
    func onPartialPaymentApplied() {
        self.viewPartialPendent.isHidden = false
        self.viewPartialValue.isHidden = true
    }
    
    static func getValueToPay() -> Double {
        return DividaDetailViewController.partialTypeId > 0 ? DividaDetailViewController.partialValue : DividaDetailViewController.totalValue
    }
}

extension DividaDetailViewController {
    
    func hideAll() {
        self.lbCaixaTitle.isHidden = true
        self.viewCaixa.isHidden = true
        self.viewStatus.isHidden = true
        self.lbSelectPayment.isHidden = true
        self.collectionView.isHidden = true
    }
    
    func showPaymentList() {
        self.hideAll()
        self.lbSelectPayment.isHidden = false
        self.collectionView.isHidden = false
    }
    
    func showCaixaOptions() {
        self.hideAll()
        self.lbCaixaTitle.isHidden = false
        self.viewCaixa.isHidden = false
        
        self.viewCaixa.setDividaId(dividaId: self.selectedDivida.dividaId)
    }
    
    func showCaixaAndStatusOptions() {
        self.hideAll()
        self.lbCaixaTitle.isHidden = false
        self.viewCaixa.isHidden = false
        self.viewStatus.isHidden = false
        
        self.viewCaixa.setCaixaCode(dividaId: self.selectedDivida.dividaId, caixaCode: self.selectedDivida.complement)
    }
    
    func showStatusView() {
        self.hideAll()
        self.viewStatus.isHidden = false
    }
}

extension DividaDetailViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            if param == Param.Contact.DOC_SENT {
                self.dismiss(animated: true)
                
                if !result {
                    self.showError(message: "transport_students_form_sent_amazon_failed")
                } else {
                    var anexos = [Anexo]()
                    var docs = object as! [DocumentImage]
                    
                    for d in docs {
                        anexos.append(Anexo(type: d.imageType, tag: d.bucketTag ?? ""))
                    }
                    
                    DividaDetailViewController.partialAnexos = anexos
                    self.onPartialPaymentApplied()
                }
            }
        }
    }
}

// MARK: Observer Height Collection
extension DividaDetailViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(UICollectionView.contentSize) {
            if let _ = object as? UICollectionView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.heightCollection.constant = size.height
                    return
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.DIVIDA_TRANSFERENCIA {
            
            // controller que sera apresentada
            if let navVC = segue.destination as? DividaTransferenciaViewController {
                // passa o pedido de order pra frente
                navVC.selectedDivida = self.selectedDivida
            }
        }
        
        if segue.identifier == Constants.Segues.DIVIDA_PIX {
                    
            // controller que sera apresentada
            if let navVC = segue.destination as? DividaPIXViewController {
                // passa o pedido de order pra frente
                navVC.selectedDivida = self.selectedDivida
            }
        }
        
        if segue.identifier == Constants.Segues.DIVIDA_DEPOSITO {
            
            // controller que sera apresentada
            if let navVC = segue.destination as? DividaDepositoViewController {
                // passa o pedido de order pra frente
                navVC.selectedDivida = self.selectedDivida
            }
        }
        
        if segue.identifier == Constants.Segues.DIVIDA_BARCODE {
            
            // controller que sera apresentada
            if let navVC = segue.destination as? DividaBarcodeViewController {
                // passa o pedido de order pra frente
                navVC.idDivida = self.selectedDivida.dividaId
            }
        }
        
        if segue.identifier == Constants.Segues.DIVIDA_TRANSACOES {
            
            // controller que sera apresentada
            if let navVC = segue.destination as? DividaTransacoesViewController {
                // passa o pedido de order pra frente
                navVC.dividaId = self.selectedDivida.dividaId
            }
        }
    }
}

// MARK: Delegate CollectionView
extension DividaDetailViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let menu = self.menus[indexPath.row]
        
        switch (menu.action) {
            
            case ActionFinder.DividaPayments.Menus.TRANSFERENCIA:
                self.performSegue(withIdentifier: Constants.Segues.DIVIDA_TRANSFERENCIA, sender: nil)
            break
            
            case ActionFinder.DividaPayments.Menus.DEPOSITO:
                self.performSegue(withIdentifier: Constants.Segues.DIVIDA_DEPOSITO, sender: nil)
            break
                
            case ActionFinder.DividaPayments.Menus.PIX:
                self.performSegue(withIdentifier: Constants.Segues.DIVIDA_PIX, sender: nil)
            break
            
            case ActionFinder.DividaPayments.Menus.BOLETO:
                self.performSegue(withIdentifier: Constants.Segues.DIVIDA_BARCODE, sender: nil)
            break
            
        default:
            return
        }
    }
}

// Data Collection
extension DividaDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageWithTextCell

        let currentItem = self.menus[indexPath.row]
        cell.displayContent(menu: currentItem)
        
        return cell
    }
}

// MARK: Layout Collection
extension DividaDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Layout custom
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 20
            flowLayout.minimumInteritemSpacing = 20
        }
        
        let size = CGSize(width: (self.collectionView.frame.width - (CGFloat(2) * 10)) / 2, height: 130)
        return size
    }
}

extension DividaDetailViewController : SetupUI {
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.textAsListTitle(self.lbCaixaTitle)
        Theme.default.textAsListTitle(self.lbSelectPayment)
        
        Theme.default.textAsListTitle(self.lbPartialPaymentTitle)
        Theme.default.textAsMessage(self.lbPartialPaymentSubtitle)
        
        Theme.default.textAsMessage(self.lbDesc)
        Theme.default.blueButton(self.btnTransitions)
        
        self.imgStatus.image = UIImage(named: "ic_clock")?.withRenderingMode(.alwaysTemplate)
        self.imgStatus.tintColor = Theme.default.yellow
        
        self.txtPartialValue.addTarget(self, action: #selector(formatCurrency), for: .editingChanged)
    }
    
    func setupTexts() {
        
        Util.setTextBarIn(self, title: "dividas_toolbar_title".localized)
        
        self.lbTitle.text = self.selectedDivida.lojaName
        self.lbDesc.text = "dividas_detail_desc".localized
        self.lbValue.text = Util.formatCoin(value: self.selectedDivida.valueDivida)
        
        self.anexoPartial.setName(name: "debt_expired_attach_title".localized)
        self.anexoPartial.setDesc(desc: "debt_expired_attach_desc".localized)
        
        self.lbCaixaTitle.text = "dividas_caixa_enviar_title".localized
        
        self.lbStatusTitle.text = "dividas_status_title_success".localized
        self.lbStatusDesc.text = "dividas_status_desc_success".localized
        
        Theme.default.yellowButton(self.btnStatus)
        self.btnStatus.addTarget(self, action: #selector(onClickFinishSuccess), for: .touchUpInside)
        
        if let status = Constants.StatusDividas(rawValue: self.selectedDivida.status) {
            
            if status == .PAGO {
                self.lbStatus.textColor = Theme.default.green

                self.hideAll()
                
                self.viewValidade.isHidden = true
                self.viewPagamento.isHidden = false
                self.lbPagamentoValue.text = DateFormatterQiwi.formatDate(self.selectedDivida.datePagamento, currentFormat: DateFormatterQiwi.defaultDatePattern, toFormat: DateFormatterQiwi.dateBrazil)
            }
            else if status == .CANCELADO {
                self.lbStatus.textColor = Theme.default.red
                self.viewPagamento.isHidden = true
                
                //self.hideAll()
            }
            else {
                self.lbStatus.textColor = Theme.default.yellow
                self.viewPagamento.isHidden = true
  
                //self.showPaymentList()
                if self.selectedDivida.idBank > 0 {
                    self.showStatusView()
                } else {
                    self.showPaymentList()
                }
            }
            
            self.lbStatus.text = Divida.getStatusName(status: status)
            self.lbVencimentoValue.text = DateFormatterQiwi.formatDate(self.selectedDivida.dateVencimento, currentFormat: DateFormatterQiwi.defaultDatePattern, toFormat: DateFormatterQiwi.dateBrazil)
            
            self.lbComissionValue.text = Util.formatCoin(value: self.selectedDivida.valueComission)
            self.lbJurosValue.text = Util.formatCoin(value: self.selectedDivida.valueJuros)
            self.lbMultaValue.text = Util.formatCoin(value: self.selectedDivida.valueMulta)
            self.lbSaldoValue.text = Util.formatCoin(value: self.selectedDivida.valueBalance)
            self.lbTotalAPagarValue.text = Util.formatCoin(value: self.selectedDivida.valueDivida)
        }
        
        self.lbSelectPayment.text = "dividas_detail_title_select_payment".localized

        self.btnTransitions.setTitle("dividas_detail_bt_transition".localized, for: .normal)
    }
    
    func setupCollectionView() {
        
        //  Cell custom
        self.collectionView.register(ImageWithTextCell.nib(), forCellWithReuseIdentifier: "Cell")
        self.collectionView.layer.masksToBounds = false
        
        self.menus = self.dividaRN.getPaymentOptions()
        self.collectionView.reloadData()
    }

    @objc func formatCurrency() {
        self.txtPartialValue.text = self.txtPartialValue.text?.currencyInputFormatting()
    }
}
