//
//  ViewController.swift
//  Search-Bach
//
//  Created by Quang Bach on 4/7/17.
//  Copyright © 2017 QuangBach. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces



protocol DataSelectDelegate: class {
    func dataLoad(data: [StoreService])
}

class MapViewCotroller: UIViewController {

    weak var delegate: DataSelectDelegate? = nil

    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 13.0
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    let defauLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 20.989517, longitude: 105.791456)
    var camera: GMSCameraPosition!
    
    //data
    var arrayAddress =  [StoreService]()
    var arrayMaker = [GMSMarker]()
    
    //post data service
    var url: URL!
    var dict: JSONDictionary!
    var type = ""
    //layout
    let buttonDemo: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "CoffeBtn")
        button.setTitleColor(UIColor.darkGray, for: .highlighted)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(selectedType), for: .touchUpInside)
        return button
    }()
    let buttonRes: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "RestaurantBtn")
        button.setTitleColor(UIColor.darkGray, for: .highlighted)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(resBtn), for: .touchUpInside)
        return button
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        return label
    }()
    
    @IBOutlet weak var radiusLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        camera = GMSCameraPosition.camera(withLatitude: defauLocation.latitude, longitude: defauLocation.longitude, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        view.addSubview(mapView)
        mapView.delegate = self
        locationManagers()
        updateUI()
        
        
    }

    func updateUI(){
        radiusLb.text = "Radius: \(Int(mapView.getRadius()))m"
        mapView.settings.myLocationButton = true
        //addSubview
        view.addSubview(buttonDemo)
        view.addSubview(buttonRes)
        view.addSubview(label)
        //autoLayout
        view.addConstrainsWithFormat(format: "H:|-8-[v0]", view: buttonDemo)
        view.addConstrainsWithFormat(format: "V:|-20-[v0]", view: buttonDemo)
        
        view.addConstrainsWithFormat(format: "H:[v0]-8-|", view: buttonRes)
        view.addConstrainsWithFormat(format: "V:|-20-[v0]-08-[v1]", view: buttonRes,label)
        view.addConstrainsWithFormat(format: "H:|-08-[v0]", view: label)
        viewSubview()
    }
    
    func viewSubview (){
        view.bringSubview(toFront: radiusLb)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    func resBtn(){
//        arrayAddress = []
//        arrayMaker = []
//        mapView.clear()
        //print(mapView.getRadius())
        type = "Quán ăn"
        url = URL(string: URL_NEAR)
        dict = ["lat":"\(mapView.getCenterCoordinate().latitude)","long":"\(mapView.getCenterCoordinate().longitude)","r":"\(Int(mapView.getRadius()))","type": type]
        downloadData(url: url!, dict: dict) {
            DispatchQueue.main.async {
                self.delegate?.dataLoad(data: self.arrayAddress)
                if self.arrayAddress.count != 0 {
                    for i in self.arrayAddress {
                        self.maker(i: i)
                    }
                    self.camera = GMSCameraPosition.camera(withTarget: self.arrayMaker[0].position, zoom: self.mapView.camera.zoom)
                    self.mapView.animate(to: self.camera)
                    self.label.text = "\(self.arrayMaker.count)"
                    
                } else {
                   self.label.text = ""
                }
            }
        }
    }
    func selectedType() {
        type = "Café/Dessert"
        url = URL(string: URL_NEAR)
        dict = ["lat":"\(mapView.getCenterCoordinate().latitude)","long":"\(mapView.getCenterCoordinate().longitude)","r":"\(Int(mapView.getRadius()))","type": type]
        downloadData(url: url!, dict: dict) {
            DispatchQueue.main.async {
        
                self.delegate?.dataLoad(data: self.arrayAddress)
                //when address show, camera return arrayAddress[0]
                if self.arrayAddress.count != 0 {
                        for i in self.arrayAddress {
                            self.maker(i: i)
                        }
                        self.camera = GMSCameraPosition.camera(withTarget: self.arrayMaker[0].position, zoom: self.mapView.camera.zoom)
                        self.mapView.animate(to: self.camera)
                        self.label.text = "có \(self.arrayMaker.count) \(self.type) tìm được"
                } else {
                    self.label.text = "Di chuyển để tìm thêm"
                }

                }
            }
        }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManagers() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        placesClient = GMSPlacesClient.shared()
    }
    
    

}
extension MapViewCotroller: CLLocationManagerDelegate {
    //handle incomming location Even
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location : CLLocation = locations.last!
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }
    
    func maker(i: StoreService){
        let lat = (i.lat as NSString).doubleValue
        let long = (i.long as NSString).doubleValue
        let maker = GMSMarker()
        maker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        maker.icon = UIImage(named: "\(i.type)Marker")
        maker.appearAnimation = kGMSMarkerAnimationPop
        maker.map = mapView
        arrayMaker.append(maker)
    }
    
    func indexMaker(marker: GMSMarker) -> Int {
        var result = 0
        
        for i in 0 ..< arrayMaker.count {
            let customMarker = arrayMaker[i]
            if customMarker.position.latitude == marker.position.latitude &&
                customMarker.position.longitude == marker.position.longitude{
                result = i
            }
        }
        
        return result

    }
}


extension MapViewCotroller: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.selectedMarker = marker
        return true
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = Bundle.main.loadNibNamed("WindowMaker", owner: self.view, options: nil)?.first as! WindowMaker
        view.configWindowMaker(data: arrayAddress[indexMaker(marker: marker)])
        return view
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailCotroller
        detailVC.detail = arrayAddress[indexMaker(marker: marker)]
        present(detailVC, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        radiusLb.text = "Radius: \(Int(mapView.getRadius()))m"
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        if url != nil || dict != nil {
            url = URL(string: URL_NEAR)
            dict = ["lat":"\(mapView.getCenterCoordinate().latitude)","long":"\(mapView.getCenterCoordinate().longitude)","r":"\(Int(mapView.getRadius()))","type": type]
            downloadData(url: url!, dict: dict) {
                DispatchQueue.main.async {
                    self.delegate?.dataLoad(data: self.arrayAddress)
                    //when address show, camera return arrayAddress[0]
                    if self.arrayAddress.count != 0 {
                        
                        for i in self.arrayAddress {
                            self.maker(i: i)
                        }
                        self.label.text = "có \(self.arrayMaker.count) \(self.type) tìm được"
                        } else {
                            self.label.text = "di chuyển thêm"
                        
                    }
                }
            }
        }
    }
}

extension MapViewCotroller {
    func downloadData(url: URL,dict: JSONDictionary,completion: @escaping DownloadCompleted) {
        arrayAddress = []
        arrayMaker = []
        mapView.clear()
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        var body = ""
        for (key, value) in dict {
            let value = value as! String
            body = body.appending(key)
            body = body.appending("=")
            body = body.appending(value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
            body = body.appending("&")
        }
        let data = body.data(using: .utf8)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = data
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let responseHTTP = response as? HTTPURLResponse, responseHTTP.statusCode == 200 {
                    do {
                        let arrayDict = try! JSONSerialization.jsonObject(with: data!, options: []) as? [JSONDictionary]
                        for jsonDict in arrayDict! {
                            let post = StoreService(result: jsonDict)
                            self.arrayAddress.append(post!)
                        }
                        print(self.arrayAddress.count)
                    }
                    completion()
                }
            }
        }
        task.resume()
        
    }
}

extension UIView {
    func addConstrainsWithFormat(format: String, view: UIView...){
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in view.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


