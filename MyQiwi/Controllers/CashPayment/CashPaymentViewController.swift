//
//  CashPaymentViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 29/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import GooglePlaces
import Alamofire

class CashPaymentViewController: UIBaseViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var mapLocation: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnArrive: UIButton!
    @IBOutlet weak var lbPlace: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var detailContainer: UICardView!

    var points = [QiwiPoint]()
    lazy var paymentRN = PaymentRN(delegate: self)
    var selectedQiwiPoint = QiwiPoint()
    var typeOfPoint: Int = ActionFinder.QiwiPoints.TYPE_MONEY
    
    var locationManager = CLLocationManager()
    var locationView = CLLocationCoordinate2D()
    var currentLocation: CLLocation?
    let height = CGFloat(50)
    var zoomLevel: Float = 18.0
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    var colorLine : Int = 0
    var longPressRecognizer = UILongPressGestureRecognizer()
    var marker = GMSMarker()
    var geocoder = GMSGeocoder()

    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.getLocation()
        self.mapLocation.delegate = self
        self.mapLocation.isMyLocationEnabled = true
        self.mapLocation.accessibilityElementsHidden = false

        var fr: CGRect = UIScreen.main.bounds
        self.detailContainer.alpha = 0
        self.detailContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor)

        self.btnArrive.addTarget(self, action: #selector(createRoute(_:)), for: .touchUpInside)

        var item: QiwiPoint! {
            didSet {
                self.lbPlace?.text = item.storeName
                self.lbAddress?.text = item.storeNameAddress
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }

    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // Put something here
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Put something here
            break
        case .authorizedAlways:
            break
        case .denied:
            break
        }
    }

    func getLocation() {
        locationManager = CLLocationManager()
        setupLocationManager()
        locationManager.startUpdatingLocation()
        self.mapLocation.settings.myLocationButton = true
    }

    func resetNavigation() {

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        let userLocation = locations.last
        let latitude = userLocation!.coordinate.latitude
        let longitude = userLocation!.coordinate.longitude
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: zoomLevel)

        if (latitude == 0 && longitude == 0) {
            self.latitude = -23.557939
            self.longitude = -46.662122
        } else {
            self.latitude = latitude
            self.longitude = longitude
        }

        mapLocation.camera = camera
        mapLocation.animate(to: camera)

        let marker = GMSMarker(position: center)

        marker.map = mapLocation
        //self.requestPointsList(latitude: marker.position.latitude, longitude: marker.position.longitude, radius: 300)

        print("Latitude :- \(userLocation!.coordinate.latitude)")
        print("Longitude :- \(userLocation!.coordinate.longitude)")

        locationManager.stopUpdatingLocation()
    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {

//        var visibleRegion = mapView.projection.visibleRegion()
//        var cameraZoom = mapView.camera.zoom
//        var bounds = GMSCoordinateBounds(region: visibleRegion)
//        var southWestCorner = bounds.southWest

        let radius = Int(mapView.getRadius())
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        self.requestPointsList(latitude: latitude, longitude: longitude, radius: radius)
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {

        print(coordinate)

        self.fadeOutView()
        self.detailContainer.isHidden = true
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

        let target = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
        mapLocation.camera = GMSCameraPosition.camera(withTarget: target, zoom: zoomLevel)

        var myData = marker.userData as! Dictionary<String, Any>
        let point = myData["point"] as! QiwiPoint
        self.selectedQiwiPoint = point

        self.lbPlace.text = point.storeName
        self.lbAddress.text = point.address

        self.fadeInView()
        self.detailContainer.isHidden = false

        return true
    }
}

extension CashPaymentViewController {

    @objc func createRoute(_ sender: UIButton) {
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)))
        source.name = "Você está aqui!"

        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.selectedQiwiPoint.latitude, longitude: self.selectedQiwiPoint.longitude)))
        destination.name = "\(self.selectedQiwiPoint.storeNameAddress)"

        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }

    func fadeInView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.detailContainer.alpha = 1
        })
    }

    func fadeOutView() {
        UIView.animate(withDuration: 0.8, animations: {
            self.detailContainer.alpha = 0
        })
    }

    func updatePoints(points: [QiwiPoint]) {
        self.points = points
        self.createPins()
    }

    func createPins() {
        self.mapLocation.clear()

        var marker: GMSMarker
        for point in self.points {
            marker = GMSMarker()

            marker.icon = UIImage(named: "ic_pin_qiwi")
            marker.position.latitude = point.latitude
            marker.position.longitude = point.longitude
            marker.map = mapLocation

            var myData = Dictionary<String, Any>()
            myData["point"] = point
            marker.userData = myData
        }
    }

    func requestPointsList(latitude: Double, longitude: Double, radius: Int) {
        self.paymentRN.getQiwiPointList(latitude: latitude, longitude: longitude, raio: radius, isFirstConsult: true, paymentType: self.typeOfPoint)
    }
}

extension CashPaymentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.points.count
    }
}

extension CashPaymentViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            if param == Param.Contact.QIWIPOINTS_RESPONSE {
                //self.dismiss(animated: true, completion: nil)
                self.updatePoints(points: object as! [QiwiPoint])
            }
        }
    }
}

extension CashPaymentViewController: SetupUI{
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.greenButton(self.btnArrive)
        Theme.default.textAsListTitle(self.lbPlace)
        Theme.default.textAsDefault(self.lbAddress)

        self.lbAddress.textColor = UIColor.lightGray
    }

    func setupTexts() {
        Util.setTextBarIn(self, title: "map_title".localized)
        self.btnArrive.setTitle("map_button_arrive".localized, for: .normal)
    }
}

// calculate radius
extension GMSMapView {

    // calculate radius
    func getCenterCoordinate() -> CLLocationCoordinate2D {
        let centerPoint = self.center
        let centerCoordinate = self.projection.coordinate(for: centerPoint)
        return centerCoordinate
    }

    func getTopCenterCoordinate() -> CLLocationCoordinate2D {
        // to get coordinate from CGPoint of your map
        let topCenterCoor = self.convert(CGPoint(x: self.frame.size.width, y: 0), from: self)
        let point = self.projection.coordinate(for: topCenterCoor)
        return point
    }

    func getRadius() -> CLLocationDistance {
        let centerCoordinate = getCenterCoordinate()
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        let topCenterCoordinate = self.getTopCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        let radius = CLLocationDistance(centerLocation.distance(from: topCenterLocation))
        return round(radius)
    }
}
