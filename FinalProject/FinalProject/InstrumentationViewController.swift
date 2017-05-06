//
//  InstrumentationViewController.swift
//  Assignment4
//
//  Created by James Thomas on 4/16/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

var sectionHeaders = [
    "One", "Two", "Three", "Four", "Five", "Six"
]

var data = [
    [
        "Apple",
        "Banana",
        "Cherry",
        "Date",
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry",
        "Date"
    ],
    [
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry",
        "Date",
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry",
        "Date",
        "Kiwi",
        "Apple",
        "Banana"
    ],
    [
        "Cherry",
        "Date",
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry",
        "Date",
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry",
        "Date",
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry",
        "Date",
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry"
    ],
    [
        "Date",
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry",
        "Date",
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry",
        "Date",
        "Kiwi",
        "Apple",
        "Banana",
        "Cherry",
        "Date",
        "Kiwi",
        "Blueberry"
    ]
]


class InstrumentationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var refreshSwitch: UISwitch!
    @IBOutlet weak var rowStepper: UIStepper!
    @IBOutlet weak var colStepper: UIStepper!
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
    
    // Hide navigation bar
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    /* to be implemented if ever row ≠ grid, but probably not
    @IBAction func colStepperDidTouch(_ sender: UIStepper) {
        colText.text = String(format:"%.0f", sender.value)
    }
    
    @IBAction func rowStepperDidTouch(_ sender: UIStepper) {
        rowText.text = String(format:"%.0f", sender.value)
    }
    */

    //MARK: TableView DataSource and Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "gridConf"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        label.text = data[indexPath.section][indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    //MARK: (#pragma mark ?) Control button handling
    
    @IBAction func anyStepperDidTouch(_ sender: UIStepper) {
        // This code keeps rows == to col because my grid is not updated for variable sizes
        
        rowText.text = String(format:"%.0f", sender.value)
        colText.text = String(format:"%.0f", sender.value)
        
        rowStepper.value = sender.value
        colStepper.value = sender.value
        
        engine.grid = Grid(Int(sender.value), Int(sender.value))
        engine.delegate?.engineDidUpdate(withGrid: engine.grid)
        
    }
    
    @IBAction func refreshDidToggle(_ sender: Any) {
        
        if (refreshSwitch.isOn) {
            engine.refreshRate = 1.0 / Double(refreshSlider.value)
        }
        else {
            engine.refreshRate = 0.0

        }

    }
    
}
