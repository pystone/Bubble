//
//  BBCalenderModel.swift
//  GoogleCalenderDemo
//
//  Created by Amy on 9/27/14.
//  Copyright (c) 2014 Amy Liu. All rights reserved.
//

import Foundation

class BBCalenderModel: NSObject{
    
    enum HTTPMethod{
        case httpMethod_GET,
                httpMethod_POST,
         httpMethod_DELETE,
              httpMethod_PUT
    }
    
    
    var bubbleList: [AnyObject]
    var accessToken: NSString?
      
    let GOOGLE_RETRIVE_URL = "https://www.googleapis.com/calendar/v3/users/me/calendarList"
    let GOOGLE_CALENDAR_RETRIEVE_URL = "https://www.googleapis.com/calendar/v3/calendars/primary/events"
    
    func retrieveCalenderData() {
        callAPI(GOOGLE_CALENDAR_RETRIEVE_URL)
    }
    
    override init(){
        bubbleList =  [AnyObject]()
    }
    
    func startLoadCalenderModel(token:NSString) {
        accessToken = token
        retrieveCalenderData()
    }
    
    func callAPI(apiURL:String){
        let accessTokenString = "access_token=" + self.accessToken!
        var timeMin = getCurrentTime()
        var timeMax = getMaxTime()
        var maxResults = 10;
        var orderBy = "startTime"
        println(timeMin)
        println(timeMax)
        var urlString = apiURL + "?" + accessTokenString + "&timeMin=" + timeMin + "&timeMax=" + timeMax + "&maxResults=" + String(maxResults)
        println(urlString)
        var url: NSURL = NSURL(string: urlString)
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{
            (response, data, error) -> Void in
            
            if error != nil {
                //Handle Error here
            }else{
                var receivedData = NSMutableData()
                receivedData.appendData(data)
                let json = JSON(data:receivedData,options:nil,error:nil)
                
                if let tempItems =  json["items"].arrayValue{
                    for item in json["items"].arrayValue!{
                    
                        var Task: BBTask = BBTask()
                    
                        if let eventTile =  item["summary"].stringValue{
                            Task._title = eventTile
                        }
                        if let eventEndTimeStr = item["end"]["dateTime"].stringValue{
                             var eventEndTime = self.stringTransToDate(eventEndTimeStr)
                             Task._due = eventEndTime
                        }
                        if let eventDescription = item["description"].stringValue{
                             Task._notes = eventDescription
                        }
                    
                        BBDataCenter.sharedDataCenter().addNewTask(Task)
                   }
                }
            }
        })
    }
    
    func getCurrentTime() -> String{
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let str = formatter.stringFromDate(NSDate())
        return str
    }
    
    func getMaxTime() -> String{
        var date = NSDate().dateFromToday(7.0)
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let str = formatter.stringFromDate(date)
        
        return str
    }
    
    func stringTransToDate(dateStr:String) -> NSDate{
        var newString = ""
        if let strArray = dateStr.componentsSeparatedByCharactersInSet(NSCharacterSet.letterCharacterSet()) as [String]? {
            if  let subStrArray = strArray[1].componentsSeparatedByString("-") as [String]?{
                       newString = strArray[0] + " " + subStrArray[0]
            }
        }
           var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let str = formatter.dateFromString(newString)
           println(str)
            return str!
    }
    
}
