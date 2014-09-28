//
//  BBConfig.swift
//  Bubble
//
//  Created by PY on 9/28/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import Foundation

enum TaskCategory {
    case Red
    case Orange
    case Yellow
    case Green
    case Teal   //青
    case Blue
    case Purple
    case Pink
}

let CategoryMap: [TaskCategory: [Int]] = [
    .Red:       [236, 117, 97],
    .Orange:    [238, 133, 55],
    .Yellow:    [236, 202, 97],
    .Green:     [137, 199, 87],
    .Teal:      [87, 199, 150],
    .Blue:      [97, 215, 236],
    .Purple:    [178, 117, 209],
    .Pink:      [236, 97, 156]
]

enum TaskIcon {
    case Lab
    case Reading
    case Report
    case Design
    case Video
    case Code
    case Discussion
}


let IconPathNormal = "%@-normal.png"
let IconPathSelected = "%@-selected.png"

let IconMap: [TaskIcon: [String]] = [
    .Lab: [String(format: IconPathNormal, "lab"), String(format: IconPathSelected, "lab")],
    .Reading: [String(format: IconPathNormal, "reading"), String(format: IconPathSelected, "reading")],
    .Report: [String(format: IconPathNormal, "report"), String(format: IconPathSelected, "report")],
    .Design: [String(format: IconPathNormal, "design"), String(format: IconPathSelected, "design")],
    .Video: [String(format: IconPathNormal, "video"), String(format: IconPathSelected, "video")],
    .Code: [String(format: IconPathNormal, "code"), String(format: IconPathSelected, "code")],
    .Discussion: [String(format: IconPathNormal, "discussion"), String(format: IconPathSelected, "discussion")]
]

let CALENDAR_DATA_NOTIFICATION = "didFinishedLoadingCalendarData"


