//
//  BBGoogleLoginManager.swift
//  GoogleCalenderDemo
//
//  Created by Amy on 9/26/14.
//  Copyright (c) 2014 Amy Liu. All rights reserved.
//

import Foundation
import UIKit


protocol  googleOAuthDelegate: NSObjectProtocol{
    func accessTokenGot()
}

class BBGoogleLoginManager: NSObject{
    
    let   GOOGLE_CLIENT_ID = "1006470383786-476a513gkvb7f2foc1h75ljq24v2spk6.apps.googleusercontent.com"
    let   GOOGLE_CLIENT_SECRET = "xR9ay-SPlTGhbcgGdApRJmPn"
    let   GOOGLE_URI = "http://localhost"
    let   GOOGLE_SCOPE = "https://www.googleapis.com/auth/calendar.readonly"
    let   AUTHOR_URL = "https://accounts.google.com/o/oauth2/auth?"
    let   ACCESS_TOKEN_URL = "https://accounts.google.com/o/oauth2/token"
    
    var authorizationCode:NSString?
    var refreshToken:NSString?
    var urlConnection: NSURLConnection?
    var receivedData:NSMutableData = NSMutableData()
    var accessToken: NSString?
    var calenderModel: BBCalenderModel?
    
    struct Static {
        static var token : dispatch_once_t = 0
        static var instance :BBGoogleLoginManager?
    }
    
    class func getInstance() -> BBGoogleLoginManager {
        dispatch_once(&Static.token) {  Static.instance = BBGoogleLoginManager() }
            return Static.instance!
        }

    override init(){
        assert(Static.instance == nil, "Singleton already initialized!")
        
        calenderModel = BBCalenderModel()
    }
    
    func getAuthorationRequestURLString() ->  String{
        
        let clientIdParameter = "client_id=" + GOOGLE_CLIENT_ID
        let redirectURIParameter = "redirect_uri=" + GOOGLE_URI
        let scopeParameter = "scope=" + GOOGLE_SCOPE
        let urlString = AUTHOR_URL  + "response_type=code" + "&" +  scopeParameter + "&" + redirectURIParameter  + "&" + clientIdParameter
        return urlString as String
    }
    
    func getAccessTokenRequestData(authorCode:String) -> String{
        let code = "code=" + authorCode
        let clientIdParameter = "client_id=" + GOOGLE_CLIENT_ID
        let clientSecretParameter = "client_secret=" + GOOGLE_CLIENT_SECRET
        let redirectURIParameter = "redirect_uri=" + GOOGLE_URI
        let grantTypeParameter =  "grant_type=authorization_code"
        
        let data = code + "&" + clientIdParameter + "&" + clientSecretParameter + "&" + redirectURIParameter + "&" + grantTypeParameter
        
        return data
    }
    
    func getAccessTokenURL() ->String{
        return ACCESS_TOKEN_URL
    }
    
    func getAccessToken() -> NSString{
        return accessToken!
    }
    
    func requestAccessToken(urlString: String ,  data: NSData){
        var url: NSURL = NSURL(string: urlString)
        println(url.query)
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = data
        println(request.URL?.query)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{
            (response, data, error) -> Void in
            
            if data == nil {
                //Handle Error here
            }else{
                self.receivedData.appendData(data)
                println( self.receivedData)
                let dictionary = NSJSONSerialization.JSONObjectWithData(self.receivedData, options: nil, error: nil) as NSDictionary
                println(dictionary["access_token"])
                let token = dictionary["access_token"] as NSString
                self.accessToken = token
                NSUserDefaults.standardUserDefaults().setObject(token, forKey: "GOOGLE_ACCESS_TOKEN")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.calenderModel?.startLoadCalenderModel(self.accessToken!)

            }
        })
    }
    
}

