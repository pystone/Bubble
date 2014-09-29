//
//  BBBubbleView.swift
//  Bubble
//
//  Created by ChuangXie on 9/26/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import Foundation
import UIKit

class BBBubbleView: UIView {
    
    var bubbleView: UIView!
    var bubbleColor: UIColor?
    var bubbleStrokeColor: UIColor?
    
    var bubbleRadius: CGFloat = 0.0 {
        didSet {
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }
    var bubbleLayer: CAShapeLayer!
    
    var _taskID: Int? {
        didSet {
            setContent()
        }
    }
    
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
        
        self.bubbleLayer = CAShapeLayer()
        
        self.addSubview(self.bubbleView)
        self.layer.insertSublayer(self.bubbleLayer, atIndex: 0)
        
        // provide a black default bubbleColor to inform you that you may actually
        // need to customize this
        self.bubbleColor = UIColor.blackColor()
        
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("bubbleViewDidTap:"))
        self.addGestureRecognizer(tapGesture)
        
        var panGesture = UIPanGestureRecognizer(target: self, action: Selector("bubbleViewDidPan:"))
        self.addGestureRecognizer(panGesture)
    }
    
    class func bubbleView(withColor: UIColor, frame: CGRect) -> BBBubbleView {
        var view = BBBubbleView(frame: frame)
        view.bubbleColor = withColor
        return view
    }
    
    override func drawRect(rect: CGRect) {
        // set the center of the circle to be the center of the view
        let center = CGPointMake(self.bubbleRadius, self.bubbleRadius)
        
        // configure the bubble layer
        self.bubbleLayer.fillColor = self.bubbleColor?.CGColor
        self.bubbleLayer.strokeColor = self.bubbleStrokeColor?.CGColor
        self.bubbleLayer.lineWidth = 0.0
        
        // arcCenter is in the current coordiante system
        self.bubbleLayer.path = UIBezierPath(arcCenter: center, radius: self.bubbleRadius,
            startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: true).CGPath
    }
    
    func setContent() {
        // to be implemented
    }
    
    func bubbleViewDidTap(sender: UITapGestureRecognizer) {
        // subclass can implment this method as needed
    }
    
    func bubbleViewDidPan(sender: UIPanGestureRecognizer) {
        // subclass can implment this method as needed
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        // subclass can implement this method as needed
    }
}
