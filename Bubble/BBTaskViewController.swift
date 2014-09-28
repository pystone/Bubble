//
//  BBTaskViewController.swift
//  Bubble
//
//  Created by ChuangXie on 9/26/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import UIKit

struct BubbleRect {
    var rect: CGRect!
    var totalBubbleCounts: Int!
    var bubbleCount: Int!
    
    init(rect: CGRect, count: Int, totalCount: Int) {
        self.rect = rect
        self.bubbleCount = count
        self.totalBubbleCounts = totalCount
    }
}

class BBTaskViewController: UIViewController, BBTaskBubbleViewProtocol {
    var taskCenterBubbleView: BBCenterBubbleView!
    var visibelTaskViews: [BBTaskBubbleView]!
    var availableRects: [BubbleRect]!
    var taskBubbleViewAdder: BBStillBubbleView!
    var currentTaskID: Int!
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("not implemented!")
    }
    
    override init() {
        super.init()
        self.availableRects = Array()
        self.visibelTaskViews = Array()
        
        self.currentTaskID = -1
        var centerViewRadius: CGFloat = 100.0
        var origin: CGPoint = CGPointMake(CGRectGetMidX(self.view.bounds)-centerViewRadius, CGRectGetMidY(self.view.bounds)-centerViewRadius)
        self.taskCenterBubbleView = BBCenterBubbleView(origin: origin, radius: centerViewRadius)
        self.view.addSubview(self.taskCenterBubbleView)
        
        // configure the available rects
        // we spilit the left area to seven segments
        // the first segment
        var originY = UIApplication.sharedApplication().statusBarFrame.height
        var originX:CGFloat = 0.0, leftSegWidth = origin.x, midSegWidth = 2*centerViewRadius
        var rightSegWidth = UIScreen.mainScreen().bounds.size.width-leftSegWidth-midSegWidth
        var rect = CGRectMake(originX, originY, leftSegWidth, origin.y-originY)
        self.availableRects.append(BubbleRect(rect: rect, count: 0, totalCount: 1))
        
        // the second segment
        originX = originX + leftSegWidth
        rect = CGRectMake(originX, originY, midSegWidth, origin.y-originY)
        self.availableRects.append(BubbleRect(rect: rect, count: 0, totalCount: 2))
        
        // the third segment
        originX = originX + midSegWidth
        rect = CGRectMake(originX, originY, rightSegWidth, origin.y-originY)
        self.availableRects.append(BubbleRect(rect: rect, count: 0, totalCount: 1))
        
        // the fourth segment
        originX = 0.0
        originY = originY + rect.height
        rect = CGRectMake(originX, originY, leftSegWidth, midSegWidth)
        self.availableRects.append(BubbleRect(rect: rect, count: 0, totalCount: 1))
        
        // the fifth segment
        originX = originX + leftSegWidth + midSegWidth
        rect = CGRectMake(originX, originY, rightSegWidth, midSegWidth)
        self.availableRects.append(BubbleRect(rect: rect, count: 0, totalCount: 1))
        
        // the sixth segment
        originX = 0.0
        originY = originY + midSegWidth
        var bottomHeight = self.view.bounds.size.height - originY
        rect = CGRectMake(originX, originY, leftSegWidth, bottomHeight)
        self.availableRects.append(BubbleRect(rect: rect, count: 0, totalCount: 1))
        
        // the seventh segment
        originX = originX + leftSegWidth
        // this is for the stupid task adder bubble
        midSegWidth -= 25.0
        rect = CGRectMake(originX, originY, midSegWidth, bottomHeight)
        self.availableRects.append(BubbleRect(rect: rect, count: 0, totalCount: 2))
        
        var rightPadding:CGFloat = 40.0, bottomPadding:CGFloat = 40.0, adderRadius:CGFloat = 35.0
        var addX = self.view.bounds.size.width - rightPadding - 2.0 * adderRadius
        var addY = self.view.bounds.size.height - bottomPadding - 2.0 * adderRadius
        
        var adderOrigin = CGPointMake(addX, addY)
        // init the task bubble view adder
        self.taskBubbleViewAdder = BBStillBubbleView(origin: adderOrigin, radius: adderRadius)
        self.taskBubbleViewAdder.delegate = self
        self.view.addSubview(self.taskBubbleViewAdder)
        self.view.addSubview(self.taskCenterBubbleView)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("layoutTaskBubbles"),
            name: CALENDAR_DATA_NOTIFICATION, object: nil)
    }
    
    func layoutTaskBubbles() {
        // load some data
        for taskID: Int in BBDataCenter.sharedDataCenter()._unfinishedTasks.keys {
            if taskExistInView(taskID) == true {
                continue
            }
            // this is a new task
            var taskView = BBTaskBubbleView(origin: CGPointMake(50.0, 60.0), radius: 30.0)
            taskView._taskID = taskID
            taskView.delegate = self
            taskView.bubbleColor = UIColor.randomColor()
            // this is to update data
//            var task: BBTask = BBDataCenter.sharedDataCenter().getUnfinishedTaskWithID(_taskID)
//            BBDataCenter.sharedDataCenter().updateUnfinishedTask(task)

            taskView.tag = taskID
            self.visibelTaskViews.append(taskView)
            self.view.addSubview(taskView)
        }

        self.layoutTasksAnimated(true)
        
//        self.view.addBlurEffect()
    }
    
    func taskExistInView(taskID: Int) -> Bool {
        for view in self.visibelTaskViews {
            if view._taskID == taskID {
                return true
            }
        }
        return false
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
    
    func layoutTasksAnimated(animated: Bool) {
        var centerRect = self.taskCenterBubbleView.frame
        
        for taskView: BBTaskBubbleView in self.visibelTaskViews {
            var tw = CGRectGetWidth(taskView.bounds), th = CGRectGetHeight(taskView.bounds)
            var full = true
            for i in 0..<self.availableRects.count {
                var bubbleRect: BubbleRect = self.availableRects[i]
                if bubbleRect.bubbleCount < bubbleRect.totalBubbleCounts {
                    // there is still a space available
                    var tmpw:CGFloat = CGRectGetWidth(bubbleRect.rect), tmph = CGRectGetHeight(bubbleRect.rect)
                    if min(tmpw, tmph) < max(tw, th) {
                        // does not work
                    } else {
                        full = false
                        tmpw = taskView.bounds.size.width / 2.0
                        tmph = taskView.bounds.size.height / 2.0

                        var offset:CGFloat = CGFloat(arc4random_uniform(UInt32(bubbleRect.rect.size.width - taskView.bounds.size.width)))
                        var centerx = tmpw + offset
                        offset = CGFloat(arc4random_uniform(UInt32(bubbleRect.rect.size.height - taskView.bounds.size.height)))
                        var centery = tmph + offset
                        taskView.center = CGPointMake(centerx+bubbleRect.rect.origin.x, centery+bubbleRect.rect.origin.y)
                        bubbleRect.bubbleCount = bubbleRect.bubbleCount + 1
                    }
                }
                if (full == false) {
                    self.availableRects[i].bubbleCount = bubbleRect.bubbleCount
                    break;
                }
            }
            if full == true {
                break;
            }
        }
    }
    
    func bubbleViewDidTap(sender: UITapGestureRecognizer) {
        var bubbleView: BBTaskBubbleView  = sender.view as  BBTaskBubbleView
        var taskEditorViewController = BBTaskEditorViewController()
        if bubbleView.tag != 0 {
            taskEditorViewController.taskID = bubbleView.tag
            taskEditorViewController.editTask = BBDataCenter.sharedDataCenter().getUnfinishedTaskWithID(bubbleView.tag)
        }
        self.navigationController?.pushViewController(taskEditorViewController, animated: true)
    }
        
    func bubbleViewDidPan(sender: UIPanGestureRecognizer) {
        
    }
    
    func startBubbleViewTask(bubbleView: BBTaskBubbleView) {
        // push bubbleView and pop the current task
        self.pushBubbleTask(bubbleView._taskID!)
    }
    
    func popBubbleTask(taskID: Int) {
        if taskID <= 0 {
            return
        }
        var newBubbleView = BBTaskBubbleView(origin: CGPointMake(60.0, 60.0), radius: 35.0)
        // then we add to the visibelBubbleList
        self.visibelTaskViews.append(newBubbleView)
        newBubbleView._taskID = taskID
        self.view.addSubview(newBubbleView)
        self.layoutTasksAnimated(true)
    }
    
    func pushBubbleTask(taskID: Int) {
        // remove the bubbleView from visibleBubbleViews
        var tmp = -1, i = 0
        for i in 0..<self.visibelTaskViews.count {
            // find the match one 
            if (taskID == self.visibelTaskViews[i]._taskID) {
                break
            }
        }
        if self.taskCenterBubbleView._taskID == taskID {
            return
        }
        self.taskCenterBubbleView.bubbleWaver.waverColor = self.visibelTaskViews[i].bubbleColor
        self.taskCenterBubbleView._taskID = taskID
        // after push, remove the view with taskID from the visibelTaskViews
        var view = self.visibelTaskViews[i]
        view.removeFromSuperview()
        self.visibelTaskViews.removeAtIndex(i)
        if self.taskCenterBubbleView._taskID > 0 {
            tmp = self.taskCenterBubbleView._taskID!
            // then pop centerBubbleView
            self.popBubbleTask(tmp)
        } else {
            self.layoutTasksAnimated(true)
        }
    }
}

