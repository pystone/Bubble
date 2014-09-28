//
//  BBTask.swift
//  bubble_data
//
//  Created by PY on 9/26/14.
//  Copyright (c) 2014 PY. All rights reserved.
//

import Foundation
import UIKit

var TotalID = 0

class BBTask {
    var _id: Int;
    var _title: String;
    var _stitle: String;
    var _category: TaskCategory;
    var _icon: TaskIcon;
    var _due: NSDate;
    var _duration: [BBDuration];
    var _location: String;
    var _notes: String;
    var _misc: AnyObject?;  //Used to display, no need to serialize
    
    init () {
        self._id = ++TotalID
        self._title = "";
        self._stitle = "";
        self._category = .None;
        self._icon = .None;
        self._due = NSDate();
        self._duration = [BBDuration]();
        self._location = "";
        self._notes = "";
        self._misc = nil;
    }
    
    // Parameters to be confirmed
    func newTaskForDisplay() -> BBTask {
        var displayTask = BBTask()
        displayTask._title = self._title;
        displayTask._stitle = self._stitle;
        displayTask._location = self._location;
        
        return displayTask;
    }
    
    func getReadableDueTimeFromToday() -> String! {
        let now = NSDate()
        let interval = self._due.timeIntervalSinceDate(now)
        
        if interval <= 0 {
            return "-1"
        }
        
        var readable = ""
        if interval/86400 >= 1 {
            readable = "\(Int(interval/86400))d"
        }
        else if interval/3600 >= 1 {
            readable = "\(Int(interval/3600))h"
        }
        else if interval/60 >= 1 {
            readable = "\(Int(interval/60))m"
        }
        else {
            readable = "\(Int(interval))s"
        }
        return readable
    }
    
    func getReadableSpentTime() -> String! {
        let totalTime = getTotalSpentTime()
        let date = NSDate.dateWithTimeIntervalSinceReferenceDate(totalTime)
        var formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        
        return "Time Spent - " + formatter.stringFromDate(date)
    }
    
    func getColor() -> UIColor! {
        let r: CGFloat = CGFloat(CategoryMap[_category]![0] / 255.0)
        let g: CGFloat = CGFloat(CategoryMap[_category]![1] / 255.0)
        let b: CGFloat = CGFloat(CategoryMap[_category]![2] / 255.0)
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    func getIconNormal() -> String! {
        return IconMap[_icon]![0]
    }
    func getIconHighlighted () -> String! {
        return IconMap[_icon]![1]
    }
    
    func setDurationForDisplay(interval: NSTimeInterval) {
        self._misc = interval;
    }
    
    func getDurationForDisplay(interval: NSTimeInterval) -> NSTimeInterval {
        return self._misc as NSTimeInterval;
    }
    
    func getTotalSpentTime() -> NSTimeInterval {
        var spentTime: NSTimeInterval = 0.0
        for duration in self._duration {
            spentTime += duration._endTime.timeIntervalSinceDate(duration._startTime)
        }
        return spentTime
    }
    
    func toDictionary () -> NSDictionary {
        var dict = NSMutableDictionary()
        dict.setObject(self._id, forKey: "id")
        dict.setObject(self._title, forKey: "title")
        dict.setObject(self._stitle, forKey: "stitle")
        dict.setObject(self._category.toRaw(), forKey: "category")
        dict.setObject(self._icon.toRaw(), forKey: "icon")
        dict.setObject(self._due.timeIntervalSince1970, forKey: "due")
        dict.setObject(self._location, forKey: "location")
        dict.setObject(self._notes, forKey: "notes")
        
        var duration = NSMutableArray()
        for singleDuration in self._duration {
            var newDuration = NSMutableArray()
            newDuration.addObject(singleDuration._startTime.timeIntervalSince1970);
            newDuration.addObject(singleDuration._endTime.timeIntervalSince1970);
            duration.addObject(newDuration);
        }
        
        dict.setObject(duration, forKey: "duration")

        return dict
    }
    
    class func fromDictionary(dict: NSDictionary) -> BBTask {
        var task = BBTask()
        task._id = dict.objectForKey("id") as Int
        task._title = dict.objectForKey("title") as String
        task._stitle = dict.objectForKey("stitle") as String
        
        let cate: Int? = dict.objectForKey("category") as? Int
        if let category = cate {
            task._category = TaskCategory.fromRaw(category)!
        } else {
            task._category = TaskCategory.None
        }
        
        let ic: Int? = dict.objectForKey("icon") as? Int
        if let icon = ic {
            task._icon = TaskIcon.fromRaw(icon)!
        } else {
            task._icon = TaskIcon.None
        }
        
        task._due = NSDate(timeIntervalSince1970: dict.objectForKey("due") as NSTimeInterval)
        task._location = dict.objectForKey("location") as String
        task._notes = dict.objectForKey("notes") as String
        
        var duration = [BBDuration]()
        for val in dict.objectForKey("duration") as NSArray {
            var singleDuration = BBDuration()
            let startInterval: NSTimeInterval = val[0] as NSTimeInterval
            singleDuration._startTime = NSDate(timeIntervalSince1970: startInterval)
            let endInterval: NSTimeInterval = val[1] as NSTimeInterval
            singleDuration._endTime = NSDate(timeIntervalSince1970: endInterval)
            duration.append(singleDuration)
        }
        task._duration = duration
        
        return task
    }
    
    var description: String {
        var desc = "\(_title)(\(_id)): \(_due.localDescription()), spent: \(self.getTotalSpentTime())\n"
        for duration in self._duration {
            desc += "\tstart: \(duration._startTime.localDescription()), end: \(duration._endTime.localDescription())\n"
        }
        return desc;
    }
    
    class func setTotalID(totID: Int) {
        TotalID = totID
    }
    
    class func getTotalID() -> Int {
        return TotalID
    }
    
    var displayDescription: String {
        var desc = "\(_title)(\(_id)): \(_due.localDescription())\n"
        desc += "today duration: \(_misc as NSTimeInterval)"
        return desc
    }
}
