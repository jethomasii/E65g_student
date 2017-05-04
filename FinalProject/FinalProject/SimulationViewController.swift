//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by James Thomas on 4/16/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, GridViewDataSource, EngineDelegate {
    
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
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(
            forName: name,
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
        engine.step()
        self.mainGrid.setNeedsDisplay()
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        self.mainGrid.size = withGrid.size.rows
        self.mainGrid.setNeedsDisplay()
    }
    
}
