//
//  BBConfig.swift
//  Bubble
//
//  Created by PY on 9/28/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import Foundation
import UIKit

enum TaskCategory: Int {
    case None = 0
    case Red
    case Orange
    case Yellow
    case Green
    case Teal   //青
    case Blue
    case Purple
    case Pink
}

enum BBBoardType{
    case colorBoard
    case iconBoard
}

let CategoryMap: [TaskCategory: [Int]] = [
    .None:      [236, 202, 97],
    .Red:       [236, 117, 97],
    .Orange:    [238, 133, 55],
    .Yellow:    [236, 202, 97],
    .Green:     [137, 199, 87],
    .Teal:      [87, 199, 150],
    .Blue:      [97, 215, 236],
    .Purple:    [178, 117, 209],
    .Pink:      [236, 97, 156]
]

enum TaskIcon: Int {
    case None = 0
    case Lab
    case Reading
    case Report
    case Design
    case Video
    case Code
    case Discussion
}


let IconPathNormal = "%@-normal.png"
let IconPathSelected = "%@-highlighted.png"
let colorList : [String] = ["blue","green","orange","pink","purple","red","teal","yellow"]
let iconList: [String] = ["book", "code","default","design","discussion","lab","paper","video"]

let IconMap: [TaskIcon: [String]] = [
    .None: [String(format: IconPathNormal, "default"), String(format: IconPathSelected, "default")],
    .Lab: [String(format: IconPathNormal, "lab"), String(format: IconPathSelected, "lab")],
    .Reading: [String(format: IconPathNormal, "reading"), String(format: IconPathSelected, "reading")],
    .Report: [String(format: IconPathNormal, "report"), String(format: IconPathSelected, "report")],
    .Design: [String(format: IconPathNormal, "design"), String(format: IconPathSelected, "design")],
    .Video: [String(format: IconPathNormal, "video"), String(format: IconPathSelected, "video")],
    .Code: [String(format: IconPathNormal, "code"), String(format: IconPathSelected, "code")],
    .Discussion: [String(format: IconPathNormal, "discussion"), String(format: IconPathSelected, "discussion")]
]


let CALENDAR_DATA_NOTIFICATION = "didFinishedLoadingCalendarData"

let ResourcePath: [String: String] = [
    "DueIcon": "due_icon",
    "LineAndMoreImage": "line_and_more",
    "TouMing": "touming",
    "AddIcon": "add_icon",
    "ShareIcon": "share_icon"
]

let BlurAlpha = CGFloat(0.85)
let BlurTransitionTime = NSTimeInterval(0.7)
let BlurViewTag = 999

let ScreenBounds = UIScreen.mainScreen().bounds
let FinishTaskArea = CGRectMake(0, 0, 20, ScreenBounds.height/3)
let DeleteTaskArea = CGRectMake(ScreenBounds.width-20, 0, 20, ScreenBounds.height/3)
