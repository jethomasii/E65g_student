//
//  InstrumentationViewController.swift
//  Assignment4
//
//  Created by James Thomas on 4/16/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {
    
    @IBOutlet weak var refreshSlider: UISlider!
    @IBOutlet weak var colText: UITextField!
    @IBOutlet weak var rowText: UITextField!
    var engine: StandardEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        engine = StandardEngine.sharedEngine
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func colStepperDidTouch(_ sender: UIStepper) {
        colText.text = String(format:"%.0f", sender.value)
    }
    
    @IBAction func rowStepperDidTouch(_ sender: UIStepper) {
        rowText.text = String(format:"%.0f", sender.value)
    }

    
    @IBAction func anyStepperDidTouch(_ sender: UIStepper) {
        rowText.text = String(format:"%.0f", sender.value)
        colText.text = String(format:"%.0f", sender.value)
    }
    
    @IBAction func refreshDidToggle(_ sender: UISwitch) {
        if (sender.isOn) { refreshSlider.isEnabled = true }
        else { refreshSlider.isEnabled = false }
    }
    @IBAction func refreshRateDidChange(_ sender: UISlider) {
        engine.refreshRate = Double(sender.value)
    }
    
}
