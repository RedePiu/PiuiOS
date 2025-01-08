//
//  LocalizationChooseViewContoller.swift
//  MyQiwi
//
//  Created by Thyago on 07/08/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit
import AVFoundation

class LocalizationChooseViewContoller : ClickBusBaseViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewContinue: ViewContinue!
    @IBOutlet weak var btnVoltar: UIButton!

    @IBOutlet weak var viewMainCities: UIStackView!
    @IBOutlet weak var lbMainCity1: UILabel!
    @IBOutlet weak var lbMainCity2: UILabel!
    @IBOutlet weak var lbMainCity3: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var cardLocation: UICardView!

    // MARK : VARIABLES
    let lbRoute: String? = nil
    var departure: String?
    var arrival: String?

    lazy var clickbusRN = ClickBusRN(delegate: self)
    var cities = [ClickBusCity]()
    var mainCities = [ClickBusCity]()
    var searching = false
    var selectedCity = ClickBusCity()

    override func setupViewDidLoad() {
        self.mainCities = self.clickbusRN.getMainCities()
        
        self.setupUI()
        self.setupNib()
        
        self.lbMainCity1.tag = 0
        self.lbMainCity2.tag = 1
        self.lbMainCity3.tag = 2
        
        self.lbMainCity1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickMainCity(sender:))))
        self.lbMainCity2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickMainCity(sender:))))
        self.lbMainCity3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickMainCity(sender:))))
        
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layer.backgroundColor = UIColor.clear.cgColor
        
        self.setupData()
    }
    
    func setupData() {
        self.searchBar.text = ""
        self.viewMainCities.isHidden = false
        self.tableView.isHidden = true
        
        self.setupTexts()
    }
    
    override func realodData() {
        self.setupData()
    }
    
    override func nextStep() {
        self.performSegue(withIdentifier: Constants.Segues.COMPANIES_LIST, sender: nil)
    }
    
    override func backStep() {
        self.popPage()
    }

    func setupNib() {
        self.tableView.register(CityCell.nib(), forCellReuseIdentifier: "Cell")
    }

    override func setupViewWillAppear() {
        //changeLayout(step: (QiwiOrder.stepClickBusIda) ? DEPARTURE : DESTINATION)
    }
}

extension LocalizationChooseViewContoller {
    
    @objc func onClickMainCity(sender: UITapGestureRecognizer) {
        
        let pos = sender.view!.tag
        self.selectedCity = self.mainCities[pos]
        
        if self.isAtDepartureStep() {
           QiwiOrder.clickBusCharge?.cityDeparture = self.selectedCity
        }
        else if self.isAtDestinationStep() {
           QiwiOrder.clickBusCharge?.cityDestiny = self.selectedCity
        }
               
        self.clickContinueRoute()
    }
}

extension LocalizationChooseViewContoller: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CityCell
        let index = indexPath.row
//        let item = self.currentCityArray[index]
//        cell.item = item

        cell.lbCity.text = self.cities[index].name
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableViewAutomaticDimension
        return 40
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 222
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
}

extension LocalizationChooseViewContoller: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let indexPath = self.tableView.indexPathForSelectedRow!
        self.selectedCity = self.cities[indexPath.row]
        
        if self.isAtDepartureStep() {
           QiwiOrder.clickBusCharge?.cityDeparture = self.selectedCity
        }
        else if self.isAtDestinationStep() {
           QiwiOrder.clickBusCharge?.cityDestiny = self.selectedCity
        }
               
        self.clickContinueRoute()
    }
}

extension LocalizationChooseViewContoller: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //self.cities = self.cities.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        
        self.searching = true
        if searchText.isEmpty {
            self.viewMainCities.isHidden = false
            self.tableView.isHidden = true
        } else {
            self.cities = self.clickbusRN.getCities(name: searchText)
            self.viewMainCities.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searching = false
        self.searchBar.text = ""
        self.tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.searching = false
        self.searchBar.text = ""
        self.tableView.reloadData()
    }
}

extension LocalizationChooseViewContoller {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension LocalizationChooseViewContoller: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            
            self.cities = object as! [ClickBusCity]
            self.tableView.reloadData()
        }
    }
}

extension LocalizationChooseViewContoller :SetupUI {

    func setupUI() {

        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lblTitle)
        Theme.default.orageButton(self.btnVoltar)
        
        self.lbMainCity1.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
        self.lbMainCity2.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
        self.lbMainCity3.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
    }

    func setupTexts() {

        Util.setTextBarIn(self, title: "clickbus_title_nav".localized)
        
        if self.isAtDepartureStep() {
            self.lblTitle.text = "clickbus_title_departure".localized
        } else {
            self.lblTitle.text = "clickbus_title_destiny".localized
        }
        
        self.searchBar.placeholder = "clickbus_placeholder_input_city".localized
        self.lbMainCity1.text = self.mainCities[0].name
        self.lbMainCity2.text = self.mainCities[1].name
        self.lbMainCity3.text = self.mainCities[2].name
    }
}
