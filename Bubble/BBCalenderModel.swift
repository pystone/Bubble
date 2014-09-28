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
                
            
                for item in json["items"].arrayValue!{
                    var eventTile =  item["summary"].stringValue
                    var eventTime = item["created"].stringValue
                    println(eventTile)
                    var Task: BBTask = BBTask()
                }
                
                
    
               // if let
                //println(tempItems)
                
                //println(json)
                
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
    
}
