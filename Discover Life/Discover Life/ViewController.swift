//
//  ViewController.swift
//  Discover Life
//
//  Created by Brandon on 12/8/18.
//  Copyright © 2018 Brandon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let myCities = Cities()
        
        print(myCities.cities)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

