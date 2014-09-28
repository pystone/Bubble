//
//  BBTaskViewController.swift
//  Bubble
//
//  Created by ChuangXie on 9/26/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import UIKit

class BBTaskViewController: UIViewController {

    var taskBubbleView: BBTaskBubbleView!
    var taskCenterBubbleView: BBCenterBubbleView!
    var taskPreviewView: BBTaskPreviewView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("not implemented!")
    }
    
    override init() {
        super.init()
        
        self.taskBubbleView = BBTaskBubbleView(origin: CGPointMake(100.0, 100.0), radius: 20.0)
        self.taskBubbleView.bubbleText = "who are-nice-people"
        
        var centerViewRadius: CGFloat = 150.0
        var center: CGPoint = CGPointMake(CGRectGetMidX(self.view.bounds)-centerViewRadius, CGRectGetMidY(self.view.bounds)-centerViewRadius)
        self.taskCenterBubbleView = BBCenterBubbleView(origin: center, radius: centerViewRadius)
        self.taskPreviewView = BBTaskPreviewView(origin: center, radius: centerViewRadius)
//        self.taskPreviewView._dueText = "23d"
        self.taskPreviewView._titleText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        self.taskPreviewView._spentTimeText = "Time Spent - 00:06:12"
        
        self.view.addSubview(self.taskBubbleView)
        self.view.addSubview(self.taskPreviewView)
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

