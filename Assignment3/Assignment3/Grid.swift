//
//  Grid.swift
//
import Foundation

public typealias Position = (row: Int, col: Int)
public typealias PositionSequence = [Position]

// Implement the wrap around rules
public func normalize(position: Position, to modulus: Position) -> Position {
    let modRows = modulus.row, modCols = modulus.col
    return Position(
        row: ((position.row % modRows) + modRows) % modRows,
        col: ((position.col % modCols) + modCols) % modCols
    )
}

// Provide a sequence of all positions in a range
public func positionSequence (from: Position, to: Position) -> PositionSequence {
    return (from.row ..< to.row)
        .map { row in zip( [Int](repeating: row, count: to.col - from.col), from.col ..< to.col ) }
        .flatMap { $0 }
}

public enum CellState {
    case alive, empty, born, died
    
    public var isAlive: Bool {
        switch self {
        case .alive, .born: return true
        default: return false
        }
    }
}

public struct Cell {
    var position = Position(row:0, col:0)
    var state = CellState.empty
}

public struct Grid {
    private var _cells: [[Cell]]
    fileprivate var modulus: Position { return Position(_cells.count, _cells[0].count) }
    
    // Get and Set cell states by position
    public subscript (pos: Position) -> CellState {
        get { let pos = normalize(position: pos, to: modulus); return _cells[pos.row][pos.col].state }
        set { let pos = normalize(position: pos, to: modulus); _cells[pos.row][pos.col].state = newValue }
    }
    
    // Allow access to the sequence of positions
    public let positions: PositionSequence
    
    // Initialize _cells and positions
    public init(_ rows: Int, _ cols: Int, cellInitializer: (Position) -> CellState = { _, _ in .empty } ) {
        _cells = [[Cell]]( repeatElement( [Cell](repeatElement(Cell(), count: rows)), count: cols) )
        positions = positionSequence(from: Position(0,0), to: Position(rows, cols))
        positions.forEach { _cells[$0.row][$0.col].position = $0; self[$0] = cellInitializer($0) }
    }
    
    private static let offsets: [Position] = [
        (row: -1, col:  -1), (row: -1, col:  0), (row: -1, col:  1),
        (row:  0, col:  -1),                     (row:  0, col:  1),
        (row:  1, col:  -1), (row:  1, col:  0), (row:  1, col:  1)
    ]
    private func neighbors(of position: Position) -> [CellState] {
        return Grid.offsets.map {
            let neighbor = normalize(position: Position(
                row: (position.row + $0.row),
                col: (position.col + $0.col)
            ), to: modulus)
            return self[neighbor]
        }
    }
    
    private func nextState(of position: Position) -> CellState {
        switch neighbors(of: position).filter({ $0.isAlive }).count {
        case 2 where self[position].isAlive,
             3: return self[position].isAlive ? .alive : .born
        default: return self[position].isAlive ? .died  : .empty
        }
    }
    
    // Generate the next state of the grid
    public func next() -> Grid {
        var nextGrid = Grid(modulus.row, modulus.col)
        positions.forEach { nextGrid[$0] = self.nextState(of: $0) }
        return nextGrid
    }
}

public extension Grid {
    public var description: String {
        return positions
            .map { (self[$0].isAlive ? "*" : " ") + ($0.1 == self.modulus.col - 1 ? "\n" : "") }
            .joined()
    }
    public var living: [Position] { return positions.filter { return  self[$0].isAlive   } }
    public var dead  : [Position] { return positions.filter { return !self[$0].isAlive   } }
    public var alive : [Position] { return positions.filter { return  self[$0] == .alive } }
    public var born  : [Position] { return positions.filter { return  self[$0] == .born  } }
    public var died  : [Position] { return positions.filter { return  self[$0] == .died  } }
    public var empty : [Position] { return positions.filter { return  self[$0] == .empty } }
}

extension Grid: Sequence {
    public struct SimpleGridIterator: IteratorProtocol {
        private var grid: Grid
        
        public init(grid: Grid) {
            self.grid = grid
        }
        
        public mutating func next() -> Grid? {
            grid = grid.next()
            return grid
        }
    }
    
    public struct HistoricGridIterator: IteratorProtocol {
        private class GridHistory: Equatable {
            let positions: [Position]
            let previous:  GridHistory?
            
            static func == (lhs: GridHistory, rhs: GridHistory) -> Bool {
                return lhs.positions.elementsEqual(rhs.positions, by: ==)
            }
            
            init(_ positions: [Position], _ previous: GridHistory? = nil) {
                self.positions = positions
                self.previous = previous
            }
            
            var hasCycle: Bool {
                var prev = previous
                while prev != nil {
                    if self == prev { return true }
                    prev = prev!.previous
                }
                return false
            }
        }
        
        private var grid: Grid
        private var history: GridHistory!
        
        init(grid: Grid) {
            self.grid = grid
            self.history = GridHistory(grid.living)
        }
        
        public mutating func next() -> Grid? {
            if history.hasCycle { return nil }
            let newGrid = grid.next()
            history = GridHistory(newGrid.living, history)
            grid = newGrid
            return grid
        }
    }
    
    public func makeIterator() -> HistoricGridIterator {
        return HistoricGridIterator(grid: self)
    }
}

func gliderInitializer(row: Int, col: Int) -> CellState {
    switch (row, col) {
    case (0, 1), (1, 2), (2, 0), (2, 1), (2, 2): return .alive
    default: return .empty
    }
}

