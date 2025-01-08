//
//  ViewController.swift
//  MyQiwi
//
//  Created by ailton on 12/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SplashViewController: UIBaseViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var lblVersion: UILabel!
    
    // MARK: Variables
    var mSplashRN: SplashRN?
    var mProcessStarted = false
    var mInitFinished = false
    var locationManager = CLLocationManager()
    private var currentLocation = CLLocation()
    var isOnSettings = false
    var timerCount = 0
    var timerLoc: Timer?
    var lat: CLLocationDegrees = 0
    var lng: CLLocationDegrees = 0
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        PushNotification.delegate = self
        
        self.setupUI()
        self.setupTexts()
        //UserRN.clearLoggedUser();
        self.mSplashRN = SplashRN(delegate: self)
        self.mSplashRN?.currentViewController = self
        
        //@@comentar aqui@@
        self.startInitialization(0, 0)
        
        //@@Descomentar aqui@@
        //Se o token já foi gerado, então segue com a localizacao
        //se o token ainda não foi gerado, o onReceiveData é chamado quando isso acontecer.
//        if !PushNotification.appleDeviceToken.isEmpty {
//            self.setupLocalization()
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (mInitFinished) {
            mProcessStarted = false
            mInitFinished = false
            
            startInitialization(self.lat, self.lng)
            // Esperar, e chamar o segue para proxima scene
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                self.performSegue(withIdentifier: Constants.Segues.HOME_TAB, sender: nil)
//            }
            return
        }
    }
    
    func setupLocalization() {
        // Ask for Authorisation from the User.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        // For use in foreground
        //self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func startInitialization(_ lat: CLLocationDegrees, _ lng: CLLocationDegrees) {
        if (mProcessStarted) { return }
        
        self.lat = lat
        self.lng = lng
        
        timerLoc?.invalidate()
        mProcessStarted = true
        let loc = CLLocation(latitude: lat, longitude: lng)
        self.mSplashRN?.start(sender: self, location: loc)
        self.locationManager.stopUpdatingLocation()
        
        print("@! >>> Splash ~> location: ", loc)
    }
}

extension SplashViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        self.lat = locValue.latitude
        self.lng = locValue.longitude
        
        self.startInitialization(locValue.latitude, locValue.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        if let clErr = error as? CLError {
            if (clErr.code == CLError.Code.denied) {
//                if (isOnSettings) {
//                    isOnSettings = false
//                    doActionAfter(after: 0.8, completion: {
//                        exit(0)
//                    })
//                }
                return
            }
        }
        
        self.startInitialization(0, 0)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .notDetermined) {
            locationManager.requestWhenInUseAuthorization()
            print("Location didChangeAuthorization = not determined")
            return
        }
        
        if (status == .denied) {
            self.startInitialization(0, 0)
//            Util.showAlertYesNo(self, message: "location_need_permission".localized, yes: "Configurações", no: "Continuar sem localização", completionOK: {
//                self.doActionAfter(after: 1, completion: {
//
//                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
//                        self.dismiss(animated: true, completion: nil)
//                        return
//                    }
//
//                    if UIApplication.shared.canOpenURL(settingsUrl) {
//                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                            print("Settings opened: \(success)") // Prints true
//                            NotificationCenter.default.addObserver(self, selector: #selector(self.OnReturnFromSettings), name: NSNotification.Name.UIApplicationDidBecomeActive, object: UIApplication.shared)
//                        })
//                    }
//                })
//            }, completionCancel: {
//                self.startInitialization(0, 0)
//            })
            
            return
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            //provavelmente é um emulador
            self.startInitialization(0, 0)
        }
    }
}

extension SplashViewController {
    
    //Será chamado quando a aplicacao voltar a ativa (após estar em foreground)
    @objc func OnReturnFromSettings() {
        //Remove o observer
        NotificationCenter.default.removeObserver(self)
        isOnSettings = true
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            //inicia um timer de 10 segundos para inciar a home caso o gps nao funcione
            timerLoc = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(OnCountTimer), userInfo: nil, repeats: true)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func OnCountTimer() {
        timerCount += 1
        Log.print("Count: \(timerCount)")
        
        if (mInitFinished) {
            timerLoc?.invalidate()
            return
        }
        
        if (timerCount >= 3) {
            timerLoc?.invalidate()
            startInitialization(0, 0)
        }
    }
}

// MARK: Delegate Base
extension SplashViewController: BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.async {
            
            if fromClass == PushNotification.self {
                self.setupLocalization()
                return
            }
            
            //If its telling to finish
            if param == Param.Contact.FINISH_ACTIVITY {
                
                Util.showAlertDefaultOK(self, message: "net_error_baptism_failed".localized) {

                    // Mostra informação que não foi possivel iniciar o app
                    Util.showController(WarningViewController.self, sender: self, completion: { controller in
                        controller.imgAvatar.image = UIImage(named: "ic_warning")
                        controller.lbTitle.text = "Operação não realizada!"
                        controller.lbDesc.text = "net_error_baptism_failed".localized
                        controller.btnContinue.addTarget(self, action: #selector(self.restart), for: .touchUpInside)
                    })
                }

                return
            }
            
            //If its telling to finish
            if param == Param.Contact.UPDATED_NBEEDED {
                self.startUpdateNeededActivity()
                return
            }
            
            //If its coming from User rn class
            if fromClass is UserRN.Type {
                
                if param == Param.Contact.NET_BAPTISM_RESPONSE {
                    
                    if !result {
                        
                        // Mostra informação que não foi possivel iniciar o app
                        Util.showController(WarningViewController.self, sender: self, completion: { controller in
                            controller.imgAvatar.image = UIImage(named: "ic_warning")
                            controller.lbTitle.text = "Operação não realizada!"
                            controller.lbDesc.text = "net_error_baptism_failed".localized
                            controller.btnContinue.addTarget(self, action: #selector(self.restart), for: .touchUpInside)
                        })
                        return
                    }
                    
                    self.mInitFinished = true
                    // Esperar, e chamar o segue para proxima scene
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.performSegue(withIdentifier: Constants.Segues.HOME_TAB, sender: nil)
                    }
                }
            }
        }
    }
}

// MARK: Methods
extension SplashViewController {
    
    @objc func restart() {
        self.setupViewWillAppear()
    }
    
    func startUpdateNeededActivity() {
        Util.showController(UpdateNeededViewController.self, sender: self)
    }
}

// MARK: SetupUI
extension SplashViewController: SetupUI {
    
    func setupUI() {
        Theme.default.textAsMessage(self.lblVersion)
    }
    
    func setupTexts() {
        self.lblVersion.text = "app_info_version".localized
            .replacingOccurrences(of: "{version}", with: Constants.version)
    }
}
