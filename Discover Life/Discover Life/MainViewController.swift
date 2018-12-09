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

class MainViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {
    
    var locationManager = CLLocationManager()
    
    //MapBox navigation view
    var mapView: NavigationMapView!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doNothing))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
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
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    @objc func doNothing(){
        print("")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
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
