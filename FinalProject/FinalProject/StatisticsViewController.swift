//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by James Thomas on 4/16/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var bornLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var diedLabel: UILabel!
    @IBOutlet weak var livedLabel: UILabel!
    var engine: StandardEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        engine = StandardEngine.sharedEngine
        self.setLabels()
        
        // Add Listener
        let nc = NotificationCenter.default
        
        // Notification names
        let engineUpdate = Notification.Name(rawValue: "EngineUpdate")
        
        // Observers
        nc.addObserver(
            forName: engineUpdate,
            object: nil,
            queue: nil) { (n) in
                self.setLabels()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Update labels for their values
    func setLabels() {
        let currentStates = engine.cumulativeStats
        bornLabel.text = String(currentStates[CellState.born]!)
        emptyLabel.text = String(currentStates[CellState.empty]!)
        diedLabel.text = String(currentStates[CellState.died]!)
        livedLabel.text = String(currentStates[CellState.alive]!)
    }
    
}
