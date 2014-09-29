//
//  BBShareView.swift
//  Bubble
//
//  Created by PY on 9/28/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import Foundation
import UIKit

class BBShareView: BBBubbleView {
    let bigCircleRadius : CGFloat = 0.0
    var bigCircleCenter: CGPoint!
    var taskViewController: BBTaskViewController!
    
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
    
    override func bubbleViewDidPan(sender: UIPanGestureRecognizer) {
        
    }
    
    override func bubbleViewDidTap(sender: UITapGestureRecognizer) {
        var words = ""
        if self.taskViewController.currentTaskID != nil {
            let task = BBDataCenter.sharedDataCenter().getUnfinishedTaskWithID(self.taskViewController.currentTaskID)
            words = "Busy with my due now. It's \(task?._title), due within \(task?.getReadableDueTimeFromTodayForShare()) from now. Already spent \(task?.getReadableSpentTimeForShare()) on it. Excited about it! #Bubble"
            
        } else {
            let todoCnt = BBDataCenter.sharedDataCenter()._unfinishedTasks.count
            let todayCnt = BBDataCenter.sharedDataCenter().getTasksForToday().count
            words = "After finishing \(todayCnt) tasks today, I'm now taking a little break! Still gotta \(todoCnt) tasks to go. I can do it! #Bubble"
        }
        
        
        let size = UIScreen.mainScreen().bounds.size
        UIGraphicsBeginImageContext(size);
        
        var delegate = UIApplication.sharedApplication().delegate as AppDelegate
        delegate.window!.rootViewController?.view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let screen = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        shareTextImageAndURL(sharingText: words, sharingImage: screen, sharingURL: nil)
    }
    
    func shareTextImageAndURL(#sharingText: String?, sharingImage: UIImage?, sharingURL: NSURL?) {
        println("sending")
        var sharingItems = [AnyObject]()
        
        if let text = sharingText {
            sharingItems.append(text)
        }
        if let image = sharingImage {
            sharingItems.append(image)
        }
        if let url = sharingURL {
            sharingItems.append(url)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        self.taskViewController.presentViewController(activityViewController, animated: true, completion: nil)
    }
}