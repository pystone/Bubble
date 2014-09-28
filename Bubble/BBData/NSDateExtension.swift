//
//  NSDateExtension.swift
//  bubble_data
//
//  Created by PY on 9/26/14.
//  Copyright (c) 2014 PY. All rights reserved.
//

import Foundation

extension NSDate {
    func sameDayAs(anotherDate: NSDate) -> Bool {
        let calender = NSCalendar.currentCalendar();
        let flags = NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit;
        
        let comp1 = calender.components(flags, fromDate: anotherDate);
        let comp2 = calender.components(flags, fromDate: self);
        
        let y1 = comp1.year
        let y2 = comp2.year
        let m1 = comp1.month
        let m2 = comp2.month
        let d1 = comp1.day
        let d2 = comp2.day
        
        return comp1.year==comp2.year && comp1.month==comp2.month && comp1.day==comp2.day;
    }
    
    func beginningOfDay() -> NSDate {
        return getDateOnTheSameDayWithTime(hour: 0, minute: 0, second: 0);
    }
    
    func endOfDay() -> NSDate {
        return getDateOnTheSameDayWithTime(hour: 23, minute: 59, second: 59);
    }
    
    func getDateOnTheSameDayWithTime(#hour: Int, minute: Int, second: Int) -> NSDate {
        
        let calender = NSCalendar.currentCalendar();
        var comp = calender.components(.YearCalendarUnit | .MonthCalendarUnit
            | .DayCalendarUnit, fromDate: self);
        
        return NSDate.dateWithDateAndTime(year: comp.year, month: comp.month, day: comp.day, hour: hour, minute: minute, second: second);
    }
    
    func getDateOnTheSameTimeWithDay(#year: Int, month: Int, day: Int) -> NSDate {
        let calender = NSCalendar.currentCalendar();
        var comp = calender.components(.HourCalendarUnit | .MinuteCalendarUnit
            | .SecondCalendarUnit, fromDate: self);
        
        return NSDate.dateWithDateAndTime(year: year, month: month, day: day, hour: comp.hour, minute: comp.minute, second: comp.second);
    }
    
    func dateFromToday(days: Double) -> NSDate {
        var interval: NSTimeInterval = 60 * 60 * 24;
        interval = interval * (days as NSTimeInterval);
        return dateByAddingTimeInterval(interval as NSTimeInterval);
    }
    
    class func dateWithDateAndTime(#year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> NSDate {
        let comp = NSDateComponents()
        comp.timeZone = NSTimeZone.localTimeZone()
        comp.setValue(year, forComponent: NSCalendarUnit.YearCalendarUnit)
        comp.setValue(month, forComponent: NSCalendarUnit.MonthCalendarUnit)
        comp.setValue(day, forComponent: NSCalendarUnit.DayCalendarUnit)
        comp.setValue(hour, forComponent: NSCalendarUnit.HourCalendarUnit)
        comp.setValue(minute, forComponent: NSCalendarUnit.MinuteCalendarUnit)
        comp.setValue(second, forComponent: NSCalendarUnit.SecondCalendarUnit)
        
        return NSCalendar.currentCalendar().dateFromComponents(comp)!
    }
    
    class func dateWithDate(year: Int, month: Int, day: Int) -> NSDate {
        return dateWithDateAndTime(year: year, month: month, day: day, hour: 3, minute: 0, second: 0)
    }
    
    func localDescription() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter.stringFromDate(self)
    }
    
}