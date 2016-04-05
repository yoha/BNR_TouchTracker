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
    
    var currentLines = [NSValue: Line]()
    var finishedLines = Array<Line>()
    
    // MARK: - IBInspectable properties
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.blackColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.redColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    // MARK: - Local Methods
    
    func strokeLine(line: Line) {
        let bezierPath = UIBezierPath()
        bezierPath.lineWidth = self.lineThickness
        bezierPath.lineCapStyle = CGLineCap.Round
        
        bezierPath.moveToPoint(line.begin)
        bezierPath.addLineToPoint(line.end)
        bezierPath.stroke()
    }
    
    // MARK: - UIView Methods
    
    override func drawRect(rect: CGRect) {
        self.finishedLineColor.setStroke()
        for line in self.finishedLines {
            self.strokeLine(line)
        }
        self.currentLineColor.setStroke()
        for (_, line) in self.currentLines {
            self.strokeLine(line)
        }
    }
    
    // MARK: - UIResponder Methods
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Let's put in a log statement to see the order of events
        print(__FUNCTION__)
        for touch in touches {
            let validTouchLocation = touch.locationInView(self)
            let newLine = Line(begin: validTouchLocation, end: validTouchLocation)
            // Will return the memory address of the argument
            let key = NSValue(nonretainedObject: touch)
            self.currentLines[key] = newLine
        }
        self.setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Let's put in a log statement to see the order of events
        print(__FUNCTION__)
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            self.currentLines[key]?.end = touch.locationInView(self)
        }
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Let's put in a log statement to see the order of events
        print(__FUNCTION__)
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var validLine = self.currentLines[key] {
                validLine.end = touch.locationInView(self)
                self.finishedLines.append(validLine)
                self.currentLines.removeValueForKey(key)
            }
        }
        self.setNeedsDisplay()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        // Let's put in a log statement to see the order of events
        print(__FUNCTION__)
        self.currentLines.removeAll()
        self.setNeedsDisplay()
    }
}
