//
//  ViewController.swift
//  Discover Life
//
//  Created by Brandon on 12/8/18.
//  Copyright © 2018 Brandon. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var locationManager = CLLocationManager()
    
    @IBAction func loginAction(_ sender: UIButton) {
        if emailTextField.text! == "" || passwordTextField.text! == "" {
            print("nothing entered")
        } else {
            let URLString = "https://055d202e.ngrok.io/user"
            
            Alamofire.request(URLString, method: .post, parameters: ["latitude": self.locationManager.location?.coordinate.latitude as Any, "longitude": self.locationManager.location?.coordinate.longitude as Any, "username": emailTextField.text!, "password": passwordTextField.text!], encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                
                switch response.result {
                case .success:
                    if let result = response.result.value {
                        print(response.result.value!)
                        let JSON = result as! NSDictionary
//                        self.rowText = (JSON["Latitude"] as! String) + (JSON["Longitude"] as! String)
                        self.performSegue(withIdentifier: "authSegue", sender: self)
                    }
                    print("pass")
                    
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    
    @IBAction func signupAction(_ sender: UIButton) {
        
        let URLString = "https://055d202e.ngrok.io/new_user"
        
        Alamofire.request(URLString, method: .post, parameters: ["latitude": self.locationManager.location?.coordinate.latitude as Any, "longitude": self.locationManager.location?.coordinate.longitude as Any, "username": emailTextField.text!, "password": passwordTextField.text!], encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
            case .success:
                if let result = response.result.value {
                    print(response.result.value!)
                    let JSON = result as! NSDictionary
                    //                        self.rowText = (JSON["Latitude"] as! String) + (JSON["Longitude"] as! String)
                    self.performSegue(withIdentifier: "authSegue", sender: self)
                }
                print("pass")
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

