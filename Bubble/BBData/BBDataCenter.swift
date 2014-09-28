//
//  BBDataCenter.swift
//  bubble_data
//
//  Created by PY on 9/26/14.
//  Copyright (c) 2014 PY. All rights reserved.
//

import Foundation


var _sharedDataCenter: BBDataCenter?
let FinishedTaskKey = "FinishedTasks"
let UnfinishedTaskKey = "UnifnishedTasks"
let TotalIDKey = "TotalID"

class BBDataCenter {
    
    var _finishedTasks: [Int: BBTask];
    var _unfinishedTasks: [Int: BBTask];
    
    class func sharedDataCenter() -> BBDataCenter {
        if (_sharedDataCenter == nil) {
            _sharedDataCenter = BBDataCenter();
        }
        return _sharedDataCenter!;
    }
    
    init () {
//        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!);
        _finishedTasks = [Int: BBTask]()
        _unfinishedTasks = [Int: BBTask]()
        
        let finished = NSUserDefaults.standardUserDefaults().objectForKey(FinishedTaskKey) as? NSArray
        let unfinished = NSUserDefaults.standardUserDefaults().objectForKey(UnfinishedTaskKey) as? NSArray
        let totalID = NSUserDefaults.standardUserDefaults().objectForKey(TotalIDKey) as? Int
        
        if finished != nil {
            for taskDict in finished! {
                let task = BBTask.fromDictionary(taskDict as NSDictionary)
                _finishedTasks.updateValue(task, forKey: task._id)
            }
            println("Data center init: file for finished found.");
        }
        
        if unfinished != nil {
            for taskDict in unfinished! {
                let task = BBTask.fromDictionary(taskDict as NSDictionary)
                _unfinishedTasks.updateValue(task, forKey: task._id)
            }
            println("Data center init: file for unfinished found.");
        }
        
        if totalID != nil {
            BBTask.setTotalID(totalID!)
            println("Data center init: total id number \(totalID)")
        }
    }
    
    /* Task management */
    func addNewTask(task: BBTask) {
        _unfinishedTasks.updateValue(task, forKey: task._id);
        saveUnfinishedToFile();
    }
    
    func finishTask(id: Int) -> Bool {
        let task = self._unfinishedTasks[id];
        if (task == nil) {
            return false
        }
        else {
            self._unfinishedTasks.removeValueForKey(id);
            self._finishedTasks.updateValue(task!, forKey: id);
            saveToFile();
            return false;
        }
    }
    
    func getUnfinishedTaskWithID(id: Int) -> BBTask? {
        return self._unfinishedTasks[id]
    }
    
    func getFinishedTaskWithID(id: Int) -> BBTask? {
        return self._finishedTasks[id]
    }
    
    func updateUnfinishedTask(task: BBTask) {
        self._unfinishedTasks.updateValue(task, forKey:task._id);
        saveUnfinishedToFile();
    }
    
    func removeUnfinishedTask(task: BBTask) {
        removeUnfinishedTask(task._id)
    }
    func removeUnfinishedTask(id: Int) {
        self._unfinishedTasks.removeValueForKey(id)
        saveUnfinishedToFile()
    }
    
    func removeFinishedTask(task: BBTask) {
        removeFinishedTask(task._id)
    }
    func removeFinishedTask(id: Int) {
        self._finishedTasks.removeValueForKey(id)
        saveFinishedToFile()
    }
    
    func saveUnfinishedToFile() {
        let serialize = NSMutableArray()
        for (key, val) in self._unfinishedTasks {
            serialize.addObject(val.toDictionary())
        }
        NSUserDefaults.standardUserDefaults().setObject(serialize, forKey: UnfinishedTaskKey);
        
        NSUserDefaults.standardUserDefaults().setObject(BBTask.getTotalID(), forKey: TotalIDKey)
    }
    func saveFinishedToFile() {
        let serialize = NSMutableArray()
        for (key, val) in self._finishedTasks {
            serialize.addObject(val.toDictionary())
        }
        NSUserDefaults.standardUserDefaults().setObject(serialize, forKey: FinishedTaskKey);
        
        NSUserDefaults.standardUserDefaults().setObject(BBTask.getTotalID(), forKey: TotalIDKey)
    }
    func saveToFile() {
        saveUnfinishedToFile();
        saveFinishedToFile();
    }
    /* Task management end */
    
    func createAndAddNewTask(#title: String, due: NSDate, location: String, notes: String) -> Int {
        let newTask = BBTask();
        newTask._title = title;
        newTask._due = due;
        newTask._location = location;
        newTask._notes = notes;
        
        self.addNewTask(newTask);
        return newTask._id;
    }
    
    func getTasksForToday() -> [BBTask] {
        return getTasksForOneDay(NSDate());
    }
    
    func getTasksForOneDay(date: NSDate) -> [BBTask] {
        var dispTasks = [BBTask]();
        
        var allTasks = self._unfinishedTasks
//        allTasks.merge(self._finishedTasks)
        allTasks += self._finishedTasks
        
        for (id, task) in allTasks {
            if task._duration.count == 0 {
                continue
            }
            
            let today = false
            var totalDuration = 0.0
            var displayTask = task.newTaskForDisplay();
            
            for duration in task._duration {
                let sameStart = duration._startTime.sameDayAs(date);
                let sameEnd = duration._endTime.sameDayAs(date);
                
                if !sameStart && !sameEnd {
                    continue;
                }
                
                if sameStart && sameEnd {
                    totalDuration = totalDuration + duration.getInterval();
                }
                else if !sameStart && sameEnd {
                    totalDuration = totalDuration + duration.getIntervalOnEnd();
                }
                else {
                    totalDuration = totalDuration + duration.getIntervalOnStart();
                }
                
                
            }
            if totalDuration == 0.0 {
                continue
            }
            displayTask.setDurationForDisplay(totalDuration);
            dispTasks.append(displayTask);
        }
        
        return dispTasks;
    }
    
    func getSortedTaskListOnDue(maxCnt: Int) -> [BBTask] {
        let sortedTask = Array(self._unfinishedTasks.values).sorted({
            $0._due.compare($1._due) == NSComparisonResult.OrderedAscending});
        
        var retList = sortedTask[0...sortedTask.endIndex-1];
        if maxCnt < sortedTask.endIndex {
            retList = sortedTask[0...maxCnt-1];
        }
        return Array(retList);
    }
    
    func print() {
//        addTestTasks()
        
        printAllTasks()
    }
    
    func printDisplayTasks(tasks: [BBTask]) {
        println("Display tasks:")
        for task in tasks {
            println(task.displayDescription)
        }
    }
    
    func printAllTasks() {
        println("Unfinished tasks: ");
        printAllTasks(Array(self._unfinishedTasks.values))
        
        println("Finished tasks: ")
        printAllTasks(Array(self._finishedTasks.values));
    }
    
    func printAllTasks(tasks: [BBTask]) {
        for task in tasks {
            println(task.description)
        }
    }
    
    // For debug
    func testDisplayTask() {
        printDisplayTasks(getTasksForOneDay(NSDate.dateWithDate(2014, month: 8, day: 11)))
        println("\n")
        printDisplayTasks(getTasksForOneDay(NSDate.dateWithDate(2014, month: 8, day: 12)))
        println("\n")
        printDisplayTasks(getTasksForOneDay(NSDate.dateWithDate(2014, month: 8, day: 13)))
        println("\n")
        printDisplayTasks(getTasksForOneDay(NSDate.dateWithDate(2014, month: 8, day: 14)))
        println("\n")
    }
    
    func testNSDate() {
        let time = NSDate();
        println(time.descriptionWithLocale(NSLocale.currentLocale()));
        var another = time.beginningOfDay();
        println(another.descriptionWithLocale(NSLocale.currentLocale()));
        another = time.endOfDay();
        println(another.descriptionWithLocale(NSLocale.currentLocale()));
        println(time.sameDayAs(another));

    }
    
    func testBBDuration() {
        let dura = BBDuration();
        dura._startTime = NSDate();
        dura._endTime = dura._startTime.dateByAddingTimeInterval(3600);
        
        println(dura.getInterval());
        println(dura.getIntervalOnStart());
        println(dura.getIntervalOnEnd());

    }
    
    func testDateSort() {
        let a = NSDate();
        let b = a.dateByAddingTimeInterval(1234);
        println(a.compare(b)==NSComparisonResult.OrderedAscending);
    }
    
    func testSortList() {
        
        let list = getSortedTaskListOnDue(4);
        printAllTasks(list);
    }
    
    func testDeleteTask() {
        let date = NSDate()
        createAndAddNewTask(title: "haha5", due: date.dateByAddingTimeInterval(4000), location: "hehe", notes: "fuck");
        createAndAddNewTask(title: "haha3", due: date.dateByAddingTimeInterval(2000), location: "hehe", notes: "fuck");
        createAndAddNewTask(title: "haha1", due: date, location: "hehe", notes: "fuck");
        createAndAddNewTask(title: "haha2", due: date.dateByAddingTimeInterval(1000), location: "hehe", notes: "fuck");
        createAndAddNewTask(title: "haha4", due: date.dateByAddingTimeInterval(3000), location: "hehe", notes: "fuck");
        
        println("Before: ")
        printAllTasks();
        
        finishTask(2)

        println("After: ")
        printAllTasks();
    }
    
    func addTestTasks() {
        let date = NSDate()
        createAndAddNewTask(title: "haha5", due: date.dateByAddingTimeInterval(4000), location: "hehe", notes: "fuck");
        createAndAddNewTask(title: "haha3", due: date.dateByAddingTimeInterval(2000), location: "hehe", notes: "fuck");
        createAndAddNewTask(title: "haha1", due: date, location: "hehe", notes: "fuck");
        createAndAddNewTask(title: "haha2", due: date.dateByAddingTimeInterval(1000), location: "hehe", notes: "fuck");
        createAndAddNewTask(title: "haha4", due: date.dateByAddingTimeInterval(3000), location: "hehe", notes: "fuck");
        
        removeUnfinishedTask(4)
        
        if let task = getUnfinishedTaskWithID(3) {
            var newDuration = BBDuration()
            newDuration._startTime = NSDate.dateWithDateAndTime(year: 2014, month: 8, day: 12, hour: 10, minute: 0, second: 0)
            newDuration._endTime = NSDate.dateWithDateAndTime(year: 2014, month: 8, day: 12, hour: 13, minute: 0, second: 0)
            task._duration.append(newDuration)
            
            newDuration = BBDuration()
            newDuration._startTime = NSDate.dateWithDateAndTime(year: 2014, month: 8, day: 12, hour: 20, minute: 0, second: 0)
            newDuration._endTime = NSDate.dateWithDateAndTime(year: 2014, month: 8, day: 13, hour: 2, minute: 0, second: 0)
            task._duration.append(newDuration)
        }
        
        if let task = getUnfinishedTaskWithID(1) {
            var newDuration = BBDuration()
            newDuration._startTime = NSDate.dateWithDateAndTime(year: 2014, month: 8, day: 11, hour: 10, minute: 0, second: 0)
            newDuration._endTime = NSDate.dateWithDateAndTime(year: 2014, month: 8, day: 11, hour: 13, minute: 0, second: 0)
            task._duration.append(newDuration)
            
            newDuration = BBDuration()
            newDuration._startTime = NSDate.dateWithDateAndTime(year: 2014, month: 8, day: 11, hour: 20, minute: 0, second: 0)
            newDuration._endTime = NSDate.dateWithDateAndTime(year: 2014, month: 8, day: 12, hour: 2, minute: 0, second: 0)
            task._duration.append(newDuration)
        }
        
        finishTask(1)
    }
}



