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
        sender.isEnabled = false
        outlet.setStatus(sender.isOn) {
            self.refreshStatus()
        }
    }
    
    private let outlet = OutletSwitch("192.168.1.166:3333")
    
    private func refreshStatus() {
        if !Thread.isMainThread {
            DispatchQueue.main.sync {
                outletSwitch.isEnabled = false
            }
        } else {
            outletSwitch.isEnabled = false
        }
        
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
        
        refreshStatus()
    }

}

