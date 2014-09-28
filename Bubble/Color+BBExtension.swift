//
//  Color+BBExtension.swift
//  Bubble
//
//  Created by ChuangXie on 9/28/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func randomColor() -> UIColor {
        var rd = arc4random_uniform(UInt32(CategoryMap.count))
        // category[0] is white color, which we actually don't want
        if rd == 0 {
            rd = 1
        }
        var tmp: Int = Int(rd)
        var arr:Array! = CategoryMap[TaskCategory.fromRaw(tmp)!]
        var r:CGFloat = CGFloat(arr[0])/255.0
        var g:CGFloat = CGFloat(arr[1])/255.0
        var b:CGFloat = CGFloat(arr[2])/255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
