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
        
        return comp1.year==comp2.year && comp1.month==comp2.month && comp1.day==comp2.day;
    }
    
    func beginningOfDay() -> NSDate {
        return getDateOnTheSameDayWithTime(0, minute: 0, second: 0);
    }
    
    func endOfDay() -> NSDate {
        return getDateOnTheSameDayWithTime(23, minute: 59, second: 59);
    }
    
    func getDateOnTheSameDayWithTime(hour: Int, minute: Int, second: Int) -> NSDate {
        let calender = NSCalendar.currentCalendar();
        var comp = calender.components(NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit
            | NSCalendarUnit.SecondCalendarUnit, fromDate: self);
        comp.setValue(hour, forComponent: NSCalendarUnit.HourCalendarUnit);
        comp.setValue(minute, forComponent: NSCalendarUnit.MinuteCalendarUnit);
        comp.setValue(second, forComponent: NSCalendarUnit.SecondCalendarUnit);
        
        return calender.dateFromComponents(comp)!;
    }
    
    func getDateOnTheSameTimeWithDay(year: Int, month: Int, day: Int) -> NSDate {
        let calender = NSCalendar.currentCalendar();
        var comp = calender.components(NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit
            | NSCalendarUnit.DayCalendarUnit, fromDate: self);
        comp.setValue(year, forComponent: NSCalendarUnit.YearCalendarUnit);
        comp.setValue(month, forComponent: NSCalendarUnit.MonthCalendarUnit);
        comp.setValue(day, forComponent: NSCalendarUnit.DayCalendarUnit);
        
        return calender.dateFromComponents(comp)!;
    }
    
    func dateFromToday(days: Double) -> NSDate {
        var interval: NSTimeInterval = 60 * 60 * 24;
        interval = interval * (days as NSTimeInterval);
        return dateByAddingTimeInterval(interval as NSTimeInterval);
    }
}