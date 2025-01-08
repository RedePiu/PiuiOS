//
//  TaxaConsultaFormViewController.swift
//  MyQiwi
//
//  Created by Daniel Catini on 14/05/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import UIKit

class TaxaConsultaFormViewController: UIBaseViewController {
    
    //vars
    var stackView = UIStackView()
    var menuCardTypes = [MenuCardTypeResponse]()
    lazy var taxaCardRN = TaxaCardRN(delegate: self)
    var getForms = [GetFormsResponse]()
    
    @IBAction func closeClick(_ sender: UIBarButtonItem) {
        self.dismissPage(sender)
    }
    
    @IBAction func clickBack(_ sender: Any) {
        self.popPage(sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        
        //recuperando formulários
        //getForms
        self.getForms = self.taxaCardRN.getAllGetForms()
        print(self.getForms.count)
        
        //arruma stack view
        self.setupStackView()
        //criar botões de escolha
        self.criaLayoutInicial()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TaxaConsultaFormViewController: SetupUI {
    func setupTexts() {
        
    }

    func setupUI() {
        Theme.default.backgroundCard(self)
    }
    
    func criaLayoutInicial()
    {
        //carregar tipo cargas
        self.menuCardTypes = self.taxaCardRN.getAllCardTypes()
        
        //titulo
        let label = UILabel()
        label.text = "Solicitação de Cartão"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true // Altura fixa
        
        stackView.addArrangedSubview(label)
        
        //criar uma lista de formulário
        

        // Atualizar a altura da stack view com base no conteúdo
        stackView.sizeToFit()
    }
    
    func setupStackView()
    {
        // Criar uma UIScrollView
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Adicionar restrições para preencher a tela
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Criar uma UIStackView
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true

        // Adicionar a stack view à view
        scrollView.addSubview(stackView)
        
        // Adicionar restrições para preencher a UIScrollView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        view.sendSubview(toBack: scrollView)
    }
    
    func clearStackView()
    {
        for subview in self.stackView.subviews{
            subview.removeFromSuperview()
        }
    }
}

extension TaxaConsultaFormViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            //parametros aqui
            
        }
    }
}
