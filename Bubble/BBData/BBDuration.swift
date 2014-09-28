//
//  BBDuration.swift
//  bubble_data
//
//  Created by PY on 9/26/14.
//  Copyright (c) 2014 PY. All rights reserved.
//

import Foundation

class BBDuration {
    var _startTime: NSDate;
    var _endTime: NSDate;
    
    init() {
        self._startTime = NSDate();
        self._endTime = NSDate();
    }
    
    func getInterval() -> NSTimeInterval {
        return _endTime.timeIntervalSinceDate(_startTime);
    }
    
    func getIntervalOnStart() -> NSTimeInterval {
        return (_startTime.endOfDay()).timeIntervalSinceDate(_startTime);
    }
    
    func getIntervalOnEnd() -> NSTimeInterval {
        let begin = _endTime.beginningOfDay()
        return _endTime.timeIntervalSinceDate(_endTime.beginningOfDay());
    }
}