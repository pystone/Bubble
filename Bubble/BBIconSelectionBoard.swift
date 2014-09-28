//
//  BBIconSelectionBoard.swift
//  Bubble
//
//  Created by Amy on 9/28/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import Foundation
import UIKit

class BBIconSelectionBoard: UIView{
    
    var originGapx:CGFloat = 20
    var originGapy:CGFloat = 20
    func generateButton(type:BBBoardType){
        if type == BBBoardType.colorBoard{
            var originX:CGFloat = 0
            var originY:CGFloat = 0
            for var index = 0; index < 8; ++index{
                var colorBtn: UIButton = UIButton(frame: CGRectMake(originX, originY, 35, 35))
                var colorPicPath = colorList[index] + ".png"
                colorBtn.setBackgroundImage(UIImage(named: colorPicPath), forState: .Normal)
                colorBtn.addTarget(self, action: Selector("colorBtnPressed"), forControlEvents: .TouchUpInside)
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
                iconBtn.addTarget(self, action: Selector("iconBtnPressed"), forControlEvents: .TouchUpInside)
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
    
    func colorBtnPressed(sender:UIButton){
        
    }
    
    func iconBtnPressed(sender:UIButton){
        
    }
    
}