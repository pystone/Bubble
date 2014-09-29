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
    func bubbleViewDidTap(sender:UITapGestureRecognizer)
    func bubbleViewDidPan(sender:UIPanGestureRecognizer)
    func startBubbleViewTask(bubbleView:BBTaskBubbleView)
    func finishTask(taskView:BBTaskBubbleView)
    func deleteTask(taskView:BBTaskBubbleView)
    func enterFinishTaskArea()
    func leaveFinishTaskArea()
    func enterDeleteTaskArea()
    func leaveDeleteTaskArea()
}

class BBTaskBubbleView: BBBubbleView{
    
    var bubbleText: String? {
        didSet {
            // retreive the initial letters of bubble text
            self.bubbleTextLabel.text = bubbleText?.initalCharacters().uppercaseString
            self.bubbleTextLabel.hidden = true
            
        }
    }

    var delegate: BBTaskBubbleViewProtocol?


    var bubbleTextLabel: UILabel!
    var bubbleTextColor: UIColor!
    var bubbleTaskIconView: UIImageView!
    var bubbleTaskIcon: UIImage? {
        didSet {
            self.bubbleTaskIconView.hidden = false
            self.bubbleTaskIconView.image = bubbleTaskIcon
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
    
    override func setContent() {
        if (self._taskID==nil || self._taskID == -1) {
            return;
        }
        let task = BBDataCenter.sharedDataCenter().getUnfinishedTaskWithID(_taskID!)
        if task != nil {
            self.bubbleText = task!._title
            self.bubbleColor = task!.getColor()
            self.bubbleTaskIcon = UIImage(named: IconMap[task!._icon]![0])
        }
    }
    
    override func layoutSubviews() {
        var frame = CGRectMake(0.0, 0.0, 2*self.bubbleRadius, 2*self.bubbleRadius)
        self.bubbleView.frame = frame
        // simple implementation
        frame = CGRectInset(frame, 0.5*self.bubbleRadius, 0.5*self.bubbleRadius)
        self.bubbleTextLabel.frame = frame
        self.bubbleTaskIconView.frame = frame
        
        let suView: UIView = self.superview!
        let bound : CGRect = suView.bounds
        self.bigCircleCenter = CGPointMake(CGRectGetMidX(bound), CGRectGetMidY(bound))
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
    
    func inFinishArea(area: CGRect) -> Bool {
        return CGRectIntersectsRect(area, FinishTaskArea)
    }
    
    func inDeleteArea(area: CGRect) -> Bool {
        return CGRectIntersectsRect(area, DeleteTaskArea)
    }
    
    override func bubbleViewDidPan(sender: UIPanGestureRecognizer) {
        self.delegate?.bubbleViewDidPan(sender)
        var offset = sender.translationInView(self.superview!)
        var newOriginX = self.center.x + offset.x
        var newOriginY = self.center.y + offset.y
        
        sender.view?.center = CGPointMake(newOriginX, newOriginY)
        sender.setTranslation(CGPointZero, inView:self.superview)
        
        if sender.state == .Ended {
            println("task view: touch ends")
            if self.circlesIntersection() {
                self.delegate?.startBubbleViewTask(self)
            }
            
            if self.inFinishArea(self.frame) == true {
                self.delegate?.finishTask(self)
            } else if self.inDeleteArea(self.frame) == true {
                self.delegate?.deleteTask(self)
            }
        }
        else {
            
            
            if self.inFinishArea(self.frame) == true {
                self.delegate?.enterFinishTaskArea()
            } else if self.inDeleteArea(self.frame) == true {
                self.delegate?.enterDeleteTaskArea()
            } else {
                self.delegate?.leaveDeleteTaskArea()
                self.delegate?.leaveFinishTaskArea()
            }
        }
    }
    
    override func bubbleViewDidTap(sender: UITapGestureRecognizer) {
        let radius = CGFloat(80.0)
        let previewView = BBTaskPreviewView(origin: CGPointMake(self.frame.origin.x, self.frame.origin.y), radius: radius)

        if self._taskID == nil {
            // add new task
            self.delegate?.bubbleViewDidTap(sender)
        }
        else {
            previewView._taskID = self._taskID
            previewView._taskBubleView = self
            
            self.superview?.addBlurEffect()
            previewView.showMySelf(self.bubbleColor!, origin: self.frame.origin, radius: self.bubbleRadius)
        }
    }
    
    func removeSuperViewBlurEffect() {
        self.superview?.removeBlurEffect()
    }
}
