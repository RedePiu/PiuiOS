//
//  TransportCardViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 19/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class TransportCardViewController: UIBaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnCheckBoxSaveCard: UIButton!
    @IBOutlet weak var btnSaveCard: UIButton!
    
    @IBOutlet weak var txtCardNumber: MaterialField!
    @IBOutlet weak var txtCardName: MaterialField!
    @IBOutlet weak var txtCardCPF: MaterialField!
    
    @IBOutlet weak var viewSaveCard: UIStackView!
    
    @IBOutlet weak var viewCardAdd: UIView!
    @IBOutlet weak var viewCardNeedHelp: UIView!
    @IBOutlet weak var viewStudentForm: UICardView!
    
    @IBOutlet weak var lblInfoCheckBox: UILabel!
    @IBOutlet weak var lblHelpCard: UILabel!
    @IBOutlet weak var imgHelpCard: UIImageView!
    
    @IBOutlet weak var imgTransportLogo: UIImageView!
    // MARK: Variables
    
    var isSaveCard: Bool = true
    var transportCardEdit: TransportCard!
    
    var delegateAddTransportCard: TransportCardDelegate?
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupTableView()
        self.setupActionHelp()
    }
    
    override func setupViewWillAppear() {
        
        // Editar cartao
        if let card = self.transportCardEdit {
            self.txtCardName.text = card.name
            self.txtCardNumber.text = "\(card.number)"
            self.txtCardCPF.text = card.cpf
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Segue Identifier
extension TransportCardViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Tutorial
        if segue.identifier == Constants.Segues.TUTORIAL_NUMBER_CARD {
            if let navigatioVC = segue.destination as? UINavigationController {
                if let tutorialVC = navigatioVC.topViewController as? TransportCardTutorialViewController {
                    tutorialVC.delegateTutorialCardNumber = self
                }
            }
        }
    }
}

// MARK: Delegate Tutorial Card Number

extension TransportCardViewController: TutorialCardNumber {
    
    func getNumber(cardNumber: String) {

        // Received number and show into textField
        self.txtCardNumber.text = cardNumber
    }
}

// MARK: IBActions
extension TransportCardViewController {
    
    @IBAction func onClickStudentForm(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segues.STUDENT_HOME, sender: nil)
        
    }
    
    @IBAction func checkBoxSaveCard(sender: UIButton) {
        
        self.view.endEditing(true)
        
        self.isSaveCard = !self.isSaveCard
        
        self.btnCheckBoxSaveCard.setImage(
            isSaveCard ? Constants.Image.Button.CHECK_BOX_ENABLE : Constants.Image.Button.CHECK_BOX_DISABLED,
            for: .normal
        )
        self.btnCheckBoxSaveCard.imageView?.tintColor = UIColor(
            hexString: isSaveCard ? Constants.Colors.Hex.colorAccent : Constants.Colors.Hex.colorGrey7
        )
//        
//        if !isSaveCard {
//        self.btnCheckBoxSaveCard.setImage(Constants.Image.Button.CHECK_BOX_DISABLED, for: .normal)
//            self.btnCheckBoxSaveCard.imageView?.tintColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
//            return
//        }
//        
//        self.btnCheckBoxSaveCard.setImage(Constants.Image.Button.CHECK_BOX_ENABLE, for: .normal)
//        self.btnCheckBoxSaveCard.imageView?.tintColor = UIColor(hexString: Constants.Colors.Hex.colorAccent)
    }
    
    @IBAction func saveCard(sender: UIButton) {
        
        self.view.endEditing(true)
        
        guard let txtCardNumber = self.txtCardNumber.text else { return }
        
        if txtCardNumber.isEmpty {
            Util.showAlertDefaultOK(self, message: "transport_card_number_invalid".localized)
            return
        }
        
        // Fechar
        self.popPage(sender)
        
        //
        let transportCard = TransportCard(number: txtCardNumber, name: self.txtCardName.text ?? "", cpf: self.txtCardCPF.text ?? "")
        
        if self.transportCardEdit != nil {
            transportCard.serverpk = self.transportCardEdit.serverpk
        }
        
        transportCard.type = QiwiOrder.getTransportCardtype()
        self.delegateAddTransportCard?.input(with: transportCard, isSaveCard: self.isSaveCard)
    }
}

extension TransportCardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

// MARK: Setup UI
extension TransportCardViewController: SetupUI {
    func setupTableView(){
        
    }
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.orageButton(self.btnBack)
        Theme.default.blueButton(self.btnSaveCard)
        
        self.viewCardNeedHelp.backgroundColor = UIColor(hexString: Constants.Colors.Hex.colorButtonGreen)
        self.viewStudentForm.isHidden = ApplicationRN.isQiwiPro() || QiwiOrder.selectedMenu.prvID != ActionFinder.Transport.Prodata.RapidoTaubate.CIDADAO
        
        self.btnCheckBoxSaveCard.imageView?.image = self.btnCheckBoxSaveCard.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.btnCheckBoxSaveCard.imageView?.tintColor = UIColor(hexString: Constants.Colors.Hex.colorAccent)
        
        self.imgHelpCard.image = self.imgHelpCard.image?.withRenderingMode(.alwaysTemplate)
        self.imgHelpCard.tintColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiWhite)
        
        self.lblHelpCard.textColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiWhite)
        
        self.txtCardCPF.isHidden = true
        if QiwiOrder.isTransportRecharge() {
            self.imgTransportLogo.image = UIImage(named: "100058")
        }
        else if QiwiOrder.isTransportCittaMobiRecharge() {
            self.imgTransportLogo.image = UIImage(named: "logo_nosso")
        }
        else if QiwiOrder.isUrbsCharge() {
            self.imgTransportLogo.image = UIImage(named: "logo_urbs")
        }
        else if QiwiOrder.isTransportProdataRecharge() {
            
            if QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.NossoRibeirao.CIDADAO {
                self.imgTransportLogo.image = UIImage(named: "logo_nosso")
            } else if QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.BemLegalMaceio.COMUM {
                self.imgTransportLogo.image = UIImage(named: "menu_produto_bem_legal_maceio")
            } else if QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.SaoVicente.COMUM {
                self.imgTransportLogo.image = UIImage(named: "menu_produto_sao_vicente")
            } else if QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.SaoSebastiao.COMUM {
                self.imgTransportLogo.image = UIImage(named: "menu_produto_sao_sebastiao")
            } else if QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.SaoCarlos.COMUM {
                self.imgTransportLogo.image = UIImage(named: "menu_produto_sao_carlos")
            } else if QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.SantanadeParnaiba.COMUM {
                self.imgTransportLogo.image = UIImage(named: "menu_produto_santana_de_parnaiba")
            } else if QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.Osasco.COMUM {
                self.imgTransportLogo.image = UIImage(named: "menu_produto_osasco")
            } else if QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.FrancodaRocha.COMUM {
                self.imgTransportLogo.image = UIImage(named: "menu_produto_franco_da_rocha")
            } else if QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.Cajamar.COMUM {
                self.imgTransportLogo.image = UIImage(named: "menu_produto_cajamar")
            } else if QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.RioClaro.COMUM {
                self.imgTransportLogo.image = UIImage(named: "menu_produto_rio_claro")
            } else if QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.Caieiras.COMUM {
                self.imgTransportLogo.image = UIImage(named: "menu_produto_caieiras")
            } else if QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.Araraquara.COMUM {
                self.imgTransportLogo.image = UIImage(named: "menu_araraquara")
            } else if QiwiOrder.getPrvID() == ActionFinder.Transport.Prodata.PresidentePrudente.COMUM {
                self.imgTransportLogo.image = UIImage(named: "menu_produto_presidente_prudente")
            } else {
                self.imgTransportLogo.image = UIImage(named: "menu_produto_rapido")
            }
        }
        else if QiwiOrder.isMetrocardRecharge() {
            self.imgTransportLogo.image = UIImage(named: "logo_metrocard")
            self.txtCardCPF.isHidden = false
            self.txtCardCPF.formatPattern = Constants.FormatPattern.Default.CPF.rawValue
        }
        
        // Font and Color
        self.lblInfoCheckBox.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
        self.lblInfoCheckBox.font = FontCustom.helveticaRegular.font(15)
        
        self.lblHelpCard.textColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiWhite)
        self.lblHelpCard.font = FontCustom.helveticaRegular.font(18)
        
        self.txtCardNumber.becomeFirstResponder()
        
        if ApplicationRN.isQiwiPro() {
            self.txtCardName.isHidden = true
            self.viewSaveCard.isHidden = true
        }
    }
    
    func setupTexts() {
        
        self.btnBack.setTitle("back".localized, for: .normal)
        self.btnSaveCard.setTitle("continue_label".localized, for: .normal)
        self.txtCardNumber.placeholder = "transport_hint_add_card".localized
        self.txtCardName.placeholder = "transport_add_name_hint".localized
        self.txtCardCPF.placeholder = "metrocard_cpf_hint".localized
        
        self.lblInfoCheckBox.text = "transport_save_card".localized
        self.lblHelpCard.text = "transport_need_help".localized
        
        Util.setTextBarIn(self, title: "transport_add_card".localized)
    }
    
    func setupActionHelp() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showNeedeHelp))
        self.viewCardNeedHelp.addGestureRecognizer(tapGesture)
    }
    
    @objc func showNeedeHelp() {
        self.view.endEditing(true)
        performSegue(withIdentifier: Constants.Segues.TUTORIAL_NUMBER_CARD, sender: nil)
    }
}
