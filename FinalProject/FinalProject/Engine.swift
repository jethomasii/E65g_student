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
    var refreshRate: Double = 0.0
    var delegate: EngineDelegate?
    static var sharedEngine = StandardEngine(rows:10,cols:10)
    
    required init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        self.grid = Grid (rows, cols)
    }
    
    func step() -> GridProtocol {
        let newGrid = grid.next()
        self.grid = newGrid
        
        // Notifications go here
        
        return self.grid
    }
    
}
