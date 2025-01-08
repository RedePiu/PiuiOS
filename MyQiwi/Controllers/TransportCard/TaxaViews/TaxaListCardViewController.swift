//
//  TaxaListCardViewController.swift
//  MyQiwi
//
//  Created by Daniel Catini on 05/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import UIKit

class TaxaListCardViewController: UIBaseViewController {
    
    // MARK: - Params
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    @IBOutlet weak var StackOutro: UIStackView!
    @IBOutlet var viewPrincipal: UIView!
    
    @IBAction func closeClick(_ sender: UIBarButtonItem) {
        self.dismissPage(sender)
    }
    
    @IBAction func clickBack(_ sender: Any) {
        self.popPage(sender)
    }
    
    @IBAction func clickOutroCartao(_ sender: Any) {
        Util.showLoading(self)
        Constants.viaCarga = 1
        self.performSegue(withIdentifier: Constants.Segues.TAXA_FORM, sender: { self.dismissPage(nil) })
    }
    
    // MARK: Variables
    private let produtoProdata = ProdutoProdataDAO().getByPrv(prvid: QiwiOrder.selectedMenu.prvID)
    
    var alreadyAccessAddCard = false
    var isEditingTableView = false
    var addedCard = false
    var saveCard = false
    var sentToConsulting = false
    var taxaCardSelected: TaxaCardResponse?
    
    var taxaCards = [TaxaCardResponse]()
    lazy var taxaCardRN = TaxaCardRN(delegate: self)
    var menuCardTypes = [MenuCardTypeResponse]()
    var layoutForm = [LayoutFormResponse]()
    
    // MARK: Ciclo de vida
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        
        self.setupConsult()
        self.setupNib()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

// MARK: Data Table
extension TaxaListCardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taxaCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TaxaCardCell = tableView.dequeueReusableCell(withIdentifier: "TaxaCardCell", for: indexPath) as? TaxaCardCell else {
            return UITableViewCell()
        }
        
        let index = indexPath.row
        let item = self.taxaCards[index]
        
        cell.item = item
        cell.btnCharge.tag = item.tipo?.Id_Tipo_Formulario_Carga ?? 0
        cell.btnCharge.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        self.setupHeightTable()
        return cell
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        //let id_tipo_carga = sender.tag // Identificar qual botão foi clicado usando a tag
        Constants.idTipoCarga = sender.tag
        Constants.viaCarga = 2
        print("@! >>> Botão com tag \(Constants.idTipoCarga) foi clicado!")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.taxaCardRN.getLayoutFormResponses(
                idEmissor: self.produtoProdata.id_emissor,
                id_tipo_formulario_carga: Constants.idTipoCarga,
                via: Constants.viaCarga,
                fl_dependente: false
            )
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
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
extension TaxaListCardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isEditingTableView = true
    }
}

private extension TaxaListCardViewController {
    func setupConsult() {
        self.carregaTipoCarga()
        
        if self.sentToConsulting {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        if self.taxaCards.isEmpty {
            if alreadyAccessAddCard {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.alreadyAccessAddCard = true
                //performSegue(withIdentifier: Constants.Segues.CARD_ADD, sender: nil)
            }
        }
    }
}

// MARK: SetupUI
extension TaxaListCardViewController: SetupUI {
    
    func setupUI() {
        self.StackOutro.isHidden(true)
        self.viewPrincipal.isHidden(true)
        
        Theme.default.backgroundCard(self)
        if QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.Caieiras.COMUM || QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.Caieiras.ESCOLAR {
            //self.cvComumForm.isHidden = false
            //self.cvStudentForm.isHidden = false
        }
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: QiwiOrder.selectedMenu.desc)
    }
    
    func setupNib() {
        self.tableView.register(TaxaCardCell.nib(), forCellReuseIdentifier: "TaxaCardCell")
    }
    
    func setupHeightTable() {
        self.heightTable.constant = self.tableView.contentSize.height + 20
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func carregaTipoCarga() {
        //Util.showLoading(self)
        let produtoProdata = ProdutoProdataDAO().getByPrv(prvid: QiwiOrder.selectedMenu.prvID)
        TaxaCardRN(delegate: self).getMenuCardTypeResponses(idEmissor: produtoProdata.id_emissor)
    }
}

extension TaxaListCardViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            switch param {
            case Param.Contact.TAXA_GET_TYPE_CARD_RESPONSE:
                self.menuCardTypes = self.taxaCardRN.getAllCardTypes()
                self.taxaCards = self.taxaCardRN.getAllCards()
                
                for card in self.menuCardTypes {
                    print("card: \(card.codCarga)")
                }
                
                for item in self.taxaCards {
                    let tipoCarga = self.menuCardTypes.filter({ Int($0.codCarga) == item.codCarga }).first
                    
                    if tipoCarga == nil {
                        if let index = self.taxaCards.firstIndex(of: item) {
                            self.taxaCards.remove(at: index)
                        }
                    } else {
                        item.tipo = tipoCarga
                    }
                }
            
                self.tableView.reloadData()
                
                if self.taxaCards.count != self.menuCardTypes.count {
                    self.StackOutro.isHidden(false)
                }
                
                if self.taxaCards.count <= 0 {
                    self.performSegue(withIdentifier: Constants.Segues.TAXA_FORM, sender: nil)
                } else {
                    self.viewPrincipal.isHidden(false)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.dismissPage(nil)
                }
                
            case Param.Contact.TAXA_LAYOUT_FORM_RESPONSE:
                self.layoutForm = self.taxaCardRN.getAllLayoutForm()
                //self.layoutForm = []
                
                for form in self.layoutForm {
                    print("@! >>> FORM_CRIADO: ", form)
                }
                
                if self.layoutForm.isEmpty {
                    //Util.showLoading(self)
                    self.setupTimer()
                    
                    //self.displayAlert(
                    //    title: "Falha ao recuperar formulário",
                    //    message: "Tivemos um problema ao carregar o formulário, tente novamente."
                    //)
                } else {
                    //Util.showLoading(self)
                    self.performSegue(withIdentifier: Constants.Segues.TAXA_FORM, sender: nil)
                }
                
                print("@! >>> LIST_LAYOUT_FORM: ", self.layoutForm)
            default:
                break
            }
        }
    }
    
    private func setupTimer() {
        Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(triggerTimer), 
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc private func triggerTimer() {
        self.taxaCardRN.getLayoutFormResponses(
            idEmissor: self.produtoProdata.id_emissor,
            id_tipo_formulario_carga: Constants.idTipoCarga,
            via: Constants.viaCarga,
            fl_dependente: false
        )
    }
}
