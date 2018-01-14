//
//  TodayViewController.swift
//  Switch Widget
//
//  Created by Greg Paton on 12/6/17.
//  Copyright © 2017 GSP. All rights reserved.
//

import UIKit
import NotificationCenter
import OutletSwitchControl

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var outletSwitch: UISwitch!
    
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        if !outletSwitch.isEnabled {
            self.refreshStatus()
        }
    }
    
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TodayViewController.handleTapGesture(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        refreshStatus()
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
