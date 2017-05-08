//
//  GridEditorViewController.swift
//  FinalProject
//
//  Created by James Thomas on 5/6/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class GridEditorViewController: UIViewController, GridViewDataSource, EngineDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var editGrid: GridView!
    var saveClosure: ((NSDictionary) -> Void)?
    var engine: StandardEngine!
    var gridDictionary: NSDictionary!
    var size: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Pull GridData from dictonary and prep for loading grid
        let gridArray = gridDictionary.object(forKey: "contents") as? NSArray
        var gridMap = [GridPosition]()
        size = 10

        // copy items into gridMap and find the size
        if (gridArray != nil){
            if ((gridArray?.count)! > 0) {
                for entry in gridArray! {
                    let testCell = entry as! NSArray
                    let testPos = GridPosition(row: testCell[0] as! Int, col: testCell[1] as! Int)
                    gridMap.append(testPos)
                    if (testPos.row > size || testPos.col > size) {
                        size = testPos.row > testPos.col ? testPos.row : testPos.col
                    }
                }
                
            }
        }
        // Adjust size as multiple of 10
        if (size % 10 != 0) { size = size + (10 - size % 10) }
        
        // Create non-singleton engine
        engine = StandardEngine.init(size: size, withMap: gridMap)
        editGrid.size = engine.grid.size.rows
        engine.delegate = self
        
        // Update grid with initial values
        editGrid.gridDataSource = self
        self.engineDidUpdate(withGrid: engine.grid)
        
        // Update tile
        titleTextField.text = gridDictionary.object(forKey: "title") as? String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Show navigation bar
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    // GridView Data Source
    public subscript (row: Int, col: Int) -> CellState {
        get { return engine.grid[row,col] }
        set { engine.grid[row,col] = newValue }
    }
    
    // Engine delegate
    func engineDidUpdate(withGrid: GridProtocol) {
        self.editGrid.size = withGrid.size.rows
        self.editGrid.setNeedsDisplay()
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        let gridMap = engine.grid.getCurrentGridData()
        
        self.gridDictionary = ["title": titleTextField.text as Any, "contents": gridMap] as NSDictionary!
        
        if let newGridDictionary = self.gridDictionary,
            let saveClosure = saveClosure {
            saveClosure(newGridDictionary)
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        // Notify the simulation view and pass grid
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "GridEditorSave")
        let n = Notification(name: name,
                             object: nil,
                             userInfo: ["gridEditor" : self,
                                        "grid": self.engine.grid])
        nc.post(n)
        
        /* old method for reference
        let runSerialQueue = DispatchQueue(label: "savedgridsupdate")
        runSerialQueue.sync {

            // Gather savedGrids from preferences
            let defaultsDict = UserDefaults.standard
            var savedGrids = Array<NSDictionary>()
            if let plistData = defaultsDict.object(forKey: "savedGrids") {
                savedGrids = NSKeyedUnarchiver.unarchiveObject(with: plistData as! Data) as! [NSDictionary]
            }
            
            // Pull the gridMap, extended GridProtocol for this
            let gridMap = engine.grid.getCurrentGridData()

            // Save the grid
            
            let currentGridDictionary = ["title": titleTextField.text as Any, "contents": gridMap] as [String : Any]
            if (self.sectionHeader == "Saved") {
                savedGrids[self.savedIndex] = (currentGridDictionary as NSDictionary)
            } else {
                savedGrids.append(currentGridDictionary as NSDictionary)
            }
            let newPlistData = NSKeyedArchiver.archivedData(withRootObject: savedGrids)
            defaultsDict.set(newPlistData, forKey: "savedGrids")

            // Notify that there was a grid saved
            let nc = NotificationCenter.default
            let name = Notification.Name(rawValue: "SavedGridsUpdate")
            let n = Notification(name: name,
            object: nil,
            userInfo: ["simulationView" : self])
            nc.post(n)

        }
        */
    }
    @IBAction func cancelButtonDidPress(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
