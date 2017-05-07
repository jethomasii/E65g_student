//
//  EngineProtocol.swift
//  Assignment4
//
//  Created by James Thomas on 4/23/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import Foundation

public protocol EngineDelegate {
    func engineDidUpdate(withGrid: GridProtocol)
}

public protocol EngineProtocol {
    var delegate: EngineDelegate? { get set }
    var grid: GridProtocol { get }
    var refreshRate: Double { get set }
    var refreshTimer: Timer? { get set }
    var rows: Int { get set }
    var cols: Int { get set }
    init(rows: Int, cols: Int)
    func step() -> GridProtocol
}

extension EngineProtocol {
    var refreshRate: Double { return 0.0 }
}

class StandardEngine: EngineProtocol {
    var rows: Int
    var cols: Int
    var grid: GridProtocol
    var refreshTimer: Timer?
    var delegate: EngineDelegate?
    static var sharedEngine = StandardEngine(rows:10,cols:10)
    var cumulativeStats = [CellState: Int]()
    
    required init(rows: Int, cols: Int) {
        cumulativeStats[CellState.born] = 0
        cumulativeStats[CellState.alive] = 0
        cumulativeStats[CellState.died] = 0
        cumulativeStats[CellState.empty] = 0
        self.rows = rows
        self.cols = cols
        self.grid = Grid (rows, cols)
    }
    
    var refreshRate: Double = 0.0 {
        didSet {
            if refreshRate > 0.0 {
                // Invalidate running timer, stops some crazy thing
                if (refreshTimer != nil) {
                    refreshTimer?.invalidate()
                    refreshTimer = nil
                }
                refreshTimer = Timer.scheduledTimer(
                    withTimeInterval: refreshRate,
                    repeats: true
                ) { (t: Timer) in
                    _ = self.step()
                }
            }
            else {
                refreshTimer?.invalidate()
                refreshTimer = nil
            }
        }
    }
    
    func step() -> GridProtocol {
        let newGrid = grid.next()
        self.grid = newGrid
        
        // Update stats
        let currentStats = grid.getCellStateDict()
        cumulativeStats[CellState.born]! = currentStats[CellState.born]!
        cumulativeStats[CellState.alive]! = currentStats[CellState.alive]!
        cumulativeStats[CellState.died]! = currentStats[CellState.died]!
        cumulativeStats[CellState.empty]! = currentStats[CellState.empty]!
        
        // Notifications go here
        
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        let n = Notification(name: name,
                             object: nil,
                             userInfo: ["engine" : self])
        nc.post(n)
        
        return self.grid
    }
    
    func resetStats() {
        cumulativeStats[CellState.born] = 0
        cumulativeStats[CellState.alive] = 0
        cumulativeStats[CellState.died] = 0
        cumulativeStats[CellState.empty] = 0
        
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        let n = Notification(name: name,
                             object: nil,
                             userInfo: ["engine" : self])
        nc.post(n)
    }
    
}
