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
    var bubbleText: String! {
        didSet {
            // retreive the initial letters of bubble text
            self.bubbleTextLabel?.text = bubbleText.initalCharacters(2).uppercaseString
        }
    }
    var _dueImg: UIImage!
    var _dueTextLabel: UILabel!
    var _titleTextLabel: UILabel!
    var _spentTimeTextLabel: UILabel!
    var _detailImg: UIImage!
    
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
        
        self.bubbleTextLabel = UILabel()
        self.bubbleTextLabel.textAlignment = NSTextAlignment.Center
        self.bubbleTextLabel.backgroundColor = UIColor.clearColor()
        
        self.bubbleTextColor = UIColor.darkGrayColor()
        self.bubbleTextLabel.textColor = self.bubbleTextColor
        
        // the bubbleView is the underlying view, which holds all the other upper views
        self.bubbleView.addSubview(self.bubbleTextLabel)
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
        self.bubbleTextLabel.frame = frame
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
    
    override func bubbleViewDidPan(sender: UIPanGestureRecognizer) {
    }
    
    override func bubbleViewDidTap(sender: UITapGestureRecognizer) {
    }
}