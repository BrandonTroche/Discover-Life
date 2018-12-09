//
//  EventViewController.swift
//  Discover Life
//
//  Created by Brandon on 12/9/18.
//  Copyright © 2018 Brandon. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import CoreLocation

class EventViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var eventNameTextField: UITextField!
        
    @IBOutlet weak var tipSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var costTextField: UITextField!
    
    @IBOutlet weak var locationPicker: UIPickerView!
    
    @IBOutlet weak var startTime: UITextField!
    
    @IBOutlet weak var endTime: UITextField!
    
    var pickerData: [String] = [String]()
    
    @IBAction func createAction(_ sender: UIButton) {
        
        let URLString = "https://a9a20ecc.ngrok.io/new_event"
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        print(hour, minutes)
        print(date)
        
        let locationDict = [
            "Hotel Andra STN - Seattle": [47.6133677, -122.3401251],
            "Grand Hyatt Seattle STN - Seattle": [47.6123491 , -122.333257],
            "The Edgewater STN - Seattle": [47.6125226, -122.3521859],
            "The Fairmont Olympic Hotel STN - Seattle": [47.6081064, -122.3339844],
            "W Seattle STN - Seattle": [47.607387, -122.3336235],
            "Hotel 1000 STN - Seattle": [47.6050424, -122.3361071],
            "Alexis Hotel STN - Seattle": [47.6048834, -122.3367717]
        ]
        
//        print(pickerData[locationPicker.selectedRow(inComponent: 0)])
        
        let selected = pickerData[locationPicker.selectedRow(inComponent: 0)]
        
        let latSel = locationDict[selected]![0]
        
        let longSel = locationDict[selected]![1]
        
        Alamofire.request(URLString, method: .post, parameters: ["latitude": latSel, "longitude": longSel, "event_id": "e3", "hotel_name":pickerData[locationPicker.selectedRow(inComponent: 0)], "city": "Seattle", "state": "Washington", "country":"United States", "number_in_attendence": 1, "rough_cost_estimate": costTextField.text!, "does_require_tip": tipSegmentControl.selectedSegmentIndex, "time_began_hour":String(describing: hour), "time_began_minute":String(describing: minutes), "time_ending": endTime.text!, "date_created":String(describing: date), "has_finished":"no"], encoding: JSONEncoding.default, headers: nil).responseString { response in

            switch response.result {
            case .success:
                print("pass")
            case .failure(let error):
                print(error)

            }
        }
    }
    
    var locationManager = CLLocationManager()
    
    let geocoder = CLGeocoder()
    
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
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        self.eventNameTextField.inputAccessoryView = toolbar
        self.costTextField.inputAccessoryView = toolbar
        self.startTime.inputAccessoryView = toolbar
        self.endTime.inputAccessoryView = toolbar
        
        self.locationPicker.delegate = self
        self.locationPicker.dataSource = self
        
        pickerData = ["Hotel Andra STN - Seattle", "Grand Hyatt Seattle STN - Seattle", "The Edgewater STN - Seattle", "The Fairmont Olympic Hotel STN - Seattle", "W Seattle STN - Seattle", "Hotel 1000 STN - Seattle", "Alexis Hotel STN - Seattle"]
        
        print(self.locationManager.location?.coordinate.longitude as Any)
        print(self.locationManager.location?.coordinate.latitude as Any)
        
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
                            print("pass")
                        case .failure(let error):
                            print(error)
                    
                        }
                }
            }
        }
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[row]
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        
    }

}
