//
//  ClickBusBaseViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 10/12/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ClickBusBaseViewController: UIBaseViewController {
    
    static let TYPE_GO = 1
    static let TYPE_BACK = 2
    public static var currentStepIda: Constants.StepsClickBusIda = .NO_STEP
    public static var currentStepIdaVolta: Constants.StepsClickBusIdaVolta = .NO_STEP
    
    func realodData() {
    }
    
    func nextStep() {
    }
    
    func backStep() {
    }
    
    @IBAction func popPageClickbus(_ sender: Any? = nil) {
        self.clickBackRoute()
    }
    
    @IBAction func dismissPageClickbus(_ sender: Any?) {
        self.clickBackRoute()
    }
    
    func getCurrentStepIda() -> Constants.StepsClickBusIda {
        return ClickBusBaseViewController.currentStepIda
    }
    
    func getCurrentStepVolta() -> Constants.StepsClickBusIdaVolta {
        return ClickBusBaseViewController.currentStepIdaVolta
    }
    
    static func forwardStep() {
        if QiwiOrder.isClickBusOnlyIda() {
            let oldStep = ClickBusBaseViewController.currentStepIda
            
            if oldStep == .PASSANGER && ApplicationRN.isQiwiBrasil() {
                ClickBusBaseViewController.currentStepIda = .PAYMENT
            }
            else {
                let nextStep = ClickBusBaseViewController.currentStepIda.rawValue + 1
                if let newStep = Constants.StepsClickBusIda(rawValue: nextStep) {
                    ClickBusBaseViewController.currentStepIda = newStep
                }
            }
        }
        else {
            //Ida e volta
            let oldStep = ClickBusBaseViewController.currentStepIdaVolta
            
            if oldStep == .PASSANGER_RETURNING && ApplicationRN.isQiwiBrasil() {
                ClickBusBaseViewController.currentStepIdaVolta = .PAYMENT
            } else {
                let nextStep = ClickBusBaseViewController.currentStepIdaVolta.rawValue + 1
                if let newStep = Constants.StepsClickBusIdaVolta(rawValue: nextStep) {
                    ClickBusBaseViewController.currentStepIdaVolta = newStep
                }
            }
        }
    }
    
    static func backwardStep() {
        
        if QiwiOrder.isClickBusOnlyIda() {
            let oldStep = ClickBusBaseViewController.currentStepIda
            
            if oldStep == .PAYMENT && ApplicationRN.isQiwiBrasil() {
                ClickBusBaseViewController.currentStepIda = .PASSANGER
            }
            else {
                let nextStep = ClickBusBaseViewController.currentStepIda.rawValue - 1
                if let newStep = Constants.StepsClickBusIda(rawValue: nextStep) {
                    ClickBusBaseViewController.currentStepIda = newStep
                }
            }
        } else {
            //Ida e volta
            let oldStep = ClickBusBaseViewController.currentStepIdaVolta
            
            if oldStep == .PAYMENT && ApplicationRN.isQiwiBrasil() {
                ClickBusBaseViewController.currentStepIdaVolta = .PASSANGER_RETURNING
            }
            else {
                let nextStep = ClickBusBaseViewController.currentStepIdaVolta.rawValue - 1
                if let newStep = Constants.StepsClickBusIdaVolta(rawValue: nextStep) {
                    ClickBusBaseViewController.currentStepIdaVolta = newStep
                }
            }
        }
    }
    
    @objc func clickContinueRoute() {
        
        
        if QiwiOrder.isClickBusOnlyIda() {
            
            let oldStep = ClickBusBaseViewController.currentStepIda
            ClickBusBaseViewController.forwardStep()
            
            switch oldStep {
                
                case .NO_STEP:
                    fallthrough
                case .DEPARTURE:
                    self.realodData()
                    break
                case .DESTINATION:
                    self.nextStep()
                    break
                case .TRAVEL_OPTIONS:
                    self.nextStep()
                    break
                case .SEATS:
                    self.nextStep()
                    break
                case .PASSANGER:
                    self.nextStep()
                    break
                case .INPUT_EMAIL:
                    self.nextStep()
                    break
                case .PAYMENT:
                    self.nextStep()
                    break
                case .CHECKOUT:
                    self.nextStep()
                    return
            }
        }
        else if QiwiOrder.isClickBusIdaEVolta() {
            
            let oldStep = ClickBusBaseViewController.currentStepIdaVolta
            ClickBusBaseViewController.forwardStep()
            
            switch oldStep {
                case .NO_STEP:
                    fallthrough
                case .DEPARTURE:
                    self.realodData()
                    break
                case .DESTINATION:
                    self.nextStep()
                    break
                case .TRAVEL_OPTIONS_GOING:
                    self.realodData()
                    break
                case .TRAVEL_OPTIONS_RETURNING:
                    self.nextStep()
                    break
                case .SEATS_DEPARTURE:
                    self.nextStep()
                    break
                case .PASSANGER_DEPARTURE:
                    self.nextStep()
                    break
                case .SEATS_RETURNING:
                    self.nextStep()
                    break
                case .PASSANGER_RETURNING:
                    self.nextStep()
                    break
                case .INPUT_EMAIL:
                    self.nextStep()
                    break
                case .PAYMENT:
                    self.nextStep()
                    break
                case .CHECKOUT:
                    return
            }
        }
    }
    
    @objc func clickBackRoute() {
        
        if QiwiOrder.isClickBusOnlyIda() {
            
            let oldStep = ClickBusBaseViewController.currentStepIda
            ClickBusBaseViewController.backwardStep()
            
            switch oldStep {
                case .NO_STEP:
                    fallthrough
                case .DEPARTURE:
                    self.backStep()
                    break
                case .DESTINATION:
                    self.realodData()
                    break
                case .TRAVEL_OPTIONS:
                    self.backStep()
                    break
                case .SEATS:
                    self.backStep()
                    break
                case .PASSANGER:
                    self.backStep()
                    break
                case .INPUT_EMAIL:
                    self.dismissPage(nil)
                    break
                case .PAYMENT:
                    if ApplicationRN.isQiwiBrasil() {
                        self.dismissPage(nil)
                        return
                    }
                    self.backStep()
                    break
                case .CHECKOUT:
                    return
            }
        }
        else if QiwiOrder.isClickBusIdaEVolta() {
            
            let oldStep = ClickBusBaseViewController.currentStepIdaVolta
            ClickBusBaseViewController.backwardStep()
            
            switch oldStep {
                case .NO_STEP:
                fallthrough
                case .DEPARTURE:
                    self.backStep()
                    break
                case .DESTINATION:
                    self.realodData()
                    break
                case .TRAVEL_OPTIONS_GOING:
                    self.backStep()
                    break
                case .TRAVEL_OPTIONS_RETURNING:
                    self.realodData()
                    break
                case .SEATS_DEPARTURE:
                    self.backStep()
                    break
                case .PASSANGER_DEPARTURE:
                    self.backStep()
                    break
                case .SEATS_RETURNING:
                    self.dismissPage(nil)
                    break
                case .PASSANGER_RETURNING:
                    self.backStep()
                    break
                case .INPUT_EMAIL:
                    self.dismissPage(nil)
                    break
                case .PAYMENT:
                    if ApplicationRN.isQiwiBrasil() {
                        self.dismissPage(nil)
                        return
                    }
                    self.backStep()
                    break
                case .CHECKOUT:
                    self.backStep()
                    break
            }
        }
    }
    
    func isAtDepartureStep() -> Bool {
        return ClickBusBaseViewController.currentStepIda == .DEPARTURE || ClickBusBaseViewController.currentStepIdaVolta == .DEPARTURE
    }
    
    func isAtDestinationStep() -> Bool {
        return ClickBusBaseViewController.currentStepIda == .DESTINATION || ClickBusBaseViewController.currentStepIdaVolta == .DESTINATION
    }
    
    func isAtPassageSelectionGoingStep() -> Bool {
        return ClickBusBaseViewController.currentStepIda == .TRAVEL_OPTIONS || ClickBusBaseViewController.currentStepIdaVolta == .TRAVEL_OPTIONS_GOING
    }
    
    func isAtPassageSelectionReturningStep() -> Bool {
        return ClickBusBaseViewController.currentStepIdaVolta == .TRAVEL_OPTIONS_RETURNING
    }
    
    func isAtSeatsGoingStep() -> Bool {
        return ClickBusBaseViewController.currentStepIda == .SEATS || ClickBusBaseViewController.currentStepIdaVolta == .SEATS_DEPARTURE
    }
    
    func isAtSeatsReturningStep() -> Bool {
        return ClickBusBaseViewController.currentStepIdaVolta == .SEATS_RETURNING
    }
    
    func isAtPassangersGoingStep() -> Bool {
        return ClickBusBaseViewController.currentStepIda == .PASSANGER || ClickBusBaseViewController.currentStepIdaVolta == .PASSANGER_DEPARTURE
    }
    
    func isAtPassangersReturningStep() -> Bool {
        return ClickBusBaseViewController.currentStepIdaVolta == .PASSANGER_RETURNING
    }
    
    func isAtPaymentOrCheckout() -> Bool {
        return ClickBusBaseViewController.currentStepIda == .CHECKOUT || ClickBusBaseViewController.currentStepIda == .PAYMENT ||  ClickBusBaseViewController.currentStepIdaVolta == .CHECKOUT ||  ClickBusBaseViewController.currentStepIdaVolta == .PAYMENT
    }
}
