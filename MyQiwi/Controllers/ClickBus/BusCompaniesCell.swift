//
//  BusCompaniesCell.swift
//  MyQiwi
//
//  Created by Thyago on 14/08/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit
import WebKit
import Kingfisher

class BusCompaniesCell: UIBaseTableViewCell {

    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var lbBusCompany: UILabel!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var lbDeparture: UILabel!
    @IBOutlet weak var lbArrival: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var timeDeparture: UILabel!
    @IBOutlet weak var timeArrive: UILabel!
    @IBOutlet weak var imgCompany: UIImageView!
    
    var item: ClickbusScheduleResponse! {
        
        didSet {
            
            self.lbType.text = item.serviceClass
            self.lbBusCompany.text = item.busCompany
            self.timeDeparture.text = item.timeDeparture
            self.lbDeparture.text = item.originStation
            self.timeArrive.text = item.timeArrival
            self.lbArrival.text = item.destinyStation
            self.lbPrice.text = Util.formatCoin(value: item.price)
            
            let departureStr = item.dateDeparture + item.timeDeparture
            let arrivalStr = item.dateArrival + item.timeArrival
            self.lbTime.text = self.getDuration(departureStr: departureStr, arrivalStr: arrivalStr)
            
//            let url = URL(string: item.logo)
//            self.webView.load(URLRequest(url: url!))
            
            let svgUrl = URL(string: item.logo)!
            let processor = SVGProcessor(size: self.imgCompany.frame.size)
            KingfisherManager.shared.retrieveImage(with: svgUrl, options: [.processor(processor), .forceRefresh]) {  result in
                   switch (result){
                       case .success(let value):
                        self.imgCompany.image = value.image
                       case .failure(let error):
                           print("error", error.localizedDescription)
                   }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    func getDuration(departureStr: String, arrivalStr: String) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddHH:mm"

        let departure = dateFormatter.date(from: departureStr) ?? Date()
        let arrival = dateFormatter.date(from: arrivalStr) ?? Date()
        
        let interval = arrival.timeIntervalSince(departure)
        return interval.toClock()
    }
    
//    private String getDuration(String departureStr,String arrivalStr) {
//        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-ddHH:mm");
//        Date departure = null;
//        Date arrival = null;
//        try {
//            departure = format.parse(departureStr);
//            arrival = format.parse(arrivalStr);
//        } catch (ParseException e) {
//            e.printStackTrace();
//            return "00:00";
//        }
//
//        long mills =  arrival.getTime() - departure.getTime();
//        return TimeFormatter.getAsHourAndMinutesOnlyTime(mills);
//    }
}
