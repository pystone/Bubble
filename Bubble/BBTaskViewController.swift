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
        
        var centerViewRadius: CGFloat = 100.0
        var center: CGPoint = CGPointMake(CGRectGetMidX(self.view.bounds)-centerViewRadius, CGRectGetMidY(self.view.bounds)-centerViewRadius)
        self.taskCenterBubbleView = BBCenterBubbleView(origin: center, radius: centerViewRadius)
        
        self.view.addSubview(self.taskBubbleView)
        self.view.addSubview(self.taskCenterBubbleView)
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

