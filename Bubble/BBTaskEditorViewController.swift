//
//  BBTaskEditorViewController.swift
//  Bubble
//
//  Created by ChuangXie on 9/28/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import Foundation
import UIKit

enum TaskEditMode {
    case CREATE
    case EDIT
}

class BBTaskEditorViewController: UIViewController {
    
    var controllerName: String! {
        didSet {
            self.title = controllerName
        }
    }
    
    var taskID: Int? {
        didSet {
            if taskID == nil {
                self.editMode = .CREATE
            }
            else {
                self.editMode = .EDIT
            }
        }
    }
    
    var selectedColor: UIColor!
    var containerScrollView: UIScrollView!
    var editTask: BBTask?
    var editMode: TaskEditMode?
    var dueDetailLabel: UILabel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init() {
        super.init()
        self.controllerName = "Create Task"
        
        if self.editMode == .CREATE{
            self.title = "Create Task"
        }else{
            self.title = self.editTask?._title
        }
        
        self.selectedColor = UIColor.whiteColor()
        self.view.backgroundColor = self.selectedColor
        
        self.containerScrollView = UIScrollView()
        
        var containerView = UIView()
        containerView.frame = CGRectMake(20.0, 64.0, self.view.bounds.size.width - 40.0, self.view.bounds.size.height)
        containerView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(containerView)
        
        var originY:CGFloat = 0.0, width:CGFloat = containerView.bounds.size.width
        var labelHeight:CGFloat = 40.0
        
        var height:CGFloat = 40.0
//        var detailTextView: UITextView = UITextView()
//        detailTextView.backgroundColor = UIColor.greenColor()
//        detailTextView.frame = CGRectMake(0.0, originY, width, height)
//        detailTextView.text = "description"
//        detailTextView.becomeFirstResponder()
//        containerView.addSubview(detailTextView)
        
        originY += height
        
        var frame: CGRect = CGRectMake(0.0, originY, width, labelHeight)
        var labelDue = UILabel(frame: frame)
        labelDue.backgroundColor = UIColor.clearColor()
        labelDue.textColor = UIColor.darkTextColor()
        labelDue.font = UIFont.boldSystemFontOfSize(20.0)
        labelDue.text = "Due"
        containerView.addSubview(labelDue)
        
        originY += labelHeight
        frame = CGRectMake(0.0, originY, width, height)
        self.dueDetailLabel = UILabel(frame: frame)
        self.dueDetailLabel.textColor = UIColor.darkTextColor()
        self.dueDetailLabel.text = NSDate.date().description
        self.dueDetailLabel.userInteractionEnabled = true
        
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("popupDatePicker"))
        self.dueDetailLabel.addGestureRecognizer(tapGesture)
        
        containerView.addSubview(self.dueDetailLabel)
        
        originY += labelHeight
        frame = CGRectMake(0.0, originY, width, labelHeight)
        var labelColor = UILabel(frame: frame)
    }
    
    func popupDataPicker(){
        
    }
    
//    func getTaskDataFromDataCenter -> BBTask{
//        BBDataCenter.sharedDataCenter().getUnfinishedTaskWithID()
//    }
    
    func popupDatePicker() {
        var datePicker = UIDatePicker(frame: CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
    }
}
