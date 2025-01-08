//
//  TransportNeedHelpViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 19/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

protocol TutorialCardNumber {
    
    func getNumber(cardNumber: String)
}

class TransportCardTutorialViewController: UIBaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtCardNumber: MaterialField!
    @IBOutlet weak var imgCardSelected: UIImageView!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    
    @IBOutlet weak var viewCardList: UIView!
    @IBOutlet weak var viewCardSelect: UIView!
    @IBOutlet weak var viewContinue: ViewContinue!
    
    // MARK: Variables
    
    var stepSelectCardNeed = Constants.StepSelectCardNeedHelp.LIST
    lazy var transportCards = TransportCardRN(delegate: self).getTransportCardTutorials()
    
    var delegateTutorialCardNumber: TutorialCardNumber?
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        self.setupNib()
        self.setupViewContinue()
        
        self.changeLayout()
        
        self.txtCardNumber.addTarget(self, action: #selector(showContinue(sender:)), for: .editingChanged)
    }
    
    override func setupViewWillAppear() {
        self.fillCardList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TransportCardTutorialViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
    }
}

// MARK: IBActions
extension TransportCardTutorialViewController {
    
    @IBAction func clickContinue(sender: UIButton) {
        
        // Valid
        if self.validateCardNumber() {
            
            // Close modal
            self.dismissPage(sender)
            
            // Pass data
            self.delegateTutorialCardNumber?.getNumber(cardNumber: self.txtCardNumber.text ?? "")
        }
    }
    
    @IBAction func clickBack(sender: UIButton) {
        
        // Step initial
        if self.stepSelectCardNeed == .LIST {
            
            // Close modal
            self.dismissPage(sender)
            return
        }
        
        // Back step
        self.controllStep(number: -1)
    }
}

// MARK: Control UI
extension TransportCardTutorialViewController {
    
    func hideAll() {
        self.txtCardNumber.isHidden = true
        self.viewCardList.isHidden = true
        self.viewCardSelect.isHidden = true
        self.viewContinue.showOnlyBackButton()
    }
    
    func changeLayout() {
        
        self.hideAll()
        
        switch self.stepSelectCardNeed {
        
        case .LIST:
            self.showList()
            break
        case .SELECT:
            self.showCardSelected()
            break
        }
    }
    
    func showList() {
        self.viewCardList.isHidden = false
    }
    
    func showCardSelected() {
        self.viewCardSelect.isHidden = false
        self.txtCardNumber.isHidden = false
    }
    
    func controllStep(number: Int) {
        
        // Current Step
        let currentStep = self.stepSelectCardNeed.rawValue + number
        
        // New Step
        if let newStep = Constants.StepSelectCardNeedHelp(rawValue: currentStep) {
            
            // Change Step
            self.stepSelectCardNeed = newStep
            
            // Load UI
            self.changeLayout()
        }
    }
    
    func selectCard(index: Int) {
        
        // Increment Step
        self.controllStep(number: 1)
        
        // Get Item
        let tutorialTransportCard = self.transportCards[index]
        
        // Show item
        self.imgCardSelected.image = UIImage(named: tutorialTransportCard.backImage)
    }
    
    func validateCardNumber() -> Bool {
        
        guard let numberCard = self.txtCardNumber.text else {
            Util.showAlertDefaultOK(self, message: "transport_card_number_invalid".localized)
            return false
        }
        
        if numberCard.isEmpty {
            Util.showAlertDefaultOK(self, message: "transport_card_number_invalid".localized)
            return false
        }
        
        return true
    }
}

// MARK: Selector

extension TransportCardTutorialViewController {
    
    @objc func showContinue(sender: UITextField) {
    
        if let text = self.txtCardNumber.text {
            
            // Hide
            if text.isEmpty {
                self.viewContinue.showOnlyBackButton()
                return
            }

            // Show
            self.viewContinue.showBackAndContinueButtons()
        }
    }
}

// MARK: SetupUI
extension TransportCardTutorialViewController: SetupUI {
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lblTitle)
    }
    
    func setupTexts() {
        
        self.lblTitle.text = "transport_select_the_similar_to_your".localized
        self.txtCardNumber.placeholder = "transport_hint_add_card".localized
        Util.setTextBarIn(self, title: "transport_add_card".localized)
    }
    
    func setupNib() {
        self.collectionView.register(TransportCardTutorialCell.nib(), forCellWithReuseIdentifier: "Cell")
    }
    
    func setupViewContinue() {
        
        self.viewContinue.btnBack.addTarget(self, action: #selector(clickBack(sender:)), for: .touchUpInside)
        self.viewContinue.btnContinue.addTarget(self, action: #selector(clickContinue(sender:)), for: .touchUpInside)
    }
}

// MARK: Data Collection
extension TransportCardTutorialViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.transportCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TransportCardTutorialCell
        
        // Get / Pass item
        cell.item = self.transportCards[indexPath.row]
        
        // Calculate height
        self.heightCollectionView.constant = self.collectionView.contentSize.height + 20
        
        return cell
    }
}

// MARK: Delegate Collection
extension TransportCardTutorialViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectCard(index: indexPath.row)
    }
}

// MARK: Delegate FlowLayout
extension TransportCardTutorialViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 20
            layout.minimumInteritemSpacing = 20
        }
        
        let itemsPerRow = CGFloat(2)
        let spacing = CGFloat(10)
        
        // Size item
        let theHeight = CGFloat(100)
        let theWidth = (self.collectionView.frame.width - (CGFloat(2) * spacing)) / itemsPerRow
        
        // Size Layout
        let size = CGSize(width: theWidth, height: theHeight)
        return size
    }
}

// MARK: Fill List
extension TransportCardTutorialViewController {
    
    func fillCardList() {
        self.collectionView.reloadData()
    }
}
