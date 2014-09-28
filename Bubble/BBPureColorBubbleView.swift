//
//  BBPureColorBubble.swift
//  Bubble
//
//  Created by PY on 9/28/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import Foundation
import UIKit

class BBPureColorBubbleView: BBBubbleView {
    var bubbleTextColor: UIColor!
    let bigCircleRadius : CGFloat = 100.0
    var bigCircleCenter: CGPoint!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init () {
        super.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        self.bigCircleCenter = CGPointZero
    }
    
    convenience init(origin: CGPoint, radius: CGFloat) {
        var frame = CGRectMake(origin.x, origin.y, 2*radius, 2*radius)
        self.init(frame:frame)
        // this is temporary, should be implemented!
        self.bubbleColor = UIColor.greenColor()
        self.bubbleRadius = radius
        
    }
    
    override func layoutSubviews() {
        var frame = CGRectMake(0.0, 0.0, 2*self.bubbleRadius, 2*self.bubbleRadius)
        self.bubbleView.frame = frame
        // simple implementation
        
        let suView: UIView = self.superview!
        let bound : CGRect = suView.bounds
        self.bigCircleCenter = CGPointMake(CGRectGetMidX(bound)-bigCircleRadius, CGRectGetMidY(bound)-bigCircleRadius)
        
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
    }
    
    func enlargeBubble(animated: Bool) {
        self.bubbleRadius += 2.0
    }
    
    func shrinkBubble(animated: Bool) {
        self.bubbleRadius -= 2.0
    }
    
    class func getBubbleView(color: UIColor, frame: CGRect, radius: CGFloat) -> BBPureColorBubbleView {
        let view = BBPureColorBubbleView(origin: frame.origin, radius: radius)
        view.bubbleColor = color
        return view
    }
}