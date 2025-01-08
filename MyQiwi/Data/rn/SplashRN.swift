//
//  SplashRN.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 28/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit
import CoreLocation

class SplashRN: BaseRN {
    
    // MARK: Variables
    
    var mUserRN: UserRN!
    var mApplicationRN: ApplicationRN!
    
    // MARK: Constructor
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
        
        //Generate hash
        //CustomObject().someMethod()
        
        self.mUserRN = UserRN(delegate: delegate)
        self.mApplicationRN = ApplicationRN(delegate: delegate)
        self.mApplicationRN.currentViewController = mUserRN.currentViewController
    }

    // MARK: Methods
    
    func start(sender: UIViewController,location: CLLocation) {
        
        if !self.mApplicationRN.initT() {
            // Verificar o que apresentar se aqui
            return
        }
        
        // Extract Location
        self.mUserRN.sendBaptismAndInitialize(sender: sender, location: location)
    }
}
