//
//  BBTask.swift
//  bubble_data
//
//  Created by PY on 9/26/14.
//  Copyright (c) 2014 PY. All rights reserved.
//

import Foundation

var TotalID = 0

class BBTask {
    var _id: Int;
    var _title: String;
    var _stitle: String;
    var _category: Int;
    var _due: NSDate;
    var _duration: [BBDuration];
    var _location: String;
    var _notes: String;
    var _misc: AnyObject?;  //Used to display, no need to serialize
    
    init () {
        self._id = ++TotalID
        self._title = "";
        self._stitle = "";
        self._category = 0;
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
        dict.setObject(self._category, forKey: "category")
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
        task._category = dict.objectForKey("category") as Int
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
