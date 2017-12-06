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
            self.refreshStatus()
        }
    }
    
    private let outlet = OutletSwitch()
    
    private func refreshStatus() {
        outletSwitch.isEnabled = false
        outlet.getStatus { (status, error) in
            DispatchQueue.main.async {
                if status != nil {
                    self.outletSwitch.isEnabled = true
                    self.outletSwitch.isOn = status!
                } else {
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        outlet.address = "192.168.1.166:3333"
    }

}

