//
//  PromoCodeViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 06/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation
import UIKit

protocol PromocodeSelected {
    
    func promocodeSelected(coupons: [Coupon])
}

class PromoCodeViewController: UIBaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lbSelectCouponTitle: UILabel!
    @IBOutlet weak var txtCode: MaterialField!
    @IBOutlet weak var btNewCoupon: UIButton!
    @IBOutlet weak var btCancelNewCoupon: UIButton!
    @IBOutlet weak var btSendCode: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewLoadingCoupon: UIActivityIndicatorView!
    @IBOutlet weak var lbInvalidCoupon: UILabel!
    @IBOutlet weak var viewInputCoupon: UIStackView!
    @IBOutlet weak var imgSent: UIImageView!
    @IBOutlet weak var lbAddCouponTitle: UILabel!
    @IBOutlet weak var viewNewCoupon: UIView!
    @IBOutlet weak var lbAvailableCouponsTitle: UILabel!
    @IBOutlet weak var viewEmpty: UIStackView!
    @IBOutlet weak var lbEmptyTitle: UILabel!
    
    @IBOutlet weak var lbLabelIndividual: UILabel!
    @IBOutlet weak var lbLabelAcumulative: UILabel!
    @IBOutlet weak var lbLabelUnactive: UILabel!
    
    
    enum comingFromOptions: Int {

        case HOME = 0
        case PAYMENT_METHODS
        case CHECKOUT
    }
    
    //MARK : VARIABLES
    lazy var couponRN = CouponRN(delegate: self)
    var coupons = [Coupon]()
    var selectedCoupons = [Coupon]()
    var isSelectingCoupons = false
    var refreshControl = UIRefreshControl()
    var comingFrom = PromoCodeViewController.comingFromOptions.HOME
    var promocodeSelected: PromocodeSelected?
    
    // MARK: Ciclo de vida
    override func setupViewDidLoad() {
        
        self.coupons = self.couponRN.getAvailableCoupons()
        
        self.setupUI()
        self.setupTexts()
        self.setupCollectionView()
        self.updateList()
    }
    
    override func setupViewWillAppear() {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PromoCodeViewController {
    
    @objc func onSwipeRefresh() {
        self.refreshControl.endRefreshing()
    }
    
    @IBAction func onClickSendCode(_ sender: Any) {
        let code = self.txtCode.text?.removeAllOtherCaracters() ?? ""
        
        if code.count != 16 {
            Util.showAlertDefaultOK(
                self,
                message: "coupon_add_coupon_input_error".localized
            )
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.view.endEditing(true)
        }
        
        self.viewLoadingCoupon.isHidden = false
        self.viewInputCoupon.isHidden = true
        self.lbInvalidCoupon.isHidden = true
        self.couponRN.addCoupon(code: code)
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        self.txtCode.text = ""
        self.viewNewCoupon.hide()
        self.btNewCoupon.show()
    }
    
    @IBAction func onClickNewCoupon(_ sender: Any) {
        self.btNewCoupon.hide()
        self.viewNewCoupon.show()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        if self.selectedCoupons.isEmpty {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.selectedCoupons.removeAll()
            self.resetNavigation()
        }
    }
}

// MARK: Observer Height Collection
extension PromoCodeViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(UICollectionView.contentSize) {
            if let _ = object as? UICollectionView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.collectionViewHeight.constant = size.height
                    return
                }
            }
        }
    }
}

extension PromoCodeViewController {
    
    func updateList() {
        if self.coupons.isEmpty {
            self.lbEmptyTitle.text = "coupon_list_not_found".localized
            self.viewEmpty.isHidden = false
            self.collectionView.isHidden = true
        } else {
            self.collectionView.reloadData()
            self.viewEmpty.isHidden = true
            self.collectionView.isHidden = false
        }
    }
}

extension PromoCodeViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            if (param == Param.Contact.ADD_COUPON_RESPONSE) {
                //self.dismiss(animated: true, completion: nil)
                self.viewLoadingCoupon.isHidden = true
                
                if result {
                    self.txtCode.text = ""
                    self.coupons = self.couponRN.getAvailableCoupons()
                    self.updateList()
                    self.imgSent.show()
                    
                    self.doActionAfter(after: 2.0, completion: {
                        self.imgSent.hide()
                    })
                    
                    self.doActionAfter(after: 2.6, completion: {
                        self.viewNewCoupon.hide()
                        self.viewInputCoupon.show()
                        self.btNewCoupon.show()
                    })
                } else {
                    self.lbInvalidCoupon.text = object as? String
                    
                    self.lbInvalidCoupon.isHidden = false
                    self.viewInputCoupon.isHidden = false
                }
            }
        }
    }
}

// MARK: Actions
extension PromoCodeViewController {

    func resetNavigation() {

        DispatchQueue.main.async {

            Util.setTextBarIn(self, title: "coupon_toolbar".localized)
            self.navigationItem.setRightBarButtonItems(nil, animated: true)
            
            for row in 0...self.coupons.count {
                let indexPath = IndexPath(row: row, section: 0)
                self.collectionView.deselectItem(at: indexPath, animated: true)
                
                if let cell = self.collectionView.cellForItem(at: indexPath) as? CouponCell {
                    cell.didUnselect()
                }
            }
        }
    }

    func setItemsNavigation() {

        let title = "coupon_coupon_selected".localized.replacingOccurrences(of: "{count}", with: String(self.selectedCoupons.count))
        
        let btnSelect = UIBarButtonItem(title: title.uppercased(), style: .plain, target: self, action: #selector(applyCoupon))
        let btnCancel = UIBarButtonItem(title: "cancel".localized.uppercased(), style: .plain, target: self, action: #selector(cancelSelection))

        self.navigationItem.title = nil
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiDark)

        DispatchQueue.main.async {

            // Set new config
            self.navigationItem.setRightBarButtonItems([btnSelect, btnCancel], animated: true)
        }
    }
}

extension PromoCodeViewController {
    
    @objc func applyCoupon() {
        
        if self.comingFrom == .PAYMENT_METHODS {
            let transationValue = Double(QiwiOrder.getValue()/100)
            var totalValue: Double = 0
            for c in self.selectedCoupons {
                totalValue += c.value
            }

            //Valores precisam ser identicos
            if totalValue < transationValue {
                Util.showAlertDefaultOK(self, message: "coupon_error_value_need_to_be_equal".localized.replacingOccurrences(of: "{value}", with: Util.formatCoin(value: transationValue)))
                return
            }
        }
        
        self.isSelectingCoupons = false
        QiwiOrder.coupons = self.selectedCoupons
        
        if self.comingFrom == .CHECKOUT || self.comingFrom == .HOME {
            self.promocodeSelected?.promocodeSelected(coupons: self.selectedCoupons)
            self.dismiss(animated: true, completion: nil)
        }
        else if self.comingFrom == .PAYMENT_METHODS {
            self.selectedCoupons.removeAll()
            self.performSegue(withIdentifier: Constants.Segues.CHECKOUT, sender: nil)
        }
    }
    
    @objc func cancelSelection() {

        self.isSelectingCoupons = false
        self.selectedCoupons.removeAll()
        self.resetNavigation()
    }
}

extension PromoCodeViewController:  SetupUI {
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lbAddCouponTitle)
        Theme.default.textAsListTitle(self.lbSelectCouponTitle)
        Theme.default.textAsListTitle(self.lbAvailableCouponsTitle)
        
        Theme.default.blueButton(self.btNewCoupon)
        Theme.default.orageButton(self.btCancelNewCoupon)
        Theme.default.greenButton(self.btSendCode)
        
        self.txtCode.formatPattern = "****-****-****-****"
        
        self.lbEmptyTitle.setupMessageMedium()
        
        self.lbInvalidCoupon.isHidden = true
        self.imgSent.isHidden = true
    }

    func setupTexts() {
        
        Util.setTextBarIn(self, title: "coupon_toolbar".localized)
        self.lbAddCouponTitle.text = "coupon_add_coupon_button".localized
        self.lbInvalidCoupon.text = "coupon_invalid".localized
        
        self.lbLabelIndividual.text = "coupon_individual".localized
        self.lbLabelAcumulative.text = "coupon_acumulative".localized
        self.lbLabelUnactive.text = "coupon_unative".localized
        
        self.btNewCoupon.setTitle("coupon_new_coupon_button".localized, for: .normal)
        self.btCancelNewCoupon.setTitle("coupon_back_button".localized, for: .normal)
        self.btSendCode.setTitle("coupon_send_button".localized, for: .normal)
    }
    
}

// MARK: Setup Collection / Table
extension PromoCodeViewController {
    
    func setupCollectionView() {
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        //  Cell custom
        self.collectionView.register(CouponCell.nib(), forCellWithReuseIdentifier: "Cell")
        self.collectionView.layer.masksToBounds = true
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(onSwipeRefresh), for: UIControl.Event.valueChanged)
        scrollView.refreshControl = refreshControl
        
        self.collectionView.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [.new], context: nil)
        self.scrollView.refreshControl = refreshControl
    }
}

// Data Collection
extension PromoCodeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.coupons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CouponCell

        let currentItem = self.coupons[indexPath.row]
        cell.displayContent(coupon: currentItem, comingFrom: self.comingFrom ,currentPrvid: QiwiOrder.getPrvID(), isSelected: self.selectedCoupons.contains(currentItem))
        
        return cell
    }
}

// MARK: Layout Collection
extension PromoCodeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Layout custom
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 10
            flowLayout.minimumInteritemSpacing = 10
        }
        
        let size = CGSize(width: self.collectionView.frame.width, height: 140)
        return size
    }
}

// MARK: Delegate Collection Favorite
extension PromoCodeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let coupon = self.coupons[indexPath.row]
        
        switch self.comingFrom {
        case .HOME:
            return
        case .CHECKOUT:
            if !coupon.isCouponAvailableForPrvAndValue(prvid: QiwiOrder.getPrvID(), value: QiwiOrder.getValue()) {
                return
            }
        case .PAYMENT_METHODS:
            if !coupon.isCouponAvailableForCouponPaymentMethod(prvid: QiwiOrder.getPrvID(), value: QiwiOrder.getValue()) {
                return
            }
        }
        
        // Colleção com os favoritos no topo, somente row
        let cell: CouponCell? = collectionView.cellForItem(at: indexPath) as? CouponCell
        
        //Se for acumulativo ou se existir cupons na lista e na lista existir no maximo um não acumulativo
        if coupon.isAcumulative {
            
            //Verifica se o que foi clicado já existe e se existir, remove da lista e deseleciona-o
            if selectedCoupons.contains(coupon) {
                self.selectedCoupons.remove(at: self.selectedCoupons.index(of: coupon)!)
                cell?.didUnselect()
                
                //Se estiver vazia, volta a toolbar ao status original
                if selectedCoupons.isEmpty {
                    self.resetNavigation()
                } else {
                    self.setItemsNavigation()
                }
                return
            }
            
            //Verifica se o valor total não passou o valor das compras
            var couponsValues: Double = 0
            for c in selectedCoupons {
                couponsValues = couponsValues + c.value
            }
            
            //Só pode adicionar cupom se o vaor da compra for menor
            if Int(couponsValues*100) < QiwiOrder.getValue() {
                couponsValues += coupon.value
            } else {
                Util.showAlertDefaultOK(self, message: "coupon_error_value_alread_cross_limit".localized)
                return
            }
            
            //Ou se ainda não existir na lista, adiciona e atualiza a toolbar
            cell?.didSelect()
            self.selectedCoupons.append(coupon)
            QiwiOrder.checkoutBody.transition?.coupons?.append(RequestCoupons(code: coupon.code))
            self.setItemsNavigation()
        }
        //Selecionou diretamente um cupom não acumulativo.
        else {
            
            //Se a lista estiver vazia, finaliza e envia pro checkout
            if self.selectedCoupons.isEmpty {
                self.selectedCoupons.removeAll()
                self.selectedCoupons.append(coupon)
                QiwiOrder.coupons = self.selectedCoupons
                for item in self.selectedCoupons {
                    QiwiOrder.checkoutBody.transition?.coupons?.append(RequestCoupons(code: item.code))
                }
                
                //Is from checkout
                if self.comingFrom == .CHECKOUT {
                    self.promocodeSelected?.promocodeSelected(coupons: self.selectedCoupons)
                    self.dismiss(animated: true, completion: nil)
                }
                //Is from payment methods
                else if self.comingFrom == .PAYMENT_METHODS {
                    
                    let transationValue = Double(QiwiOrder.getValue()/100)
                    var totalValue: Double = 0
                    for c in self.selectedCoupons {
                        totalValue += c.value
                    }

                    //Valores precisam ser identicos
                    if totalValue < transationValue {
                        Util.showAlertDefaultOK(
                            self,
                            message: "coupon_error_value_need_to_be_equal".localized.replacingOccurrences(
                                of: "{value}",
                                with: Util.formatCoin(value: transationValue)
                            )
                        )
                        return
                    }
                    
                    self.selectedCoupons.removeAll()
                    self.performSegue(withIdentifier: Constants.Segues.CHECKOUT, sender: nil)
                }
                
            } else {
                //Se não, informa que não é possivel adicionar um cartão não acumulativo
                Util.showAlertDefaultOK(self, message: "coupon_error_inserting_on_list".localized)
            }
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? CouponCell {
//            cell.didUnselect()
//        }
//    }
}
