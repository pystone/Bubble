//
//  BBTaskBubbleView.swift
//  Bubble
//
//  Created by ChuangXie on 9/26/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import Foundation
import UIKit

protocol BBTaskBubbleViewProtocol {
    func bubbleViewDidTap()
    func bubbleViewDidPan()
}

class BBTaskBubbleView: BBBubbleView {
    
    var bubbleText: String? {
        didSet {
            // retreive the initial letters of bubble text
            self.bubbleTextLabel.text = bubbleText?.initalCharacters().uppercaseString
            self.bubbleTextLabel.hidden = false
        }
    }

    var delegate: BBTaskBubbleViewProtocol?

    var _taskID: Int? {
        didSet {
            setContent()
        }
    }

    var bubbleTextLabel: UILabel!
    var bubbleTextColor: UIColor!
    var bubbleTaskIconView: UIImageView!
    var bubbleTaskIcon: UIImage? {
        didSet {
            self.bubbleTaskIconView.hidden = false
        }
    }
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
        self.bubbleTextLabel = UILabel()
        self.bubbleTextLabel.textAlignment = NSTextAlignment.Center
        self.bubbleTextLabel.backgroundColor = UIColor.clearColor()
        
        self.bubbleTextColor = UIColor.darkGrayColor()
        self.bubbleTextLabel.textColor = self.bubbleTextColor
        self.bubbleTextLabel.hidden = true
        
        self.bubbleTaskIconView = UIImageView()
        self.bubbleTaskIconView.hidden = true
        
        // the bubbleView is the underlying view, which holds all the other upper views
        self.bubbleView.addSubview(self.bubbleTextLabel)
        self.bubbleView.addSubview(self.bubbleTaskIconView)
    }
    
    convenience init(origin: CGPoint, radius: CGFloat) {
        var frame = CGRectMake(origin.x, origin.y, 2*radius, 2*radius)
        self.init(frame:frame)
        // this is temporary, should be implemented!
        self.bubbleColor = UIColor.greenColor()
        self.bubbleRadius = radius
        
    }
    
    func setContent() {
        if (self._taskID==nil || self._taskID == -1) {
            return;
        }
        let task = BBDataCenter.sharedDataCenter().getUnfinishedTaskWithID(_taskID!)
        if task != nil {
            self.bubbleText = task!._title
            self.bubbleColor = task!.getColor()
        }
        
    }
    
    override func layoutSubviews() {
        var frame = CGRectMake(0.0, 0.0, 2*self.bubbleRadius, 2*self.bubbleRadius)
        self.bubbleView.frame = frame
        // simple implementation
        self.bubbleTextLabel.frame = frame
        self.bubbleTaskIconView.frame = frame
        
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
    
    /*
    * map radius to the related font-size
    */
    func mapRadius() {
        
    }
    
    func circlesIntersection() -> Bool{
        var distanceX = bigCircleCenter.x - self.center.x
        var distanceY = bigCircleCenter.y - self.center.y
        
        var magnitude = sqrt(distanceX * distanceX + distanceY * distanceY);
        return magnitude < bigCircleRadius + self.bubbleRadius;
    }
    
    
    override func bubbleViewDidPan(sender: UIPanGestureRecognizer) {

        self.delegate?.bubbleViewDidPan()

        var offset = sender.translationInView(self.superview!)
        var newOriginX = self.center.x + offset.x
        var newOriginY = self.center.y + offset.y
        
        sender.view?.center = CGPointMake(newOriginX, newOriginY)
        sender.setTranslation(CGPointZero, inView:self.superview)
        
    }
    
    override func bubbleViewDidTap(sender: UITapGestureRecognizer) {
        self.delegate?.bubbleViewDidTap()
    }
}
