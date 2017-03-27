//
//  GridView.swift
//  Assignment3
//
//  Created by James Thomas on 3/26/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

@IBDesignable class GridView: UIView {
    /*  grid - Grid object used to store the grid
        updated when size changes as per problem 2
    */
    var grid = Grid(20,20)
    @IBInspectable var size = 20 {
        didSet { grid = Grid(size,size) }
    }
    @IBInspectable var livingColor = UIColor.black
    @IBInspectable var emptyColor = UIColor.clear
    @IBInspectable var bornColor = UIColor.gray
    @IBInspectable var diedColor = UIColor.gray
    @IBInspectable var gridColor = UIColor.black
    @IBInspectable var gridWidth = CGFloat(1.0)
    
    override func draw(_ rect: CGRect) {
        
        /*  colorDict - maps CellStates to colors used for Cell Drawing */
        let colorDict = [CellState.alive: livingColor,
                         CellState.empty: emptyColor,
                         CellState.born: bornColor,
                         CellState.died: diedColor]
        /*  cellSize - height/width of cells based on the size of
            the view and the size var
        */
        let cellSize = CGSize(
            width: rect.size.width / CGFloat(size),
            height: rect.size.height / CGFloat(size)
        )
        
        /*  code for drawing the ovals in each cell
            based on code given in XView from lecture
            Updated to reflect size var instead of static
            values
        */
        let base = rect.origin
        (0 ..< size).forEach { i in
            (0 ..< size).forEach { j in
                let origin = CGPoint(
                    x: base.x + (CGFloat(j) * cellSize.width),
                    y: base.y + (CGFloat(i) * cellSize.height)
                )
                let subRect = CGRect(
                    origin: origin,
                    size: cellSize
                )
                let path = UIBezierPath(ovalIn: subRect)
                let cellColor = colorDict[grid[(i,j)]]
                cellColor?.setFill()
                path.fill()
            }
        }
        
        //  code for drawing lines, also from XView
        (0 ..< size+1).forEach {
            drawLine(
                start:  CGPoint(x: CGFloat($0)/CGFloat(size) * rect.size.width, y: 0.0),
                end:    CGPoint(x: CGFloat($0)/CGFloat(size) * rect.size.width, y: rect.size.height)
            )
            drawLine(
                start:  CGPoint(x: 0.0, y: CGFloat($0)/CGFloat(size) * rect.size.height),
                end:    CGPoint(x: rect.size.width, y: CGFloat($0)/CGFloat(size) * rect.size.height)
            )
        }
    }
    /*  drawLine - used above, provides the actual
        implementation of line drawing. Based on XView
    */
    func drawLine(start:CGPoint, end:CGPoint) {
        let path = UIBezierPath()
        path.lineWidth = gridWidth
        path.move(to: start)
        path.addLine(to: end)
        gridColor.setStroke()
        path.stroke()
    }
    
    //  Touch functions adapted from Lecture 7
    typealias Position = (row: Int, col: Int)
    var lastTouchedPosition: Position?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = nil
    }
    
    /*  process - process UITouch input to update cells
        i.e. toggle states by touch
    */
    func process(touches: Set<UITouch>) -> Position? {
        guard touches.count == 1 else { return nil }
        let pos = convert(touch: touches.first!)
        guard lastTouchedPosition?.row != pos.row
            || lastTouchedPosition?.col != pos.col
            else { return pos }
        grid[(pos.row,pos.col)] = grid[(pos.row,pos.col)].toggle(value: grid[(pos.row,pos.col)])
        setNeedsDisplay()
        return pos
    }
    
    /*  convert - conterts UITouch to position to determine
        which cells are updated in func process
    */
    func convert(touch: UITouch) -> Position {
        let touchY = touch.location(in: self).y
        let gridHeight = frame.size.height
        let row = touchY / gridHeight * CGFloat(size)
        let touchX = touch.location(in: self).x
        let gridWidth = frame.size.width
        let col = touchX / gridWidth * CGFloat(size)
        let position = (row: Int(row), col: Int(col))
        return position
    }

    /*  iterateGrid - advances the grid based on current
        cells one iteration.
    */
    func iterateGrid() {
        grid = grid.next()
        setNeedsDisplay()
    }
    
}
