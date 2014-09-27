//
//  BBDataCenter.swift
//  bubble_data
//
//  Created by PY on 9/26/14.
//  Copyright (c) 2014 PY. All rights reserved.
//

import Foundation

//class BBDataCenter;


var _sharedDataCenter: BBDataCenter?

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
        _finishedTasks = [Int: BBTask]();
        _unfinishedTasks = [Int: BBTask]();
    }
    
    func addNewTask(task: BBTask) {
        _unfinishedTasks.updateValue(task, forKey: task._id);
    }
    
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
        var tasks = [BBTask]();
        
        for (id, task) in self._unfinishedTasks {
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
            displayTask.setDurationForDisplay(totalDuration);
            tasks.append(displayTask);
        }
        
        return tasks;
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
    
    func finishTask(id: Int) -> Bool {
        let task = self._unfinishedTasks[id];
        if (task == nil) {
            return false
        }
        else {
            self._unfinishedTasks.removeValueForKey(id);
            self._finishedTasks.updateValue(task!, forKey: id);
            return false;
        }
    }
    
    func print() {
        testDeleteTask();
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
    // TODO: test getTasksForOneDay
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
        let date = NSDate()
        createAndAddNewTask(title: "haha5", due: date.dateByAddingTimeInterval(4000), location: "hehe", notes: "fuck");
        createAndAddNewTask(title: "haha3", due: date.dateByAddingTimeInterval(2000), location: "hehe", notes: "fuck");
        createAndAddNewTask(title: "haha1", due: date, location: "hehe", notes: "fuck");
        createAndAddNewTask(title: "haha2", due: date.dateByAddingTimeInterval(1000), location: "hehe", notes: "fuck");
        createAndAddNewTask(title: "haha4", due: date.dateByAddingTimeInterval(3000), location: "hehe", notes: "fuck");
        
        let list = getSortedTaskListOnDue(4);
        printAllTasks(list);
    }
    
    func testListPass() {
        var dic = ["a":123, "v":234];
        var arr = [1, 2, 3, 4];
        var i = 0;
        for (i = 0; i<arr.endIndex; ++i) {
            
        }
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
}



