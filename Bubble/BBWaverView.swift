//
//  BBWaveView.swift
//  Bubble
//
//  Created by ChuangXie on 9/27/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import Foundation
import UIKit

class BBWaverView: UIView {
    // y = Asin(wx+fi) + h
    var waverColor: UIColor! {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var waverPeak: CGFloat!
    var waverPhase: CGFloat!
    var waverPhaseIncrement: CGFloat!
    var waverBaseline: CGFloat!
    var waverRadius: CGFloat!
    var waverRising: Bool!
    
    var displayLink: CADisplayLink!
    var animationRunning: Bool!
    
    override var frame:CGRect {
        didSet {
            self.waverBaseline = CGRectGetMidY(frame)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        self.backgroundColor = UIColor.clearColor()
        self.waverRising = false
        self.waverPeak = 1.2
        self.waverPhase = 0.0
        self.waverBaseline = 0.0
        self.waverPhaseIncrement = 0.1
        self.waverColor = UIColor(red: 86/255.0, green: 202/255.0, blue: 139/255.0, alpha: 1)
        
        // init the display for efficient drawing
        self.displayLink = CADisplayLink(target: self, selector: Selector("animateWave"))
        self.animationRunning = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func animateWave() {
        
        if self.waverRising == true {
            self.waverPeak = self.waverPeak + 0.01
        }else{
            self.waverPeak = self.waverPeak - 0.01
        }
        // 1.0 ~ 1.5 is the vibrate offset value
        if self.waverPeak <= 1.0 {
            self.waverRising = true;
        }
        if self.waverPeak >= 1.5 {
            self.waverRising = false;
        }
        
        self.waverPhase = self.waverPhase + self.waverPhaseIncrement
        
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        
        if self.animationRunning == false {
            self.displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            self.animationRunning = true
        }
        
        var centerPoint = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        var context: CGContextRef = UIGraphicsGetCurrentContext()
        var path: CGMutablePathRef = CGPathCreateMutable()

        CGContextSetLineWidth(context, 20)
        CGContextSetFillColorWithColor(context, self.waverColor.CGColor)
        
        var lineY:CGFloat = self.waverBaseline
        
        // Here are the funny stupid things
        CGPathMoveToPoint(path, nil, 0, lineY)
        
        // T = 2*M_PI
        for (var x = 0; x < Int(rect.width); x++) {
            var angle = 1.2*(CGFloat(x) / 180.0) * CGFloat(M_PI) + 2*self.waverPhase / CGFloat(M_PI)
            lineY = 3.0 * self.waverPeak * sin(CGFloat(angle)) + self.waverBaseline
            
            CGPathAddLineToPoint(path, nil, CGFloat(x), lineY)
        }
        
        CGPathAddLineToPoint(path, nil, rect.width, rect.height)
        CGPathAddLineToPoint(path, nil, 0.0, rect.height)
        
        CGContextAddPath(context, path)
        CGContextFillPath(context)
        CGContextDrawPath(context, kCGPathStroke)
    }
}
