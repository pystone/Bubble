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
    var _misc: AnyObject?;
    
    init () {
        self._title = "";
        self._stitle = "";
        self._category = 0;
        self._due = NSDate();
        self._duration = [BBDuration]();
        self._location = "";
        self._notes = "";
        self._misc = nil;
        self._id = ++TotalID
    }
    
    var description: String {
        return "\(_title)(\(_id)): \(_due)";
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
}
