//
//  UltragazAddressViewController.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 14/05/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit
import CoreLocation

class UltragazAddressViewController: UIBaseViewController {
    
    // MARK : VIEWS
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var txtAddress: MaterialField!
    @IBOutlet weak var btnOtherAddress: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        
        self.txtAddress.addTarget(self, action: #selector(addressChanged), for: UIControlEvents.editingChanged)
    }
}

extension UltragazAddressViewController {
    
    @IBAction func onClickOtherAddress(_ sender: Any) {
        self.txtAddress.text = ""
        self.btnOtherAddress.isHidden = true
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickContinue(_ sender: Any) {
        self.setAddress()
    }
}

extension UltragazAddressViewController {
 
    func setAddress() {
        self.findAddressLoc(address: self.txtAddress.text!)
    }
    
    func findAddressLoc(address: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location else {
                // handle no location found
                    Util.showAlertDefaultOK(self, message: "ultragaz_street_error".localized)
                return
            }

            // Use your location
            QiwiOrder.checkoutBody.requestUltragaz!.latitude = location.coordinate.latitude
            QiwiOrder.checkoutBody.requestUltragaz!.longitude = location.coordinate.longitude
            
//            if QiwiOrder.isUltragaz() && !ApplicationRN.isProd() {
//                QiwiOrder.latitude = -23.607271408952812
//                QiwiOrder.longitude = -46.37404515529871
//            }
            
            self.getAddressFromLatLon(pdblLatitude: String(location.coordinate.latitude), withLongitude: String(location.coordinate.longitude))
        }
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)

        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                    
                    QiwiOrder.adressName = ""
                    self.performSegue(withIdentifier: Constants.Segues.ULTRAGAZ_PRODUCTS, sender: nil)
                    return
                }
                let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                    
                    var addressString : String = ""
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality!
                    }
//                    if pm.postalCode != nil {
//                        addressString = addressString + pm.postalCode! + " "
//                    }

                    //Se deu tudo certo, salva o endereço
                    print(addressString)
                    QiwiOrder.adressName = addressString
                    self.performSegue(withIdentifier: Constants.Segues.ULTRAGAZ_PRODUCTS, sender: nil)
              }
        })
    }
}

extension UltragazAddressViewController {
    
    @objc func addressChanged() {
        self.btnOtherAddress.isHidden = self.txtAddress.text?.isEmpty ?? true
    }
}

extension UltragazAddressViewController: SetupUI {
    
    func setupUI() {
        Theme.default.textAsListTitle(self.lbTitle)
        
        Theme.default.orageButton(self.btnBack)
        Theme.default.greenButton(self.btnContinue)
        
        self.btnOtherAddress.isHidden = true
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: QiwiOrder.productName)
        self.lbTitle.text = "ultragaz_street_title".localized
        self.lbDesc.text = "ultragaz_street_desc".localized
        
        self.txtAddress.placeholder = "ultragaz_street_placeholder".localized

        self.btnOtherAddress.setTitle("ultragaz_street_other_address".localized, for: .normal)
        self.btnBack.setTitle("back".localized, for: .normal)
        self.btnContinue.setTitle("continue_label".localized, for: .normal)
    }
}
