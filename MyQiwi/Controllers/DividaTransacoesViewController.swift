//
//  DividaTransacoesViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 15/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class DividaTransacoesViewController : UIBaseViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noContentView: UIView!
    @IBOutlet weak var lbNoContent: UILabel!
    
    var transacoes = [DividaDetailsResponse]()
    var selectedTransacao = DividaDetailsResponse()
    var dividaId = 0
    lazy var dividaRN = DividaRN(delegate: self)
    lazy var orderProRN = OrdersProRN(delegate: self)
    
    enum CardState {
        case expanded
        case collapsed
    }

    var popoverViewController: PopoverProViewController!
    var visualEffectView: UIVisualEffectView!

    let cardHeight = CGFloat(600)
    let cardHandleAreaHeight = CGFloat(70)
    var runningAnimation = [UIViewPropertyAnimator]()
    var animationProgresseWhenInterrupted: CGFloat = 0
    
    var isVisible = false
    var nextState: CardState {
        return isVisible ? .collapsed : .expanded
    }
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupNib()
        self.setupCard()
        
        self.requestTransacoes()
    }
    
    func setupCard() {

        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        //  self.view.addSubview(visualEffectView)

        popoverViewController = PopoverProViewController(nibName: "PopoverPro", bundle: nil)
        self.addChildViewController(popoverViewController)
        self.view.addSubview(popoverViewController.view)

        popoverViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - 240, width: self.view.bounds.width, height: cardHeight)

        popoverViewController.view.clipsToBounds = true
        popoverViewController.view.layer.cornerRadius = 8

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))

        popoverViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        popoverViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
    }
}

extension DividaTransacoesViewController {
    
    @objc func handleCardTap(recognizer: UITapGestureRecognizer) {

        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.4)
        default:
            break
        }
    }
    
    @objc func handleCardPan(recognizer: UIPanGestureRecognizer) {
            switch recognizer.state {
            case .began:
                startTransition(state: nextState, duration: 0.4)
            case .changed:
                let translation = recognizer.location(in: self.popoverViewController.handleArea)
                var fractionComplete = translation.y / cardHeight
                fractionComplete = isVisible ? fractionComplete : -fractionComplete
                updateTransition(fractionCompleted: fractionComplete)
            case .ended:
                continueTransition()
            default:
                break
            }
        }

        func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
            if runningAnimation.isEmpty {
                let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                    switch state {
                    case .expanded:
                        self.popoverViewController.view.frame.origin.y = self.view.frame.height - (self.cardHeight - 170)
                    case .collapsed:
                        self.popoverViewController.view.frame.origin.y = self.view.frame.height - (self.cardHandleAreaHeight)
                    }
                }

                frameAnimator.addCompletion { _ in
                    self.isVisible = !self.isVisible
                    self.runningAnimation.removeAll()
                }

                frameAnimator.startAnimation()
                runningAnimation.append(frameAnimator)

                let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {

                    switch state {
                    case .expanded:
                        self.visualEffectView.effect = UIBlurEffect(style: .dark)
    //                    self.popoverViewController.imgArrow.image = UIImage(named: "ic_arrow_down")
                        self.popoverViewController.imgArrow.image = #imageLiteral(resourceName: "ic_arrow_down").withRenderingMode(.alwaysTemplate)
                        self.popoverViewController.imgArrow.tintColor = Theme.default.white
                    case .collapsed:
                        self.visualEffectView.effect = nil
    //                    self.popoverViewController.imgArrow.image = UIImage(named: "ic_arrow_up")
                        self.popoverViewController.imgArrow.image = #imageLiteral(resourceName: "ic_arrow_up").withRenderingMode(.alwaysTemplate)
                        self.popoverViewController.imgArrow.tintColor = Theme.default.white
                    }
                }

                blurAnimator.startAnimation()
                runningAnimation.append(blurAnimator)
            }
        }

        func startTransition(state: CardState, duration: TimeInterval) {

            if runningAnimation.isEmpty {
                animateTransitionIfNeeded(state: state, duration: duration)
            }

            for animator in runningAnimation {
                animator.pauseAnimation()
                animationProgresseWhenInterrupted = animator.fractionComplete
            }
        }

        func updateTransition(fractionCompleted: CGFloat) {

            for animator in runningAnimation {
                animator.fractionComplete = fractionCompleted + animationProgresseWhenInterrupted
            }
        }

        func continueTransition() {

            for animator in runningAnimation {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            }
        }
}

extension DividaTransacoesViewController {
    
    func requestTransacoes() {
        Util.showLoading(self)
        
        self.dividaRN.getTransacoes(idDivida: dividaId)
    }
    
    func updateList() {
        
        self.tableView.isHidden = true
        self.noContentView.isHidden = true
        
        if !self.transacoes.isEmpty {
            self.tableView.reloadData()
            self.tableView.isHidden = false
            
            DispatchQueue.main.async {
                self.popoverViewController.countList = self.orderProRN.somarValores(dividas: self.transacoes)
                self.popoverViewController.tableView.reloadData()

                self.popoverViewController.lbTotalPrice.text = Util.formatCoin(value: self.orderProRN.calculateTotalPrice(proValues: self.popoverViewController.countList))
                self.popoverViewController.lbTotalCommission.text = Util.formatCoin(value: self.orderProRN.calculateTotalCommission(proValues: self.popoverViewController.countList))
            }
            
            return
        }
        
        self.noContentView.isHidden = false
    }
}

extension DividaTransacoesViewController {
    
    @objc func showDetailsOrder(sender: UIButton) {
        
        // Item
        self.selectedTransacao = self.transacoes[sender.tag]

        // Proxima tela
        performSegue(withIdentifier: Constants.Segues.ORDER_DETAIL, sender: nil)
    }
}

// MARK: Segue Idetifier
extension DividaTransacoesViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.ORDER_DETAIL {
            if let vc = segue.destination as? OrderDetailViewController {

                // Passa item
                vc.orderId = 0
                vc.transitionId = self.selectedTransacao.idTransition
            }
        }
    }
}

extension DividaTransacoesViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.async {
            
            if fromClass == DividaRN.self {
                if param == Param.Contact.DIVIDA_GET_TRANSICOES {
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    if result {
                        self.transacoes = object as! [DividaDetailsResponse]
                    }
                    
                    self.updateList()
                }
            }
        }
    }
}

extension DividaTransacoesViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transacoes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! DividaTransicaoCell
        
        let index = indexPath.row
        let item = self.transacoes[index]
        cell.item = item
        
        // Index no button, para abrir detalhes
        cell.btnDetails.tag = index
        cell.btnDetails.addTarget(self, action: #selector(showDetailsOrder(sender:)), for: .touchUpInside)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 222
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension DividaTransacoesViewController : SetupUI {
    
    func setupUI() {
        
        Theme.default.textAsListTitle(self.lbTitle)
        self.lbNoContent.setupMessageMedium()
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "dividas_toolbar_title".localized)
        self.lbTitle.text = "dividas_transacoes_title".localized
    }
    
    func setupNib() {
        self.tableView.register(DividaTransicaoCell.nib(), forCellReuseIdentifier: "Cell")
    }
}
