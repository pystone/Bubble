//
//  BBTaskPreviewView.swift
//  Bubble
//
//  Created by PY on 9/28/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import Foundation
import UIKit

class BBTaskPreviewView: BBBubbleView {
    
    var _dueText: String! {
        didSet {
            // "123d"
            self._dueTextLabel?.text = _dueText
        }
    }
    var _titleText: String! {
        didSet {
            self._titleTextLabel?.text = _titleText
        }
    }
    var _spentTimeText: String! {
        didSet {
            // "Time Spent - 00:16:12"
            self._spentTimeTextLabel?.text = _spentTimeText
        }
    }
    var _newWindow: UIWindow!
    var _touming: UIButton!
    var _dueImg: UIImageView!
    var _dueTextLabel: UILabel!
    var _titleTextLabel: UILabel!
    var _spentTimeTextLabel: UILabel!
    var _detailImg: UIButton!
    
    var bubbleTextLabel: UILabel!
    var bubbleTextColor: UIColor!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self._newWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
        self._newWindow?.backgroundColor = UIColor.clearColor()
        
        self._touming = UIButton.buttonWithType(.Custom) as UIButton
        let touming = UIImage(named: ResourcePath["TouMing"]!)
        self._touming.frame = CGRectMake(0, 0, touming.size.width, touming.size.height)
        self._touming.setImage(touming, forState: .Normal)
        self._touming.setImage(touming, forState: .Highlighted)
        self._touming.addTarget(self, action: Selector("returnToSmallBall:"), forControlEvents: .TouchUpInside)
        self._touming.alpha = 0.0
        self._newWindow.addSubview(self._touming)
        
        self.bubbleTextColor = UIColor.blackColor()
        
        let dueImg = UIImage(named: ResourcePath["DueIcon"]!)
        self._dueImg = UIImageView(image: dueImg)
        self._dueImg.frame = CGRectMake(43, 20, _dueImg.frame.width, _dueImg.frame.height)
        self.bubbleView.addSubview(self._dueImg)
        
        self._detailImg = UIButton.buttonWithType(.Custom) as UIButton
        let detailImg = UIImage(named: ResourcePath["LineAndMoreImage"]!)
        self._detailImg.frame = CGRectMake(30, 120, detailImg.size.width, detailImg.size.height)
        self._detailImg.setImage(detailImg, forState: .Normal)
        self._detailImg.setImage(detailImg, forState: .Highlighted)
        self._detailImg.addTarget(self, action: Selector("moreDetail:"), forControlEvents: .TouchUpInside)
        self.bubbleView.addSubview(self._detailImg)
        
        self._dueTextLabel = UILabel(frame: CGRectMake(_dueImg.frame.origin.x + _dueImg.frame.size.width + 5, _dueImg.frame.origin.y, 24*4, dueImg.size.height))
        self._dueTextLabel.textAlignment = .Left
        self._dueTextLabel.backgroundColor = UIColor.clearColor()
        self._dueTextLabel.textColor = UIColor.whiteColor()
        self._dueTextLabel.font = UIFont.systemFontOfSize(24)
        self.bubbleView.addSubview(self._dueTextLabel)
        
        self._titleTextLabel = UILabel(frame: CGRectMake(7, 56, self.frame.width-2*7, 12*3))
        self._titleTextLabel.textAlignment = .Center
        self._titleTextLabel.numberOfLines = 0
        self._titleTextLabel.backgroundColor = UIColor.clearColor()
        self._titleTextLabel.textColor = UIColor.whiteColor()
        self._titleTextLabel.font = UIFont.systemFontOfSize(12)
        self.bubbleView.addSubview(self._titleTextLabel)
        
        self._spentTimeTextLabel = UILabel(frame: CGRectMake(28, 105, self.frame.width-2*27, 10))
        self._spentTimeTextLabel.textAlignment = .Center
        self._spentTimeTextLabel.backgroundColor = UIColor.clearColor()
        self._spentTimeTextLabel.textColor = UIColor.blackColor()
        self._spentTimeTextLabel.font = UIFont.systemFontOfSize(10)
        self.bubbleView.addSubview(self._spentTimeTextLabel)
    }
    
    convenience init(origin: CGPoint, radius: CGFloat) {
        var frame = CGRectMake(origin.x, origin.y, 2*radius, 2*radius)
        self.init(frame:frame)

        self.bubbleColor = UIColor.orangeColor()
        self.bubbleRadius = radius
    }
    
    override func setContent() {
        let task = BBDataCenter.sharedDataCenter().getUnfinishedTaskWithID(self._taskID!)
        if task != nil {
            self._dueText = task!.getReadableDueTimeFromToday()
            self._titleText = task!._title
            self._spentTimeText = task!.getReadableSpentTime()
        }
    }
    
    func showMySelf() {
        self._newWindow.hidden = false
        self._newWindow.addSubview(self)
        self._newWindow.makeKeyAndVisible()
        self._newWindow.windowLevel = UIWindowLevelStatusBar
        
        UIView.animateWithDuration(1.0, animations: {() -> Void in
            self._touming.alpha = 0.8
        })
//        self._touming.
    }
    
    override func layoutSubviews() {
        var frame = CGRectMake(0.0, 0.0, 2*self.bubbleRadius, 2*self.bubbleRadius)
        self.bubbleView.frame = frame
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
    
    override func bubbleViewDidPan(sender: UIPanGestureRecognizer) {
    }
    
    override func bubbleViewDidTap(sender: UITapGestureRecognizer) {
    }
    
    func moreDetail(sender: UIButton!) {
    }
    
    func returnToSmallBall(sender: UIButton!) {
        self._touming.removeFromSuperview()
        self.removeFromSuperview()
        self._newWindow.windowLevel = UIWindowLevelNormal
        self._newWindow.hidden = true
        
        var delegate = UIApplication.sharedApplication().delegate as AppDelegate
        delegate.window!.makeKeyAndVisible()
        
        delegate.window!.rootViewController?.view.removeBlurEffect()
        
    }
}