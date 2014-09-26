//
//  BBTaskBubbleView.swift
//  Bubble
//
//  Created by ChuangXie on 9/26/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import Foundation
import UIKit

class BBTaskBubbleView: UIView {
    
    var bubbleView: UIView!
    var bubbleText: String! {
        didSet {
            // retreive the initial letters of bubble text
            self.bubbleTextLabel?.text = bubbleText.initalCharacters().uppercaseString
        }
    }
    var bubbleTextLabel: UILabel!
    var bubbleTextColor: UIColor!
    var bubbleColor: UIColor?
    var bubbleStrokeColor: UIColor?
    var bubbleRadius: CGFloat = 0.0 {
        didSet {
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }
    var bubbleLayer: CAShapeLayer!

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
        self.bubbleView = UIView()
        self.bubbleView.clipsToBounds = true
        self.bubbleView.backgroundColor = UIColor.clearColor()
        
        self.bubbleTextLabel = UILabel()
        self.bubbleTextLabel.textAlignment = NSTextAlignment.Center
        self.bubbleTextLabel.backgroundColor = UIColor.clearColor()
        
        self.bubbleTextColor = UIColor.darkGrayColor()
        self.bubbleTextLabel.textColor = self.bubbleTextColor
        
        self.bubbleLayer = CAShapeLayer()
        self.layer.insertSublayer(self.bubbleLayer, atIndex: 0)
    }
    
    convenience init(origin: CGPoint, radius: CGFloat) {
        var frame = CGRectMake(origin.x, origin.y, 2*radius, 2*radius)
        self.init(frame:frame)
        
        self.bubbleRadius = radius
        self.bubbleColor = UIColor.greenColor()
        
        self.bubbleView.addSubview(self.bubbleTextLabel)
        self.addSubview(self.bubbleView)
    }
    
    override func drawRect(rect: CGRect) {
        // set the center of the circle to be the center of the view
        let center = CGPointMake(self.bubbleRadius, self.bubbleRadius)
        
        // arcCenter is in the current coordiante system
        self.bubbleLayer.path = UIBezierPath(arcCenter: center, radius: self.bubbleRadius,
            startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: true).CGPath
        
        // configure the circle
        self.bubbleLayer.fillColor = self.bubbleColor?.CGColor
        self.bubbleLayer.strokeColor = self.bubbleStrokeColor?.CGColor
        self.bubbleLayer.lineWidth = 0.0
    }
    
    override func layoutSubviews() {
        var frame = CGRectMake(0.0, 0.0, 2*self.bubbleRadius, 2*self.bubbleRadius)
        self.bubbleView.frame = frame
        // simple implementation
        self.bubbleTextLabel.frame = frame
    }
    
    func enlargeBubble(animated: Bool) {
        self.bubbleRadius += 2.0
    }
    
    func shrinkBubble(animated: Bool) {
        self.bubbleRadius -= 2.0
    }
    
    /*
    * map radius to the related font-size
    */
    func mapRadius() {
        
    }
    
}
