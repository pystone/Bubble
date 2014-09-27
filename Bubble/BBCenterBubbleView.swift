//
//  BBCenterBubbleView.swift
//  Bubble
//
//  Created by ChuangXie on 9/26/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import Foundation
import UIKit

class BBCenterBubbleView: BBBubbleView {
    
    var taskNameLabel: UILabel!
    var taskTimerLabel: UILabel!
    var taskDueLabel: UILabel!
    var taskTimer: NSTimer!
    var accumulateTime: UInt64!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.accumulateTime = 0
        
        self.taskNameLabel = UILabel()
        self.taskNameLabel.adjustsFontSizeToFitWidth = false
        self.taskNameLabel.numberOfLines = 0
        self.taskNameLabel.textAlignment = NSTextAlignment.Center
        
        self.taskTimerLabel = UILabel()
        self.taskTimerLabel.textAlignment = NSTextAlignment.Center
        
        self.taskDueLabel = UILabel()
        self.taskDueLabel.textAlignment = NSTextAlignment.Center
        
        // currently, we do not allow customization
        self.taskNameLabel.textColor = UIColor.whiteColor()
        self.taskTimerLabel.textColor = UIColor.whiteColor()
        self.taskDueLabel.textColor = UIColor.whiteColor()
        
        self.taskTimerLabel.font = UIFont.systemFontOfSize(44)
        self.taskNameLabel.font = UIFont.systemFontOfSize(26)
        self.taskDueLabel.font = UIFont.systemFontOfSize(16)

        self.addSubview(self.taskNameLabel)
        self.addSubview(self.taskTimerLabel)
        self.addSubview(self.taskDueLabel)
    }
    
    convenience init(origin: CGPoint, radius: CGFloat) {
        var frame = CGRectMake(origin.x, origin.y, 2*radius, 2*radius)
        self.init(frame: frame)
        
        self.bubbleColor = UIColor.lightGrayColor()
        self.bubbleRadius = radius
        
        // to be implemented!
        self.taskDueLabel.text = "12d"
        self.taskNameLabel.text = "Computer Netowrks"
        self.taskTimerLabel.text = "0:00:00"
    }
    
    override func layoutSubviews() {
        
        var width = 2*self.bubbleRadius, height = 2*self.bubbleRadius
        var frame = CGRectMake(0.0, 0.0, width, height)
        var segmentHeight = height / 5.0
        var originY:CGFloat = 0.8*segmentHeight
        
        // 5 segments
        frame = CGRectMake(0.0, originY, width, segmentHeight)
        self.taskTimerLabel.frame = frame

        originY += 1.3*segmentHeight
        // the middle 2.5 segments are for the taskTimerLabel
        frame = CGRectMake(0.0, originY, width, 2*segmentHeight)
        self.taskNameLabel.frame = frame
        
        originY += 2.1*segmentHeight
        
        // the bottom segment are for the taskDueLabel
        frame = CGRectMake(0.0, originY, width, 0.8*segmentHeight)
        self.taskDueLabel.frame = frame
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
    }
    
    func setTaskName(name: String) {
        self.taskNameLabel.text = name
    }
    
    func setTaskDue(due: String) {
        self.taskDueLabel.text = due
    }
    
    func startTaskTimer() {
        if self.taskTimer == nil {
            self.taskTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTaskTimerLabel"), userInfo: nil, repeats: true)
        } else {
            self.stopTaskTimer()
        }
    }
    
    func stopTaskTimer() {
        if self.taskTimer == nil {
            return
        }
        self.taskTimer.invalidate()
        self.taskTimer = nil
    }
    
    func updateTaskTimerLabel() {
        self.accumulateTime = self.accumulateTime + 1
        var tmp: UInt64 = self.accumulateTime
        var hour, minutes, seconds: UInt64
        hour = tmp / 3600
        tmp = tmp - hour*3600
        minutes = tmp / 60
        tmp = tmp - minutes*60
        seconds = tmp
        self.taskTimerLabel.text = String(format: "%d:%02d:%02d", arguments: [hour, minutes, seconds])
    }
    
    override func bubbleViewDidPan(sender: UIPanGestureRecognizer) {
    }
    
    override func bubbleViewDidTap(sender: UITapGestureRecognizer) {
        startTaskTimer()
    }
    
}
