//
//  MainViewController.swift
//  Discover Life
//
//  Created by Brandon on 12/8/18.
//  Copyright © 2018 Brandon. All rights reserved.
//
import UIKit
import Foundation
import Alamofire
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import MapboxGeocoder
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cellContent = [String]()
    
    var cellLength:Int = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellLength
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = cellContent[indexPath.row]
        
        return cell
    }
    
    
    var locationManager = CLLocationManager()
    
    let geocoder = CLGeocoder()
    
    //MapBox navigation view
    var mapView: NavigationMapView!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView = NavigationMapView(frame: view.bounds)
        mapView.layer.zPosition = 999
        mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.5)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(mapView)
        
        view.bringSubview(toFront: mapView)
        
        mapView.delegate = self
        
        mapView.showsUserLocation = true
//        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.setUserTrackingMode(.follow, animated: false)
        
        mapView.zoomLevel = 12
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        print(self.locationManager.location?.coordinate.longitude as Any)
        print(self.locationManager.location?.coordinate.latitude as Any)
        
        let URLString2 = "https://a9a20ecc.ngrok.io/tip/guide"
        
        Alamofire.request(URLString2, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
            case .success:
                if let result = response.result.value {
                    print("Tip")
                    print(result)
                    print("")
                    let res = result as! NSDictionary
                    UserDefaults.standard.set(res["percentage"], forKey: "tip")
                }
                // self.rowText = (JSON["Latitude"] as! String) + (JSON["Longitude"] as! String)
                print("pass")
                //                        UserDefaults.standard.set(self.emailTextField.text!, forKey: "email")
                //                        UserDefaults.standard.set(self.passwordTextField.text!, forKey: "password")
                
            case .failure(let error):
                print(error)
            }
            
        }
        
        let URLString3 = "https://a9a20ecc.ngrok.io/currency/exchangerate"
        
        Alamofire.request(URLString3, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
            case .success:
                if let result = response.result.value {
                    print("Currency")
                    print(result)
                    print("")
                    let res = result as! NSDictionary
                    UserDefaults.standard.set(res["exchangerate"], forKey: "exchange")
                }
                // self.rowText = (JSON["Latitude"] as! String) + (JSON["Longitude"] as! String)
                print("pass")
                //                        UserDefaults.standard.set(self.emailTextField.text!, forKey: "email")
                //                        UserDefaults.standard.set(self.passwordTextField.text!, forKey: "password")
                
            case .failure(let error):
                print(error)
            }
            
        }
        
        geocoder.reverseGeocodeLocation(CLLocation(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)) { (placemarks, error) in
            
            if let placemark = placemarks?[0] {
                print("")
                print(placemark.region!)
                print("")
                print(placemark.locality!)
                print("")
                print(placemark.subLocality!)
                print("")
                print(placemark.country!)
                print("")
                
                let URLString = "https://a9a20ecc.ngrok.io/location"
                
                Alamofire.request(URLString, method: .post, parameters: ["latitude": self.locationManager.location?.coordinate.latitude as Any, "longitude": self.locationManager.location?.coordinate.longitude as Any, "city": placemark.locality!], encoding: JSONEncoding.default, headers: nil).responseString { response in
                    
                    switch response.result {
                    case .success:
                        if let result = response.result.value {
                            print("")
                            print("")
                            print("")
                            //                            var newString = result.replacingOccurrences(of: "[", with: "")
                            //                            newString = newString.replacingOccurrences(of: "]", with: "")
                            //                            newString = newString.replacingOccurrences(of: "\"", with: "")
                            //                            newString = newString.replacingOccurrences(of: "'", with: "\"")
                            //                            print(newString)
                            print(result)
                            print("")
                            var dictonary:NSDictionary?
                            
                            if let data = result.data(using: String.Encoding.utf8) {
                                
                                do {
                                    dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
                                    
                                    if let myDictionary = dictonary{
                                        self.cellLength = dictonary!.count
                                        for x in dictonary! {
                                            
                                            print("dict")
                                            
                                            print(x.value)
                                            
                                            var newS = x.value as! String
                                            newS = newS.replacingOccurrences(of: "'", with: "\"")
                                            
                                            print(newS)
                                            
                                            var newD:NSDictionary?
                                            
                                            if let newData = newS.data(using: String.Encoding.utf8) {
                                                do {
                                                    newD = try JSONSerialization.jsonObject(with: newData, options: []) as? [String:AnyObject] as NSDictionary?
                                                    
                                                    print(newD!["hotel_name"])
                                                    let newContent = newD!["hotel_name"] as! String
                                                    
                                                    self.cellContent.append(newContent)
                                                    
                                                    let coord = CLLocationCoordinate2D(latitude: newD!["latitude"]! as! CLLocationDegrees, longitude: newD!["longitude"] as! CLLocationDegrees)
                                                    
                                                    let ann = MGLPointAnnotation() //RideAnnotation(coordinate: coord, title: "Ride", subtitle: "This is my ride")
                                                    ann.coordinate = coord
                                                    
                                                    var tip = ""
                                                    var tipM = ""
                                                    
                                                    if newD!["does_require_tip"] as! Int == 1 {
                                                        tip = "Yes"
                                                        tipM = UserDefaults.standard.string(forKey: "tip")!
                                                    } else {
                                                        tip = "No"
                                                    }
                                                    
                                                    var cost = newD!["rough_cost_estimate"] as! Double
                                                    
                                                    var ex = UserDefaults.standard.string(forKey: "exchange")!
                                                    
                                                    var conv = Double(cost) / Double(ex)!
                                                    
                                                    var con = String(format: "%.2f", conv) // "3.14"
                                                    
                                                    ann.title = "Tip: " + tip + " " + tipM + "| Cost: $" + String(describing: cost) + " £" + String(describing: con)
                                                    
                                                    //Add that annotation to the MapBox map
                                                    self.mapView.addAnnotation(ann)
                                                }
                                            }
                                            
                                        }
                                        
                                        self.tableView.reloadData()
                                        
                                    }//end if
                                    
                                } catch let error as NSError {
                                    print(error)
                                }
                            }
                            print("")
                            // self.rowText = (JSON["Latitude"] as! String) + (JSON["Longitude"] as! String)
                        }
                        print("pass")
                        //                        UserDefaults.standard.set(self.emailTextField.text!, forKey: "email")
                        //                        UserDefaults.standard.set(self.passwordTextField.text!, forKey: "password")
                        
                    case .failure(let error):
                        print(error)
                    }
                    
                }
                
            }// End Alamofire
            
        }//end geocode
        

    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.willRemoveSubview(mapView)
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//let date = Date()
//let calendar = Calendar.current
//let hour = calendar.component(.hour, from: date)
//let minutes = calendar.component(.minute, from: date)

//let myCities = Cities()
//
////        print(myCities.cities["result"]!)
//
//var myarr = myCities.cities["result"]! as! Array<Dictionary<String, Any>>
//
//for x in 0...myarr.count - 1{
//    print("")
//    print(myarr[x]["_id"])
//    print("")
//}
//
////        print(myarr[0]["_id"])
