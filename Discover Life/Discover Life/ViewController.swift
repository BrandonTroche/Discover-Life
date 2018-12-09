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
            let URLString = "https://a9a20ecc.ngrok.io/user"
            
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
                    UserDefaults.standard.set(self.emailTextField.text!, forKey: "email")
                    UserDefaults.standard.set(self.passwordTextField.text!, forKey: "password")
                    
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    
    @IBAction func signupAction(_ sender: UIButton) {
        
        let URLString = "https://a9a20ecc.ngrok.io/new_user"
        
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
                UserDefaults.standard.set(self.emailTextField.text!, forKey: "email")
                UserDefaults.standard.set(self.passwordTextField.text!, forKey: "password")
                
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
        
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        self.emailTextField.inputAccessoryView = toolbar
        self.passwordTextField.inputAccessoryView = toolbar
        // Do any additional setup after loading the view, typically from a nib.
        if UserDefaults.standard.string(forKey: "email") != nil{
            emailTextField.text! = UserDefaults.standard.string(forKey: "email")!
        }
        if UserDefaults.standard.string(forKey: "password") != nil{
            passwordTextField.text! = UserDefaults.standard.string(forKey: "password")!
        }
        
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

