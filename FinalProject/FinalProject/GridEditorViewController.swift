//
//  GridEditorViewController.swift
//  FinalProject
//
//  Created by James Thomas on 5/6/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class GridEditorViewController: UIViewController, GridViewDataSource, EngineDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var editGrid: GridView!
    var engine: StandardEngine!
    var gridDictionary: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create non-singleton engine
        engine = StandardEngine(rows: 10, cols: 10)
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
    
}
