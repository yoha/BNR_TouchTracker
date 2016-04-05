//
//  DrawView.swift
//  BNR_TouchTracker
//
//  Created by Yohannes Wijaya on 4/5/16.
//  Copyright © 2016 Yohannes Wijaya. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    // MARK: - Stored Properties
    
    var currentLine: Line?
    var finishedLines = Array<Line>()
    
    // MARK: - Local Methods
    
    func strokeLine(line: Line) {
        let bezierPath = UIBezierPath()
        bezierPath.lineWidth = 10
        bezierPath.lineCapStyle = CGLineCap.Round
        
        bezierPath.moveToPoint(line.begin)
        bezierPath.addLineToPoint(line.end)
        bezierPath.stroke()
    }
    
    // MARK: - UIView Methods
    
    override func drawRect(rect: CGRect) {
        // Draw finished lines in black
        UIColor.blackColor().setStroke()
        for line in self.finishedLines {
            self.strokeLine(line)
        }
        if let line = self.currentLine {
            // If there is a line currently being drawn, do it in red
            UIColor.redColor().setStroke()
            self.strokeLine(line)
        }
    }
}
