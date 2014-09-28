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
        
        self.containerScrollView = UIScrollView(frame: CGRectMake(0, 0, self.view.frame.width , self.view.frame.height))
        
        self.view.addSubview(self.containerScrollView)
        
        var originY:CGFloat = 0.0, width:CGFloat = self.containerScrollView.bounds.size.width
        var labelHeight:CGFloat = 40.0
        let gap:CGFloat = 20
        
        var height:CGFloat = 40.0
        
        originY += height
        
        var frame: CGRect = CGRectMake(20, originY, width, labelHeight)
        var labelDue = UILabel(frame: frame)
        labelDue.backgroundColor = UIColor.clearColor()
        labelDue.textColor = UIColor.darkTextColor()
        labelDue.font = UIFont.boldSystemFontOfSize(20.0)
        labelDue.text = "Due"
        self.containerScrollView.addSubview(labelDue)
        
        originY += labelHeight
        frame = CGRectMake(20, originY, width, height)
        self.dueDetailLabel = UILabel(frame: frame)
        self.dueDetailLabel.textColor = UIColor.darkTextColor()
        self.dueDetailLabel.text = NSDate.date().description
        self.dueDetailLabel.userInteractionEnabled = true
        
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("popupDatePicker"))
        self.dueDetailLabel.addGestureRecognizer(tapGesture)
        
        self.containerScrollView.addSubview(self.dueDetailLabel)
        
        originY += labelHeight
        var colorLabel: UILabel = UILabel(frame: CGRectMake(20, originY, self.view.frame.width - 20, labelHeight))
        colorLabel.textColor = UIColor.darkTextColor()
        colorLabel.text = "Color"
        colorLabel.font = UIFont.boldSystemFontOfSize(20.0)
        self.containerScrollView.addSubview(colorLabel)
        
        originY += labelHeight  + gap
        var colorSelectionBoard: BBIconSelectionBoard = BBIconSelectionBoard(frame: CGRectMake(20, originY, self.view.frame.width - 20, 150))
        colorSelectionBoard.getBoardWithType(BBBoardType.colorBoard)
        self.containerScrollView.addSubview(colorSelectionBoard)
        
        originY += 100 + gap
        var iconLabel: UILabel = UILabel(frame: CGRectMake(20, originY, self.view.frame.width - 20, labelHeight))
        iconLabel.textColor = UIColor.darkTextColor()
        iconLabel.text = "Icon"
        iconLabel.font = UIFont.boldSystemFontOfSize(20.0)
        self.containerScrollView.addSubview(iconLabel)
        
        originY += labelHeight + gap
        var iconSelectionBoard: BBIconSelectionBoard = BBIconSelectionBoard(frame: CGRectMake(20, originY, self.view.frame.width - 20, 150))
        iconSelectionBoard.getBoardWithType(BBBoardType.iconBoard)
        self.containerScrollView.addSubview(iconSelectionBoard)
        
        originY += 150 + gap
        self.containerScrollView.contentSize = CGSizeMake(self.view.frame.width, originY)
        
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
