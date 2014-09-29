//
//  BBIconSelectionBoard.swift
//  Bubble
//
//  Created by Amy on 9/28/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import Foundation
import UIKit

protocol eventCreationProtocol{
    func haveGetNewItem(task:BBTask)
}

class BBIconSelectionBoard: UIView{
    
    var delegate:eventCreationProtocol?
    var originGapx:CGFloat = 20
    var originGapy:CGFloat = 20
    var newTask:BBTask?
    var color:TaskCategory?
    var icon:TaskIcon?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = BBTaskViewController()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
    }

    func generateButton(type:BBBoardType){
        if type == BBBoardType.colorBoard{
            var originX:CGFloat = 0
            var originY:CGFloat = 0
            for var index = 0; index < 8; ++index{
                var colorBtn: UIButton = UIButton(frame: CGRectMake(originX, originY, 35, 35))
                var colorPicPath = colorList[index] + ".png"
                colorBtn.setBackgroundImage(UIImage(named: colorPicPath), forState: .Normal)
                colorBtn.addTarget(self, action: Selector("colorBtnPressed:"), forControlEvents: .TouchUpInside)
                colorBtn.tag = index
                self.addSubview(colorBtn)
                originX += 35 + originGapx
                if index == 3{
                    originX = 0
                    originY = 35 + originGapy
                }
            }
        }else{
            var originX:CGFloat = 0
            var originY:CGFloat = 0
            for var index = 0; index < 8; ++index{
                var iconBtn: UIButton = UIButton(frame: CGRectMake(originX, originY, 35, 35))
                var iconPicPath = iconList[index] + ".png"
                iconBtn.setBackgroundImage(UIImage(named: iconPicPath), forState: .Normal)
                iconBtn.addTarget(self, action: Selector("iconBtnPressed:"), forControlEvents: .TouchUpInside)
                iconBtn.tag = index
                self.addSubview(iconBtn)
                originX += 35 + originGapx
                if index == 3{
                    originX = 0
                    originY = 35 + originGapy
                }
             }
         }
    }
    
    func getBoardWithType(type:BBBoardType){
            generateButton(type)
    }
    
    func colorBtnPressed(sender:UIButton!){
        var btn: UIButton = sender as UIButton
        var index =  btn.tag
        color = TaskCategory.fromRaw(index)!
        didGetNewItem()
    }
    
    func iconBtnPressed(sender:UIButton!){
        var btn: UIButton = sender as UIButton
        var index =  btn.tag
        icon = TaskIcon.fromRaw(index)!
        didGetNewItem()
    }
    
    func didGetNewItem(){
         if (color != TaskCategory.None && icon != TaskIcon.None){
            newTask = BBTask()
            if icon == nil{
                 icon = TaskIcon.Reading
            }
            if color == nil{
                 color = TaskCategory.Yellow
            }
            newTask?._category = color!
            newTask?._icon = icon!
            self.delegate?.haveGetNewItem(newTask!)
            
        }
    }
    
}