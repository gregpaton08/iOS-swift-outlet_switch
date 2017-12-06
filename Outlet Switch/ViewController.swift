//
//  ViewController.swift
//  Outlet Switch
//
//  Created by Greg Paton on 12/6/17.
//  Copyright © 2017 GSP. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var outletSwitch: UISwitch!
    
    @IBAction func pressOutletSwitch(_ sender: UISwitch) {
        outlet.setStatus(sender.isOn) {
            
        }
    }
    
    private let outlet = OutletSwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        outlet.address = "192.168.1.166:3333"
    }

}

