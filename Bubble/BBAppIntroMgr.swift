//
//  BBAppIntroMgr.swift
//  Bubble
//
//  Created by Amy on 9/27/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import Foundation
import UIKit


class BBAppIntroMgr: NSObject{
    
    var firstLoad: Bool = true
    
    var viewControllerForAppIntro = IntroViewController()
    
    class func shouldShowAppIntro() -> Bool {
        
       // var first = NSUserDefaults.standardUserDefaults().boolForKey("BBAppIntroNumKey") as Bool

        return  true
    }
    
    struct Static {
        static var token : dispatch_once_t = 0
        static var instance :BBAppIntroMgr?
    }
    
    class func getInstance() ->BBAppIntroMgr{
        dispatch_once(&Static.token) {  Static.instance = BBAppIntroMgr() }
        return Static.instance!
    }
    
}

class IntroViewController: UIViewController, UIWebViewDelegate,googleOAuthDelegate {
    var Label1: UIButton?
    var Label2: UIButton?
    var introView: UIImageView?
    var webView: UIWebView?
     var loginInMgr: BBGoogleLoginManager?
    
    override func viewDidLoad() {
        let bounds: CGRect = self.view.bounds
        introView = UIImageView(frame: CGRectMake(0, 0, bounds.width, bounds.height))
        introView?.userInteractionEnabled = true
        introView?.backgroundColor = UIColor.whiteColor()
        
        Label1 = UIButton(frame: CGRectMake(bounds.width/2 - 80,  bounds.height/2 - 80, 160, 30))
        Label1?.backgroundColor = UIColor.yellowColor()
        Label1?.setTitle("Sign in With Google", forState: .Normal )
        Label1?.setTitleColor(UIColor.blueColor(), forState: .Normal)
        Label1?.addTarget(self, action: Selector("SignInPressed:"), forControlEvents: .TouchUpInside)
        
        Label2 = UIButton(frame: CGRectMake(bounds.width/2 - 80,  bounds.height/2 - 10,160 , 30))
        Label2?.backgroundColor = UIColor.yellowColor()
        Label2?.setTitle("Next Time", forState: .Normal)
        Label2?.addTarget(self, action: Selector("nextTime:"), forControlEvents: .TouchUpInside)
        Label2?.setTitleColor(UIColor.blueColor(), forState: .Normal)
        
        introView?.addSubview(Label1!)
        introView?.addSubview(Label2!)
        
        self.view.addSubview(introView!)
    }
    
    func SignInPressed(sender: UIButton!) {
        
        introView?.removeFromSuperview()
        webView = UIWebView(frame: self.view.bounds)
        webView?.delegate = self
        self.view.addSubview(webView!)
        
        loginInMgr = BBGoogleLoginManager()
        var str : String?
        str = loginInMgr?.getAuthorationRequestURLString()
        
        var urlstr = NSURL(string: str!)
        var request1: NSURLRequest = NSURLRequest(URL: urlstr)
        
        webView?.loadRequest(request1)
        
       // self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func nextTime(sender: UIButton!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.URL.host == "localhost" {
            var verifier: String?
            let urlQuery: NSString = request.URL.query!
            var params = urlQuery.componentsSeparatedByString("&") as [String]
            for param in params{
                var keyValue = param.componentsSeparatedByString("=") as [String]
                var key = keyValue[0]
                if key == "code"{
                    verifier = keyValue[1]
                    println(verifier)
                    break;
                }
            }
            
            if verifier != nil{
                loginInMgr?.authorizationCode = verifier
                let dataStr : NSString? = loginInMgr?.getAccessTokenRequestData(verifier!)
                let data = dataStr?.dataUsingEncoding(
                    NSUTF8StringEncoding)
                let url : String? = loginInMgr?.getAccessTokenURL()
                println(url)
                loginInMgr?.requestAccessToken(url!, data: data!)
            }
            
            webView.removeFromSuperview()
            return false
            
        }
        return true
    }
    
    func accessTokenGot(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

