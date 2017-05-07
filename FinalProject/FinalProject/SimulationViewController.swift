//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by James Thomas on 4/16/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, GridViewDataSource, EngineDelegate {
    

    @IBOutlet weak var refreshSwitch: UISwitch!
    @IBOutlet weak var mainGrid: GridView!
    var engine: StandardEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setup the engine
        engine = StandardEngine.sharedEngine
        mainGrid.size = engine.grid.size.rows
        engine.delegate = self
        
        // Update the grid with the initial values
        mainGrid.gridDataSource = self
        self.engineDidUpdate(withGrid: engine.grid)
        
        // Notification listening
        let nc = NotificationCenter.default
        
        // Notification names
        let engineUpdate = Notification.Name(rawValue: "EngineUpdate")
        
        // Observers
        nc.addObserver(
            forName: engineUpdate,
            object: nil,
            queue: nil) { (n) in
                self.mainGrid.setNeedsDisplay()
        }

    }
    
    public subscript (row: Int, col: Int) -> CellState {
        get { return engine.grid[row,col] }
        set { engine.grid[row,col] = newValue }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stepDidTouch(_ sender: UIButton) {
        _ = engine.step()
        self.mainGrid.setNeedsDisplay()
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        self.mainGrid.size = withGrid.size.rows
        self.engine.resetStats()
        self.mainGrid.setNeedsDisplay()
    }
    
    @IBAction func resetGrid(_ sender: Any) {
        self.engine.resetGrid()
    }
    
    @IBAction func saveGrid(_ sender: Any) {
        let defaultsDict = UserDefaults.standard
        var savedGrids = Array<NSDictionary>()
        let plistData = defaultsDict.object(forKey: "savedGrids") as! Data
        
        if (plistData.isEmpty) {
            savedGrids = Array<NSDictionary>()
            let defaultDictionary = ["title": "default", "contents": []] as [String : Any]
            savedGrids.append(defaultDictionary as NSDictionary)
        }
        
        let gridMap = engine.grid.getCurrentGridData()
        print("Grid Data %", gridMap)
        
        let alert = UIAlertController(title: "Set Title", message: "Please enter a title for the saved grid", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = "title"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
            return
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            print("Text field: \(textField?.text)")
        }))
        
        
        self.present(alert, animated: true, completion:nil)
    }
    
}
