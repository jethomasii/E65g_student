//
//  InstrumentationViewController.swift
//  Assignment4
//
//  Created by James Thomas on 4/16/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

// URL of remote grids
let remoteGridsURL = "https://dl.dropboxusercontent.com/u/7544475/S65g.json"

class InstrumentationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var refreshSwitch: UISwitch!
    @IBOutlet weak var rowStepper: UIStepper!
    @IBOutlet weak var colStepper: UIStepper!
    @IBOutlet weak var refreshSlider: UISlider!
    @IBOutlet weak var colText: UITextField!
    @IBOutlet weak var rowText: UITextField!
    @IBOutlet weak var configTableView: UITableView!
    var engine: StandardEngine!
    var sectionHeaders = [String]()
    var gridData = Array<Array<NSDictionary>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        engine = StandardEngine.sharedEngine
        
        // Add Listener
        let nc = NotificationCenter.default
        let engineUpdate = Notification.Name(rawValue: "SavedGridsUpdate")
        nc.addObserver(
            forName: engineUpdate,
            object: nil,
            queue: nil) { (n) in
                self.updateSavedGrids()
                self.configTableView.reloadData()
        }

        // Create section headers
        sectionHeaders.append("Saved")
        sectionHeaders.append("Downloaded")
        
        // get saved grids
        self.updateSavedGrids()
        
        // Download grid information for class
        self.getGrids()
        
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
        return gridData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gridData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "gridConf"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        let currentGridDictionary = gridData[indexPath.section][indexPath.item] 
        label.text = currentGridDictionary["title"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    // send item to the grid editor view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let currentIndexPath = configTableView.indexPathForSelectedRow
        if let currentIndexPath = currentIndexPath {
            let currentGridDictionary = gridData[currentIndexPath.section][currentIndexPath.row]
            if let vc = segue.destination as? GridEditorViewController {
                // add values
                vc.gridDictionary = currentGridDictionary
                // Update dictionary
                vc.saveClosure = { newGridDictionary in
                    
                    // Do not update downloaded items add a new one instead
                    if (self.sectionHeaders[currentIndexPath.section] == "Saved") {
                        self.gridData[currentIndexPath.section][currentIndexPath.row] = newGridDictionary
                    } else {
                        let savedIndex = self.sectionHeaders.index(of: "Saved")
                        self.gridData[savedIndex!] = [newGridDictionary] + self.gridData[savedIndex!]
                    }
                    self.rowStepper.value = Double(vc.size)
                    self.anyStepperDidTouch(self.rowStepper)
                    self.saveGrids()
                    self.configTableView.reloadData()
                }
            }
        }
    }
    
    // allow deletion of items
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var newData = gridData[indexPath.section]
            newData.remove(at: indexPath.row)
            gridData[indexPath.section] = newData
            // Update Saved Grids
            self.saveGrids()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    
    // Do not allow deletion/editing of downloaded items
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (sectionHeaders[indexPath.section] == "Saved") {
            return true
        } else {
            return false
        }
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
    
    @IBAction func addNewConfiguration(_ sender: Any) {
        let savedIndex = self.sectionHeaders.index(of: "Saved")
        let currentGridDictionary = ["title": "new", "contents": nil]
        gridData[savedIndex!] = [currentGridDictionary as NSDictionary] + gridData[savedIndex!]
        self.saveGrids()
        self.configTableView.reloadData()
    }
    
    //MARK: Miscellaneous
    
    func getGrids() {
        let fetcher = Fetcher()
        fetcher.fetchJSON(url: URL(string:remoteGridsURL)!) { (json: Any?, message: String?) in
            guard message == nil else {
                print (message ?? "nil")
                return
            }
            guard let json = json else {
                print("no json")
                return
            }
            let gridArray = json as! Array<NSDictionary>
            self.gridData.append(gridArray)
            OperationQueue.main.addOperation {
                self.configTableView.reloadData()
            }
        }
    }
    
    func saveGrids() {
        let savedIndex = self.sectionHeaders.index(of: "Saved")
        let savedGrids = gridData[savedIndex!]
        let plistData = NSKeyedArchiver.archivedData(withRootObject: savedGrids)
        let defaultsDict = UserDefaults.standard
        defaultsDict.set(plistData, forKey: "savedGrids")
    }
    
    func updateSavedGrids() {
        // Check for saved grids
        print("Updating saved Grids!")
        let defaultsDict = UserDefaults.standard
        var savedGrids = Array<NSDictionary>()
        if let plistData = defaultsDict.object(forKey: "savedGrids") {
            savedGrids = NSKeyedUnarchiver.unarchiveObject(with: plistData as! Data) as! [NSDictionary]
        }

        
        if (gridData.count > 0) {
            gridData[0] = savedGrids
        } else {
            gridData.append(savedGrids)
        }
    }
    
}
