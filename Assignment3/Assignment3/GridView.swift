//
//  GridView.swift
//  Assignment3
//
//  Created by James Thomas on 3/26/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

@IBDesignable class GridView: UIView {
    
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
    
    
    
}
